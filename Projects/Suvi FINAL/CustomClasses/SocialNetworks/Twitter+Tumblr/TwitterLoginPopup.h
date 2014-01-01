//
//  TwitterLoginPopup.h
//
//  Created by Jaanus Kase on 15.01.10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthTwitterCallbacks.h"
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"

@class OAuthTwitter, TwitterWebViewController;

typedef enum {
    TwitterLoginPinFlow,
    TwitterLoginCallbackFlow
} TwitterLoginFlowType;

typedef enum {
    SocialNetworkTwitter,
    SocialNetworkTumblr
} SocialNetworkType;

@interface TwitterLoginPopup : UIViewController <OAuthTwitterCallbacks,
    UINavigationControllerDelegate, UIWebViewDelegate> 
{
	id <oAuthLoginPopupDelegate> delegate;
	id <TwitterLoginUiFeedback> uiDelegate;
	
    TwitterLoginFlowType flowType;
    SocialNetworkType socialnetworkType;
        
	NSOperationQueue *queue;
	OAuthTwitter *oAuth;
	IBOutlet UIWebView *webView;
	TwitterWebViewController *webViewController;
    NSString *oAuthCallbackUrl;
}

@property (assign) id<oAuthLoginPopupDelegate> delegate;
@property (assign) id<TwitterLoginUiFeedback> uiDelegate;

@property (assign) TwitterLoginFlowType flowType;
@property (assign) SocialNetworkType socialnetworkType;

@property (nonatomic, retain) OAuthTwitter *oAuth;
@property (nonatomic, copy) NSString *oAuthCallbackUrl;

// Call this when receiving the verifier as URL parameter in URL callback flow,
// or when input in the UI.
- (void)authorizeOAuthVerifier:(NSString *)oauth_verifier;

@end


