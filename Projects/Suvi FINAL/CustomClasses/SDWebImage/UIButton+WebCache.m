/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "objc/runtime.h"
#define imgSync [UIImage imageNamed:@"sync.png"]
static char operationKey;

@implementation UIButton (WebCache)

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];

    [self setImage:placeholder forState:state];

    if (url)
    {
        if (placeholder == imgSync)
        {
            [self setContentMode:UIViewContentModeCenter];
            [self startRotate];
        }
        else
        {
            [self startRotate];
        }
        __weak UIButton *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image)
            {
                [self stopRotate];
                
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished)
            {
                [self stopRotate];
                completedBlock(image, error, cacheType);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
   [self cancelCurrentImageLoad];

    [self setBackgroundImage:placeholder forState:state];

    if (url)
    {
        if (placeholder == imgSync)
        {
            [self setContentMode:UIViewContentModeCenter];
            [self startRotate];
        }
        else
        {
            [self startRotate];
        }
        
        __weak UIButton *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image)
            {
                [self stopRotate];
                
                [sself setBackgroundImage:image forState:state];
            }
            if (completedBlock && finished)
            {
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
    __block UIActivityIndicatorView *Acti = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [Acti setFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20, 20)];
    Acti.tag = 123654;
    [Acti startAnimating];
    [self addSubview:Acti];
    /*
     CABasicAnimation *fullRotation;
     fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
     fullRotation.fromValue = [NSNumber numberWithFloat:0];
     fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
     fullRotation.duration = 1.5f;
     fullRotation.repeatCount = MAXFLOAT;
     
     [self.layer addAnimation:fullRotation forKey:@"360"];
     */
}
-(void)stopRotate
{
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
    
    /*
     [self.layer removeAnimationForKey:@"360"];
     */
}
@end
