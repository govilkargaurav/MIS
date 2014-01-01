//
//  GetImageInfo.m
//  HuntingApp
//
//  Created by Habib Ali on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetImageInfo.h"

@implementation GetImageInfo

@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void)dealloc
{
    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    RELEASE_SAFELY(pic);
    [super dealloc];
}

-(void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE]) 
    {
        if(getImageRequest)
        {
            getImageRequest.delegate = nil;
            RELEASE_SAFELY(getImageRequest);
        }
        if ([[jsonDict objectForKey:@"data"] count]>0)
        {
            NSDictionary *imgInfo = [[[jsonDict objectForKey:@"data"] objectAtIndex:0]objectForKey:@"data"];
            if (pic)
            {
                NSString *ID = pic.pic_id;
                NSString *caption = [imgInfo objectForKey:KWEB_SERVICE_IMAGE_TITLE];
                NSNumber *likes_count = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]];
                Picture *picture = [[DAL sharedInstance] getImageByImageID:ID];
                [picture setCaption:caption];
                [picture setLikes_count:likes_count];
                [[DAL sharedInstance] saveContext];
                RELEASE_SAFELY(pic);
                if (delegate && [delegate respondsToSelector:@selector(getImageInfoRequestCompleted:)])
                {
                    [delegate getImageInfoRequestCompleted:self];
                }
            }
        }
        else if (![jsonDict objectForKey:@"data"])
        {
            [Utility showServerError];
        }
    }

}

-(void)getImageInfo:(Picture *)picture
{
    pic = [picture retain];
    if (getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    getImageRequest = [[WebServices alloc]init];
    getImageRequest.delegate = self;
    [getImageRequest getImage:[[picture.image_url componentsSeparatedByString:@"="]lastObject] ofUser:[Utility userID]];
    
}

@end
