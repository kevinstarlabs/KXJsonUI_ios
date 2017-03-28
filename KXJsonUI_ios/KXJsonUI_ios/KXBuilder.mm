//
// KXBuilder.m
// Copyright (c) 2016-2017 kxzen ( https://github.com/kxzen/KXJsonUI_ios )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KXBuilder.h"
#import "KXCommon.h"
#import "KXFileHelper.h"
#import "KXJSONParseHelper.h"
#import "KXStringHelper.h"
#import "KXFileHelper.h"
#import "UIView+KXFrame.h"
#import "UIView+KXLayout.h"
#import "KXLinearLayout.h"
#import "KXRelativeLayout.h"

#import "UIColor+KXHex.h"
#import "UIColor+KXBrightness.h"

#include <queue>
#include <vector>
#include <map>

#define KX_FIND_WIDGET_BY_NAME(x,y,z) ((y*)[x findWidgetByName:@z])
#define KX_CAST_VIEW(x) x *view_r = (x *)*view;

@interface KXBuilder()

@property(nonatomic, strong) KXViewAttribute *rootAttribute;

@end

@implementation KXBuilder{   
    
    std::map<std::string,unsigned int> hashKeyTable_;
    std::vector<UIView *> flattenNodeList_;
};

-(BOOL) loadFileWithName:(NSString * _Nonnull)fileName
{
//    return builder_.loadFile(KX_TO_CPPSTRING(fileName));
    NSString* path = nil;
    if( fileName.length > 0 && [fileName characterAtIndex:0] != '/' ){
        path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    }else{
        path = fileName;
    }
    
    NSDictionary *root;
    
    id cachedObject = [[KXJsonSharedCache sharedManager] cachedJsonObjectWithFileName:fileName];
    if( cachedObject != nil ){
        root = cachedObject;
    }else{
        root = [KXFileHelper readJsonFromFile:path];
        if( root == nil ){
            return NO;
        }
    }
    
    if( [root objectForKey:@"layout"] != nil ) {
        [self parseJsonViewWithAttribute:nil jsonView:root[@"layout"]];
    }
    
    [KXBuilder basicSetup];
    
    return YES;
}

-(void) buildLayoutInView:(UIView * _Nonnull)view
{
    UIView *container = view;
    if( self.rootAttribute != nil && [self.rootAttribute.name isEqualToString:@"root"] ){
        unsigned int hashKey = (unsigned int) arc4random();
        char szKey[128] = {};
        sprintf(szKey, "%p", container);
        hashKeyTable_[szKey] = hashKey;
        [self internalBuildWithParent:@"" attribute:self.rootAttribute container:container hashKey:hashKey];
        NSAssert( KX_FIND_WIDGET_BY_NAME(container,UIView,"root") != nil ,
                 @"The root element in Json UI file must be named \"root\"." );
    }else{
        NSLog(@"It seems that there was something wrong with the layout JSON file. The root element was not found.");
    }
}

-(void) reloadAnotherLayoutInView:(UIView * _Nonnull)view
{
    UIView *container = view;
    char szKey[128] = {};
    sprintf(szKey, "%p", container);
    if( hashKeyTable_.find(szKey) == hashKeyTable_.end() ) return;
    unsigned int oldHashKey = hashKeyTable_[szKey];
    UIView *oldRootView = [container findWidgetByName:@"root" hashKey:oldHashKey];
    assert( oldRootView != nil );
    if( oldRootView != nil ){
        unsigned int newHashKey = 0;
        do{
            newHashKey = (unsigned int) arc4random();
        }while( newHashKey == oldHashKey );
        
        flattenNodeList_.clear();
        std::queue<UIView *> q;
        q.push(oldRootView);
        while( !q.empty() ){
            UIView *curNode = q.front();
            q.pop();
            if( curNode.kxLayoutHashKey == oldHashKey ){
                flattenNodeList_.push_back(curNode);
            }
            if( curNode != nil ){
                for (UIView *subview in curNode.subviews)
                {
                    if( subview != curNode && subview != nil ){
                        q.push(subview);
                    }
                }
            }
        }
        
        for( int i=0;i<flattenNodeList_.size();++i ){
            [flattenNodeList_[i] removeFromSuperview];
        }
        
        [self internalBuildWithReuse:@"" attribute:self.rootAttribute container:container oldHashKey:oldHashKey hashKey:newHashKey];
        hashKeyTable_[szKey] = newHashKey;
        flattenNodeList_.clear();
        assert( KX_FIND_WIDGET_BY_NAME(container,UIView,"root") != nil );
    }
}


