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
//#import "Global.h"
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

    self.image = placeholder;
    
    if (url)
    {
        if (placeholder == imgSync)
        {
            [self setContentMode:UIViewContentModeCenter];
            [self startRotate];
        }
        else
        {
           // [self startRotate];
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
            
//                switch (self.tag)
//                {
//                    case 500500:
//                        //sself.image = [image squareImage];
//                        break;
//                        
//                    default:
//                        if (options!= SDWebImageProgressiveDownload)
//                        {
//                           // [self setAlpha:0];
//                            [UIView beginAnimations:nil context:NULL];
//                            [UIView setAnimationDuration:0.5];
//                            
//                            sself.image = image;
//                            //[self setAlpha:1];
//                            
//                            [UIView commitAnimations];
//                        }
//                        else
//                            sself.image = image;
//                        break;
//                }
                switch (self.tag) {
                    case 0:
                    {
                        self.image = image;
                    }
                        break;
                        
                    case 1001:
                    {
                        self.image = [image squareImage];
                    }
                        break;
                        
                    case 1002:
                    {
                        self.image=[image cropCenterToSize:self.frame.size];
                    }
                        break;
                    case 500500:
                    {
                        self.image=[image cropCenterToSize:CGSizeMake(310, 310)];
                    }
                        break;
                    default:
                    {
                        self.image = image;
                    }
                        break;
                }    

                //sself.image = image;
                [sself setNeedsLayout];
            }
            if (completedBlock && finished)
            {
                //[self setContentMode:UIViewContentModeScaleAspectFit];
                [self stopRotate];
                completedBlock(image, error, cacheType);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad
{
   
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [self stopRotate];
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(void)startRotate
{
    /*
    __block UIActivityIndicatorView *Acti = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [Acti setFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20)];
    Acti.tag = 123654;
    [Acti startAnimating];
    [self addSubview:Acti];
     */
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 1.5f;
    fullRotation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:fullRotation forKey:@"360"];
    
}
-(void)stopRotate
{
    /*
    for (UIActivityIndicatorView *acti in self.subviews)
    {
        if ([acti isKindOfClass:[UIActivityIndicatorView class]])
        {
            if (acti.tag == 123654)
            {
                [acti removeFromSuperview];
            }
        }
    }
    */
    
    [self.layer removeAnimationForKey:@"360"];
    
}
@end
