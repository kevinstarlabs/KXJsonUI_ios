// KXStringHelper.mm
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

#include "KXStringHelper.h"
#include <cstring>
#include <cstdlib>
#include <strstream>
#include <sstream>
#include <iomanip>
#include <cassert>
#include <functional>
#include <cstdio>

std::string KXStringHelper::intToStr( int v )
{
    return std::to_string(v);
}

std::string KXStringHelper::uintToStr( unsigned int v )
{
    return std::to_string(v);
}

std::string KXStringHelper::doubleToStr( double v )
{
    return std::to_string(v);
}

int KXStringHelper::strToInt( const std::string& v )
{
    if( v.empty() ) return 0;
    return std::atoi( v.c_str() );
}

unsigned int KXStringHelper::strToUint( const std::string& v )
{
    if( v.empty() ) return 0;
    unsigned long r = std::stoul(v, 0, 10);
    return (unsigned int) r;
}

double KXStringHelper::strToDouble( const std::string& v )
{
    if( v.empty() ) return 0;
    return std::atof( v.c_str() );
}

float KXStringHelper::strToFloat( const std::string& v )
{
    if( v.empty() ) return 0;
    return (float) std::atof( v.c_str() );
}

std::string KXStringHelper::getRandomString( const std::string &prefix, int len)
{
    auto randchar = []() -> char
    {
        const char charset[] =
        "0123456789"
        "abcdefghijklmnopqrstuvwxyz";
        const size_t max_index = (sizeof(charset) - 1);
        return charset[ arc4random() % max_index ];
    };
    std::string str(len,0);
    std::generate_n( str.begin(), len, randchar );
    return prefix + str;
}

std::string KXStringHelper::getRandomNumericString( const std::string &prefix, int len)
{
    auto randchar = []() -> char
    {
        const char charset[] =
        "0123456789";
        const size_t max_index = (sizeof(charset) - 1);
        return charset[ random() % max_index ];
    };
    std::string str(len,0);
    std::generate_n( str.begin(), len, randchar );
    return prefix + str;
}

std::string KXStringHelper::strToHex( const std::string& input )
{
    if( input.length() == 0 ) return "";
    const char *hex = "0123456789ABCDEF";
    std::string ret;
    for( int i=0;i<input.length();++i ){
        unsigned char c = input[i];
        ret+= hex[ (c >> 4) & 0xf ];
        ret+= hex[ c & 0xf ];
    }
    assert( ret.length() % 2 == 0 );
    return ret;
}

std::string KXStringHelper::hexToStr( const std::string& input )
{
    //    CCLOG("before hexToStr:%s", input.c_str());
    if( input.length() == 0 ) return "";
    assert( input.length() % 2 == 0 );
    std::string ret;
    for( int i=0;i<input.length();i+=2 ){
        int b1,b2,b;
        unsigned char c1 = input[i];
        unsigned char c2 = input[i+1];
        if( c1 >= '0' && c1 <= '9' ){
            b1 = c1 - '0';
        }else{
            b1 = c1-'A'+10;
        }
        if( c2 >= '0' && c2 <= '9' ) {
            b2 = c2 - '0';
        } else {
            b2 = ( c2-'A'+10 );
        }
        b = ( b1 << 4 ) + b2;
        ret+= ( char ) b;
    }
    return ret;
}

std::string KXStringHelper::toUpper(const std::string &str)
{
    std::string ret;
    for( int i=0;i<str.length();++i )
        ret+=std::toupper(str[i]);
    return ret;
}

std::string KXStringHelper::toLower(const std::string &str)
{
    std::string ret;
    for( int i=0;i<str.length();++i )
        ret+=std::tolower(str[i]);
    return ret;
}

std::string KXStringHelper::replace(const std::string& str, const std::string& from, const std::string& to)
{
    if(from.empty())
        return str;
    std::string ret = str;
    size_t start_pos = 0;
    while((start_pos = ret.find(from, start_pos)) != std::string::npos) {
        ret.replace(start_pos, from.length(), to);
        start_pos += to.length();
    }
    return ret;
}

