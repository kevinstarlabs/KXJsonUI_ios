//
// KXJsonSharedCache.m
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

#import "KXJsonSharedCache.h"
#import "KXVariant.h"

#define registerAttributeDataType(x,y) ([self registerAttributeDataTypeForName:@x dataType:@y])

@interface KXJsonSharedCache()

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *jsonCacheTable;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *defaultAttributeDataTypeTable;


@end

@implementation KXJsonSharedCache

+ (KXJsonSharedCache *)sharedManager {
    static KXJsonSharedCache *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.jsonCacheTable = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.defaultAttributeDataTypeTable = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self registerCommonAttributes];
    }
    return self;
}

- (void)dealloc {
}

-(NSDictionary *) cachedJsonObjectWithFileName:(NSString *)fileName
{
    return self.jsonCacheTable[fileName];
}

-(void) addToCache:(NSDictionary *) jsonObject forFileName:(NSString *)fileName
{
    [self.jsonCacheTable setObject:jsonObject forKey:fileName];
}

-(void) registerCommonAttributes
{
    registerAttributeDataType("size","size");
    registerAttributeDataType("margins", "edge");
    registerAttributeDataType("text", "string");
    registerAttributeDataType("text_color", "string");
    registerAttributeDataType("color", "string");
    registerAttributeDataType("content_size", "size");
    registerAttributeDataType("direction", "string");
    registerAttributeDataType("item_size", "size");
    registerAttributeDataType("interitem_spacing", "real");
    registerAttributeDataType("line_spacing", "real");
    registerAttributeDataType("inner_padding", "real");
    registerAttributeDataType("font_size", "real");
    registerAttributeDataType("font_fit", "bool");
    registerAttributeDataType("text_align", "string");
    registerAttributeDataType("line_break_mode", "string");
    registerAttributeDataType("image", "string");
    registerAttributeDataType("image_highlighted", "string");
    registerAttributeDataType("image_disabled", "string");
    registerAttributeDataType("content_mode", "string");
    registerAttributeDataType("placeholder", "string");
    registerAttributeDataType("v_align", "string");
    registerAttributeDataType("clear_button", "string");
    registerAttributeDataType("keyboard_type", "string");
    registerAttributeDataType("return_key", "string");
    registerAttributeDataType("password", "string");
    registerAttributeDataType("gravity", "string");
    registerAttributeDataType("alpha", "real");
    registerAttributeDataType("visible", "bool");
    registerAttributeDataType("visibility", "string");
    registerAttributeDataType("password", "bool");
    registerAttributeDataType("align_left", "string");
    registerAttributeDataType("align_top", "string");
    registerAttributeDataType("align_right", "string");
    registerAttributeDataType("align_bottom", "string");
    registerAttributeDataType("left_of", "string");
    registerAttributeDataType("right_of", "string");
    registerAttributeDataType("above", "string");
    registerAttributeDataType("below", "string");
    registerAttributeDataType("align_parent_left", "bool");
    registerAttributeDataType("align_parent_right", "bool");
    registerAttributeDataType("align_parent_top", "bool");
    registerAttributeDataType("align_parent_bottom", "bool");
    registerAttributeDataType("align_parent_center", "bool");
    registerAttributeDataType("align_parent_center_horizontal", "bool");
    registerAttributeDataType("align_parent_center_vertical", "bool");
    registerAttributeDataType("tag", "int");
    registerAttributeDataType("weight", "int");
    registerAttributeDataType("orientation", "string");
}

-(void) registerAttributeDataTypeForName:(NSString *)name dataType:(NSString *)dataType
{
    if( [dataType isEqualToString:@"int"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeINTEGER);
    }else if( [dataType isEqualToString:@"real"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeREAL);
    }else if( [dataType isEqualToString:@"string"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeSTRING);
    }else if( [dataType isEqualToString:@"point"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeUI_POINT);
    }else if( [dataType isEqualToString:@"size"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeUI_SIZE);
    }else if( [dataType isEqualToString:@"edge"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeUI_EDGE);
    }else if( [dataType isEqualToString:@"rect"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeUI_RECT);
    }else if( [dataType isEqualToString:@"bool"] ){
        self.defaultAttributeDataTypeTable[name] = @((int)KXVariantTypeINTEGER);
    }
}

-(NSInteger) attributeDataTypeForName:(NSString *)name
{
    if( self.defaultAttributeDataTypeTable[name] == nil ){
        return -1;
    }
    return [self.defaultAttributeDataTypeTable[name] intValue];
}

@end
