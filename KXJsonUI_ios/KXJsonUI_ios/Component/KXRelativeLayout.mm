// KXRelativeLayout.mm
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

#import "KXRelativeLayout.h"
#import "KXLinearLayout.h"
#import "../KXCommon.h"
#import "../Base/UIView+KXFrame.h"

#include <vector>
#include <map>
#include <string>

#define IS_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] && \
![x isKindOfClass:[UITableView class]] && \
![x isKindOfClass:[UICollectionView class]])

#define IS_INHERIT_FROM_SCROLLVIEW(x) ([x isKindOfClass:[UIScrollView class]] ||  \
[x isKindOfClass:[UITableView class]] || \
[x isKindOfClass:[UICollectionView class]])

#define IS_KX_LAYOUT_CLASS(x) ([x isKindOfClass:[KXLinearLayout class]] || \
[x isKindOfClass:[KXRelativeLayout class]])

@implementation KXRelativeLayout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialize...
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
    // DO NOT Adjust self.width/height in layoutSubviews. (would cause infinite recursion).
    [self doLayout:list];
}

-(void) doLayout:(std::vector<UIView *>&) list{
    float SW = self.width;
    float SH = self.height;
    float S_LEFT = 0;
    float S_TOP = 0;

    // parent align
    for( UIView *v: list ){
        KXRelativeLayoutParams *params = v.kxRelativeParams;
        UIEdgeInsets margins = UIEdgeInsetsZero;
        margins = params.margins;
        NSValue *dynamicMeasuredSize = nil;
        if( [v respondsToSelector:@selector(measuredSize)] ){
            dynamicMeasuredSize = (NSValue *)[v performSelector:@selector(measuredSize) withObject:nil];
        }
        
        // Adjust size
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
        
        if( [params containsParentRule:KXRelativeLayoutParentRuleAlignLeft] ){
            v.left = margins.left;
        }else if( [params containsParentRule:KXRelativeLayoutParentRuleAlignRight] ){
            v.right = SW - margins.right;
        }
        if( [params containsParentRule:KXRelativeLayoutParentRuleAlignTop] ){
            v.top = margins.top;
        }else if( [params containsParentRule:KXRelativeLayoutParentRuleAlignBottom] ){
            v.bottom = SH - margins.bottom;
        }
        if( [params containsParentRule:KXRelativeLayoutParentRuleCenter] ){
            if( SW < v.width + margins.left + margins.right ){
                v.width = SW - margins.left - margins.right;
            }
            if( SH < v.height + margins.top + margins.bottom ){
                v.height = SH - margins.top - margins.bottom;
            }
            v.center = CGPointMake(S_LEFT+(SW-margins.left-margins.right)/2+margins.left,
                                   S_TOP+(SH-margins.top-margins.bottom)/2+margins.top);
        }
        if( [params containsParentRule:KXRelativeLayoutParentRuleCenterHorizontal] ){
            if( SW < v.width + margins.left + margins.right ){
                v.width = SW - margins.left - margins.right;
            }
            if( SH < v.height + margins.top + margins.bottom ){
                v.height = SH - margins.top - margins.bottom;
            }
            v.center = CGPointMake(S_LEFT+(SW-margins.left-margins.right)/2+margins.left,
                                   v.center.y);
        }
        if( [params containsParentRule:KXRelativeLayoutParentRuleCenterVertical] ){
            if( SW < v.width + margins.left + margins.right ){
                v.width = SW - margins.left - margins.right;
            }
            if( SH < v.height + margins.top + margins.bottom ){
                v.height = SH - margins.top - margins.bottom;
            }
            v.center = CGPointMake(v.center.x,
                                   S_TOP+(SH-margins.top-margins.bottom)/2+margins.top);
        }
    }
    
    // sibling align
    for( int k = 0 ; k <= 2 ; ++k ){
        for( UIView *v: list ){
            KXRelativeLayoutParams *params = v.kxRelativeParams;
            UIEdgeInsets margins = UIEdgeInsetsZero;
            margins = params.margins;
            // Align
            if( [params containsRule:KXRelativeLayoutRuleAlignLeft] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleAlignLeft];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.left = target.left + margins.left;
                        if( v.kxIngoreSizeAdjustment == NO && params.width == KX_MATCHPARENT ){
                            v.width = SW - v.left - margins.right;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleAlignRight] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleAlignRight];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.right = target.right + margins.right;
                        if( v.kxIngoreSizeAdjustment == NO && params.width == KX_MATCHPARENT ){
                            v.width = SW - v.right - margins.left;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleAlignTop] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleAlignTop];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.top = target.top + margins.top;
                        if( v.kxIngoreSizeAdjustment == NO && params.height == KX_MATCHPARENT ){
                            v.height = SH - v.top - margins.bottom;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleAlignBottom] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleAlignBottom];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.bottom = target.bottom + margins.bottom;
                        if( v.kxIngoreSizeAdjustment == NO && params.height == KX_MATCHPARENT ){
                            v.height = SH - v.bottom - margins.top;
                        }
                        break;
                    }
                }
            }
            // Place
            if( [params containsRule:KXRelativeLayoutRuleLeftOf] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleLeftOf];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.right = target.left - margins.right;
                        if( v.kxIngoreSizeAdjustment == NO && params.width == KX_MATCHPARENT ){
                            v.width = SW - v.right - margins.left;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleRightOf] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleRightOf];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.left = target.right + margins.left;
                        if( v.kxIngoreSizeAdjustment == NO && params.width == KX_MATCHPARENT ){
                            v.width = SW - v.left - margins.right;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleAbove] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleAbove];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.bottom = target.top - margins.bottom;
                        if( v.kxIngoreSizeAdjustment == NO && params.height == KX_MATCHPARENT ){
                            v.height = SH - v.bottom - margins.top;
                        }
                        break;
                    }
                }
            }
            if( [params containsRule:KXRelativeLayoutRuleBelow] ){
                NSString *targetName = [params getRule:KXRelativeLayoutRuleBelow];
                for( UIView *target: list ){
                    if( target != v && [target.kxName isEqualToString:targetName] ){
                        v.top = target.bottom + margins.top;
                        if( v.kxIngoreSizeAdjustment == NO && params.height == KX_MATCHPARENT ){
                            v.height = SH - v.top - margins.bottom;
                        }
                        break;
                    }
                }
            }
        }
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
        if( !IS_KX_LAYOUT_CLASS(v) ){
            [v kxInvalidateLayout];
        }else{
            [v setNeedsLayout];
        }
    }
}

@end
