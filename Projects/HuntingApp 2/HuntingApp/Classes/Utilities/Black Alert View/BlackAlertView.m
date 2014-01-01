//
//  BlackAlertView.m
//  Elanguide iPad
//
//  Created by hussainmansoor on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlackAlertView.h"

static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@implementation BlackAlertView

@synthesize isAlertShown;

+ (void) setBackgroundColor:(UIColor *) background 
            withStrokeColor:(UIColor *) stroke
{
    [super setBackgroundColor:background withStrokeColor:stroke];
	if(fillColor != nil)
	{
		[fillColor release];
		[borderColor release];
	}
    
	fillColor = [background retain];
	borderColor = [stroke retain];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        if(fillColor == nil)
		{
			fillColor = [[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1] retain];
			borderColor = [[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8] retain];
		}        
        isAlertShown = YES;
    }	
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	for (UIView *sub in [self subviews])
	{
		if([sub isKindOfClass:[UIActivityIndicatorView class]])
        {
            [sub removeFromSuperview];
        }
	}
     
}

-(void)dealloc{
    isAlertShown = NO;
    [super dealloc];
}

@end
