//
//  ViewActivity.m
//  Suvi
//
//  Created by Vivek Rajput on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewActivity.h"

@implementation ViewActivity
@synthesize iAdminID;
@synthesize TagLine;

@synthesize admin_fname,admin_lname,feedDate,iActivityID,imageHeight,imageWidth,imgURL,imgURLPOST,tsInsertDt,labelHeight,vActivityText,vType_of_content;

@synthesize Status;

@synthesize dcLatitude,dcLongitude;
@synthesize unixTimeStamp;
@synthesize vIamAt,vIamAt2;
@synthesize vImWithflname,vLikersIDs_count,vUnlikersIDs_count,canLike,canUnLike,hasCommented;

@synthesize postOwner_fname,postOwner_lname;

@synthesize image_NotiOwner;
@synthesize Comment_counts;

//Music Image
@synthesize music_img,strAlbumTitle;

//For Wrote
@synthesize generalText,wroteBy_id,wrotedOn_image_path,wrotedOn_Name,wroteOn_School,wroteOn_hasFriends;

//For BirthDay
@synthesize birthdaywishOn_hasFriends,birthdaywishOn_School,birthdaywishdOn_image_path,birthdaywishdOn_Name;

//Youtube Video ID
@synthesize strYouTubeTitle,strYouTubeId;

//Now Friends
@synthesize iFriendsID,image_path_iFriendsID,fullname_iFriendsID,image_path_iAdminID,fname_iAdminID,lname_iAdminID,hasNoOfFriends_iFriendsID,school_iFriendsID;

//Profile Update
@synthesize strOldProfilePic;

//Badge
@synthesize badge_friends;
@end
