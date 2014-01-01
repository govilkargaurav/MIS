//
//  UIImage+Scale.h
//  HS RSS Reader
//
//  Created by Habib Ali on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/**
 @category UIImage_Scale
 @class UIImage
 @description This class will allow user to scale their images to any size
 */
#import <Foundation/Foundation.h>


@interface UIImage (UIImage_Scale)
/**
 @method        scaleToSize
 @description   scale image to a particular size
 @param         CGSize
 @returns       UIImaage
 */
-(UIImage*)scaleToSize:(CGSize)size;


- (UIImage *)scaleDownToSize:(CGSize)size;

@end
