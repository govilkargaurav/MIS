//
//  UIImageView+Border.m
//  HuntingApp
//
//  Created by Habib Ali on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+Border.h"
#import <QuartzCore/CALayer.h>

@implementation UIImageView (Border)

- (void)getWhiteBorderImage
{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2.0;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
}

- (void)getBorderImageOfColor:(UIColor *)color
{
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = 2.0;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
}

@end