+(void) registerViewHandlerForWidget:(NSString *)widget
                          onCreation:(KXViewConfigureHandler) creationHandler
                             onSetup:(KXViewConfigureHandler) setupHandler
{
    // make sure we are adding its copy from heap, not from stack.
    KXViewConfigureHandler handler1 = [creationHandler copy];
    [[KXViewHandlerManager sharedManager] addCreationHandler:handler1 forWidget:widget];
    KXViewConfigureHandler handler2 = [setupHandler copy];
    [[KXViewHandlerManager sharedManager] addSetupHandler:handler2 forWidget:widget];
}

+(void) basicSetup
{
    if( [[KXViewHandlerManager sharedManager] containsHandlerForWidget:@"UIView"] ){
        return;
    }
    
    [self registerViewHandlerForWidget:@"UIView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UIView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
    }];
    
    [self registerViewHandlerForWidget:@"KXLinearLayout" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[KXLinearLayout alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {

        KX_CAST_VIEW(KXLinearLayout);
        if( parentWidget == nil || parentWidget.length == 0 ){
            view_r.kxName = attribute.name;
            view_r.kxRelativeParams.width = KX_MATCHPARENT;
            view_r.kxRelativeParams.height = KX_MATCHPARENT;
            view_r.orientation = ([attribute.attrs[@"orientation"] isEqualToString:@"vertical"]) ?
            KXLinearLayoutOrientationVertical:KXLinearLayoutOrientationHorizontal;
            if( attribute.attrs[@"color"] != nil ){
                view_r.backgroundColor = [self getColor:attribute.attrs[@"color"]];
            }
            if( attribute.iosAutoEdge ){
                view_r.kxAutoAdjustForFullLayout = YES;
            }else{
                view_r.kxAutoAdjustForFullLayout = NO;
            }
        }else{
            [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
            view_r.orientation = ([attribute.attrs[@"orientation"] isEqualToString:@"vertical"]) ?
        KXLinearLayoutOrientationVertical:KXLinearLayoutOrientationHorizontal;
        }
    }];
    
    [self registerViewHandlerForWidget:@"KXRelativeLayout" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[KXRelativeLayout alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(KXRelativeLayout);
        if( parentWidget == nil || parentWidget.length == 0 ){
            view_r.kxName = attribute.name;
            view_r.kxRelativeParams.width = KX_MATCHPARENT;
            view_r.kxRelativeParams.height = KX_MATCHPARENT;
            if( attribute.attrs[@"color"] != nil ){
                view_r.backgroundColor = [self getColor:attribute.attrs[@"color"]];
            }
            if( attribute.iosAutoEdge ){
                view_r.kxAutoAdjustForFullLayout = YES;
            }else{
                view_r.kxAutoAdjustForFullLayout = NO;
            }
        }else{
            [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        }
    }];
    
    [self registerViewHandlerForWidget:@"UIScrollView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UIScrollView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(UIScrollView);
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        if( attribute.attrs[@"content_size"] != nil && [attribute.attrs[@"content_size"] isKindOfClass:[NSValue class]] ){
            CGSize contentSize = [attribute.attrs[@"content_size"] CGSizeValue];
            NSMutableDictionary *propertyNS = [[NSMutableDictionary alloc] initWithCapacity:0];
            [propertyNS setValue:[NSValue valueWithCGSize:contentSize] forKey:@"content_size"];
            view_r.kxProperty = propertyNS;
        }
    }];
    
    [self registerViewHandlerForWidget:@"UITableView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UITableView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
    }];
    
    
    [self registerViewHandlerForWidget:@"UICollectionView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        NSString *dir = attribute.attrs[@"direction"];
        if( [dir isEqualToString:@"horizontal"] ){
            [collectionViewFlowLayout setScrollDirection:(UICollectionViewScrollDirection)UICollectionViewScrollDirectionHorizontal];
        }else if( [dir isEqualToString:@"vertical"] ){
            [collectionViewFlowLayout setScrollDirection:(UICollectionViewScrollDirection)UICollectionViewScrollDirectionVertical];
        }
        CGSize itemSize = [attribute.attrs[@"item_size"] CGSizeValue];
        [collectionViewFlowLayout setItemSize:itemSize];
        [collectionViewFlowLayout setHeaderReferenceSize:CGSizeMake(0, 0)];
        [collectionViewFlowLayout setFooterReferenceSize:CGSizeMake(0, 0)];
        if( attribute.attrs[@"interitem_spacing"] != nil ){
            [collectionViewFlowLayout setMinimumInteritemSpacing:[attribute.attrs[@"iteritem_spacing"] doubleValue]];
        }else{
            [collectionViewFlowLayout setMinimumInteritemSpacing:0];
        }
        if( attribute.attrs[@"line_spacing"] != nil ){
            [collectionViewFlowLayout setMinimumLineSpacing:[attribute.attrs[@"line_spacing"] doubleValue]];
        }else{
            [collectionViewFlowLayout setMinimumLineSpacing:0];
        }
        if( attribute.attrs[@"inner_padding"] != nil ){
            [collectionViewFlowLayout setSectionInset:[attribute.attrs[@"inner_padding"] UIEdgeInsetsValue]];
        }else{
            [collectionViewFlowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];

    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
    }];
    
    [self registerViewHandlerForWidget:@"UILabel" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UILabel alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(UILabel);
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        if( attribute.attrs[@"text"] ){
            view_r.text = [self getText:attribute.attrs[@"text"]];
        }
        double fontSize = 14;
        
        if( attribute.attrs[@"font_size"] != nil ){
            fontSize = [attribute.attrs[@"font_size"] doubleValue];
        }
        
        view_r.font = [UIFont systemFontOfSize:fontSize];
        
        if( attribute.attrs[@"text_color"] != nil ){
            view_r.textColor = [self getColor:attribute.attrs[@"text_color"]];
        }
        if( attribute.attrs[@"font_fit"] ){
            view_r.kxAutoFontSize = [attribute.attrs[@"font_fit"] boolValue];
        }
        if( attribute.attrs[@"text_align"] ){
            NSString *align = attribute.attrs[@"text_align"];
            if( [align isEqualToString:@"left"] ){
                view_r.textAlignment = NSTextAlignmentLeft;
            }else if( [align isEqualToString:@"center"] ){
                view_r.textAlignment = NSTextAlignmentCenter;
            }else if( [align isEqualToString:@"right"] ){
                view_r.textAlignment = NSTextAlignmentRight;
            }
        }
        if( attribute.attrs[@"line_break_mode"] != nil ){
            NSString *mode = attribute.attrs[@"line_break_mode"];
            if( [mode isEqualToString:@"wordwrap"] ){
                view_r.numberOfLines = 0;
                view_r.lineBreakMode = NSLineBreakByWordWrapping;
            }else if( [mode isEqualToString:@"clip"] ){
                view_r.lineBreakMode = NSLineBreakByClipping;
            }else if( [mode isEqualToString:@"truncate_tail"] ){
                view_r.lineBreakMode = NSLineBreakByTruncatingTail;
            }else if( [mode isEqualToString:@"truncate_middle"] ){
                view_r.lineBreakMode = NSLineBreakByTruncatingMiddle;
            }else if( [mode isEqualToString:@"truncate_head"] ){
                view_r.lineBreakMode = NSLineBreakByTruncatingHead;
            }
        }

    }];
    
    [self registerViewHandlerForWidget:@"UIButton" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UIButton alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(UIButton);
        
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        
        if( attribute.attrs[@"text"] != nil ){
            [view_r setTitle:[self getText:attribute.attrs[@"text"]] forState:UIControlStateNormal];
        }
        
        if( attribute.attrs[@"text_color"] != nil ){
            NSString *textColor = attribute.attrs[@"text_color"];
            UIColor *defaultTextColor = [self getColor:textColor];
            [view_r setTitleColor:defaultTextColor forState:UIControlStateNormal];
            
            UIColor *pressedTextColor = [defaultTextColor darkerColor];
            if( [pressedTextColor isEqualToColor:defaultTextColor] ){
                pressedTextColor = [defaultTextColor lighterColor];
            }
            [view_r setTitleColor:pressedTextColor forState:UIControlStateHighlighted];
        }
        
        double fontSize = 14.0;
        if( attribute.attrs[@"font_size"] != nil ){
            fontSize = [attribute.attrs[@"font_size"] doubleValue];
        }
        view_r.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        if( attribute.attrs[@"image"] != nil ){
            NSString *imageName = attribute.attrs[@"image"];
            [view_r setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        if( attribute.attrs[@"image_highlighted"] != nil ){
            NSString *imageName = attribute.attrs[@"image_highlighted"];
            [view_r setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        }
        if( attribute.attrs[@"image_disabled"] != nil ){
            NSString *imageName = attribute.attrs[@"image_disabled"];
            [view_r setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
        }
        if( attribute.attrs[@"font_fit"] != nil ){
            view_r.kxAutoFontSize = [attribute.attrs[@"font_fit"] boolValue];
        }

    }];
    
    [self registerViewHandlerForWidget:@"UIImageView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UIImageView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(UIImageView);
        
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        if( attribute.attrs[@"image"] != nil ){
            NSString *imageName = attribute.attrs[@"image"];
            [view_r setImage:[UIImage imageNamed:imageName]];
        }
        if( attribute.attrs[@"content_mode"] != nil ){
            NSString *mode = attribute.attrs[@"content_mode"];
            if( [mode isEqualToString:@"aspect_fit"] ){
                view_r.contentMode = UIViewContentModeScaleAspectFit;
            }else if( [mode isEqualToString:@"aspect_fill"] ){
                view_r.contentMode = UIViewContentModeScaleAspectFill;
            }else if( [mode isEqualToString:@"fill"] ){
                view_r.contentMode = UIViewContentModeScaleToFill;
            }else if( [mode isEqualToString:@"center"] ){
                view_r.contentMode = UIViewContentModeCenter;
            }
        }
    }];
    
    [self registerViewHandlerForWidget:@"UITextField" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UITextField alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {

        KX_CAST_VIEW(UITextField);
        
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        
        if( attribute.attrs[@"text"] != nil ){
            view_r.text = [self getText:attribute.attrs[@"text"]];
        }
        if( attribute.attrs[@"placeholder"] ){
            view_r.placeholder = [self getText:attribute.attrs[@"placeholder"]];
        }
        double fontSize = 14;
        if( attribute.attrs[@"font_size"] ){
            fontSize = [attribute.attrs[@"font_size"] doubleValue];
        }
        view_r.font = [UIFont systemFontOfSize:fontSize];
        
        if( attribute.attrs[@"text_color"] != nil ){
            NSString *textColor = attribute.attrs[@"text_color"];
            view_r.textColor = [self getColor:textColor];
        }
        if( attribute.attrs[@"font_fit"] != nil ){
            view_r.kxAutoFontSize = [attribute.attrs[@"font_fit"] boolValue];
        }
        if( attribute.attrs[@"text_align"] != nil ){
            NSString *align = attribute.attrs[@"text_align"];
            if( [align isEqualToString:@"left"] ){
                view_r.textAlignment = NSTextAlignmentLeft;
            }else if( [align isEqualToString:@"center"] ){
                view_r.textAlignment = NSTextAlignmentCenter;
            }else if( [align isEqualToString:@"right"] ){
                view_r.textAlignment = NSTextAlignmentRight;
            }
        }
        if( attribute.attrs[@"v_align"] != nil ){
            NSString *align = attribute.attrs[@"v_align"];
            if( [align isEqualToString:@"top"] ){
                view_r.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            }else if( [align isEqualToString:@"center"] ){
                view_r.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            }else if( [align isEqualToString:@"bottom"] ){
                view_r.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            }
        }
        if( attribute.attrs[@"clear_button"] != nil ){
            NSString *clearButtonMode = attribute.attrs[@"clear_button"];
            if( [clearButtonMode isEqualToString:@"always"] ){
                view_r.clearButtonMode = UITextFieldViewModeAlways;
            }else if( [clearButtonMode isEqualToString:@"editing"] ){
                view_r.clearButtonMode = UITextFieldViewModeWhileEditing;
            }else if( [clearButtonMode isEqualToString:@"none"] || clearButtonMode.length == 0 ){
                view_r.clearButtonMode = UITextFieldViewModeNever;
            }
        }
        if( attribute.attrs[@"keyboard_type"] != nil ){
            NSString *keyboardType = attribute.attrs[@"keyboard_type"];
            if( [keyboardType isEqualToString:@"default"] ){
                view_r.keyboardType = UIKeyboardTypeDefault;
            }else if( [keyboardType isEqualToString:@"ascii"] ){
                view_r.keyboardType = UIKeyboardTypeASCIICapable;
            }else if( [keyboardType isEqualToString:@"number"] ){
                view_r.keyboardType = UIKeyboardTypeNumberPad;
            }else if( [keyboardType isEqualToString:@"phone"] ){
                view_r.keyboardType = UIKeyboardTypePhonePad;
            }else if( [keyboardType isEqualToString:@"email"] ){
                view_r.keyboardType = UIKeyboardTypeEmailAddress;
            }else if( [keyboardType isEqualToString:@"websearch"] ){
                view_r.keyboardType = UIKeyboardTypeWebSearch;
            }else if( [keyboardType isEqualToString:@"number_p"] ){
                view_r.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }else if( [keyboardType isEqualToString:@"decimal"] ){
                view_r.keyboardType = UIKeyboardTypeDecimalPad;
            }
        }
        if( attribute.attrs[@"return_key"] != nil ){
            NSString *returnKey = attribute.attrs[@"return_key"];
            if( [returnKey isEqualToString:@"default"] ){
                view_r.returnKeyType = UIReturnKeyDefault;
            }else if( [returnKey isEqualToString:@"done"] ){
                view_r.returnKeyType = UIReturnKeyDone;
            }else if( [returnKey isEqualToString:@"go"] ){
                view_r.returnKeyType = UIReturnKeyGo;
            }else if( [returnKey isEqualToString:@"next"] ){
                view_r.returnKeyType = UIReturnKeyNext;
            }else if( [returnKey isEqualToString:@"search"] ){
                view_r.returnKeyType = UIReturnKeySearch;
            }else if( [returnKey isEqualToString:@"route"] ){
                view_r.returnKeyType = UIReturnKeyRoute;
            }else if( [returnKey isEqualToString:@"join"] ){
                view_r.returnKeyType = UIReturnKeyJoin;
            }
        }
        if( attribute.attrs[@"password"] != nil ){
            if( [attribute.attrs[@"password"] boolValue] ){
                view_r.secureTextEntry = YES;
            }else{
                view_r.secureTextEntry = NO;
            }
        }

    }];
    
    [self registerViewHandlerForWidget:@"UITextView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UITextView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        KX_CAST_VIEW(UITextView);
        
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
        if( attribute.attrs[@"text"] != nil ){
            view_r.text = [self getText:attribute.attrs[@"text"]];
        }
        double fontSize = 14;
        std::string fontName = "DEFAULT_FONT";
        if( attribute.attrs[@"font_size"] != nil ){
            fontSize = [attribute.attrs[@"font_size"] doubleValue];
        }
        view_r.font = [UIFont systemFontOfSize:fontSize];
        
        if( attribute.attrs[@"text_color"] != nil ){
            NSString *textColor = attribute.attrs[@"text_color"];
            view_r.textColor = [self getColor:textColor];
        }
        if( attribute.attrs[@"text_align"] != nil ){
            NSString *align = attribute.attrs[@"text_align"];
            if( [align isEqualToString:@"left"] ){
                view_r.textAlignment = NSTextAlignmentLeft;
            }else if( [align isEqualToString:@"center"] ){
                view_r.textAlignment = NSTextAlignmentCenter;
            }else if( [align isEqualToString:@"right"] ){
                view_r.textAlignment = NSTextAlignmentRight;
            }
        }

    }];
    
    [self registerViewHandlerForWidget:@"UIWebView" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UIWebView alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
    }];
    
    [self registerViewHandlerForWidget:@"UISearchBar" onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        *view = [[UISearchBar alloc] init];
    } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
        [self setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
    }];
}

