//
// KXCommon.h
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

#ifndef KXCommon_h
#define KXCommon_h

#include <string>

#define UIViewParentController(__view) ({ \
UIResponder *__responder = __view; \
while ([__responder isKindOfClass:[UIView class]]) \
__responder = [__responder nextResponder]; \
(UIViewController *)__responder; \
})

#define IOS_VERSION_OLDER_THAN_8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define SCREEN_WIDTH_CALCULATED (IOS_VERSION_OLDER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT_CALCULATED (IOS_VERSION_OLDER_THAN_8 ? (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.height)

#define IS_IN_LANDSCAPE_MODE (SCREEN_WIDTH_CALCULATED > SCREEN_HEIGHT_CALCULATED)
#define IS_IN_PORTRAIT_MODE (SCREEN_WIDTH_CALCULATED <= SCREEN_HEIGHT_CALCULATED)

#define KX_AUTO -1
#define KX_MATCHPARENT -2

template<class T>
const T& de_strref(const T* p) { return std::string(p); }

template<class T>
const T& de_strref(const T& r) { return r; }

#define KX_TO_NSSTRING(x) ([NSString stringWithUTF8String:(de_strref((x))).c_str()])
#define KX_TO_CPPSTRING(x) (x==nil?"":[x UTF8String])

#endif /* KXCommon_h */
