// KXLinearLayout.mm
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

#import "KXLinearLayout.h"
#import "KXRelativeLayout.h"
#import "../KXCommon.h"
#import "UIView+KXFrame.h"

#import <QuartzCore/QuartzCore.h>

#include <vector>

#define IS_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] && \
![x isKindOfClass:[UITableView class]] && \
![x isKindOfClass:[UICollectionView class]])

#define IS_INHERIT_FROM_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] ||  \
[x isKindOfClass:[UITableView class]] || \
[x isKindOfClass:[UICollectionView class]])

#define IS_KX_LAYOUT_CLASS(x) ([x isKindOfClass:[KXLinearLayout class]] || \
[x isKindOfClass:[KXRelativeLayout class]])

@implementation KXLinearLayout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orientation = KXLinearLayoutOrientationVertical;
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    std::vector<UIView *> list;
    for (UIView *subview in self.subviews)
    {
        if( subview.kxEnabled == YES ){
            list.push_back(subview);
        }
    }
    if( list.size() == 0 ) return;

    bool changed = false;
    do{
        changed = false;
        for( int i=0;i<list.size()-1;++i ){
            if( list[i].kxOrder > list[i+1].kxOrder ){
                UIView *tmp = list[i];
                list[i] = list[i+1];
                list[i+1] = tmp;
                changed = true;
            }
        }
    }while( changed );
    // DO NOT Adjust self.width/height in layoutSubviews. (would cause infinite recursion).
    if( self.orientation == KXLinearLayoutOrientationVertical ){
        [self doVerticalLayout:list];
    }else{
        [self doHorizontalLayout:list];
    }
}