std::vector<std::string> KXStringHelper::split(const std::string &str, const std::string &delimiter)
{
    std::vector<std::string> tokens;
    std::string tmp;
    for( int i=0;i<str.length() ; ++i ){
        bool isDelimiter = false;
        for( int k=0;k<delimiter.length();++k ){
            if( str[i] == delimiter[k] ){
                isDelimiter = true;
                break;
            }
        }
        if( isDelimiter == false ){
            tmp += str[i];
        }else{
            if( tmp.length() > 0 ){
                tokens.push_back(tmp);
                tmp.clear();
            }
        }
    }
    if( tmp.length() > 0 ){
        tokens.push_back(tmp);
    }
    return tokens;
}

bool KXStringHelper::isDigit(const std::string &str)
{
    for( int i=0;i<str.length();++i ){
        if( !isdigit(str[i]) ){
            return false;
        }
    }
    return true && str.length() > 0;
}

bool KXStringHelper::isNumeric(const std::string &str)
{
    bool isValid = true;
    bool hasDecimalPlace = false;
    int j = 0;
    int len = (int) str.length();
    while( j < str.length() && (str[j] == ' '||str[j] == '\t'||str[j] == '\n'||str[j] == '\r') ){
        ++j;
    }
    while( len > 0 && (str[len-1] == ' '||str[len-1] == '\t'||str[len-1] == '\n'||str[len-1] == '\r') ){
        len--;
    }
    for( int i = j ; i < len ; ++i ){
        if( isdigit(str[i]) ||
            (hasDecimalPlace == false && str[i] == '.') ||
            (i == 0 && str[i] == '-') ||
            (i == 0 && str[i] == '+')
           ){
            hasDecimalPlace = (str[i] == '.');
        }else{
            isValid = false;
        }
    }
    
    if( isValid && str.length() > 0 ){
        return true;
    }else{
        return false;
    }
}

std::string KXStringHelper::trim(const std::string &str)
{
    std::string ret;
    int start = -1 , end = (int)str.length();
    for( int i=0;i<str.length();++i ){
        if( str[i] != ' ' ){
            break;
        }else{
            start = i;
        }
    }
    for( int i= (int)str.length()-1;i>=0;i-- ){
        if( str[i] != ' ' ){
            break;
        }else{
            end = i;
        }
    }
    for( int i = start + 1 ; i < end && i < str.length() ; ++i ){
        ret += str[i];
    }
    return ret;
}

bool KXStringHelper::equals(const std::string &str1, const std::string &str2, bool caseSensitive /*= true*/)
{
    if( str1.length() != str2.length() ) return false;
    for( size_t i=0;i<str1.length();++i ){
        if( tolower(str1[i]) != tolower(str2[i]) ){
            return false;
        }
    }
    return true;
}

unsigned long KXStringHelper::getHashCode(const std::string &str)
{
    unsigned long hash = 5381;
    for( size_t i=0;i<str.length();++i ){
        hash = ((hash << 5) + hash) + str[i]; /* hash * 33 + c */
    }
    return hash;
}

uint64_t KXStringHelper::getHashCode64(const std::string &str)
{
    uint64_t h = 1125899906842597L;
    size_t len = str.length();
    for (size_t i = 0; i < len; i++) {
        h = 31*h + str[i];
    }
    return h;
}

bool KXStringHelper::startsWith(const std::string &str, const std::string &prefix)
{
    if( str.length() < prefix.length() ) return false;
    for( int i=0;i<prefix.length();++i ){
        if( str[i] != prefix[i] ){
            return false;
        }
    }
    return true;
}

std::string KXStringHelper::stripPrefix(const std::string &str, const std::string &prefix)
{
    if( str.length() < prefix.length() ) return str;
    for( int i=0;i<prefix.length();++i ){
        if( str[i] != prefix[i] ){
            return str;
        }
    }
    if( str.length() == prefix.length() ) return "";
    return str.substr(prefix.length());
}

bool KXStringHelper::containsSubstring(const std::string &origin,const std::string &target, bool caseSensitive)
{
    if( origin.length() < target.length() ){
        return false;
    }
    if( caseSensitive ){
        return origin.find(target) != std::string::npos;
    }else{
        return toLower(origin).find(toLower(target)) != std::string::npos;
    }
}
