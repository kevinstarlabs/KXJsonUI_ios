// Example4ViewController.m
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

#import "Example4ViewController.h"

#import <KXJsonUI_ios/KXJsonUI_ios.h>

@interface Example4ViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) KXBuilder *builder;

@property(nonatomic, readonly) UILabel *label1;
@property(nonatomic, readonly) UITextField *textfield1;
@property(nonatomic, readonly) UITextField *textfield2;

@end

@implementation Example4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSStringFromClass([self class]);
    self.builder = [[KXBuilder alloc] init];
    if( [self.builder loadFileWithName: @"sample4.js"] ){
        [self.builder buildLayoutInView:self.view];
        [self setupEvents];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupEvents
{
    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Widgets

-(UILabel *) label1{
    return (UILabel *)[self.view findWidgetByName:@"label1"];
}

-(UITextField *) textfield1{
    return (UITextField *)[self.view findWidgetByName:@"textfield1"];
}

-(UITextField *) textfield2{
    return (UITextField *)[self.view findWidgetByName:@"textfield2"];
}

@end
