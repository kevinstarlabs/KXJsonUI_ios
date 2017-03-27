// KXFileHelper.mm
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

#import "KXFileHelper.h"

@implementation KXFileHelper

+(BOOL) fileExists:(NSString *)fullPath{
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir];
    if (exists) {
        return YES;
    }
    return NO;
}

+(id) readJsonFromFile:(NSString *)fileName{
    
    if( ![KXFileHelper fileExists:fileName] ){
        NSLog(@"Unable to find the Json file: %@",fileName);
        return nil;
    }
    
    NSData *content = [NSData dataWithContentsOfFile:fileName];
    if( content != nil ){
        
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:&jsonError];
        if( jsonObject != nil ){
            return jsonObject;
        }else{
            if( jsonError != nil ){
                NSLog(@"Unable to parse the Json file: %@, error: %@", fileName, [jsonError localizedDescription] );
            }else{
                NSLog(@"Unable to parse the Json file: %@", fileName);
            }
        }
    }
    return nil;
}

@end
