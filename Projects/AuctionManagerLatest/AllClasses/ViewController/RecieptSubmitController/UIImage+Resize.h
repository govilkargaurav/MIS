// UIImage+Resize.h
//
//
// 

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

@end
