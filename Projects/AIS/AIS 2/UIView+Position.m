//
//  UIView+Position.m
//
//  Created by Tyler Neylon on 3/19/10.
//  Copyleft 2010 Bynomial.
//

#import "UIView+position.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Position)

- (CGPoint)frameOrigin {
  return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
  self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
  return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          newSize.width, newSize.height);
}

- (CGFloat)frameX {
  return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
  self.frame = CGRectMake(newX, self.frame.origin.y,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
  return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
  self.frame = CGRectMake(self.frame.origin.x, newY,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
  self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
  self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                          self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
  return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
  return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          self.frame.size.width, newHeight);
}

- (void)addCenteredSubview:(UIView *)subview {
  subview.frameX = (int)((self.bounds.size.width - subview.frameWidth) / 2);
  subview.frameY = (int)((self.bounds.size.height - subview.frameHeight) / 2);
  [self addSubview:subview];
}

- (void)moveToCenterOfSuperview {
  self.frameX = (int)((self.superview.bounds.size.width - self.frameWidth) / 2);
  self.frameY = (int)((self.superview.bounds.size.height - self.frameHeight) / 2);
}
/*
-(void)animation{
//	int x= (-5)+ (arc4random()%(10));
//	int y=	arc4random()%5;
	
	

	if (self.frame.origin.y < 850) {
		self.frame=CGRectMake([self frameX], [self frameY]+kSpeed, [self frameWidth],[self frameHeight]);		
		[self performSelector:@selector(animation) withObject:nil afterDelay:0.1];
		
	}else {
		
		[self stopAnimation];
	}

 //   [timer invalidate];
	//[NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(animation) object:nil];
	//timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animation) userInfo:nil repeats:NO];
}
-(void)stopAnimation{
	
	[timer invalidate];
	timer=nil;
	
//	self.hidden=TRUE;
	

	[NSTimer cancelPreviousPerformRequestsWithTarget:self];
	
	self.alpha=1.0;
	[UIView beginAnimations:nil context:NULL];
	[UIView	setAnimationDelegate:self];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationRepeatCount:5];
	self.alpha=0.0;
	[UIView commitAnimations];
//	[self performSelector:@selector(changeColor) withObject:nil afterDelay:0.5];
}
*/
@end
