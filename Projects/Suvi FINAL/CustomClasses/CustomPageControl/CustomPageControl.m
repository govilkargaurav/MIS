//
//  CustomPageControl.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl
@synthesize activeImage;
@synthesize inactiveImage;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    activeImage = [UIImage imageNamed:@"selectedpage.png"];
    inactiveImage = [UIImage imageNamed:@"unselectedpage.png"];
    return self;
}

-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
            dot.image = activeImage;
        else
            dot.image = inactiveImage;
        
        [dot sizeToFit];
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
