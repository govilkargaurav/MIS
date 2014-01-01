//
//  FoursquareLoginPopup.m
//  PlainOAuth
//
//  Created by Jaanus Kase on 27.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "FoursquareLoginPopup.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "common.h"

@implementation FoursquareLoginPopup
@synthesize delegate, oAuth;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Foursquare";
	
	UIButton *btncancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btncancel setImage:[UIImage imageNamed:@"btnprevious"] forState:UIControlStateNormal];
    btncancel.frame=CGRectMake(0,0,44,44);
    [btncancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btncancel];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;    
    webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,0,appFrame.size.width,appFrame.size.height)] autorelease];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor=OAUTH_WEBVIEW_BG_COLOR;
    [webView setOpaque:NO];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@", OAUTH_FOURSQUARE_CONSUMER_KEY, @"fsqdemo://foursquare"]]]];
}
-(BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *URLString = [[request URL] absoluteString];
        
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) 
    {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        
        NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [socialdict setObject:[NSString stringWithFormat:@"%@",accessToken] forKey:@"foursquare_token"];
        [socialdict setObject:@"Authenticate" forKey:@"foursquare"];
        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString  *urlstring1 = [NSString stringWithFormat:@"%@%@",kAuthoriseUnauthoriseSocialNw,[NSString stringWithFormat:@"&func=auth_unauthFoursquare&userID=%@&foursquare_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],accessToken]]; 
        
        NSURL *urlTwiter = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString * jsonRes1 = [NSString stringWithContentsOfURL:urlTwiter encoding:NSUTF8StringEncoding error:nil];
        if (jsonRes1) {
          /*
           NSError *error;
           NSData *storesData = [jsonRes1 dataUsingEncoding:NSUTF8StringEncoding];
           NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONWritingPrettyPrinted error:&error];
           */
        }
        

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        oAuth.oauth_token = accessToken;
        oAuth.oauth_token_authorized = YES;
        [oAuth save];
        [self.delegate oAuthLoginPopupDidAuthorize:self];
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)cancel 
{    
	[self.delegate oAuthLoginPopupDidCancel:self];
}

#pragma mark - 
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
}- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
- (void) dealloc {
    [oAuth release];
    [super dealloc];
}
@end
