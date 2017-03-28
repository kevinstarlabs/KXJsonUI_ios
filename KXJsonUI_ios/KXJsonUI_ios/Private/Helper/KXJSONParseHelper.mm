// KXJSONParseHelper.mm
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

#import "KXJSONParseHelper.h"
#import "KXUnitHelper.h"
#import "KXStringHelper.h"
#import "../KXCommon.h"

int KXJSONParseHelper::getInteger(id jsonValue)
{
    if( [jsonValue isKindOfClass:[NSNumber class]] ){
        return [jsonValue intValue];
    }else if( [jsonValue isKindOfClass:[NSString class]] ){
        return (int) KXUnitHelper::convertValueWithUnit( KX_TO_CPPSTRING(jsonValue) );
    }else{
        return 0;
    }
}

double KXJSONParseHelper::getReal(id jsonValue)
{
    if( [jsonValue isKindOfClass:[NSNumber class]] ){
        return [jsonValue doubleValue];
    }else if( [jsonValue isKindOfClass:[NSString class]] ){
        return KXUnitHelper::convertValueWithUnit( KX_TO_CPPSTRING(jsonValue) );
    }else{
        return 0;
    }
}

double KXJSONParseHelper::getDimension(id jsonValue)
{
    double value = 0;
    if( [jsonValue isKindOfClass:[NSString class]] && [jsonValue isEqualToString:@"auto"] ){
        value = KX_AUTO;
    }else if( [jsonValue isKindOfClass:[NSString class]] && [jsonValue isEqualToString:@"match_parent"] ){
        value = KX_MATCHPARENT;
    }else{
        value = getReal(jsonValue);
    }
    return value;
}

std::string KXJSONParseHelper::getString(id jsonValue)
{
    if( [jsonValue isKindOfClass:[NSNumber class]] ){
        return KX_TO_CPPSTRING( [jsonValue stringValue] );
    }else if( [jsonValue isKindOfClass:[NSString class]] ){
        return KX_TO_CPPSTRING( jsonValue );
    }else{
        return "";
    }
}

CGSize KXJSONParseHelper::getSize(id jsonValue)
{
    CGSize value = CGSizeZero;
    if( [jsonValue isKindOfClass:[NSDictionary class]] ){
        value.width = getDimension(jsonValue[@"width"]);
        value.height = getDimension(jsonValue[@"height"]);
    }
    return value;
}

CGPoint KXJSONParseHelper::getPoint(id jsonValue)
{
    CGPoint value = CGPointZero;
    if( [jsonValue isKindOfClass:[NSDictionary class]] ){
        value.x = getReal(jsonValue[@"left"]);
        value.y = getReal(jsonValue[@"top"]);
    }
    return value;
}

CGRect KXJSONParseHelper::getRect(id jsonValue)
{
    CGRect value = CGRectZero;
    if( [jsonValue isKindOfClass:[NSDictionary class]] ){
            value.origin = CGPointMake( getReal(jsonValue[@"left"]),
                                       getReal(jsonValue[@"top"]) );
            value.size = CGSizeMake( getDimension(jsonValue[@"width"]),
                                    getDimension(jsonValue[@"height"]) );
    }
    return value;
}

UIEdgeInsets KXJSONParseHelper::getEdge(id jsonValue)
{
    UIEdgeInsets value = UIEdgeInsetsZero;
    if( [jsonValue isKindOfClass:[NSDictionary class]] ){
            value.left = getReal(jsonValue[@"left"]);
            value.top = getReal(jsonValue[@"top"]);
            value.right = getReal(jsonValue[@"right"]);
            value.bottom = getReal(jsonValue[@"bottom"]);
    }
    return value;
}