-(void) parseJsonViewWithAttribute:(KXViewAttribute **) currentViewAttribute jsonView:(NSDictionary *)jsonView
{
    NSDictionary *item = jsonView;
    
    KXViewAttribute *ni = [[KXViewAttribute alloc] init];
    
    if( item[@"name"] != nil ){
        ni.name = item[@"name"];
    }
    
    if( ni.name == nil || ni.name.length == 0 ){
        ni.name = KX_TO_NSSTRING(KXStringHelper::getRandomString("KX_", 8));
    }
    
    ni.widget = item[@"widget"];
    
    if( item[@"layout"] != nil ){
        ni.autoLayout = [item[@"layout"] boolValue];
    }else{
        ni.autoLayout = true;
    }
    
    if( item[@"ios_auto_edge"] ){
        ni.iosAutoEdge = [item[@"ios_auto_edge"] boolValue];
    }
    if( item[@"ignore_size"] ){
        ni.ignoreSizeAdjustment = [item[@"ignore_size"] boolValue];
    }
    if( item[@"attr"] != nil ) {
        NSArray *jsonProperties = item[@"attr"];
        for( int i = 0 ; i < [jsonProperties count] ; ++i ){
            
            NSString *name =  jsonProperties[i][@"name"];
            
            id jsonValue = jsonProperties[i][@"value"];
            
            const int dataType = [[KXJsonSharedCache sharedManager] attributeDataTypeForName:name];
            
            if(  dataType != -1 ){
                
                KXVariantType castDataType = (KXVariantType) dataType;
                
                if( castDataType == KXVariantTypeINTEGER ){
                    ni.attrs[name] = @(KXJSONParseHelper::getInteger(jsonValue));
                }else if( castDataType == KXVariantTypeREAL ){
                    ni.attrs[name] = @(KXJSONParseHelper::getReal(jsonValue));
                }else if( castDataType == KXVariantTypeSTRING ){
                    ni.attrs[name] = KX_TO_NSSTRING(KXJSONParseHelper::getString(jsonValue));
                }else if( castDataType == KXVariantTypeUI_POINT ){
                    ni.attrs[name] = [NSValue valueWithCGPoint:KXJSONParseHelper::getPoint(jsonValue)];
                }else if( castDataType == KXVariantTypeUI_SIZE ){
                    ni.attrs[name] = [NSValue valueWithCGSize:KXJSONParseHelper::getSize(jsonValue)];
                }else if( castDataType == KXVariantTypeUI_RECT ){
                    ni.attrs[name] = [NSValue valueWithCGRect:KXJSONParseHelper::getRect(jsonValue)];
                }else if( castDataType == KXVariantTypeUI_EDGE ){
                    ni.attrs[name] = [NSValue valueWithUIEdgeInsets:KXJSONParseHelper::getEdge(jsonValue)];
                }
            }
        }
        if( ni.attrs[@"visibility"] != nil ){
            if( [ni.attrs[@"visibility"] isEqualToString:@"gone"] ){
                ni.autoLayout = false;
            }
        }
    }
    if( [item[@"subviews"] isKindOfClass:[NSArray class]] ){
        for( NSDictionary *jsonSubview in (NSArray *)item[@"subviews"] ){
            KXViewAttribute *v = nil;
            [self parseJsonViewWithAttribute:&v jsonView:jsonSubview];
            if( v != nil ){
                [ni.subviews addObject:v];
            }
        }
    }
    
    if( currentViewAttribute == nil ){
        self.rootAttribute = ni;
    }else{
        *currentViewAttribute = ni;
    }
}

