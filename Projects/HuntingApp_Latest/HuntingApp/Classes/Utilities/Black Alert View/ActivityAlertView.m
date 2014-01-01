//
//  ActivityAlertView.m
//  Elanguide iPad
//
//  Created by Folio 3 on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/* 
 * Extended UIAlertView to show UIActivityIndicator with custom background color
 */

#import "ActivityAlertView.h"
@interface ActivityAlertView (Private)
//Draw round edged rectangle
- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context withRadius:(CGFloat) radius;

@end

static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@implementation ActivityAlertView

@synthesize activityView;

//Set color of AlertView for lifetime
+ (void) setBackgroundColor:(UIColor *) background 
            withStrokeColor:(UIColor *) stroke
{
	if(fillColor != nil)
	{
		[fillColor release];
		[borderColor release];
	}
    
	fillColor = [background retain];
	borderColor = [stroke retain];
}

//Init background color of AlertView with activity viewer
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        if(fillColor == nil)
		{
			fillColor = [[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1] retain];
			borderColor = [[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8] retain];
		}
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
        activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[activityView startAnimating];
    }
	
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	for (UIView *sub in [self subviews])
	{
		if([sub class] == [UIImageView class] && sub.tag == 0)
		{
			[sub removeFromSuperview];
			break;
		}
	}
}

//To show desired background 
- (void)drawRect:(CGRect)rect
{	
    [super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextClearRect(context, rect);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.8); 
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
	// Draw background
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, 
                                 rect.origin.y + backOffset, 
                                 rect.size.width - backOffset*2, 
                                 rect.size.height - backOffset*2);
    
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);
    
	// Clip Context
	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1, 
                                 backRect.origin.y + backOffset-1, 
                                 backRect.size.width - (backOffset-1)*2, 
                                 backRect.size.height - (backOffset-1)*2);
    
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);
    
	//Draw highlight
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2), 
                                 rect.size.width/2);
    
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
    
	CGContextSetAlpha(context, 1.0); 
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
    
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace);
}

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
    
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void) close
{
    [activityView stopAnimating];
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) dealloc
{
	[activityView release];
	[super dealloc];
}

@end
