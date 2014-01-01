/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Utilities.h"

#define imgSync [UIImage imageNamed:@"sync.png"]
static char operationKey;

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}
- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;
{
    [self cancelCurrentImageLoad];

    if (url)
    {
        if (placeholder == imgSync)
        {
            self.image = placeholder;
            [self setContentMode:UIViewContentModeCenter];
            [self startRotate];
        }
        else if(placeholder == [UIImage imageNamed:@"spinner"])
        {
            self.image = placeholder;
            [self setContentMode:UIViewContentModeCenter];
            [self startRotate];
        }
        else
        {
            //self.backgroundColor=[UIColor lightGrayColor];
            self.image = placeholder;
        }
        
        __weak UIImageView *wself = self;
        
        
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            __strong UIImageView *sself = wself;
            if (!sself) return;
            if (image)
            {
                [self setContentMode:UIViewContentModeScaleAspectFit];
                 [self stopRotate];
                [self stopAnimating];
                
                
                switch (self.tag)
                {
                    case 2001:
                    {
                        sself.image = [image cropCenterToSize:CGSizeMake(self.frame.size.width,self.frame.size.height)];
                        
                        CATransition *transition = [CATransition animation];
                        transition.duration = 1.0f;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                        transition.type = kCATransitionFade;
                        [sself.layer addAnimation:transition forKey:nil];
                    }
                        break;
                    case 107:
                    {
                        sself.image = [image squaredImage];
                    }
                        break;
                        
                    default:
                        sself.image = image;
                        break;
                }

                [sself setNeedsLayout];
                
                if (finished)
                {
                    if (![dictImages objectForKey:url])
                    {
                        [dictImages setObject:sself.image forKey:url];
                    }
                }
            }
            if (completedBlock && finished)
            {
                [self setContentMode:UIViewContentModeScaleAspectFit];
                [self stopAnimating];
                [self stopRotate];
                completedBlock(image, error, cacheType);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        self.image = [UIImage imageNamed:@"imgNoPhoto"];
    }
}


- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [self stopRotate];
        [self stopAnimating];
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(void)startRotate
{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 1.2f;
    fullRotation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:fullRotation forKey:@"360"];
}
-(void)stopRotate
{
    [self.layer removeAnimationForKey:@"360"];
}
@end
