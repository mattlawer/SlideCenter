//
//  SCSlideView.m
//  WeeAppDesign
//
//  Created by Mathieu Bolard on 12/11/11.
//  Copyright (c) 2011 Streettours. All rights reserved.
//

#import "SCSlideView.h"
#import "Debug.h"

@implementation SCSlideView
@synthesize photoView = _photoView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.photoView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Clear old view
    for (id view in [self subviews]) {
        if (![view isKindOfClass:[UIButton class]]) { // don't clear the btn
            [view performSelector:@selector(removeFromSuperview)];
        }
    }
    
    // Drawing code
    UIImageView *overlay = [[UIImageView alloc] initWithFrame:rect];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [overlay setImage:[[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SlideCenter.bundle/overlay.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:40]];
    [self addSubview:overlay];
    [self sendSubviewToBack:overlay];
    [overlay release];
    
    
    [self addSubview:self.photoView];
    [self sendSubviewToBack:self.photoView];
    
}

- (void) setImage:(UIImage*)image {
    DBGLog(@"setImage : %@",image);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^(void) {
            DBGLog(@"setImage async (%@)",self.photoView);
            self.photoView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.photoView setImage:image];
            [UIView beginAnimations:@"showPhoto" context:NULL];
            [UIView setAnimationDuration:0.3];
            self.photoView.alpha = 1.0;
            [UIView commitAnimations];
        }];
    });
}

- (void) dealloc {
    [_photoView release];
    [super dealloc];
}

@end
