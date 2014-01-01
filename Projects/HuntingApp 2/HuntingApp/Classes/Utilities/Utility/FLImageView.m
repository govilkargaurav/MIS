//
//  FLImageView.m
//  GameZebo
//
//  Created by Muhammad Asif Kamboh on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FLImageView.h"

@implementation FLImageView

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    // Cancels an asynchronous request
    [_request cancel];
    // Cancels an asynchronous request, clearing all delegates and blocks first
    [_request clearDelegatesAndCancel];
    delegate = nil;
    RELEASE_SAFELY(_request);
    RELEASE_SAFELY(image);
    [super dealloc];

}

- (void)setImageWithImageID:(NSString *)ID
{
    NSString *url = [NSString stringWithFormat:@"%@%@",KIMAGE_LOAD_URL,ID];
    [self setImageWithUrl:url];
}

- (void)setImageWithUrl:(NSString *)url {
    
       
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
    [_request startAsynchronous];
   
}

- (void)setImageWithProfile:(Profile *)aprofile
{
    profile = [aprofile retain];
    [self setImageWithUrl:[Utility getProfilePicURL:profile.user_id]];
}

- (void)setImageWithImage:(Picture *)apicture
{
    picture = [apicture retain];
    [self setImageWithUrl:apicture.image_url];
}


- (void)imageDidLoad 
{
    if (profile)
    {
        [profile setPicture:(UIImagePNGRepresentation(image))];
        //[[DAL sharedInstance] saveContext];
        RELEASE_SAFELY(profile);
    }
    if (picture)
    {
        [[DAL sharedInstance] createImageMapWithPicture:picture andImage:image];
        //[picture setImage:(UIImagePNGRepresentation(image))];
        //[[DAL sharedInstance] saveContext];
        RELEASE_SAFELY(picture);
    }
    @try {
        if (delegate && [delegate retainCount]>0 && [delegate respondsToSelector:@selector(imageDidLoad:)])
        {
            [delegate performSelector:@selector(imageDidLoad:) withObject:image];
        }

    }
    @catch (NSException *exception) {
        DLog(@"Exception..... ");
    }
    @finally {
        RELEASE_SAFELY(image);
    }
        
}
//implemnt this messgae in child class
- (void)viewForError:(NSError *)error {

    [self titleForError:error];
}

//implemnt this messgae in child class
- (NSString*)titleForError:(NSError*)error {

    return [error description];
}

#pragma marka -ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    image = [[UIImage imageWithData:responseData] retain];
    //image = [image scaleToSize:self.frame.size];
    [self setImage:image];
    [self imageDidLoad];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    [self viewForError:error];
}
@end
