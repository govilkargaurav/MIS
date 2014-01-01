//
//  DAL+Comment.h
//  HuntingApp
//
//  Created by Habib Ali on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"

@interface DAL (Comment)

- (Comment *)addCommentAndEditPictureWithParams:(NSDictionary *)params inPicture:(NSString *)picID;

- (Comment *)getCommentByID:(NSNumber *)ID;


@end
