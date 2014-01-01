//
//  TwitterLoginPopup.m
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import "TwitterLoginPopup.h"
#import "OAuthTwitter.h"
#import "TwitterWebViewController.h"
#import "OAuthConsumerCredentials.h"

@interface TwitterLoginPopup (PrivateMethods)
-(void) requestTokenWithCallbackUrl:(NSString *)callbackUrl;
@end

@implementation TwitterLoginPopup
@synthesize delegate, uiDelegate, oAuth, flowType, oAuthCallbackUrl,socialnetworkType;

#pragma mark - UIViewController and memory mgmt
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
    if (socialnetworkType==SocialNetworkTwitter) 
    {
        self.title=@"Twitter";
    }
    else
    {
        self.title=@"Tumblr";
    }
	    
    UIButton *btncancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btncancel setImage:[UIImage imageNamed:@"btnprevious"] forState:UIControlStateNormal];
    btncancel.frame=CGRectMake(0,0,44,44);
    [btncancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btncancel];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    webView.backgroundColor=OAUTH_WEBVIEW_BG_COLOR;
    [webView setOpaque:NO];

	queue = [[NSOperationQueue alloc] init];
	oAuth.delegate = self;
	self.navigationController.delegate = self;    
    [self requestTokenWithCallbackUrl:oAuthCallbackUrl];
}

-(void)webViewDidStartLoad:(UIWebView *)webViewx
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webViewx 
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(BOOL)webView:(UIWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    NSString *URLString = [[request URL] absoluteString];
    
    if ([URLString hasPrefix:OAUTH_CALLBACK_URL]) 
    {
        NSArray *urlComponents = [URLString componentsSeparatedByString:@"?"];
        NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
        for (NSString *chunk in requestParameterChunks) {
            NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
            
            if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) 
            {
                NSDictionary *notificationdict=[NSDictionary dictionaryWithObject:[keyVal objectAtIndex:1] forKey:@"oauth_verifier"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil userInfo:notificationdict];
            }
        }
    }
    
    return YES;
}
#pragma mark -Authorize OAuth verifier received through URL callback or UI
- (void)authorizeOAuthVerifier:(NSString *)oauth_verifier {
    // delegate authorizationRequestDidStart
	[self.uiDelegate authorizationRequestDidStart:self];
    
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousAuthorizeTwitterTokenWithVerifier:)
										object:oauth_verifier];
	[queue addOperation:operation];
	[operation release];
    
}
-(void)cancel
{
    [webView stopLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // fix?
	[self.delegate oAuthLoginPopupDidCancel:self];
    oAuth.delegate=nil;
}

// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.
-(void) requestTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
    if (socialnetworkType == SocialNetworkTwitter)
    {
        NSURL *myURL = [NSURL URLWithString:[NSString
                                             stringWithFormat:@"%@?oauth_token=%@",OAUTH_TWITTER_AUTHORISE_URL,
                                             _oAuth.oauth_token]];
        [webView loadRequest:[NSURLRequest requestWithURL:myURL]];
        webView.delegate=self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    else
    {
        NSURL *myURL = [NSURL URLWithString:[NSString
                                             stringWithFormat:@"%@?oauth_token=%@",OAUTH_TUMBLR_AUTHORISE_URL,
                                             _oAuth.oauth_token]];
        [webView loadRequest:[NSURLRequest requestWithURL:myURL]];
        webView.delegate=self;
        webView.scalesPageToFit=YES;
    }

	[self.uiDelegate tokenRequestDidSucceed:self];
}

- (void) requestTwitterTokenDidFail:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}

    // Re-enable the link to try again.
	[self.uiDelegate tokenRequestDidFail:self];
}

- (void) authorizeTwitterTokenDidSucceed:(OAuth *)_oAuth 
{
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}

	[self.uiDelegate authorizationRequestDidSucceed:self];
    [self.delegate oAuthLoginPopupDidAuthorize:self];
}

- (void) authorizeTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	[self.uiDelegate authorizationRequestDidFail:self];	
}
-(void)requestTokenWithCallbackUrl:(NSString *)callbackUrl
{
    [self.uiDelegate tokenRequestDidStart:self];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:oAuth
										selector:@selector(synchronousRequestTwitterTokenWithCallbackUrl:)
										object:callbackUrl];
	
	[queue addOperation:operation];
	[operation release];
}

#pragma mark - DEALLOC
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
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewDidUnload 
{
	self.navigationController.delegate = nil;
	[queue release];
}
- (void)dealloc 
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [oAuthCallbackUrl release];
    [queue release];
	[webView release];
	[webViewController release];
	[oAuth release];
    [super dealloc];
}

@end
