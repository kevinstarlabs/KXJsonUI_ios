//
//  Example9ViewController.m
//  KXJsonUIDemo
//
//  Created by kevin on 2017/3/27.
//  Copyright © 2017年 kxzen. All rights reserved.
//

#import "Example9ViewController.h"

#import <KXJsonUI_ios/KXJsonUI_ios.h>

@interface Example9ViewController ()

@property(nonatomic, strong) KXBuilder *builder;

@property(nonatomic, strong) UIButton *button1;

@property(nonatomic, strong) NSString *currentLayoutFileName;

@end

@implementation Example9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSStringFromClass([self class]);
    self.builder = [[KXBuilder alloc] init];
    
    self.currentLayoutFileName = @"sample9_layout1.json";
    
    if( [self.builder loadFileWithName: self.currentLayoutFileName] ){
        [self.builder buildLayoutInView:self.view];
        [self setupEvents];
    }
}

-(void) setupEvents{
    [self.button1 addTarget:self action:@selector(button1_onClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void) button1_onClick{
    
    if( [self.currentLayoutFileName isEqualToString:@"sample9_layout1.json"] ){
        self.currentLayoutFileName = @"sample9_layout2.json";
    }else{
        self.currentLayoutFileName = @"sample9_layout1.json";
    }
    
    if( [self.builder loadFileWithName: self.currentLayoutFileName] ){
        [self.builder reloadAnotherLayoutInView:self.view];
        
        [self.view kxInvalidateLayout];
        
        [UIView transitionWithView:self.view
                          duration:0.24f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.view setNeedsDisplay];
                        } completion:NULL];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Widgets

-(UIButton *) button1{
    return (UIButton *)[self.view findWidgetByName:@"button1"];
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
