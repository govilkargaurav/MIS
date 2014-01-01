    //
//  CustomLoginPopup.m
//  Plain2
//
//  Created by Jaanus Kase on 03.05.10.
//  Copyright 2010. All rights reserved.
//

#import "CustomLoginPopup.h"

@implementation CustomLoginPopup
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color=[UIColor blackColor];
        CGRect activityFrame = activityIndicator.frame;
        activityFrame.origin = CGPointMake(141.5,189.5);
        activityIndicator.frame = activityFrame;
        ishudanimating=NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:activityIndicator];
}
-(void)startanimator
{
    if (!ishudanimating) {
        ishudanimating=YES;
        [activityIndicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
-(void)stopanimator
{
    if (ishudanimating) {
        ishudanimating=NO;
        [activityIndicator stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)dealloc
{
    [activityIndicator release];
    [super dealloc];
}
@end