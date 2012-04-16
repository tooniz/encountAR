//
//  TZGradientButton.h
//  trackfriend
//
//  Created by Ming Zhou on 12-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface TZGradientButton : UIButton 

@property (strong, nonatomic) UIColor *_highColor;
@property (strong, nonatomic) UIColor *_lowColor;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

- (void)setHighColor:(UIColor*)color;
- (void)setLowColor:(UIColor*)color;


@end
