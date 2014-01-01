//
//  RequestWrapper.m
//  Listentail
//
//  Created by Kashan Khan on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestWrapper.h"
#import "CJSONSerializer.h"


@interface RequestWrapper (Private)
//show the network indicator on top staus bar.
- (void) networkActivityIndicatorVisible:(BOOL)isVisible;
- (void) sendGetRequestWithURL:(NSString*)uri WithParams:(NSDictionary*)params withLoadSynchronous:(BOOL)isLoadSynchronously;
- (void) sendPostRequestWithURL:(NSString*)uri WithParams:(NSDictionary*)params withLoadSynchronous:(BOOL)isLoadSynchronously;
@end

@implementation RequestWrapper

@synthesize delegate = _delegate, userInfo = _userInfo;

#define TIME_OUT_INTERVAL 120.0f



- (id) init {
    self = [super init];
    if (self) {
        _delegate = nil;
        _userInfo = nil;
        isAppServerUrl = YES;
    }
    return self;

}

- (id) initWithThirdPartyServer {
    
    self = [self init];
    isAppServerUrl = NO;
    
    return self;
}
- (void) dealloc {

    _delegate = nil;
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
    
    [_request release];
    
    [_postRequest cancel];
    [_postRequest clearDelegatesAndCancel];
    [_postRequest release];
    
    [_userInfo release];

    [super dealloc];
}

#pragma mark -Async Request Public Methods
// This method will send the async POST call 
- (void)perfromAsyncPostRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:params withHTTPMethod:HTTP_METHOD_POST withLoadSynchronous:NO];
}

// This method will send the async GET call 
- (void)perfromAsyncPutRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:params withHTTPMethod:HTTP_METHOD_PUT withLoadSynchronous:NO];
}

// This method will send the async GET call 
- (void)perfromAsyncGetRequestWithURL:(NSString*)uri {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:nil withHTTPMethod:HTTP_METHOD_GET withLoadSynchronous:NO];

}

- (void)perfromAsyncGetRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params{
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:params withHTTPMethod:HTTP_METHOD_GET withLoadSynchronous:NO];
}


#pragma mark -Sync Request Public Methods
// This method will send the sync POST call 
- (void)perfromSyncPostRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:params withHTTPMethod:HTTP_METHOD_POST withLoadSynchronous:YES];

}
// This method will send the sync PUT call
- (void)perfromSyncPutRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:params withHTTPMethod:HTTP_METHOD_PUT withLoadSynchronous:YES];
}

// This method will send the sync GET call
- (void)perfromSyncGetRequestWithURL:(NSString*)uri {
    uri = (isAppServerUrl) ? [kServerUri stringByAppendingString:uri] : uri;
    [self sendRequestWithURL:uri WithParams:nil withHTTPMethod:HTTP_METHOD_GET withLoadSynchronous:YES];
}



#pragma mark -Private Methods

- (void) sendRequestWithURL:(NSString*)uri WithParams:(NSDictionary*)params withHTTPMethod:(NSString*)httpMethod withLoadSynchronous:(BOOL)isLoadSynchronously {
    
    if ([httpMethod isEqualToString:HTTP_METHOD_GET])
    {
        [self sendGetRequestWithURL:uri WithParams:params withLoadSynchronous:isLoadSynchronously];
    }
    else if([httpMethod isEqualToString:HTTP_METHOD_POST])
    {
        [self sendPostRequestWithURL:uri WithParams:params withLoadSynchronous:isLoadSynchronously];
    }
}

- (void)sendGetRequestWithURL:(NSString *)uri WithParams:(NSDictionary *)params withLoadSynchronous:(BOOL)isLoadSynchronously
{
    //if (!_request)
    {
        for (NSString *key in [params allKeys]) 
        {
            uri = [NSString stringWithFormat:@"%@%@=%@&",uri,key,[params objectForKey:key]];
            //[_request addRequestHeader:key value:[params objectForKey:key]];
        }  
        if ([uri hasSuffix:@"&"])
        {
            uri = [uri substringToIndex:[uri length] - 1];
        }
        uri = [uri stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:uri];
        DLog(@"URL  : %@ ",url);
        _request = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:uri]] retain];
        [_request setRequestMethod:HTTP_METHOD_GET];
        
        //Adding addtional headers
        [_request addRequestHeader:@"Cache-Control" value:@"no-cache"];
        // only send the body if the params exists & HTTP method is not get Type.
        
        if (isLoadSynchronously) {
            [_request startSynchronous];
            NSError *error = [_request error];
            if (!error) {
                NSString *response = [_request responseString];
                
                if (_delegate && [_delegate respondsToSelector:@selector(requestWrapperDidReceiveResponse:withHttpStautusCode:withRequestUrl:withUserInfo:)]) {
                    
                    [_delegate requestWrapperDidReceiveResponse:response withHttpStautusCode:[_request responseStatusCode] withRequestUrl:url withUserInfo:_userInfo];
                    
                }//if
                
            }//if
        }//if
        else {
            [_request setDelegate:self];
            [_request startAsynchronous];
        }
    }
}

- (void)sendPostRequestWithURL:(NSString *)uri WithParams:(NSDictionary *)params withLoadSynchronous:(BOOL)isLoadSynchronously
{
    uri = [uri stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:uri];
    DLog(@"URL  : %@ ",url);
    _postRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:uri]] retain];
    [_postRequest setRequestMethod:HTTP_METHOD_POST];
    
    //Adding addtional headers
    [_postRequest addRequestHeader:@"Cache-Control" value:@"no-cache"];
    // only send the body if the params exists & HTTP method is not get Type.
    
    for (NSString *key in [params allKeys]) {
        [_postRequest setPostValue:[params objectForKey:key] forKey:key];
    }
    
    NSMutableDictionary *mutPrams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutPrams removeObjectForKey:@"image"];
    DLog(@"%@",[mutPrams description]);
    
    if (isLoadSynchronously) {
        [_postRequest startSynchronous];
        NSError *error = [_postRequest error];
        if (!error) {
            NSString *response = [_postRequest responseString];
            
            if (_delegate && [_delegate respondsToSelector:@selector(requestWrapperDidReceiveResponse:withHttpStautusCode:withRequestUrl:withUserInfo:)]) {
                
                [_delegate requestWrapperDidReceiveResponse:response withHttpStautusCode:[_postRequest responseStatusCode] withRequestUrl:url withUserInfo:_userInfo];
                
            }//if
            
        }//if
    }//if
    else {
        [_postRequest setDelegate:self];
        [_postRequest startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    // Use when fetching binary data
  //  NSData *responseData = [request responseData];
    
   if (_delegate && [_delegate respondsToSelector:@selector(requestWrapperDidReceiveResponse:withHttpStautusCode:withRequestUrl:withUserInfo:)]) {
        [_delegate requestWrapperDidReceiveResponse:responseString withHttpStautusCode:[request responseStatusCode] withRequestUrl:[request url] withUserInfo:_userInfo];
    }
    else {
        BlackAlertView *alertView = [[BlackAlertView alloc] initWithTitle:nil message:responseString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestWrapperDidReceiveResponse:withHttpStautusCode:withRequestUrl:withUserInfo:)]) {
        [_delegate requestWrapperDidReceiveResponse:[request responseStatusMessage] withHttpStautusCode:[request responseStatusCode] withRequestUrl:[request url] withUserInfo:_userInfo];
    }
    else {
        BlackAlertView *alertView = [[BlackAlertView alloc] initWithTitle:nil message:[request description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

@end
