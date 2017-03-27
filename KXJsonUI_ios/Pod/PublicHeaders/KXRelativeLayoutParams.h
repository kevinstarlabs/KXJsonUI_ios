// KXRelativeLayoutParams.h
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

#import "KXLayoutParams.h"

typedef NS_ENUM(NSUInteger, KXRelativeLayoutRule) {
    KXRelativeLayoutRuleLeftOf = 0,
    KXRelativeLayoutRuleRightOf,
    KXRelativeLayoutRuleAbove,
    KXRelativeLayoutRuleBelow,
    
    KXRelativeLayoutRuleAlignLeft,
    KXRelativeLayoutRuleAlignTop,
    KXRelativeLayoutRuleAlignRight,
    KXRelativeLayoutRuleAlignBottom,
    KXRelativeLayoutRuleCount
};

typedef NS_ENUM(NSUInteger, KXRelativeLayoutParentRule) {
    KXRelativeLayoutParentRuleAlignLeft = 0,
    KXRelativeLayoutParentRuleAlignRight,
    KXRelativeLayoutParentRuleAlignTop,
    KXRelativeLayoutParentRuleAlignBottom,
    
    KXRelativeLayoutParentRuleCenter,
    KXRelativeLayoutParentRuleCenterHorizontal,
    KXRelativeLayoutParentRuleCenterVertical,
    KXRelativeLayoutParentRuleCount
};

@interface KXRelativeLayoutParams : KXLayoutParams

@property(atomic, assign) float top;
@property(atomic, assign) float left;
@property(atomic, assign) float bottom;
@property(atomic, assign) float right;
@property(atomic, strong) NSMutableDictionary<NSNumber *, NSString *> *rules;
@property(atomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *parentRules;

-(BOOL) containsRule:(NSUInteger) ruleId;
-(BOOL) containsParentRule:(NSUInteger) ruleId;
-(NSString *) getRule:(NSUInteger) ruleId;

@end
