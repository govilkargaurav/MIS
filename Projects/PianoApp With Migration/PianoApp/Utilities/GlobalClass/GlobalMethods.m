//
//  GlobalMethods.m
//  PianoApp_With_Migration
//
//  Created by Imac 2 on 9/12/13.
//
//

#import "GlobalMethods.h"
#import "UIImage+KTCategory.h"

@implementation GlobalMethods
+ (void)animateIncorrectPassword:(UIView*)viewname
{
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        viewname.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            // Translate right
            viewname.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                viewname.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    viewname.transform = resetTransform;
                }];
            }];
            
        }];
    }];
}

+(void)SetViewShadow:(UIView*)ViewName
{
    ViewName.layer.borderColor = [UIColor orangeColor].CGColor;
    ViewName.layer.borderWidth = 1.0;
    ViewName.layer.cornerRadius = 8.0;
}
+(void)SetTfShadow:(UITextField*)tfName
{
    tfName.layer.borderColor = [UIColor orangeColor].CGColor;
    tfName.layer.borderWidth = 1.0;
    tfName.layer.cornerRadius = 8.0;
}
+(void)SetInsetToTextField:(UITextField*)tf
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    [tf.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    [tf.layer setBorderWidth: 1.0];
    [tf.layer setMasksToBounds:YES];
}
+ (UIImage *)imageAtPath:(NSString *)path cache:(NSMutableDictionary *)cache ImageType:(NSString*)strImageType{
    // Retrieve image from the cache.
    UIImage *imageThumb = [cache objectForKey:path];
    // If not in the cache, retrieve from the file system
    // and add to the cache.
    UIImage *image;
    if (imageThumb == nil) {
        
        if ([strImageType isEqualToString:@"Video"])
        {
            NSURL *videoURL = [NSURL fileURLWithPath:path];
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            image = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [player stop];
        }
        else
        {
            image = [UIImage imageWithContentsOfFile:path];
        }
        imageThumb = [image imageScaleAndCropToMaxSize:CGSizeMake(150,150)];
        if (imageThumb) {
            NSString *StrPath = [NSString stringWithFormat:@"%@Big",path];
            [cache setObject:imageThumb forKey:path];
            [cache setObject:image forKey:StrPath];
        }
    }
    return imageThumb;
}
@end
