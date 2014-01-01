//
//  ImageZoomViewController.m
//  OBVENT
//
//  Created by W@rrior on 18/03/13.
//  Copyright (c) 2013 W@rrior. All rights reserved.
//

#import "ImagePreviewController.h"
#import "UIImageView+WebCache.h"
#import "UIScrollViewEvent.h"

#define PADDING  10

@interface ImagePreviewController ()

@end

@implementation ImagePreviewController
@synthesize imgPreview,strURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    btnDone.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self scrollViewSetup];
    
    UILongPressGestureRecognizer *longPressPhoto = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleLongPressWall:)];
    longPressPhoto.minimumPressDuration = 1;
    [scrollphoto addGestureRecognizer:longPressPhoto];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setDelaysTouchesBegan : YES];
    [scrollphoto addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setDelaysTouchesBegan : YES];
    [scrollphoto addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail : doubleTap];
    
    UISwipeGestureRecognizer *swipe_Down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipe_Down.direction = UISwipeGestureRecognizerDirectionDown;
    [scrollphoto addGestureRecognizer:swipe_Down];
    
    [self setFullPreviewImage];
}

#pragma mark - Double Tap
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if(scrollphoto.zoomScale > scrollphoto.minimumZoomScale)
        [scrollphoto setZoomScale:scrollphoto.minimumZoomScale animated:YES];
    else
        [scrollphoto setZoomScale:scrollphoto.maximumZoomScale animated:YES];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (btnDone.alpha == 1.0f)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.10f];
        btnDone.alpha = 0.0f;
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.10f];
        btnDone.alpha = 1.0f;
        [UIView commitAnimations];
    }
}
- (void)scrollViewSetup
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    // supports iPhone 5 screen size
    scrollphoto.frame = screenFrame;
    
    scrollphoto.contentSize = [self contentSizeForscrollView];
    scrollphoto.maximumZoomScale = 5.;
    scrollphoto.minimumZoomScale = 1;
    
    shouldLoadImage = YES;
    imgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.tag = 1;
    imgView.userInteractionEnabled=YES;
    imgView.backgroundColor=[UIColor grayColor];
    imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    scrollphoto.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  
    // @Fix: Allows scrolling for different sized images
    scrollphoto.zoomScale = 1.1;
    scrollphoto.zoomScale = 1.0;
    ((UIScrollViewEvent*)scrollphoto).imgView = imgView;
    [scrollphoto addSubview:imgView];
    
    //[self.view bringSubviewToFront:bottomView];
    [scrollphoto setNeedsDisplay];
    [self.view setNeedsDisplay];
}

- (CGSize)contentSizeForscrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = scrollphoto.bounds;
    return CGSizeMake(bounds.size.width + PADDING, bounds.size.height + PADDING);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imgView;
}

- (void)layoutSubviews {
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = scrollphoto.bounds.size;
    CGRect frameToCenter = imgView.frame;
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
}
-(void)handleLongPressWall:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:kAppName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save photo to album", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        sheet.tag = 1;
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //Do Whatever You want on End of Gesture
    }
}
-(void)swipeDown:(UISwipeGestureRecognizer*)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self performSelector:@selector(saveimagetoalbum) withObject:nil afterDelay:0.0];
        }
        else if (buttonIndex == 1)
        {
            return;
        }
    }
}
-(void)saveimagetoalbum
{
    UIImageWriteToSavedPhotosAlbum(imgView.image, self, nil, nil);
}




-(void)setFullPreviewImage
{
    if (imgPreview)
    {
        imgView.image=imgPreview;
        actIndCenter.hidden=YES;
    }
    else
    {
        if (shouldLoadImage)
        {
            __block ImagePreviewController *imgdet = self;
            actIndCenter.hidden = NO;
            [actIndCenter startAnimating];
            NSURL *imageURL = [NSURL URLWithString:self.strURL];
            if (![self.strURL isEqualToString:@""] || imageURL != nil)
            {
                [imgView setImageWithURL:imageURL placeholderImage:Nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                 {
                     imgdet->imgView.image = image;
                     [imgdet HideAnimating];
                 }];
            }
            shouldLoadImage = NO;
        }
    }
    
}
-(void)HideAnimating
{
    [scrollphoto setZoomScale:scrollphoto.maximumZoomScale animated:NO];
    [scrollphoto setZoomScale:scrollphoto.minimumZoomScale animated:NO];
    [actIndCenter stopAnimating];
     actIndCenter.hidden = YES;
}

#pragma mark - URLManager Delegete Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(IBAction)btnDonePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