-(UIView *) createViewWithParent:(NSString *)parentWidget attribute:(KXViewAttribute *) viewAttribute
{
    NSAssert( viewAttribute.name != nil && viewAttribute.name.length > 0 , @"Widget name cannot be empty. Please check your json UI file." );
    NSAssert( viewAttribute.widget != nil && viewAttribute.widget.length > 0 , @"Widget type cannot be empty. Please check your json UI file." );
    {
        KXViewConfigureHandler handler1 = [[KXViewHandlerManager sharedManager] getCreationHandlerForWidget:viewAttribute.widget];
        if( handler1 != nil ){
            UIView* pView = nil;
            handler1(parentWidget, viewAttribute, &pView);
            if( pView != nil ){
                KXViewConfigureHandler handler2 = [[KXViewHandlerManager sharedManager] getSetupHandlerForWidget:viewAttribute.widget];
                if( handler2 != nil ){
                    handler2(parentWidget, viewAttribute, &pView);
                }
            }
            return pView;
        }
    }
    NSLog(@"Unable to create view with widget type:%@", viewAttribute.widget );
    return nil;

}

-(void) internalBuildWithParent:(NSString *) parentWidget
                    attribute:(KXViewAttribute *) attribute
                      container:(UIView *) container
                        hashKey:(unsigned int) hashKey
{
    NSAssert( container != nil , @"You cannot create a view on a NIL view object." );
    
    UIView *view = [self createViewWithParent:parentWidget attribute:attribute];
    
    NSAssert( view != nil , @"Unable to create view for widget type: %@", attribute.widget );
    
    if( view != nil ){
        if( attribute.autoLayout ){
            view.kxEnabled = YES;
        }else{
            view.kxEnabled = NO;
        }
        view.kxLayoutHashKey = hashKey;
        [container addSubview:view];
        for( KXViewAttribute *subviewAttribute in attribute.subviews ){
            [self internalBuildWithParent: attribute.widget
                                attribute: subviewAttribute
                                container: view
                                  hashKey:hashKey];
        }
    }
}

