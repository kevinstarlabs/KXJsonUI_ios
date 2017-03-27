// FirstViewController.m
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

#import "FirstViewController.h"

#import "ExampleViewControllers/ExampleViewControllers.h"

@interface FirstViewController ()

@property(nonatomic, strong) NSArray *exampleTitleList1;
@property(nonatomic, strong) NSArray *exampleTitleList2;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"KXJsonUI";
    
    // Do any additional setup after loading the view, typically from a nib.
    self.exampleTitleList1 = @[@"Hello World",
                               @"Images and Labels",
                               @"Images and RelativeLayout",
                               @"UITextField"];
    
    self.exampleTitleList2 = @[
                               @"UIScrollView",
                               @"Custom UITableViewCell",
                               @"UICollectionView",
                               @"Support Custom View",
                               @"Switch between Two Layouts"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section == 0 ){
        return [self.exampleTitleList1 count];
    }else if( section == 1 ){
        return [self.exampleTitleList2 count];
    }else if( section == 2 ){
        return 1;
    }
    return 0;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if( section == 0 ){
        return @"Basic Exmaples";
    }else if( section == 1 ){
        return @"Advanced Examples";
    }else if( section == 2 ){
        return @"About";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DefaultCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if( indexPath.section == 0 ){
        cell.textLabel.text = self.exampleTitleList1[(indexPath.row)];
    }else if( indexPath.section == 1 ){
        cell.textLabel.text = self.exampleTitleList2[(indexPath.row)];
    }else if( indexPath.section == 2 ){
        if( indexPath.row == 0 ){
            cell.textLabel.text = @"Visit KXJsonUI on Github!";
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            Example1ViewController *vc = [[Example1ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 1 ){
            Example2ViewController *vc = [[Example2ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 2 ){
            Example3ViewController *vc = [[Example3ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 3 ){
            Example4ViewController *vc = [[Example4ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if( indexPath.section == 1 ){
        if( indexPath.row == 0 ){
            Example5ViewController *vc = [[Example5ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 1 ){
            Example6ViewController *vc = [[Example6ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 2 ){
            Example7ViewController *vc = [[Example7ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 3 ){
            Example8ViewController *vc = [[Example8ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if( indexPath.row == 4 ){
            Example9ViewController *vc = [[Example9ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if( indexPath.section == 2 ){
        if( indexPath.row == 0 ){
            NSURL *url = [NSURL URLWithString:@"https://github.com/kxzen/KXJsonUI_ios"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

@end
