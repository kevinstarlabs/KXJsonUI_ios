// Example7ViewController.m
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

#import "Example7ViewController.h"
#import "Example7CollectionViewCell.h"

#import <KXJsonUI_ios/KXJsonUI_ios.h>

@interface Example7ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) KXBuilder *builder;

@property (strong, nonatomic) UICollectionView* collectionView;

@property (strong, nonatomic) NSArray *dataList;

@end

static NSString *gCellIdentifier = @"Example7Cell";

@implementation Example7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataList = @[@{@"img":@"icon1.png", @"title":@"Flag"},
                      @{@"img":@"icon2.png", @"title":@"Profile"},
                      @{@"img":@"icon3.png", @"title":@"Lightbulb"},
                      @{@"img":@"icon4.png", @"title":@"Music"},
                      @{@"img":@"icon5.png", @"title":@"Mail"},
                      @{@"img":@"icon6.png", @"title":@"Heart"},
                      @{@"img":@"icon7.png", @"title":@"Star"}];
    
    
    self.title = NSStringFromClass([self class]);
    self.builder = [[KXBuilder alloc] init];
    if( [self.builder loadFileWithName: @"sample7.js"] ){
        [self.builder buildLayoutInView:self.view];
        [self setupEvents];
    }
}

-(void) setupEvents
{
    [self.collectionView registerClass:[Example7CollectionViewCell class] forCellWithReuseIdentifier:gCellIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionView stuff

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    NSLog(@"You select item at IndexPath: %@", indexPath);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Example7CollectionViewCell *cell = (Example7CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:gCellIdentifier forIndexPath:indexPath];
    
    if( indexPath.section == 0 ){
        if( indexPath.row < [self.dataList count] ){
            NSDictionary *data = self.dataList[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:data[@"img"]];
            cell.labelTitle.text = data[@"title"];
        }
    }
    
    return cell;
}

#pragma mark - Controls

-(UICollectionView *) collectionView{
    return (UICollectionView *)[self.view findWidgetByName:@"root"];
}

@end
