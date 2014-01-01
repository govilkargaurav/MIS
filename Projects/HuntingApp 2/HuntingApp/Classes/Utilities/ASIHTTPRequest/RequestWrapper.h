//
//  RequestWrapper.h
//  Listentail
//
//  Created by Kashan Khan on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

#define HTTP_METHOD_GET @"GET"
#define HTTP_METHOD_PUT @"PUT"
#define HTTP_METHOD_POST @"POST"

typedef enum {
    HTTP_STATUS_CODE_UNABLE_TO_SEND_REQUEST     = 0,
    HTTP_STATUS_CODE_200                        = 200,
    HTTP_STATUS_CODE_201                        = 201,
    HTTP_STATUS_CODE_202                        = 202,
    HTTP_STATUS_CODE_404                        = 404,
    HTTP_STATUS_CODE_406                        = 406,
    HTTP_STATUS_CODE_417                        = 417,
    HTTP_STATUS_CODE_421                        = 421 //User already exists
} HttpStatusCodes;


@protocol RequestWrapperDelegate;

@interface RequestWrapper : NSObject <ASIHTTPRequestDelegate> {
    id<RequestWrapperDelegate> _delegate;
    
    ASIHTTPRequest *_request;
    ASIFormDataRequest *_postRequest;
    NSDictionary *_userInfo;
    
    //Note: this variable is user to identifies whether its an app server Url or other servers 
    BOOL isAppServerUrl;
    
}

@property (nonatomic, assign) id<RequestWrapperDelegate> delegate;
//Set this proper need to set when user want to set any additional info to the request
// this will return in response delegate
@property (nonatomic, retain) NSDictionary *userInfo;

//Note: This method use for other than app servers url
- (id) initWithThirdPartyServer; 

// This method will send the async Post call
- (void)perfromAsyncPostRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params;
// This method will send the async PUT call
- (void)perfromAsyncPutRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params;
// This method will send the async GET call
- (void)perfromAsyncGetRequestWithURL:(NSString*)uri;
// This method will send the sync Get call with params
- (void)perfromAsyncGetRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params;

// This method will send the sync Post call
- (void)perfromSyncPostRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params;
// This method will send the put Put call
- (void)perfromSyncPutRequestWithURL:(NSString*)uri withParams:(NSDictionary*)params;
// This method will send the sync Get call
- (void)perfromSyncGetRequestWithURL:(NSString*)uri;
// This method will send the request with params send by caller convert into json object 
// decide whether the call should be sync or async

- (void) sendRequestWithURL:(NSString*)uri WithParams:(NSDictionary*)params withHTTPMethod:(NSString*)httpMethod withLoadSynchronous:(BOOL)isLoadSynchronously;

@end


@protocol RequestWrapperDelegate <NSObject>

- (void)requestWrapperDidReceiveResponse:(NSString*)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL*)requestUrl withUserInfo:(NSDictionary*)userInfo;

@end