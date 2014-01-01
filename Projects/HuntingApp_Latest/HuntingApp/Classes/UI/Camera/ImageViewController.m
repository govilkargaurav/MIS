//
//  ImageViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "SaveImageViewController.h"
#import "UIImage+Scale.h"

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize imageView,image,parentController;

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

    [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
    DLog(@"%f----%f",image.size.width, image.size.width);
    [imageView setImage:image];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    scrollView.contentSize = image.size;
    
    scrollView.bounces = NO;
    
    scrollView.delegate = self;
    
    // set up our content size and min/max zoomscale
    CGFloat xScale = applicationFrame.size.width / image.size.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = applicationFrame.size.height / image.size.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    scrollView.contentSize = image.size;
    scrollView.maximumZoomScale = maxScale;
    scrollView.minimumZoomScale = minScale;
    scrollView.zoomScale = minScale;
    
    
    //////////////
    
    CGSize boundsSize = scrollView.frame.size;
    CGRect frameToCenter = imageView.frame;
    
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
    
    //////////////
    
    imageView.frame = frameToCenter; 
    
    // To change
    
    UIImage *aimage = [image scaleDownToSize:CGSizeMake(320, 416)];
    float y = (416 - aimage.size.height)/2;
    CGRect landScapeFrame = CGRectMake(0, y, 320, aimage.size.height);
    CGRect fullFrame =  CGRectMake(0,0 , 320, 416);
    CGRect frame = fullFrame;
    if (image.size.width > image.size.height)
    {
        frame = landScapeFrame;
    }
    imageView.frame = frame;
    [self.navigationItem setHidesBackButton:YES];
    
    
	// Do any additional setup after loading the view.
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"Image"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:titleView];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage:)] autorelease];
    self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [scrollView release];
    scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    parentController = nil;
    RELEASE_SAFELY(titleView);
    [imageView release];
    RELEASE_SAFELY(image);
    [scrollView release];
    [super dealloc];
}

- (IBAction)share:(id)sender {
    SHKItem *item = [SHKItem image:image title:@"Check out"];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	[actionSheet showFromToolbar:self.navigationController.toolbar];

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"SaveImage"])
    {
        SaveImageViewController *controller = (SaveImageViewController *)[segue destinationViewController];
        [controller setImage:image];
        [controller setParentController:parentController];
    }
}

- (void)popViewController
{
    [parentController dismissModalViewControllerAnimated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

- (void)saveImage:(id)sender
{
    [self performSegueWithIdentifier:@"SaveImage" sender:self];
}

@end
