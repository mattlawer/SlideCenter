//
//  SCInfoView.m
//  WeeAppDesign
//
//  Created by Mathieu Bolard on 11/11/11.
//  Copyright (c) 2011 Streettours. All rights reserved.
//

#import "SCInfoView.h"
#define DONATE_TAG 1010

@implementation SCInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Clear old views
    for (UIView *view in [self subviews]) {
        if (![view isKindOfClass:[UIButton class]] && view.tag != DONATE_TAG) { // don't clear the btn
            [view performSelector:@selector(removeFromSuperview)];
        }
    }
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:rect];
    [back setImage:[[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SlideCenter.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:40]];
    back.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
    [self addSubview:back];
    [back release];
    [self sendSubviewToBack:back];
    
    NSString *title = @"SlideCenter v1.2-3";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, 40.0)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:22.0];
    label.shadowColor = [UIColor lightGrayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    [label release];
    
    UITextView *detail = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 40.0, rect.size.width, 100.0)];
    detail.text = @"This widget is using the same slideshow timer than the Photos app. You can change it in Settings->Photos.";
    detail.editable = NO;
    detail.userInteractionEnabled = NO;
    detail.backgroundColor = [UIColor clearColor];
    detail.textColor = [UIColor lightGrayColor];
    detail.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:detail];
    [detail release];
    
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 135.0, rect.size.width-100.0, 20.0)];
    copyright.backgroundColor = [UIColor clearColor];
    copyright.text = @"© 2011 Mathieu Bolard";
    copyright.textColor = [UIColor whiteColor];
    copyright.font = [UIFont systemFontOfSize:12.0];
    copyright.shadowColor = [UIColor blackColor];
    copyright.shadowOffset = CGSizeMake(0, 1);
    copyright.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:copyright];
    [copyright release];
    
    UIButton *donate = [UIButton buttonWithType:UIButtonTypeCustom];
    donate.tag = DONATE_TAG;
    donate.frame = CGRectMake(rect.size.width-110.0, 110.0, 100.0, 40.0);
    [donate setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SlideCenter.bundle/donate.png"] forState:UIControlStateNormal];
    [donate addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    donate.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:donate];
    
    
}

- (void) donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/ufm6N4"]];
}

@end
