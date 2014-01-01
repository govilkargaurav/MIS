//
//  myScrollView.m
//  demoOne1
//
//  Created by openxcell open on 2/11/11.
//  Copyright 2011 xcsxzc. All rights reserved.
//

#import "myScrollView.h"


@implementation myScrollView


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	self.scrollEnabled=NO;
	[self.nextResponder touchesBegan:touches withEvent:event];

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

	[self.nextResponder touchesMoved:touches withEvent:event];

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	self.scrollEnabled=YES;
	[self.nextResponder touchesEnded:touches withEvent:event];
}
@end
