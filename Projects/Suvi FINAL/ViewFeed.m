//
//  ViewFeed.m
//  Suvi
//
//  Created by Vivek Rajput on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFeed.h"

@implementation ViewFeed
@synthesize iActivityID,iAdminID,vLikersIDs_count,vUnlikersIDs_count,Total_like_unlikes,tsInsertDt,tsLastUpdateDt,vActivityText,vType_of_content,strAlbumTitle,badge_friends,strOldProfilePic,wroteOn_id,dateSort;

@synthesize vImWithflname;
@synthesize feedDate;
@synthesize Comment_counts;
@synthesize imgURL;
@synthesize labelHeight;
@synthesize imageHeight,imageWidth;
@synthesize imgURLPOST;
@synthesize vIamAt;
@synthesize vIamAt2;
@synthesize imagePost;
@synthesize imageIndex;
@synthesize iScore;
@synthesize canLike,hasCommented;
@synthesize canUnLike;
@synthesize dcLatitude,dcLongitude;
@synthesize unixTimeStamp;

@synthesize strAttributed,ht_attributed;
@synthesize admin_fname,admin_lname,isUserPrivate;
@synthesize strYouTubeId;
@synthesize strYouTubeTitle;

//For Wrote
@synthesize generalText,wroteBy_id,wrotedOn_image_path,wrotedOn_Name,wroteOn_School,wroteOn_hasFriends;

@synthesize birthdaywishdOn_image_path,birthdaywishdOn_Name,birthdaywishOn_hasFriends,birthdaywishOn_School;

//Now Friends
@synthesize iFriendsID,image_path_iFriendsID,fullname_iFriendsID,hasNoOfFriends_iFriendsID,school_iFriendsID;

@synthesize isLocal;

@end
