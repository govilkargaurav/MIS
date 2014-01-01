//
//  RaderBackground.m
//  AIS
//
//  Created by apple on 4/13/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "RaderBackground.h"


@implementation RaderBackground

-(void)drawRect:(CGRect)rect{
	
    NSLog(@"drawRect");
	self.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:155.0f/255.0f alpha:1.0];
	context = UIGraphicsGetCurrentContext();
	path = CGPathCreateMutable();
	CGContextBeginPath(context);
	CGContextSetLineWidth(context, 2);	
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextSetLineJoin(context, kCGLineJoinBevel);

	CGContextMoveToPoint(context, self.center.x, self.center.y);
/*	float angle = 3.142;
//	CGPathAddArc(path, NULL, aRect.size.width/2, aRect.size.height/2, 45, 0*3.142/180, angle*3.142/180, 0);
	CGPathAddArc(path, NULL, self.center.x, self.center.y, 90, angle, 180, 0);
	
	CGPathCloseSubpath(path);
	CGContextMoveToPoint(context, self.center.x, self.center.y);
	CGPathAddArc(path, NULL, self.center.x, self.center.y, 180, angle, 180, 0);
	CGContextAddPath(context, path);
	[self setNeedsDisplay];
	CGContextAddPath(context, path);
	CFRelease(path);
	//CFRelease(context);
	*/
	
	UIColor *c = [UIColor redColor];
    const CGFloat *components = CGColorGetComponents([c CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    CGFloat al = components[3];     
    CGContextSetRGBFillColor(context, red, green, blue, al);
	
	CGRect theRect = CGRectMake(self.frame.origin.x ,self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    CGContextAddEllipseInRect(context, theRect);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	
  //  CGContextDrawPath(context, kCGPath);

	CGContextStrokePath(context);
    
  
}

- (void)dealloc {
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		[self drawRect:self.frame];
	}
	return self;
}
@end
