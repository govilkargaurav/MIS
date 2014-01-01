//
//  FLImageView.h
//  GameZebo
//
//  Created by Muhammad Asif Kamboh on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
/**
 @class FLImageView
 @inherits UIImageView
 @conforms ASIHTTPRequestDelegate
 @description This class will facilitate to cache the images downloaded from the url
 */
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@protocol FLImageViewDelegate <NSObject>

- (void)imageDidLoad:(UIImage *)img;

@end

@interface FLImageView : UIImageView <ASIHTTPRequestDelegate> 
{
    ASIHTTPRequest *_request;
    UIImage *image;
    Picture *picture;
    Profile *profile;
}

@property (nonatomic, retain) id<FLImageViewDelegate> delegate;

- (void)setImageWithImageID:(NSString *)imgID;

/**
 @method        setImageWithUrl
 @description   get cached image from the url. the url request sets the image in the image view after request completion
 @param         string URL
 @returns       nil
 */
- (void)setImageWithUrl:(NSString *)uri;

- (void)setImageWithProfile:(Profile *)profile;

- (void)setImageWithImage:(Picture *)picture;

/**
 @method        imageDidLoad
 @description   called after request completion
 @param         nil
 @returns       nil
 */
- (void)imageDidLoad;

/**
 @method        viewForError
 @description   sets the error view if image request is not loaded coz of error
 @param         NSError error
 @returns       nil
 */
- (void)viewForError:(NSError*)error;

/**
 @method        titleForError
 @description   returns error description
 @param         NSError error
 @returns       error description
 */
- (NSString*)titleForError:(NSError*)error;

@end
