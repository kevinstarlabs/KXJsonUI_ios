// UIView+KXLayout.mm
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

#import "UIView+KXLayout.h"
#import "UIView+KXFrame.h"
#import "KXLinearLayout.h"
#import "KXRelativeLayout.h"
#import "KXCommon.h"
#import <objc/runtime.h>
#include <queue>

#define IS_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] && \
![x isKindOfClass:[UITableView class]] && \
![x isKindOfClass:[UICollectionView class]])

#define IS_INHERIT_FROM_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] ||  \
[x isKindOfClass:[UITableView class]] || \
[x isKindOfClass:[UICollectionView class]])

#define IS_K_LAYOUT_CLASS(x) ([x isKindOfClass:[KXLinearLayout class]] || \
[x isKindOfClass:[KXRelativeLayout class]])

@implementation UIView (KXLayout)

@dynamic kxName;
@dynamic kxMinSize;
@dynamic kxMeasuredSize;
@dynamic kxAutoAdjustForFullLayout;
@dynamic kxEnabled;
@dynamic kxDebug;
@dynamic kxLinearParams;
@dynamic kxRelativeParams;
@dynamic kxOrder;
@dynamic kxProperty;

-(void) setKxName:(NSString *)kxName{
    objc_setAssociatedObject(self,
                             @selector(kxName),
                             (id)kxName,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *) kxName{
    return objc_getAssociatedObject(self, @selector(kxName));
}

-(void) setKxMinSize:(CGSize)kxMinSize{
    objc_setAssociatedObject(self,
                             @selector(kxMinSize),
                             (id)[NSValue valueWithCGSize:kxMinSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGSize) kxMinSize{
    return [objc_getAssociatedObject(self, @selector(kxMinSize)) CGSizeValue];
}

-(void) setKxMeasuredSize:(CGSize)kxMeasuredSize{
    objc_setAssociatedObject(self,
                             @selector(kxMeasuredSize),
                             (id)[NSValue valueWithCGSize:kxMeasuredSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGSize) kxMeasuredSize{
    return [objc_getAssociatedObject(self, @selector(kxMeasuredSize)) CGSizeValue];
}

-(void) setKxAutoAdjustForFullLayout:(BOOL)kxAutoAdjustForFullLayout
{
    objc_setAssociatedObject(self,
                             @selector(kxAutoAdjustForFullLayout),
                             (id)[NSNumber numberWithBool:kxAutoAdjustForFullLayout],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxAutoAdjustForFullLayout{
    return [objc_getAssociatedObject(self, @selector(kxAutoAdjustForFullLayout)) boolValue];
}

-(void) setKxEnabled:(BOOL)kxEnabled{
    objc_setAssociatedObject(self,
                             @selector(kxEnabled),
                             (id)[NSNumber numberWithBool:kxEnabled],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxEnabled{
    return [objc_getAssociatedObject(self, @selector(kxEnabled)) boolValue];
}


-(void) setKxGone:(BOOL)kxGone{
    if( kxGone == YES ){
        self.kxEnabled = NO;
        self.hidden = YES;
    }else{
        self.kxEnabled = YES;
        self.hidden = NO;
    }
}

-(BOOL) kxGone{
    return self.hidden;
}

-(void) setKxDebug:(BOOL)kxDebug{
    objc_setAssociatedObject(self,
                             @selector(kxDebug),
                             (id)[NSNumber numberWithBool:kxDebug],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxDebug{
    return [objc_getAssociatedObject(self, @selector(kxDebug)) boolValue];
}

-(void) setKxDisableViewLookup:(BOOL)kxDisableViewLookup{
    objc_setAssociatedObject(self,
                             @selector(kxDisableViewLookup),
                             (id)[NSNumber numberWithBool:kxDisableViewLookup],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxDisableViewLookup{
    return [objc_getAssociatedObject(self, @selector(kxDisableViewLookup)) boolValue];
}

-(void) setKxIngoreSizeAdjustment:(BOOL)kxIngoreSizeAdjustment{
    objc_setAssociatedObject(self,
                             @selector(kxIngoreSizeAdjustment),
                             (id)[NSNumber numberWithBool:kxIngoreSizeAdjustment],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxIngoreSizeAdjustment{
    return [objc_getAssociatedObject(self, @selector(kxIngoreSizeAdjustment)) boolValue];
}

-(void) setKxAutoFontSize:(BOOL)kxAutoFontSize{
    objc_setAssociatedObject(self,
                             @selector(kxAutoFontSize),
                             (id)[NSNumber numberWithBool:kxAutoFontSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL) kxAutoFontSize{
    return [objc_getAssociatedObject(self, @selector(kxAutoFontSize)) boolValue];
}

-(void) setKxLinearParams:(KXLinearLayoutParams *)kxLinearParams{
    objc_setAssociatedObject(self,
                             @selector(kxLinearParams),
                             (id)kxLinearParams,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KXLinearLayoutParams *) kxLinearParams{
    return objc_getAssociatedObject(self, @selector(kxLinearParams));
}

-(void) setKxRelativeParams:(KXRelativeLayoutParams *)kxRelativeParams{
    objc_setAssociatedObject(self,
                             @selector(kxRelativeParams),
                             (id)kxRelativeParams,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KXRelativeLayoutParams *) kxRelativeParams{
    return objc_getAssociatedObject(self, @selector(kxRelativeParams));
}

-(void) setKxOrder:(int)kxOrder{
    objc_setAssociatedObject(self,
                             @selector(kxOrder),
                             (id)[NSNumber numberWithInt:kxOrder],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(int) kxOrder{
    return [objc_getAssociatedObject(self, @selector(kxOrder)) intValue];
}

-(void) setKxProperty:(NSMutableDictionary *)kxProperty{
    objc_setAssociatedObject(self,
                             @selector(kxProperty),
                             (id)kxProperty,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *) kxProperty{
    return objc_getAssociatedObject(self, @selector(kxProperty));
}

-(void) setKxLayoutHashKey:(unsigned int)kxLayoutHashKey{
    objc_setAssociatedObject(self,
                             @selector(kxLayoutHashKey),
                             (id)[NSNumber numberWithUnsignedInt:kxLayoutHashKey],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(unsigned int) kxLayoutHashKey{
    return [objc_getAssociatedObject(self, @selector(kxLayoutHashKey)) unsignedIntValue];
}

-(UIView *) findWidgetByName:(NSString *) name{
    
    if( self.kxDisableViewLookup == YES ){
        return nil;
    }
    
    std::queue<UIView *> q;
    
    q.push(self);
    
    while( !q.empty() ){
        UIView *curNode = q.front();
        q.pop();
        if( curNode.kxName != nil && [curNode.kxName isEqualToString:name] ){
            return curNode;
        }
        if( curNode != nil ){
            NSArray *viewArray = [NSArray arrayWithArray:curNode.subviews];
            for (UIView *subview in viewArray)
            {
                if( subview != curNode && subview != nil && subview.kxDisableViewLookup == NO ){
                    q.push(subview);
                }
            }
        }
    }
    return nil;
}

-(UIView *) findWidgetByName:(NSString *) name hashKey:(unsigned int)hashKey{
    std::queue<UIView *> q;
    q.push(self);
    while( !q.empty() ){
        UIView *curNode = q.front();
        q.pop();
        if( curNode.kxName != nil && [curNode.kxName isEqualToString:name] && curNode.kxLayoutHashKey == hashKey ){
            return curNode;
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
    return nil;
}

-(void) kxInvalidateLayout{
    
    const CGFloat statusBarHeight = 20;
    const CGFloat horizontalNavigationBarHeight = 32;
    const CGFloat verticalNavigationBarHeight = 44;
    
    UIViewController *controller = UIViewParentController(self);
    for (UIView *subview in self.subviews)
    {
        if( subview.kxEnabled == NO ) continue;
        if( subview.kxIngoreSizeAdjustment == YES ) continue;
        if( IS_K_LAYOUT_CLASS(subview) ){
            if( !IS_K_LAYOUT_CLASS(self) ){
                
                if( IS_SCROLLVIEW(self) ){
                    CGSize containerSize = ((UIScrollView *)self).contentSize;
                    subview.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
                    [subview setNeedsLayout];
                }else{
                    int adjustType = 0;
                    BOOL isTopLevelView = ([controller.view isEqual:self]);
                    if( isTopLevelView && subview.kxAutoAdjustForFullLayout == YES ){
                        if( [controller respondsToSelector:@selector(setEdgesForExtendedLayout:)] ){
#ifdef __IPHONE_7_0
                            if( controller.edgesForExtendedLayout & UIRectEdgeTop ){
                                adjustType = 1;
                            }else{
                                adjustType = 0;
                            }
#else
                            adjustType = 0;
#endif
                        }
                    }
                    CGSize containerSize = self.frame.size;
                    if( adjustType == 1 ){
                        CGFloat topMargin = 0;
                        if( IS_IN_PORTRAIT_MODE ){
                            topMargin += statusBarHeight + verticalNavigationBarHeight;
                        }else{
                            topMargin += statusBarHeight + horizontalNavigationBarHeight;
                        }
                        subview.frame = CGRectMake(0, topMargin, containerSize.width, containerSize.height - topMargin);
                        
                    }else if( adjustType == 0 ){
                        subview.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
                    }
                    [subview setNeedsLayout];
                }
            }else{
                // self and subview are klayout!
            }
        }else{
            if( IS_INHERIT_FROM_SCROLLVIEW(subview) ){
                int adjustType = 0;
                BOOL isTopScrollView = (controller.view == self );
                if( isTopScrollView && subview.kxAutoAdjustForFullLayout == YES ){
                    if( [controller respondsToSelector:@selector(setEdgesForExtendedLayout:)] &&
                       [controller respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)] ){
#ifdef __IPHONE_7_0
                        if( controller.automaticallyAdjustsScrollViewInsets == YES &&
                           (controller.edgesForExtendedLayout & UIRectEdgeTop) ){
                            adjustType = 0;
                        }else{
                            adjustType = 1;
                        }
#else
                        adjustType = 0;
#endif
                    }
                }
                CGSize containerSize = CGSizeZero;
                if( IS_SCROLLVIEW(self) ){
                    containerSize = ((UIScrollView *)self).contentSize;
                }else{
                    containerSize = self.frame.size;
                }
                if( adjustType == 1 ){
                    CGFloat topMargin = 0;
                    if( IS_IN_PORTRAIT_MODE ){
                        topMargin += statusBarHeight + verticalNavigationBarHeight;
                    }else{
                        topMargin += statusBarHeight + horizontalNavigationBarHeight;
                    }
                    subview.frame = CGRectMake(0, topMargin, containerSize.width, containerSize.height - topMargin);
                    
                }else if( adjustType == 0 ){
                    subview.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
                }
                if( IS_SCROLLVIEW(subview) ){
                    UIScrollView *childScrollView = (UIScrollView *)subview;
                    if( childScrollView.kxProperty != nil ){
                        if( [childScrollView.kxProperty valueForKey:@"content_size"] != nil ){
                            CGSize contentSize = [[childScrollView.kxProperty valueForKey:@"content_size"] CGSizeValue];
                            
                            if( contentSize.width == KX_MATCHPARENT || contentSize.width == KX_AUTO ){
                                contentSize.width = subview.width;
                            }
                            if( contentSize.height == KX_MATCHPARENT || contentSize.height == KX_AUTO ){
                                
                                double selfHeight = subview.height;
                                
                                CGFloat topMargin = 0;
                                
                                if( adjustType == 1 ){
                                    if( IS_IN_PORTRAIT_MODE ){
                                        topMargin += statusBarHeight + verticalNavigationBarHeight;
                                    }else{
                                        topMargin += statusBarHeight + horizontalNavigationBarHeight;
                                    }
                                }
                                if( self.kxAutoAdjustForFullLayout && topMargin > 0  ){
                                    contentSize.height = selfHeight - topMargin;
                                }else{
                                    contentSize.height = selfHeight;
                                }
                            }
                            [childScrollView setContentSize:contentSize];
                        }
                    }
                    [subview kxInvalidateLayout];
                }
            }else{
                [subview kxInvalidateLayout];
            }
        }
    }
}

@end
