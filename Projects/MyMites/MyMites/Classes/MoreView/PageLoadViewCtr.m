//
//  PageLoadViewCtr.m
//  MyMites
//
//  Created by Mac-i7 on 1/31/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "PageLoadViewCtr.h"
#import "BusyAgent.h"

@interface PageLoadViewCtr ()

@end

@implementation PageLoadViewCtr
@synthesize strTitle,strLink;

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
    CALayer *l=[webViewLoad layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor clearColor] CGColor];
    l.backgroundColor=[[UIColor clearColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
        
    lblTitle.text = [NSString stringWithFormat:@"%@",strTitle];
    if ([strLink length] == 0)
    {
        lblMsg.hidden = NO;
    }
    else
    {
        [webViewLoad loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLink]]];
    }
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebView Delegate Method

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
