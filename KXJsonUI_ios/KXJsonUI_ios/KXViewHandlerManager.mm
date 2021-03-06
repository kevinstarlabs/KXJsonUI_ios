//
// KXViewHandlerManager.m
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

#import "KXViewHandlerManager.h"

@interface KXViewHandlerManager()

@property(nonatomic, strong) NSMutableDictionary<NSString *,KXViewConfigureHandler> *viewCreationHandler;
@property(nonatomic, strong) NSMutableDictionary<NSString *,KXViewConfigureHandler> *viewSetupHandler;

@end

@implementation KXViewHandlerManager

+ (KXViewHandlerManager *)sharedManager {
    static KXViewHandlerManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.viewCreationHandler = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.viewSetupHandler = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc {
}

-(void) addCreationHandler:(KXViewConfigureHandler) handler forWidget:(NSString *)name
{
    [self.viewCreationHandler setObject:handler forKey:name];
}

-(void) addSetupHandler:(KXViewConfigureHandler) handler forWidget:(NSString *)name
{
    [self.viewSetupHandler setObject:handler forKey:name];
}

-(void) removeCreationHandlerForWidget:(NSString *)name
{
    [self.viewCreationHandler removeObjectForKey:name];
}

-(void) removeSetupHandlerForWidget:(NSString *)name
{
    [self.viewSetupHandler removeObjectForKey:name];
}

-(KXViewConfigureHandler) getCreationHandlerForWidget:(NSString *)name
{
    return self.viewCreationHandler[name];
}

-(KXViewConfigureHandler) getSetupHandlerForWidget:(NSString *)name
{
    return self.viewSetupHandler[name];
}

-(NSUInteger) numberOfCreationHandlers
{
    return [self.viewCreationHandler count];
}

-(BOOL) containsHandlerForWidget:(NSString *)name
{
    return self.viewCreationHandler[name] != nil && self.viewSetupHandler[name] != nil;
}


@end
