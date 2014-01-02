//
//  ProductivityWebViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/16/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "ProductivityWebViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"


@interface ProductivityWebViewCtr ()

@end

@implementation ProductivityWebViewCtr
@synthesize strLink;

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
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        webview.frame = CGRectMake(webview.frame.origin.x, webview.frame.origin.y + 20, webview.frame.size.width, webview.frame.size.height  - 20);
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLink]]];
}

#pragma mark - WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
}

#pragma mark - IBAction Methods

#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
#pragma mark - Set Landscape Frame

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [webview stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
