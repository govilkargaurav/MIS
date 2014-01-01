//
//  WebServices.h
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestWrapper.h"


@interface WebServices : NSObject<RequestWrapperDelegate>
{
    RequestWrapper *requestWrapper;
    
}

@property (nonatomic, assign)id<RequestWrapperDelegate>delegate;
@property (nonatomic, retain) NSString *tagAction;

+ (NSDictionary *)parseJSONString:(NSString *)responseString;
- (BOOL)isNetAvailable;
- (void)showNetworkError;
- (void) perfromAsyncPostRequestWithURL:(NSString *)url withParams:(NSDictionary *)dict;
- (void) perfromSyncPostRequestWithURL:(NSString *)url withParams:(NSDictionary *)dict;
@end
