//
//  ViewActivity.h
//  Suvi
//
//  Created by Vivek Rajput on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewActivity : NSObject

@property(nonatomic,copy)NSString *iAdminID;
@property(nonatomic,copy)NSString *iActivityID;

@property(nonatomic,copy)NSString *admin_fname;
@property(nonatomic,copy)NSString *admin_lname;

@property(nonatomic,copy)NSString *tsInsertDt;
@property(nonatomic,copy)NSString *imgURL;
@property(nonatomic,copy)NSString *imgURLPOST;
@property(nonatomic,copy)NSString *image_NotiOwner;
@property(nonatomic,copy)NSString *vIamAt;
@property(nonatomic,copy)NSString *vIamAt2;
@property(nonatomic,copy)NSString *vLikersIDs_count;
@property(nonatomic,copy)NSString *vUnlikersIDs_count;
@property(nonatomic,copy)NSString *vImWithflname;
@property(nonatomic,copy)NSString *canLike,*hasCommented;
@property(nonatomic,copy)NSString *canUnLike;
@property(nonatomic,copy)NSString *Comment_counts;

@property(nonatomic,retain)NSDate *feedDate;

@property(nonatomic,copy)NSString *TagLine;
@property(nonatomic,copy)NSString *Status;
@property(nonatomic,copy)NSString *vActivityText;
@property(nonatomic,copy)NSNumber *labelHeight;

@property(nonatomic,copy)NSNumber *imageHeight;
@property(nonatomic,copy)NSNumber *imageWidth;

@property(nonatomic,copy)NSString *vType_of_content;

@property(nonatomic,copy)NSString *dcLatitude;
@property(nonatomic,copy)NSString *dcLongitude;

@property(nonatomic,copy)NSString *unixTimeStamp;

@property(nonatomic,copy)NSString *postOwner_fname;
@property(nonatomic,copy)NSString *postOwner_lname;

//Music Image
@property(nonatomic,copy)NSString *music_img;
@property(nonatomic,copy)NSString *strAlbumTitle;

//For Wrote Note
@property(nonatomic,copy)NSString *generalText;
@property(nonatomic,copy)NSString *wroteBy_id;
@property(nonatomic,copy)NSString *wrotedOn_Name;
@property(nonatomic,copy)NSString *wrotedOn_image_path;
@property(nonatomic,copy)NSString *wroteOn_School;
@property(nonatomic,copy)NSString *wroteOn_hasFriends;

//For Birthday Wish
@property(nonatomic,copy)NSString *birthdaywishdOn_Name;
@property(nonatomic,copy)NSString *birthdaywishdOn_image_path;
@property(nonatomic,copy)NSString *birthdaywishOn_School;
@property(nonatomic,copy)NSString *birthdaywishOn_hasFriends;

//Youtube Video ID
@property(nonatomic,copy)NSString *strYouTubeTitle;
@property(nonatomic,copy)NSString *strYouTubeId;

//Now Friends
@property(nonatomic,copy)NSString *image_path_iFriendsID;
@property(nonatomic,copy)NSString *iFriendsID;
@property(nonatomic,copy)NSString *fullname_iFriendsID;
@property(nonatomic,copy)NSString *image_path_iAdminID;
@property(nonatomic,copy)NSString *fname_iAdminID;

@property(nonatomic,copy)NSString *lname_iAdminID;
@property(nonatomic,copy)NSString *hasNoOfFriends_iFriendsID;
@property(nonatomic,copy)NSString *school_iFriendsID;

//ProfileUpdate
@property(nonatomic,copy)NSString *strOldProfilePic;

//Badge
@property(nonatomic,readwrite) NSInteger badge_friends;
@end
