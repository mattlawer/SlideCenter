//
//  SCSlideView.h
//  WeeAppDesign
//
//  Created by Mathieu Bolard on 12/11/11.
//  Copyright (c) 2011 Streettours. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSlideView : UIView {
    UIImageView *_photoView;
}

@property (nonatomic, retain) UIImageView *photoView;

- (void) setImage:(UIImage*)image;

@end