-(void) internalBuildWithReuse:(NSString *) parentWidget
                      attribute:(KXViewAttribute *) attribute
                      container:(UIView *) container
                     oldHashKey:(unsigned int) oldHashKey
                        hashKey:(unsigned int) hashKey
{
    assert( container != nil );
    UIView *view = nil;
    bool canResuse = false;

    for( int i=0;i<flattenNodeList_.size();++i ){
        if( attribute.name != nil && attribute.name.length > 0 &&
            flattenNodeList_[i].kxName != nil && [flattenNodeList_[i].kxName isEqualToString:attribute.name] ){
            view = flattenNodeList_[i];
            flattenNodeList_.erase(flattenNodeList_.begin()+i);
            break;
        }
    }

    if( view != nil &&
       attribute.widget != nil &&
       attribute.widget.length > 0 &&
       [NSStringFromClass([view class]) isEqualToString: attribute.widget] ){
        canResuse = true;
    }
    if( canResuse ){
        
        NSAssert( [[KXViewHandlerManager sharedManager] getSetupHandlerForWidget:attribute.widget] != nil , @"View setup handler not found." );
        KXViewConfigureHandler setupHandler = [[KXViewHandlerManager sharedManager] getSetupHandlerForWidget:attribute.widget];
        setupHandler(parentWidget, attribute, &view);
    }else{
        view = [self createViewWithParent:parentWidget attribute:attribute];
    }
    NSAssert( view != nil, @"Unable to create view." );
    if( view != nil ){
        if( attribute.autoLayout ){
            view.kxEnabled = YES;
        }else{
            view.kxEnabled = NO;
        }
        view.kxLayoutHashKey = hashKey;
        [container addSubview:view];
        for( KXViewAttribute *subviewAttribute in attribute.subviews ){
            [self internalBuildWithReuse: attribute.widget
                                attribute: subviewAttribute
                                container: view
                              oldHashKey:oldHashKey
                                  hashKey:hashKey];
        }
    }
}

