//
//  UIImage+Utilities.h
//  Suvi
//
//  Created by Gagan Mishra on 2/19/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

+(UIImage *)imageNamed:(NSString *)imageName bundleName:(NSString *)bundleName;
-(UIImage *)squaredImage;
-(UIImage *)cropCenterToSize:(CGSize)newSize;
-(UIImage *)addWaterMarkImage:(UIImage *)wmarkImage;
-(UIImage *)scaleAndRotateImage;

@end
