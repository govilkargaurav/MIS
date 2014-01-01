//
//  WebViewPController.m
//  ChatPRJ
//
//  Created by Vijay on 7/24/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "WebViewPController.h"
#import "NSString+Utilities.h"

@interface WebViewPController () <UITextFieldDelegate,UIWebViewDelegate>
{
    IBOutlet UIWebView  *webView;
}
@end

@implementation WebViewPController
@synthesize strLink;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadRequest];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
-(IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

- (void)loadRequest
{
    NSString *strURL;
    
    NSURL *candidateURL = [NSURL URLWithString:[strLink removeNull]];
    if (candidateURL && candidateURL.scheme && candidateURL.host)
    {
        strURL=[NSString stringWithFormat:@"%@",strLink];
    }
    else if(!candidateURL.scheme)
    {
        strURL=[NSString stringWithFormat:@"http://%@",strLink];
        
        if (![self validateUrl:strURL])
        {
            strURL=[NSString stringWithFormat:@"http://www.google.com/search?q=%@",strLink];
        }
    }
    else
    {
        strURL=[NSString stringWithFormat:@"http://www.google.com/search?q=%@",strLink];
    }
    
    webView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgchatgrey.png"]];
    webView.opaque=NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@",strURL]]]];
}

- (BOOL)isValidRequest:(NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}

- (BOOL) validateUrl: (NSString *) candidate
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
#pragma mark - EXTRA METHODS
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