+(void) setupCommonAttributesWithParent:(NSString *)parentWidget
                              attribute:(KXViewAttribute *)attribute
                                   view:(UIView *)view
{
    if( [parentWidget isEqualToString:@"KXLinearLayout"] ){
        view.kxName = attribute.name;
        KXLinearLayoutParams *params = [[KXLinearLayoutParams alloc] init];
        if( attribute.ignoreSizeAdjustment == false ){
            CGSize theSize = [attribute.attrs[@"size"] CGSizeValue];
            params.width = theSize.width;
            params.height = theSize.height;
            if( params.width >= 0 ){
                view.width = params.width;
                view.kxMeasuredSize = CGSizeMake(params.width, view.kxMeasuredSize.height);
            }
            if( params.height >= 0 ){
                view.height = params.height;
                view.kxMeasuredSize = CGSizeMake(view.kxMeasuredSize.width, params.height);
            }
        }
        params.weight = [attribute.attrs[@"weight"] intValue];
        
        if( attribute.attrs[@"margins"] != nil ){
            params.margins = [attribute.attrs[@"margins"] UIEdgeInsetsValue];
        }
        
        if( attribute.attrs[@"gravity"] != nil ){
            NSString *gravity = attribute.attrs[@"gravity"];
            if( [gravity isEqualToString:@"start"] ){
                params.gravity = KXLinearLayoutGravityStart;
            }else if( [gravity isEqualToString:@"center"] ){
                params.gravity = KXLinearLayoutGravityCenter;
            }else if( [gravity isEqualToString:@"end"] ){
                params.gravity = KXLinearLayoutGravityEnd;
            }
        }
        
        view.kxLinearParams = params;
        
        if( attribute.attrs[@"alpha"] != nil ){
            view.alpha = [attribute.attrs[@"alpha"] doubleValue];
        }
        
        if( attribute.attrs[@"color"] != nil ){
            NSString *color = attribute.attrs[@"color"];
            view.backgroundColor = [self getColor:color];
        }
        
        if( attribute.attrs[@"visible"] != nil ){
            view.hidden = ![attribute.attrs[@"visible"] boolValue];
        }
        
        if( attribute.attrs[@"visibility"] != nil ){
            NSString *visibility = attribute.attrs[@"visibility"];
            if( [visibility isEqualToString:@"visible"] ){
                view.hidden = NO;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"invisible"] ){
                view.hidden = YES;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"gone"] ){
                view.hidden = YES;
                view.kxGone = YES;
                attribute.autoLayout = false;
            }
        }
        
    }else if( [parentWidget isEqualToString:@"KXRelativeLayout"] ){

        view.kxName = attribute.name;
        
        KXRelativeLayoutParams *params = [[KXRelativeLayoutParams alloc] init];
        
        if( attribute.ignoreSizeAdjustment == false ){
            CGSize theSize = [attribute.attrs[@"size"] CGSizeValue];
            params.width = theSize.width;
            params.height = theSize.height;
            if( params.width >= 0 ){
                view.width = params.width;
            }
            if( params.height >= 0 ){
                view.height = params.height;
            }
        }
        if( attribute.attrs[@"align_left"] != nil ){
            params.rules[@(KXRelativeLayoutRuleAlignLeft)] = attribute.attrs[@"align_left"];
        }
        if( attribute.attrs[@"align_top"] != nil ){
            params.rules[@(KXRelativeLayoutRuleAlignTop)] = attribute.attrs[@"align_top"];
        }
        if( attribute.attrs[@"align_right"] != nil ){
            params.rules[@(KXRelativeLayoutRuleAlignRight)] = attribute.attrs[@"align_right"];
        }
        if( attribute.attrs[@"align_bottom"] != nil ){
            params.rules[@(KXRelativeLayoutRuleAlignBottom)] = attribute.attrs[@"align_bottom"];
        }
        if( attribute.attrs[@"left_of"] != nil ){
            params.rules[@(KXRelativeLayoutRuleLeftOf)] = attribute.attrs[@"left_of"];
        }
        if( attribute.attrs[@"right_of"] != nil ){
            params.rules[@(KXRelativeLayoutRuleRightOf)] = attribute.attrs[@"right_of"];
        }
        if( attribute.attrs[@"above"] != nil ){
            params.rules[@(KXRelativeLayoutRuleAbove)] = attribute.attrs[@"above"];
        }
        if( attribute.attrs[@"below"] != nil ){
            params.rules[@(KXRelativeLayoutRuleBelow)] = attribute.attrs[@"below"];
        }
        if( attribute.attrs[@"align_parent_left"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleAlignLeft)] = @([attribute.attrs[@"align_parent_left"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_right"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleAlignRight)] = @([attribute.attrs[@"align_parent_right"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_top"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleAlignTop)] = @([attribute.attrs[@"align_parent_top"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_bottom"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleAlignBottom)] = @([attribute.attrs[@"align_parent_bottom"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_center"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleCenter)] = @([attribute.attrs[@"align_parent_center"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_center_horizontal"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleCenterHorizontal)] = @([attribute.attrs[@"align_parent_center_horizontal"] boolValue]);
        }
        if( attribute.attrs[@"align_parent_center_vertical"] != nil ){
            params.parentRules[@(KXRelativeLayoutParentRuleCenterVertical)] = @([attribute.attrs[@"align_parent_center_vertical"] boolValue]);
        }
        if( attribute.attrs[@"margins"] != nil ){
            params.margins = [attribute.attrs[@"margins"] UIEdgeInsetsValue];
        }
        view.kxRelativeParams = params;
        
        if( attribute.attrs[@"alpha"] != nil ){
            view.alpha = [attribute.attrs[@"alpha"] doubleValue];
        }
        
        if( attribute.attrs[@"color"] != nil ){
            NSString *color = attribute.attrs[@"color"];
            view.backgroundColor = [self getColor:color];
        }
        
        if( attribute.attrs[@"visible"] != nil ){
            view.hidden = ![attribute.attrs[@"visible"] boolValue];
        }
        
        if( attribute.attrs[@"visibility"] != nil ){
            NSString *visibility = attribute.attrs[@"visibility"];
            if( [visibility isEqualToString:@"visible"] ){
                view.hidden = NO;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"invisible"] ){
                view.hidden = YES;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"gone"] ){
                view.hidden = YES;
                view.kxGone = YES;
                attribute.autoLayout = false;
            }
        }
        
    }else{
        
        view.kxName = attribute.name;
        
        KXRelativeLayoutParams *params = [[KXRelativeLayoutParams alloc] init];
        
        CGSize theSize = [attribute.attrs[@"size"] CGSizeValue];
        params.width = theSize.width;
        params.height = theSize.height;
        if( params.width >= 0 ){
            view.width = params.width;
        }
        if( params.height >= 0 ){
            view.height = params.height;
        }
        view.kxRelativeParams = params;
        
        if( attribute.attrs[@"alpha"] != nil ){
            view.alpha = [attribute.attrs[@"alpha"] doubleValue];
        }
        
        if( attribute.attrs[@"color"] != nil ){
            NSString *color = attribute.attrs[@"color"];
            view.backgroundColor = [self getColor:color];
        }
        if( attribute.attrs[@"visible"] != nil ){
            view.hidden = ![attribute.attrs[@"visible"] boolValue];
        }
        if( attribute.attrs[@"visibility"] != nil ){
            NSString *visibility = attribute.attrs[@"visibility"];
            if( [visibility isEqualToString:@"visible"] ){
                view.hidden = NO;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"invisible"] ){
                view.hidden = YES;
                attribute.autoLayout = true;
            }else if( [visibility isEqualToString:@"gone"] ){
                view.hidden = YES;
                view.kxGone = YES;
                attribute.autoLayout = false;
            }
        }
    }
    if( attribute.iosAutoEdge ){
        view.kxAutoAdjustForFullLayout = YES;
    }else{
        view.kxAutoAdjustForFullLayout = NO;
    }
    if( attribute.attrs[@"tag"] != nil ){
        view.tag = [attribute.attrs[@"tag"] intValue];
    }
    if( attribute.ignoreSizeAdjustment ){
        view.kxIngoreSizeAdjustment = YES;
    }else{
        view.kxIngoreSizeAdjustment = NO;
    }
}

