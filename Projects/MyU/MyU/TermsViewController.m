//
//  TermsViewController.m
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
}
@end

@implementation TermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTermsURL]]];
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DisplayAlert([error localizedDescription]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - DEFAULT METHODS
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


@end