-(void) doVerticalLayout:(std::vector<UIView *>&) list{
    CGFloat curTop = 0;
    int wSum = 0;
    float SW = self.width;
    float SH = self.height;
    float S_LEFT = 0;
    float S_TOP = 0;
    double heightSum = SH;

    UIView *lastWeightedView = nil;
    for( UIView *v: list ){
        KXLinearLayoutParams *params = v.kxLinearParams;
        wSum += params.weight;
        if( params.weight == 0 && params.height > 0 ){
            heightSum -= params.height + params.margins.top + params.margins.bottom;
            lastWeightedView = nil;
        }else{
            lastWeightedView = v;
        }
    }
    for( UIView *v: list ){
        
        KXLinearLayoutParams *params = v.kxLinearParams;
        UIEdgeInsets margins = UIEdgeInsetsZero;
        margins = params.margins;
        NSValue *dynamicMeasuredSize = nil;
        if( [v respondsToSelector:@selector(measuredSize)] ){
            dynamicMeasuredSize = (NSValue *)[v performSelector:@selector(measuredSize) withObject:nil];
        }
        
        if( v.kxIngoreSizeAdjustment == NO ){
            if( params.width == KX_MATCHPARENT ){
                v.width = SW - margins.left - margins.right;
            }else if( params.width == KX_AUTO ){
                if( dynamicMeasuredSize != nil ){
                    v.width = [dynamicMeasuredSize CGSizeValue].width;
                }else{
                    v.width = v.kxMeasuredSize.width;
                }
            }else{
                v.width = params.width;
            }
            
            NSLog(@"v.name=%@, width=%f", v.kxName, v.width);
            
            if( params.height == KX_MATCHPARENT ){
                v.height = SH - margins.top - margins.bottom;
            }else if( params.height == KX_AUTO ){
                if( params.weight != 0 ){
                    
                    float autoValue = floor((params.weight/(float)wSum)*heightSum);
                    if( lastWeightedView && v == lastWeightedView && (SH - curTop) > 0 ){
                        autoValue = SH - curTop;
                    }
                    v.height = autoValue - margins.top - margins.bottom;
                }else{
                    if( dynamicMeasuredSize != nil ){
                        v.height = [dynamicMeasuredSize CGSizeValue].height;
                    }
                }
            }else{
                v.height = params.height;
            }
            
            NSLog(@"v.name=%@, height=%f", v.kxName, v.height);
        }
        
        curTop += margins.top;
        v.top = curTop;
        
        if( params.gravity == KXLinearLayoutGravityStart ){
            v.left = 0 + margins.left;
        }else if( params.gravity == KXLinearLayoutGravityEnd ){
            v.left =  SW - margins.right - v.width;
        }else if( params.gravity == KXLinearLayoutGravityCenter ){
            v.left = SW/2.0 - v.width/2.0;
        }
        
        curTop += v.height;
        curTop += margins.bottom;
        
    }
    
    // add debug cross
    for( UIView *v: list ){
        BOOL enableDebug = v.kxDebug;
#ifdef ENABLE_KXJSONUI_DEBUG
        enableDebug = YES;
#endif
        if( enableDebug ){
            if( [v viewWithTag:899775] == nil ){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(v.width/2.0-80/2,
                                                                            v.height/2.0-80/2,
                                                                            80,
                                                                            80)];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setLineBreakMode:NSLineBreakByWordWrapping];
                [label setFont:[UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:13.0]];
                [label setText:[NSString stringWithFormat:@"%dx%d", (int)v.width, (int)v.height]];
                [label setTextColor:[UIColor colorWithWhite:0.4 alpha:0.9]];
                [label setTag:899775];
                [v addSubview:label];
            }else{
                UILabel *label = (UILabel *)[v viewWithTag:899775];
                [label setText:[NSString stringWithFormat:@"%dx%d", (int)v.width, (int)v.height]];
            }
        }
    }
    
    for( UIView *v: list ){
        
        if( IS_SCROLLVIEW(v) ){
            UIScrollView *scrollview = (UIScrollView *)v;
            if( scrollview.kxProperty != nil ){
                if( [scrollview.kxProperty valueForKey:@"content_size"] != nil ){
                    CGSize contentSize = [[scrollview.kxProperty valueForKey:@"content_size"] CGSizeValue];
                    if( contentSize.width == KX_MATCHPARENT || contentSize.width == KX_AUTO ){
                        contentSize.width = scrollview.width;
                    }
                    if( contentSize.height == KX_MATCHPARENT || contentSize.height == KX_AUTO ){
                        double selfHeight = scrollview.height;
                        contentSize.height = selfHeight;
                    }
                    [scrollview setContentSize:contentSize];
                }
            }
        }
    }
    
    for( UIView *v: list ){
        if( [v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UIButton class]] ||
           [v isKindOfClass:[UITextField class]] ){
            if( v.kxAutoFontSize ){
                v.kxAutoFontSize = NO;
                if( [v isKindOfClass:[UILabel class]] ){
                    ((UILabel *)v).adjustsFontSizeToFitWidth = YES;
                }else if( [v isKindOfClass:[UIButton class]] ){
                    ((UIButton *)v).titleLabel.adjustsFontSizeToFitWidth = YES;
                }else if( [v isKindOfClass:[UITextField class]] ){
                    ((UITextField *)v).adjustsFontSizeToFitWidth = YES;
                }
            }
        }
        if( IS_KX_LAYOUT_CLASS(v) ){
            [v setNeedsLayout];
        }else{
            [v kxInvalidateLayout];
            [v setNeedsLayout];
        }
    }
}

