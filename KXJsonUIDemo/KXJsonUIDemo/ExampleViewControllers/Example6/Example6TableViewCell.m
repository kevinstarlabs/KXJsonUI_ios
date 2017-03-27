// Example6TableViewCell.m
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

#import "Example6TableViewCell.h"

#import <KXJsonUI_ios/KXJsonUI_ios.h>

@interface Example6TableViewCell ()

@property(nonatomic, strong) KXBuilder *builder;

@end

@implementation Example6TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.builder = [[KXBuilder alloc] init];
        
        if( [self.builder loadFileWithName: @"sample6_cell.js"] ){
            [self.builder buildLayoutInView:self.contentView];
        }
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-(void) layoutSubviews
//{
//    
//}


#pragma mark - Controls

-(UILabel *) labelStudentId{
    return (UILabel *)[self.contentView findWidgetByName:@"label_student_id"];
}

-(UILabel *) labelName{
    return (UILabel *)[self.contentView findWidgetByName:@"label_name"];
}

-(UILabel *) labelScore{
    return (UILabel *)[self.contentView findWidgetByName:@"label_score"];
}


@end
