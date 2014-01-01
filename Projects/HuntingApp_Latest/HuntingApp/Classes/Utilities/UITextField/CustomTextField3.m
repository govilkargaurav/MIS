//
//  CustomTextField3.m
//  HuntingApp
//
//  Created by Habib Ali on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField3.h"

@implementation CustomTextField3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect theRect=CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return theRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

//To change the color of place holder text
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
}

@end