-(void) doHorizontalLayout:(std::vector<UIView *>&) list{
    CGFloat curLeft = 0;
    int wSum = 0;
    float SW = self.width;
    float SH = self.height;
    
    float S_LEFT = 0;
    float S_TOP = 0;
    double widthSum = SW;
    for( UIView *v: list ){
        KXLinearLayoutParams *params = v.kxLinearParams;
        wSum += params.weight;
        if( params.weight == 0 && params.width > 0 ){
            widthSum -= params.width + params.margins.left + params.margins.right;
        }
    }
    for( UIView *v: list ){
        KXLinearLayoutParams *params = v.kxLinearParams;
        UIEdgeInsets margins = UIEdgeInsetsZero;
        margins = params.margins;
        
        NSValue *dynamicMeasuredSize = nil;
        if( [v respondsToSelector:@selector(measuredSize)] ){
            dynamicMeasuredSize = (NSValue *)[v performSelector:@selector(measuredSize) withObject:nil];
        }
        
        if( v.kxIngoreSizeAdjustment == NO ){
            if( params.width == KX_MATCHPARENT ){
                v.width = SW - margins.left - margins.right;
            }else if( params.width == KX_AUTO ){
                if( params.weight != 0 ){
                    float autoValue = floor((params.weight/(float)wSum)*widthSum);
                    v.width = autoValue - margins.left - margins.right;
                }else{
                    if( dynamicMeasuredSize != nil ){
                        v.width = [dynamicMeasuredSize CGSizeValue].width;
                    }
                }
            }else{
                v.width = params.width;
            }
            
            if( params.height == KX_MATCHPARENT ){
                v.height = SH - margins.top - margins.bottom;
            }else if( params.height == KX_AUTO ){
                if( dynamicMeasuredSize != nil ){
                    v.height = [dynamicMeasuredSize CGSizeValue].height;
                }else{
                    v.height = v.kxMeasuredSize.height;
                }
            }else{
                v.height = params.height;
            }
        }
        
        curLeft += margins.left;
        v.left = curLeft;
        
        if( params.gravity == KXLinearLayoutGravityStart ){
            v.top = 0 + margins.top;
        }else if( params.gravity == KXLinearLayoutGravityEnd ){
            v.top =  SH - margins.bottom - v.height;
        }else if( params.gravity == KXLinearLayoutGravityCenter ){
            v.top = SH/2.0 - v.height/2.0;
        }
        
        curLeft += v.width;
        curLeft += margins.right;
        
    }
    
    // add debug cross
    for( UIView *v: list ){
        BOOL enableDebug = v.kxDebug;
#ifdef ENABLE_KXJSONUI_DEBUG
        enableDebug = YES;
#endif
        if( enableDebug ){
            if( [v viewWithTag:899775] == nil ){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(v.width/2.0-80/2,
                                                                            v.height/2.0-80/2,
                                                                            80,
                                                                            80)];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setLineBreakMode:NSLineBreakByWordWrapping];
                [label setFont:[UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:13.0]];
                [label setText:[NSString stringWithFormat:@"%dx%d", (int)v.width, (int)v.height]];
                [label setTextColor:[UIColor colorWithWhite:0.4 alpha:0.9]];
                [label setTag:899775];
                [v addSubview:label];
            }else{
                UILabel *label = (UILabel *)[v viewWithTag:899775];
                [label setText:[NSString stringWithFormat:@"%dx%d", (int)v.width, (int)v.height]];
            }
        }
    }
    

    
    for( UIView *v: list ){
        if( IS_SCROLLVIEW(v) ){
            UIScrollView *scrollview = (UIScrollView *)v;
            // adjust content size for scrollview
            if( scrollview.kxProperty != nil ){
                if( [scrollview.kxProperty valueForKey:@"content_size"] != nil ){
                    CGSize contentSize = [[scrollview.kxProperty valueForKey:@"content_size"] CGSizeValue];
                    if( contentSize.width == KX_MATCHPARENT || contentSize.width == KX_AUTO ){
                        contentSize.width = scrollview.width;
                    }
                    if( contentSize.height == KX_MATCHPARENT || contentSize.height == KX_AUTO ){
                        double selfHeight = scrollview.height;
                        contentSize.height = selfHeight;
                    }
                    [scrollview setContentSize:contentSize];
                }
            }
        }
    }
    
    for( UIView *v: list ){
        if( [v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UIButton class]] ||
           [v isKindOfClass:[UITextField class]] ){
            if( v.kxAutoFontSize ){
                v.kxAutoFontSize = NO;
                if( [v isKindOfClass:[UILabel class]] ){
                    ((UILabel *)v).adjustsFontSizeToFitWidth = YES;
                }else if( [v isKindOfClass:[UIButton class]] ){
                    ((UIButton *)v).titleLabel.adjustsFontSizeToFitWidth = YES;
                }else if( [v isKindOfClass:[UITextField class]] ){
                    ((UITextField *)v).adjustsFontSizeToFitWidth = YES;
                }
            }
        }
        if( IS_KX_LAYOUT_CLASS(v) ){
            [v setNeedsLayout];
        }else{
            [v kxInvalidateLayout];
            [v setNeedsLayout];
        }
    }
}

@end
