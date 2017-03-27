// KXStringHelper.h
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
#ifndef __FrozenIce__StringHelper__
#define __FrozenIce__StringHelper__

#import <Foundation/Foundation.h>

#include <string>
#include <vector>

class KXStringHelper {
public:
    static std::string intToStr( int v );
    static std::string uintToStr( unsigned int v );
    static std::string doubleToStr( double v );
    static int strToInt( const std::string& v );
    static unsigned int strToUint( const std::string& v );
    static double strToDouble( const std::string& v );
    static float strToFloat( const std::string& v );
    static std::string getRandomString( const std::string &prefix, int len);
    static std::string getRandomNumericString( const std::string &prefix, int len);
    static std::string strToHex( const std::string& input );
    static std::string hexToStr( const std::string& input );
    static std::string toUpper(const std::string &str);
    static std::string toLower(const std::string &str);
    static std::string replace(const std::string& str, const std::string& from, const std::string& to);
    static std::vector<std::string> split(const std::string &str, const std::string &delimiter);
    static bool isDigit(const std::string &str);
    static bool isNumeric(const std::string &str);
    static std::string trim(const std::string &str);
    static bool equals(const std::string &str1,const std::string &str2, bool caseSensitive = true);
    static unsigned long getHashCode(const std::string &str);
    static uint64_t getHashCode64(const std::string &str);
    static bool startsWith(const std::string &str, const std::string &prefix);
    static std::string stripPrefix(const std::string &str, const std::string &prefix);
    static bool containsSubstring(const std::string &origin,const std::string &target, bool caseSensitive);
};

#endif
