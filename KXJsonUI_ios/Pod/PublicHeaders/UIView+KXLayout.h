// UIView+KXLayout.h
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

#import <UIKit/UIKit.h>

#import "KXLinearLayoutParams.h"
#import "KXRelativeLayoutParams.h"

@interface UIView (KXLayout)


-(UIView *) findWidgetByName:(NSString *) name;
-(UIView *) findWidgetByName:(NSString *) name hashKey:(unsigned int)hashKey;

-(void) kxInvalidateLayout;

@property(nonatomic,retain) NSString* kxName;
@property(nonatomic,assign) CGSize kxMinSize;
@property(nonatomic,assign) CGSize kxMeasuredSize;
@property(nonatomic,assign) BOOL kxAutoAdjustForFullLayout;
@property(nonatomic,assign) BOOL kxEnabled;
@property(nonatomic,assign) BOOL kxGone;
@property(nonatomic,assign) BOOL kxDisableViewLookup;
@property(nonatomic,assign) BOOL kxDebug;
@property(nonatomic,assign) BOOL kxIngoreSizeAdjustment;
@property(nonatomic,assign) BOOL kxAutoFontSize;
@property(nonatomic,assign) KXLinearLayoutParams *kxLinearParams;
@property(nonatomic,assign) KXRelativeLayoutParams *kxRelativeParams;
@property(nonatomic,assign) int kxOrder;
@property(nonatomic,retain) NSMutableDictionary* kxProperty;
@property(nonatomic,assign) unsigned int kxLayoutHashKey;

@end
