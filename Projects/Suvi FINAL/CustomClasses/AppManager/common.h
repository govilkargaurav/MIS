//
//  common.h
//  Suvi
//
//  Created by Vivek Rajput on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define kAppInviteText @"Don’t miss out! This is an exclusive invitation to join Suvi (free on the app store) https://itunes.apple.com/us/app/suvi.me/id584676549?ls=1&mt=8"
#define kAppInviteText @"Connect with me on Suvi, download the free app. https://itunes.apple.com/us/app/suvi.me/id584676549?ls=1&mt=8"


@interface common : NSObject
//RGB = 22,143,98


extern NSString *strRegistration;
extern NSString *strLogin;
extern NSString *dateofbirth;

//All Feedswith Friends
extern NSString *getFeedsALL;
extern NSString *strgetMyFeeds;
extern NSString *strgetFriendFeeds;

extern NSString *getFriends;
extern NSString *getFriendList;
extern NSString *removeFriend;

//Friend Full Package
extern NSString *strAllFriends;

//Winked
extern NSString *strWinked;

//Post On Wall
extern NSString *strPostonwall;

//Post
extern NSString *strPOST;
extern NSString *strMusicPOST;
//Post Photo
extern NSString *strPostSuccessful;//After Successful post photo
extern NSString *strPostPhoto;
extern NSString *strPostFeatured;
extern NSString *strPostVideo;
extern NSString *kYouTubeURL;

extern NSString *strLocationFetchURL;
extern NSString *strSetCustomStatus;

//View All Comments
extern NSString *strViewAllComments;
extern NSString *strGETAllCommentsWithAllData;
extern NSString *strSetPrivacy;
extern NSString *strEditProfile;
extern NSString *strChangeUserStatus;
extern NSString *strForgetPassword;

extern NSString *kAppStoreURL;

//Social Networks
extern NSString *kInstagramApp_ID;
extern NSString *kInstagramCallbackPrefix;

extern NSString *kFourSquareClientID;
extern NSString *kFourSquareCallbackURL;
extern NSString *kFourSquareAccessToken;

extern NSString *kFacebookApp_ID;
extern NSString *kFacebookApp_Secret;
extern NSString *kFacebookPermissions;


extern NSString *kAuthoriseUnauthoriseSocialNw;
extern NSString *kAuthoriseUnauthoriseSocialNw;
extern NSString *kCoverImageUpdateURL;
extern NSString *kCoverImageRemoveURL;
extern NSString *kProfileImageUpdateURL;
extern NSString *kProfileImageUpdateFirstTimeURL;
extern NSString *kProfileImageRemoveURL;
extern NSString *kChangePasswordURL;
extern NSString *kTermsOfUsePageURL;
extern NSString *kPrivacyPolicy;
extern NSString *kPrivacyPolicyCombined;

//Friends Page
extern NSString *kFriendPageWithFullDetailsURL;
extern NSString *kAcceptFriendRequestURL;
extern NSString *kRejectFriendRequestURL;
//Friends
extern NSString *kSearchUsersURL;
extern NSString *kSendFriendRequestURL;
extern NSString *kSendInviteViaEmailURL;

//Like - Unlike
extern NSString *strLikeFeed;
extern NSString *strUNLikeFeed;

//Add Comment
extern NSString *strAddComment;

//Delete Post
extern NSString *strDeletePost;

//Get Activities
extern NSString *strGetActivities;
//MY Activities
extern NSString *strMYActivities;

//Sign Out
extern NSString *strSignOut;

//UpdateTokenFor Noti
extern NSString *strUpdateToken;

//Random User Refresh
extern NSString *strRandomUserRefresh;

//Suggested User Refresh
extern NSString *strSuggestedUserRefresh;

@end
