//
//  FJSwitch.m
//
//  Created by Francisco Jimenez on 3/7/12.
//
//  Copyright (c) 2012 Francisco Jimenez
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "FJSwitch.h"

@implementation FJSwitch

@synthesize imageView, onWidth, offWidth, onLabel, offLabel, borderView, borderWidth, borderColor;

- (id) initWithImage:(UIImage *)image frame:(CGRect)frame onWidth:(CGFloat)onW offWidth:(CGFloat)offW {
    self = [super initWithFrame:frame];
    borderlessFrame = frame;
    
    if (self) {
        [self addTarget:self action:@selector(toggleOn) forControlEvents:UIControlEventTouchUpInside];        
                
        self.onWidth = onW;
        self.offWidth = offW;
        
        self.clipsToBounds = YES;
        
        CGRect imageViewFrame = self.bounds;
        imageViewFrame.size.width += offWidth;
        
        self.imageView = [UIImageView new];
        imageView.image = image;
        imageView.frame = imageViewFrame;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                
        self.onLabel = [UILabel new];
        onLabel.frame = CGRectMake(0, 0, onWidth, imageViewFrame.size.height);
        onLabel.shadowColor = [UIColor blackColor];
        onLabel.shadowOffset = CGSizeMake(0, -1);
        onLabel.text = @"ON";
        onLabel.textColor = [UIColor whiteColor];
        onLabel.backgroundColor = [UIColor clearColor];
        onLabel.font = [UIFont boldSystemFontOfSize:14];
        onLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageView addSubview:onLabel];
        
        self.offLabel = [UILabel new];
        offLabel.frame = CGRectMake(imageViewFrame.size.width - offWidth, 0, offWidth, imageViewFrame.size.height);
        offLabel.shadowColor = [UIColor blackColor];
        offLabel.shadowOffset = CGSizeMake(0, -1);
        offLabel.text = @"OFF";
        offLabel.textColor = [UIColor whiteColor];
        offLabel.backgroundColor = [UIColor clearColor];
        offLabel.font = [UIFont boldSystemFontOfSize:14];
        offLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageView addSubview:offLabel];
        
        [self addSubview:imageView];
        
        self.borderView = [[BorderView alloc] initWithFrame:self.bounds];
        borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        //[self addSubview:borderView];
                
#if !__has_feature(objc_arc)
        [onLabel release];
        [offLabel release];
        [borderView release];
        [imageView release];
#endif
    }
    
    return self;
}

- (void)moveToOnPositon:(BOOL)setOn {
    CGRect frame = self.imageView.frame;
    
    if (setOn) {
        frame.origin.x = onPosition;
    } else {
        frame.origin.x = onPosition - onWidth;
    }
    
    imageView.frame = frame;
}

- (void) layoutSubviews {
    BOOL isOn = imageView.frame.origin.x >= 0;
    
    self.frame = CGRectInset(borderlessFrame, -borderView.borderWidth, -borderView.borderWidth); 

    CGRect imageViewFrame = self.bounds;
    imageViewFrame.size.width += offWidth;
    imageView.frame = imageViewFrame;
    
    imageView.frame = CGRectInset(imageViewFrame, onPosition, onPosition);
        
    onLabel.frame = CGRectMake(0, 0, onWidth, imageView.frame.size.height);
    offLabel.frame = CGRectMake(imageView.frame.size.width - offWidth, 0, offWidth, imageView.frame.size.height);
    
    [self moveToOnPositon:isOn];
}

- (void) setOn:(BOOL)setOn animated:(BOOL)animated {
    NSTimeInterval duration = animated ? 0.2 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{[self moveToOnPositon:setOn];}];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL) isOn {    
    return imageView.frame.origin.x == onPosition;
}

- (void) toggleOn {
    [self setOn:!self.isOn animated:YES];
}

- (void) setBorderWidth:(int) width {
    if (width >= 0)
        onPosition = width;
    else
        onPosition = 0;
        
    
    borderView.borderWidth = width;
    [borderView setNeedsDisplay];
    [self setNeedsLayout];
}

- (int) borderWidth {
    return borderView.borderWidth;
}

- (void) setBorderColor:(UIColor *) color {
    borderView.borderColor = color;
    [borderView setNeedsDisplay];
    [self setNeedsLayout];
}

- (UIColor *) borderColor {
    return borderView.borderColor;
}

@end
