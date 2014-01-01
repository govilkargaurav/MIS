//
//  UIImage+Scale.m
//  HS RSS Reader
//
//  Created by Habib Ali on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Scale.h"


@implementation UIImage (UIImage_Scale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

- (UIImage *)scaleDownToSize:(CGSize)size
{
    float width = size.width;
    float desiredWidth = width;
    float currentWidth =  self.size.width;
    if (width!=145)
    {
        
        if (width<currentWidth)
        {
            int widthDivider = ceilf(currentWidth/width);
            desiredWidth = currentWidth/widthDivider;
        }
        else {
            desiredWidth = currentWidth;
        }
    }
    float height = size.height;
    //float currentWidth =  self.size.width;
    float currentHeight = self.size.height;
    if (currentHeight<height)
    {
        if (desiredWidth == width)
            return self;
        else {
            int widthDivider = ceilf(currentWidth/width);
            float desiredHeight = currentHeight/widthDivider;
            return [self scaleToSize:CGSizeMake(desiredWidth, desiredHeight)];
        }
    }
    else {
        int heightDivider = ceilf(currentHeight/height);
        if (desiredWidth==currentWidth)
        {
            desiredWidth = currentWidth/heightDivider;
        }
        //int widthDivider = ceilf(currentWidth/width);
        float desiredHeight = currentHeight/heightDivider;
        return [self scaleToSize:CGSizeMake(desiredWidth, desiredHeight)];
    }
}

@end
