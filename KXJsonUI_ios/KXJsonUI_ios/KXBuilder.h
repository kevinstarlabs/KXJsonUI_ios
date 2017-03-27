//
// KXBuilder.h
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
#import <UIKit/UIKit.h>

#import "UIViewController+KXSwizzling.h"
#import "UITableViewCell+KXSwizzling.h"
#import "UICollectionViewCell+KXSwizzling.h"

#import "UIView+KXLayout.h"
#import "KXLayoutParams.h"
#import "KXLinearLayoutParams.h"
#import "KXRelativeLayoutParams.h"
#import "KXLinearLayout.h"
#import "KXRelativeLayout.h"

#import "KXViewHandlerManager.h"
#import "KXJsonSharedCache.h"

@interface KXBuilder : NSObject

-(BOOL) loadFileWithName:(NSString * _Nonnull)fileName;

-(void) buildLayoutInView:(UIView * _Nonnull)view;

-(void) reloadAnotherLayoutInView:(UIView * _Nonnull)view;

#pragma mark - Static Methods

+(void) registerViewHandlerForWidget:(NSString * _Nonnull)widget
                          onCreation:(KXViewConfigureHandler _Nonnull) creationHandler
                             onSetup:(KXViewConfigureHandler _Nonnull) setupHandler;

+(void) unregisterViewHandlerForWidget:(NSString * _Nonnull)widget;


+(void) setupCommonAttributesWithParent:(NSString * _Nonnull)parentWidget
                              attribute:(KXViewAttribute * _Nonnull) attribute
                                   view:(UIView * _Nonnull)view;

+(void) registerAttributeDataTypeForName:(NSString * _Nonnull)name dataType:(NSString * _Nonnull)dataType;


@end
