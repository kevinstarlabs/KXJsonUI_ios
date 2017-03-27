//
//  Example8ViewController.m
//  KXJsonUIDemo
//
//  Created by kevin on 2017/3/27.
//  Copyright © 2017年 kxzen. All rights reserved.
//

#import "Example8ViewController.h"

#import <KXJsonUI_ios/KXJsonUI_ios.h>

@interface Example8ViewController ()

@property(nonatomic, strong) KXBuilder *builder;

@property(nonatomic, strong) UISwitch *switch1;

@end

@implementation Example8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSStringFromClass([self class]);
    self.builder = [[KXBuilder alloc] init];
    
    [self supportUISiwtch];
    
    if( [self.builder loadFileWithName: @"sample8.js"] ){
        [self.builder buildLayoutInView:self.view];
    }
}


-(void) supportUISiwtch
{
    [KXBuilder registerAttributeDataTypeForName:@"on" dataType:@"bool"];
    [KXBuilder registerViewHandlerForWidget:@"UISwitch"
                                 onCreation:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
                                     *view = [[UISwitch alloc] init];
                                 } onSetup:^(NSString *parentWidget, KXViewAttribute *attribute, UIView *__autoreleasing *view) {
                                     [KXBuilder setupCommonAttributesWithParent:parentWidget attribute:attribute view:*view];
                                     UISwitch *theSwitch = (UISwitch *)(*view);
                                     if( attribute.attrs[@"on"] != nil ){
                                         theSwitch.on = [attribute.attrs[@"on"] boolValue];
                                     }
                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UISwitch *) switch1{
    return (UISwitch *)[self.view findWidgetByName:@"switch1"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
