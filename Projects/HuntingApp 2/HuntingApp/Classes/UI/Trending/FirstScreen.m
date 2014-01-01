//
//  FirstScreen.m
//  HuntingApp
//
//  Created by Habib Ali on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstScreen.h"

@interface FirstScreen ()

@end

@implementation FirstScreen
@synthesize imgView,imgViewFrame,image,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    RELEASE_SAFELY(tapGestureRecognizer);
    [imgView release];
    image = nil;
    [scrollVw release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (image)
    {
        [imgView setFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
        DLog(@"%f----%f",image.size.width, image.size.width);
        [imgView setImage:image];
        
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        scrollVw.contentSize = image.size;
        
        scrollVw.bounces = NO;
        
        scrollVw.delegate = self;
        
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
        
        scrollVw.contentSize = image.size;
        scrollVw.maximumZoomScale = maxScale;
        scrollVw.minimumZoomScale = minScale;
        scrollVw.zoomScale = minScale;
        
        
        //////////////
        
        CGSize boundsSize = scrollVw.frame.size;
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
        
        //////////////
        
        imgView.frame = frameToCenter; 
    }

    else {
        [imgView setFrame:CGRectMake(57, 86, 206, 200)];
    }
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(singleTapGestureRecognizer) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.view setAlpha:0.899999976158142];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [self setImgView:nil];
    [scrollVw release];
    scrollVw = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma TapGestureRecognizer Methods
- (void)singleTapGestureRecognizer {
    DLog(@"%s", __FUNCTION__);
    [UIView animateWithDuration:1.0 animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL isCompleted){
        if (isCompleted)
        {
            
            if (delegate && [delegate respondsToSelector:@selector(imageDisappeared)])
                [delegate imageDisappeared];
            else {
                [tapGestureRecognizer.view removeFromSuperview];
            }
        }
    }];
    
    
    //      [self.view removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imgView;
}


@end
