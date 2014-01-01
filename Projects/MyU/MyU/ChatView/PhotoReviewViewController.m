//
//  PhotoReviewViewController.m
//  MyU
//
//  Created by Vijay on 8/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "PhotoReviewViewController.h"
#import "UIScrollViewEvent.h"
#define PADDING  10

@interface PhotoReviewViewController ()

@end

@implementation PhotoReviewViewController
@synthesize imgPreview;

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
    [self scrollViewSetup];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setDelaysTouchesBegan : YES];
    [scrollphoto addGestureRecognizer:doubleTap];
    
    imgView.image=imgPreview;
}

#pragma mark - Double Tap
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if(scrollphoto.zoomScale > scrollphoto.minimumZoomScale)
        [scrollphoto setZoomScale:scrollphoto.minimumZoomScale animated:YES];
    else
        [scrollphoto setZoomScale:scrollphoto.maximumZoomScale animated:YES];
}

- (void)scrollViewSetup
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    // supports iPhone 5 screen size
    scrollphoto.frame = screenFrame;
    
    scrollphoto.contentSize = [self contentSizeForscrollView];
    scrollphoto.maximumZoomScale = 5.;
    scrollphoto.minimumZoomScale = 1;
    
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


#pragma mark - URLManager Delegete Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(IBAction)btnDonePressed:(id)sender
{
    shouldImageBeShared=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImagePicked" object:nil userInfo:[NSDictionary dictionaryWithObject:imgPreview forKey:@"image"]];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
-(IBAction)btnCancelPressed:(id)sender
{
    shouldImageBeShared=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageCanceled" object:nil userInfo:nil];
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