+(NSString *) getText:(NSString *) text
{
    return text;
}


+(UIColor*) getColor:(NSString *) color
{
    NSAssert( color != nil , @"color string cannot be NIL.");
    if( [color isEqualToString:@"clear"] ||
        [color isEqualToString:@"pure"] ||
        [color isEqualToString:@"transparent"] ||
        color.length == 0 ){
        return [UIColor clearColor];
    }else if( [color isEqualToString:@"white"] ){
        return [UIColor whiteColor];
    }else if( [color isEqualToString:@"black"] ){
        return [UIColor blackColor];
    }else if( [color isEqualToString:@"gray"] ){
        return [UIColor grayColor];
    }else if( [color isEqualToString:@"blue"] ){
        return [UIColor blueColor];
    }else if( [color isEqualToString:@"red"] ){
        return [UIColor redColor];
    }else if( [color isEqualToString:@"green"] ){
        return [UIColor greenColor];
    }else if( [color isEqualToString:@"yellow"] ){
        return [UIColor yellowColor];
    }else if( color.length >= 7 && [color characterAtIndex:0] == '#' ){
        return [UIColor colorWithCSS:color];
    }else{
        NSLog(@"Unsupported color string: %@", color );
        return [UIColor clearColor];
    }
}

+(void) registerAttributeDataTypeForName:(NSString *)name dataType:(NSString *)dataType
{
    [[KXJsonSharedCache sharedManager] registerAttributeDataTypeForName:name dataType:dataType];
}

@end
