//
//  CustomTimeLineFooter.m
//  HuntingApp
//
//  Created by Habib Ali on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTimeLineFooter.h"

@implementation CustomTimeLineFooter
@synthesize btnName;
@synthesize btnLike;
@synthesize lblLike;
@synthesize btnComment;
@synthesize lblComment;

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

- (void)dealloc {
    [btnName release];
    [btnLike release];
    [lblLike release];
    [btnComment release];
    [lblComment release];
    [super dealloc];
}
@end
