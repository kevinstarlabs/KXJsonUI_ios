// KXUnitHelper.mm
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
#import <Foundation/Foundation.h>

#import "KXUnitHelper.h"
#import "KXStringHelper.h"
#import "KXScreenHelper.h"

double KXUnitHelper::convertValueWithUnit(const std::string &value)
{
    std::string tmp;
    std::string unit;
    for( int i=(int)value.length()-1;i>=0;--i ){
        if( isdigit(value[i]) ){
            break;
        }else if( isalpha(value[i]) ){
            unit = value[i] + unit;
        }else if( unit.length() > 0 ){
            break;
        }
    }
    if( unit.length() == 0 ) unit = "dp";
    
    NSCAssert( unit == "dp" || unit == "sp" || unit == "W" || unit == "H" ||
            unit == "w" || unit == "h", @"Invalid unit name." );
    
    for( int i=0;i<value.length();++i ){
        if( isalpha(value[i]) ) break;
        if( value[i] !=' ' && value[i] != '\t' && value[i] !=',' ){
            tmp += value[i];
        }
    }
    
    double origValue = KXStringHelper::strToDouble(tmp);
    double newValue = 0;
    if( unit == "dp" || unit == "sp" ){
        newValue = origValue;
    }else if( unit == "W" || unit == "w" ){
        newValue = origValue * [KXScreenHelper screenWidth];
    }else if( unit == "H" || unit == "h" ){
        newValue = origValue * [KXScreenHelper screenHeight];
    }
    return newValue;
}
