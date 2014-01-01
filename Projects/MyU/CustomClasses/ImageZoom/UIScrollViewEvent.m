//
//  UIScrollViewEvent.m
//  PhotoTest
//
//  Created by Yoo-Jin Lee on 28/11/12.
//  Copyright (c) 2012 Mokten Pty Ltd. All rights reserved.
//

#import "UIScrollViewEvent.h"

@implementation UIScrollViewEvent

//http://stackoverflow.com/questions/638299/uiscrollview-with-centered-uiimageview-like-photos-app
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imgView != nil) {
        // center the image as it becomes smaller than the size of the screen
        CGSize boundsSize = self.bounds.size;
        
        UIImage * img = imgView.image;
        CGRect  frameToCenter =  CGRectZero;
        
        if (img) {
            // Change orientation: Portrait -> Lanscape : this lets you see the whole image
            if (UIDeviceOrientationIsLandscape( [UIDevice currentDevice].orientation)) {
                frameToCenter = CGRectMake(0, 0, (self.frame.size.height*img.size.width)/img.size.height  * self.zoomScale, self.frame.size.height * self.zoomScale);
            } else {
                frameToCenter = CGRectMake(0, 0, self.frame.size.width * self.zoomScale, (self.frame.size.width*img.size.height)/img.size.width  * self.zoomScale);
            }
        } else {
            frameToCenter =  self.imgView.frame;
        }
        
        // center horizontally
        if (frameToCenter.size.width < boundsSize.width)
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        else
            frameToCenter.origin.x = 0;
        
        // center vertically
        if (frameToCenter.size.height < boundsSize.height)
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
        else
            frameToCenter.origin.y = 0;
        
        imgView.frame = frameToCenter;
        self.contentSize = imgView.frame.size;
    }
}

- (void) dealloc {
 imgView = nil;
}

@synthesize imgView;

@end
