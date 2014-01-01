//
//  TermsAndPolicyViewController.m
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "TermsAndPolicyViewController.h"

@interface TermsAndPolicyViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *lblHeader;
}
@end

@implementation TermsAndPolicyViewController

@synthesize pagetype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (pagetype) {
        case TermsPage:
        {
            lblHeader.text=@"Terms";
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kTermsURL]]];
        }
            break;
            
        case PrivacyPage:
        {
            lblHeader.text=@"Privacy Policy";
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kPrivacyURL]]];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
