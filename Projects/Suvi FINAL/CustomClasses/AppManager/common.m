//
//  common.m
//  Suvi
//
//  Created by Vivek Rajput on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "common.h"
#import "Constants.h"

@implementation common

NSString *kFourSquareClientID = @"PUEV5YPUUBW11RSR1CMKLLYZT5TMXZRL0AC2W1P3WA2RJPJS";
NSString *kFourSquareClientSecret = @"3CWKTTMFNWD3W0KJRLTEWHXFN2IMSX5YIC0D040CNJMZ1WVQ";
NSString *kFourSquareCallbackURL = @"fsqdemo://foursquare";
NSString *kFourSquareAccessToken = @"IE2B0Q4HUMI3JSAQZQUMHY5FREH53RFRTU2L3IUSTOHJC3NZ";

NSString *kFacebookApp_ID = @"174508596025622";
NSString *kFacebookApp_Secret = @"8c2d22f26654b2c21275c12b63fb6e82";
NSString *kFacebookPermissions = @"publish_stream,offline_access,user_checkins,read_stream,email,publish_checkins,user_photos,user_videos,friends_checkins,publish_actions";

NSString *kAppStoreURL = @"https://itunes.apple.com/us/app/suvi.me/id584676549?ls=1&mt=8";

NSString *kAuthoriseUnauthoriseSocialNw = WebURL @"index.php?c=admin";

NSString *kCoverImageUpdateURL = WebURL @"index.php?c=updates&func=updateCoverPage";
NSString *kCoverImageRemoveURL = WebURL @"index.php?c=admin&func=removeCoverPic";
NSString *kProfileImageUpdateURL = WebURL @"index.php?c=updates&func=updateProfilePic";
NSString *kProfileImageUpdateFirstTimeURL = WebURL @"index.php?c=updates&func=updateProfilePicFirst";
NSString *kProfileImageRemoveURL = WebURL @"index.php?c=admin&func=removeProfilePic";

NSString *kChangePasswordURL = WebURL @"index.php?c=admin&func=changePassword";
NSString *kTermsOfUsePageURL = WebURL @"index.php?c=content&func=termsPage";
NSString *kPrivacyPolicy = WebURL @"index.php?c=content&func=privacyPage";
NSString *kPrivacyPolicyCombined = WebURL @"index.php?c=content&func=getBothPage";
//Friends
NSString *kFriendPageWithFullDetailsURL = WebURL @"index.php?c=feeds&func=friendPage";
NSString *kAcceptFriendRequestURL = WebURL @"index.php?c=feeds&func=accptMultiFriendReq";
NSString *kRejectFriendRequestURL = WebURL @"index.php?c=admin&func=rejectMultiFriendReq";

NSString *kSearchUsersURL = WebURL @"index.php?c=admin&func=findFriend";
NSString *kSendFriendRequestURL = WebURL @"index.php?c=admin&func=sendFrinedReq";
NSString *kSendInviteViaEmailURL= WebURL @"index.php?c=admin&func=sendInvitation";

NSString *strRegistration = WebURL @"index.php?c=admin&func=add";
NSString *strLogin = WebURL @"index.php?c=login";
NSString *dateofbirth=@"";

//http://suvi.me/suvi/ws/index.php?c=login
//My Feeds
NSString *strgetMyFeeds = WebURL @"index.php?c=feeds&func=frontPage";
NSString *strgetFriendFeeds = WebURL @"index.php?c=feeds&func=frontPageOfFriend";

//ALL Feeds with Friends
NSString *getFeedsALL = WebURL @"index.php?c=feeds&func=frontPageWithFrndsDetails";


//Image Choose For Post
NSString *strPostSuccessful = @"";
NSString *strPostPhoto = WebURL @"index.php?c=version3&func=addActivity";
NSString *strPostFeatured = WebURL @"index.php?c=callback&func=postfeatured";

//Get Friends
NSString *getFriends = WebURL @"index.php?c=admin&func=friendcanBeAdded";
NSString *getFriendList = WebURL @"index.php?c=admin&func=getFriendList";
NSString *removeFriend = WebURL @"index.php?c=admin&func=unFriend";

//Friend Full Package
NSString *strAllFriends = WebURL @"index.php?c=feeds&func=friendPage";

//Winked
NSString *strWinked = WebURL @"index.php?c=feeds&func=winked";

//Post On Wall
NSString *strPostonwall = WebURL @"index.php?c=feeds&func=writeOnwall";

//POST
NSString *strPOST = WebURL @"index.php?c=version3&func=addActivity";
NSString *strMusicPOST = WebURL @"index.php?c=version3&func=addActivity";

//Video Post
NSString *strPostVideo = WebURL @"index.php?c=version3&func=addActivity";


NSString *kYouTubeURL = WebURL @"index.php?c=version3&func=addVideos";

//View All Comments
NSString *strViewAllComments = WebURL @"index.php?c=comment&func=listCommentByPostID";
NSString *strGETAllCommentsWithAllData = WebURL @"index.php?c=feeds&func=fullActivity";

NSString *strSetPrivacy = WebURL @"index.php?c=admin&func=changePrivacySettings";
NSString *strEditProfile = WebURL @"index.php?c=updates&func=edit";
NSString *strLocationFetchURL = WebURL @"index.php?c=admin&func=allLocationsFromDB";

NSString *strChangeUserStatus = WebURL @"index.php?c=admin&func=changeUserStatus";
NSString *strForgetPassword = WebURL @"index.php?c=forgot_pass&func=check";

//Like - UnLike
NSString *strLikeFeed = WebURL @"index.php?c=activity2&func=likePost";
NSString *strUNLikeFeed = WebURL @"index.php?c=activity2&func=unLikePost";

NSString *strSetCustomStatus = WebURL @"index.php?c=version3&func=customStatus";

//Add Comment
NSString *strAddComment = WebURL @"index.php?c=comment&func=addComment";

//Delete Post
NSString *strDeletePost = WebURL @"index.php?c=activity&func=deleteActivity";

//Get Activities
NSString *strGetActivities = WebURL @"index.php?c=feeds&func=myRecentActivities";
//MY Activities
NSString *strMYActivities = WebURL @"index.php?c=admin&func=myRecentActivitiesMee";

//Sign Out
NSString *strSignOut = WebURL @"index.php?c=logout";

//UpdateTokenFor Noti
NSString *strUpdateToken = WebURL @"index.php?c=admin&func=addForDeviceTokken";

//Random User Refresh
NSString *strRandomUserRefresh = WebURL @"index.php?c=feeds&func=randomUsers";

//Suggested User Refresh
NSString *strSuggestedUserRefresh = WebURL @"index.php?c=feeds&func=suggestedUsers";

@end

