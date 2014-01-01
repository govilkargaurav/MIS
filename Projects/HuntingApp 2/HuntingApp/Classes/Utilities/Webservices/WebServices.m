//
//  WebServices.m
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebServices.h"
#import "MyReachability.h"

@implementation WebServices

@synthesize delegate;
@synthesize tagAction;
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void) perfromAsyncPostRequestWithURL:(NSString *)url withParams:(NSDictionary *)dict
{
    if ([dict objectForKey:KWEB_SERVICE_ACTION])
        [self setTagAction:[NSString stringWithString:[dict objectForKey:KWEB_SERVICE_ACTION]]];
    if (requestWrapper)
    {
        [requestWrapper setDelegate:nil];
        RELEASE_SAFELY(requestWrapper);
    }
    requestWrapper = [[RequestWrapper alloc]init];
    [requestWrapper setDelegate:self];
    [requestWrapper perfromAsyncPostRequestWithURL:url withParams:dict];
}

- (void) perfromSyncPostRequestWithURL:(NSString *)url withParams:(NSDictionary *)dict
{
    if ([dict objectForKey:KWEB_SERVICE_ACTION])
        [self setTagAction:[NSString stringWithString:[dict objectForKey:KWEB_SERVICE_ACTION]]];
    if (requestWrapper)
    {
        [requestWrapper setDelegate:nil];
        RELEASE_SAFELY(requestWrapper);
    }
    requestWrapper = [[RequestWrapper alloc]init];
    [requestWrapper setDelegate:self];
    [requestWrapper perfromSyncPostRequestWithURL:url withParams:dict];
}

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *dict = [[self class] parseJSONString:response];
    if ([dict objectForKey:@"error"]&&[[[dict objectForKey:@"error"]objectForKey:@"error"] isEqualToString:@"Request Token not found"])
    {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Log In Error" message:@"Your session has expired. Please login again!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        [Utility logout];
    }
    else 
    {
        if (self.tagAction)
            userInfo = [NSDictionary dictionaryWithObject:self.tagAction forKey:KWEB_SERVICE_ACTION];
        DLog(@"%d-----%@-------%@",statusCode,response,[userInfo description]);
        RELEASE_SAFELY(requestWrapper);
        if (delegate && [delegate respondsToSelector:@selector(requestWrapperDidReceiveResponse:withHttpStautusCode:withRequestUrl:withUserInfo:)])
        {
            [delegate requestWrapperDidReceiveResponse:response withHttpStautusCode:statusCode withRequestUrl:requestUrl withUserInfo:userInfo];
        }

    }
}

- (void)dealloc
{
    self.tagAction=nil;
    requestWrapper.delegate = nil;
    RELEASE_SAFELY(requestWrapper);
    [super dealloc];
}


+ (NSDictionary *)parseJSONString:(NSString *)responseString
{
    if (responseString)
    {
        NSError *error = nil;
        NSData* data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
        if (!error)
            return dictionary;
        else {
            DLog(@"%@",[error description]);
            return nil;
        }
    }
    return nil;
}

- (BOOL)isNetAvailable
{
    MyReachability *reachability = [MyReachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}

- (void)showNetworkError
{
    BlackAlertView *alertView = [[BlackAlertView alloc]initWithTitle:@"Network Error" message:@"Network not found. Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    [self requestWrapperDidReceiveResponse:@"" withHttpStautusCode:0 withRequestUrl:nil withUserInfo:nil];
}

@end
