//
//  FLImage.h
//  HuntingApp
//
//  Created by Habib Ali on 8/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface FLImage : NSObject <ASIHTTPRequestDelegate> 
{
    ASIHTTPRequest *_request;
}

/**
 @method        setImageWithUrl
 @description   get cached image from the url. the url request sets the image in the image view after request completion
 @param         string URL
 @returns       nil
 */
- (UIImage *)setImageWithImageID:(NSString *)imgID withSize:(CGSize)size;

- (UIImage *)setImageWithUserID:(NSString *)userID;

+ (FLImage *)sharedInstance;

@end
