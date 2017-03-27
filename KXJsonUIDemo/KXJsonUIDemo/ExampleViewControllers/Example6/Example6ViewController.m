// Example6ViewController.m
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

#import "Example6ViewController.h"
#import "Example6TableViewCell.h"

@interface Example6ViewController ()

@property(nonatomic, strong) NSArray *dataset;

@end

@implementation Example6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSStringFromClass([self class]);
    self.dataset = [NSArray arrayWithObjects:
                    @{@"student_id":@1001, @"name": @"Michelle", @"score":@120},
                    @{@"student_id":@1002, @"name": @"Barry", @"score":@115},
                    @{@"student_id":@1003, @"name": @"Harris", @"score":@100},
                    @{@"student_id":@1004, @"name": @"Jennifer", @"score":@90},
                    @{@"student_id":@1005, @"name": @"Kim", @"score":@85},
                    @{@"student_id":@1006, @"name": @"Wally", @"score":@83},
                    @{@"student_id":@1007, @"name": @"Iris", @"score":@75},
                    @{@"student_id":@1008, @"name": @"Lily", @"score":@60}
                    , nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.dataset count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DefaultCell";
    
    Example6TableViewCell *cell = (Example6TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[Example6TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *data = self.dataset[indexPath.row];
    if( data != nil ){
        cell.labelStudentId.text = [NSString stringWithFormat:@"%d", [data[@"student_id"] intValue]];
        cell.labelName.text = data[@"name"];
        cell.labelScore.text = [NSString stringWithFormat:@"%d", [data[@"score"] intValue]];
    }
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You clicked item with indexPath: %@", indexPath);
}

@end
