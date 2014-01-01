//
//  GetImageInfo.h
//  HuntingApp
//
//  Created by Habib Ali on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetImageInfoDelegate <NSObject>

- (void) getImageInfoRequestCompleted:(id)getImageInfoClass;

@end

@interface GetImageInfo : NSObject<RequestWrapperDelegate>
{
    WebServices *getImageRequest;
    Picture *pic;
}
@property (retain, nonatomic) id<GetImageInfoDelegate> delegate;

- (void)getImageInfo:(Picture *)picture;

@end
