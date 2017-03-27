// KXRelativeLayoutParams.mm
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

#import "KXRelativeLayoutParams.h"

@implementation KXRelativeLayoutParams

- (id)init
{
    self = [super init];
    if (self) {
        self.rules = [[NSMutableDictionary alloc] init];
        self.parentRules = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(BOOL) containsRule:(NSUInteger) ruleId
{
    return [self.rules objectForKey:@(ruleId)] != nil &&
                [self.rules objectForKey:@(ruleId)].length > 0;
}

-(BOOL) containsParentRule:(NSUInteger) ruleId
{
    return [self.parentRules objectForKey:@(ruleId)] != nil &&
           [[self.parentRules objectForKey:@(ruleId)] boolValue] == YES;
}

-(NSString *) getRule:(NSUInteger) ruleId
{
    return [self.rules objectForKey:@(ruleId)];
}

@end
