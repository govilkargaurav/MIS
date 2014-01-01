//
//  FLImage.m
//  HuntingApp
//
//  Created by Habib Ali on 8/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "FLImage.h"
#import "UIImage+Scale.h"

@implementation FLImage

static FLImage *singletonInstance = nil;

+ (FLImage *)sharedInstance {
    
    if (singletonInstance == nil) {
        
        singletonInstance = [[super allocWithZone:NULL] init];
    }
    return singletonInstance;
}

-(id) init {
    
    self = [super init];
    if (self ) {
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;    
}

- (id)retain {
    
    return self;
}

- (NSUInteger)retainCount {
    
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}


- (void)dealloc {
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
    
    RELEASE_SAFELY(_request);
    
    [super dealloc];
    
}

- (UIImage *)setImageWithImageID:(NSString *)imgID withSize:(CGSize)size
{
    UIImage *image = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@=%@",KIMAGE_LOAD_URL,KWEB_SERVICE_IMAGE_ID,imgID];
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
    RELEASE_SAFELY(_request);
    
    NSURL *iamgeUrl = [NSURL URLWithString:url];
    _request = [[ASIHTTPRequest requestWithURL:iamgeUrl] retain];
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setDelegate:self];
    [_request startSynchronous];
    DLog(@"%d",_request.responseStatusCode);
    NSData *responseData = [_request responseData];
    if (responseData && [_request responseStatusCode]==200)
    {
        image = [UIImage imageWithData:responseData];
        if (size.width>0 && size.height>0)
            image = [image scaleToSize:size];
    }
    return image;
}

- (UIImage *)setImageWithUserID:(NSString *)userID
{
    UIImage *image = nil;
    NSString *url = [NSString stringWithFormat:@"%@%@=%@",KIMAGE_LOAD_URL,KWEB_SERVICE_USERID,userID];
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
    RELEASE_SAFELY(_request);
    
    NSURL *iamgeUrl = [NSURL URLWithString:url];
    _request = [[ASIHTTPRequest requestWithURL:iamgeUrl] retain];
    [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setDelegate:self];
    [_request startSynchronous];
    DLog(@"%d",_request.responseStatusCode);
    NSData *responseData = [_request responseData];
    if (responseData && [_request responseStatusCode]==200)
    {
        image = [UIImage imageWithData:responseData];
    }
    return image;

}

@end

