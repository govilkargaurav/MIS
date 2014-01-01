//
//  WatchVideoViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WatchVideoViewController.h"

@implementation WatchVideoViewController
@synthesize imgURLPOST;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[imgURLPOST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}
- (void)videoFullScreen:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)videoExitFullScreen:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(IBAction)Back:(id)sender
{
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:YES];
}
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
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

@end