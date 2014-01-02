//
//  WebSiteViewController.m
//  NewsStand
//
//  Created by openxcell technolabs on 5/7/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "WebSiteViewController.h"
#import "AppDelegate.h"

@implementation WebSiteViewController
@synthesize strLink;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [actObj setHidden:NO];
    [actObj startAnimating];

    [webViewObj loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLink]]];
}

-(IBAction)ClickBtnCancel:(id)sender
{
    [actObj setHidden:YES];
    [actObj stopAnimating];
    [webViewObj stopLoading];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [actObj setHidden:NO];
    [actObj startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [actObj setHidden:YES];
    [actObj stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [actObj setHidden:YES];
    [actObj stopAnimating];
    
    if ([error code] != -999)
    {
        DisplayAlertWithTitle(App_Name, error.localizedDescription);
        return;
    }
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight
        ||interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        flagOrientation = 1;
    }
    else
    {
        flagOrientation = 0;
    }
    [self setOrientation];
    
	return YES;
}
-(void)setOrientation
{
    if (flagOrientation == 1)
    {
        imgHeader.image = [UIImage imageNamed:@"L-WebBg.png"];
    }
    else
    {
        imgHeader.image = [UIImage imageNamed:@"WebBg.png"];
    }
}
- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    return orientations;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        flagOrientation = 0;
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        flagOrientation = 1;
    }
    [self setOrientation];
}

@end
