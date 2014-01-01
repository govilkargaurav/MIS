//
//  UIView+Utilities.m
//  Suvi
//
//  Created by Gagan Mishra on 2/25/13.
//
//

#import "UIView+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utilities)

-(void)animateRightToLeft
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    [transition setSubtype:kCATransitionFromRight];
    [self.layer addAnimation:transition forKey:nil];
}

-(void)animateLeftToRight
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    [self.layer addAnimation:transition forKey:nil];
}

-(void)animateFade
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

@end
