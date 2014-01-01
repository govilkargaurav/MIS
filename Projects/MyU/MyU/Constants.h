//
//  Constants.h
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#include "UIView+Utilities.h"
#include "NSAttributedString+Extension.h"
#include "NSString+Utilities.h"
#include "GRAlertView.h"
#include "WCAlertView.h"
#include "WSManager.h"
#include "DBManager.h"
#include "MyAppManager.h"
#include "UIImageView+WebCache.h"
#include "MTStatusBarOverlay.h"

#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"

/*
 
com.openxcell.testing007
 
 
com.openxcell.demo
com.openxcell.test7
  com.openxcell.test34
 
 apple@gl.com
 
 apple@bl.com
 
 
 
 */


NSInteger selectedMenuIndex;
NSInteger unread_notificationcount;
NSInteger group_maxinvite;
NSMutableDictionary *dictHome;
NSMutableArray *arrHome;
NSMutableArray *arrHomeModel;
NSMutableDictionary *dictNews;
NSMutableArray *arrNews;
NSMutableArray *arrNewsModel;
NSMutableArray *arrJoinedGroups;
NSMutableArray *arrUnJoinedGroups;
NSMutableArray *arrPosts;
NSMutableArray *arrUserNewsModel;

NSMutableDictionary *dictGroups;
NSMutableString *strSubscribedUni;
NSMutableArray *arrProfessors;
NSMutableArray *arrProfessorRatings;
NSMutableDictionary *dictProfessorRatings;
NSMutableArray *arrAppUsers;
NSMutableString *strRules;

NSMutableDictionary *dictImages;


BOOL isSubscribedUniChanged;
BOOL canPostNews;
BOOL shouldImageBeShared;
BOOL isAppInGuestMode;
BOOL shouldInviteToSignUp;
BOOL shouldUpdateGroupSettings;
BOOL shouldBackToRoot;
BOOL shouldBackToChat;

NSMutableDictionary *dictGuestModeUni;
NSMutableArray *arrNotifications;

NSString *strUserId;
NSString *strUserUniId;
NSString *strUserProfilePic;

NSMutableDictionary *dictUserInfo;
NSMutableDictionary *dictUpdatedGroupSettings;

NSInteger activitycount;

#define kSIDEOFFSETVALUE_RIGHT 70.0f
#define kSIDEOFFSETVALUE_LEFT 70.0f

#define kSIDEBARCOLOR [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0]
#define kSIDEBAR_HCOLOR [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]

#define kFONT_HOMECELL [UIFont fontWithName:@"Helvetica" size:13.5]

#define kAppName @"MyU"
#define kGuestPrompt @"Ops! you must register before doing that"

#define IS_DEVICE_iPHONE_5 ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen ] bounds].size.height>=568.0f))
#define iPhone5ExHeight ((IS_DEVICE_iPHONE_5)?88:0)
#define iPhone5ExHalfHeight ((IS_DEVICE_iPHONE_5)?44:0)
#define iPhone5ImageSuffix (IS_DEVICE_iPHONE_5)?@"-i5":@""
#define iOS7 (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20:0)
#define iOS7ExHeight (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?20:0)
#define IS_iOS_Version_7 (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?YES:NO)

#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }
//#define kGRAlert(msg) { GRAlertView* alertView = [[GRAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

#define DisplayAlertWithTitle(title,msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; }

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/256.0f green:(g)/256.0f blue:(b)/256.0f alpha:1.0f]

#define kCustomGRBLColor [UIColor colorWithRed:58.0/256.0f green:156.0/256.0f blue:178.0/256.0f alpha:1.0f]
#define kCustomGRBLDarkColor [UIColor colorWithRed:37.0/256.0f green:106.0/256.0f blue:115.0/256.0f alpha:1.0f]
#define kCustomGRBLDarkAlphaColor [UIColor colorWithRed:37.0/256.0f green:106.0/256.0f blue:115.0/256.0f alpha:0.7f]
//#define kCustomGRBLColor [UIColor colorWithRed:(r)/256.0f green:(g)/256.0f blue:(b)/256.0f alpha:1.0f]

#define kGRAlert(msg) {[WCAlertView showAlertWithTitle:nil message:msg customizationBlock:^(WCAlertView *alertView) { alertView.style = WCAlertViewStyleViolet; } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) { } cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];}
//548299851919550
//App Secret: 	f1f38e8f2c2fe1e1102d6ad5c93fec3d(reset)
#define kFacebookAppID @"548299851919550"
#define kUniversityNotLoadedAlert @"Please wait until university-list syncs with server."
#define kFacebookPermissions @"publish_stream,offline_access,user_checkins,read_stream,email,publish_checkins,user_photos,user_videos,friends_checkins,publish_actions,user_about_me,user_birthday"
#define kBaseURL @"http://www.myu.co/ws/"

#pragma mark - LOGIN SECTION
/************************REGISTRATION****************************/

#define kLoginURL kBaseURL@"index.php?c=user&func=login"
#define kSignUpURL kBaseURL@"index.php?c=user&func=register"
#define kSignOutURL kBaseURL@"index.php?c=user&func=logout"
//&userid=71
#define kForgetPassURL kBaseURL@"index.php?c=user&func=forgotpassword"
#define kResendURL kBaseURL@"index.php?c=user&func=resendactivationlink"

#define kUpdateBadgeNotificationURL kBaseURL@"index.php?c=notification1&func=update_notification_read_status"
//&notification_id=10&user_id=103
#define kBadgeNotificationURL kBaseURL@"index.php?c=notification1&func=get_total_count"
//&user_id=103
#define kUpdateChatNotificationURL kBaseURL@"index.php?c=message&func=private_update_count"

#define kNotifyUpdateNotificationBadge @"kNotifyUpdateNotificationBadge"
#define kNotifyUpdateData @"kNotifyUpdateData"
#pragma mark - UNIVERSITY SECTION
/************************UNIVERSITY****************************/

#define kLoadUniversityURL kBaseURL@"index.php?c=university&func=universitylist"
#define kAddUniversityURL kBaseURL@"index.php?c=university&func=adduniversity"
#define kSubscribeUniURL kBaseURL@"index.php?c=university&func=updateuniversitylist"
//&user_id=3&uni_list=9,10,11,18


#pragma mark - BLOG SECTION
/************************BLOG SECTION****************************/

#define kBlogLatestURL kBaseURL@"index.php?c=blog&func=postslatest"
//&user_id=3

#define kBlogViewMoreURL kBaseURL@"index.php?c=blog&func=viewmore"
//&user_id=3&timestamp=1374900637

#define kBlogRefreshURL kBaseURL@"index.php?c=blog&func=refresh"
//&user_id=3&timestamp=1375178921&oldtimestamp=1374149778

#define kBlogLikeURL kBaseURL@"index.php?c=blog&func=likeblog"
//&blog_id=8&user_id=7

#define kBlogDisLikeURL kBaseURL@"index.php?c=blog&func=unlikeblog"
//&blog_id=8&user_id=7

#define kBlogLikeFullURL kBaseURL@"index.php?c=blog&func=likeblog1"
//&blog_id=8&user_id=7

#define kBlogDisLikeFullURL kBaseURL@"index.php?c=blog&func=unlikeblog1"
//&blog_id=8&user_id=7

#define kBlogReadCountURL kBaseURL@"index.php?c=blog&func=updatereadcount"
//&blog_id=8&user_id=7

#define kBlogAllCommentsURL kBaseURL@"index.php?c=blog&func=getAllComments"
//&blog_id=7&user_id=3

#define kBlogAddCommentURL kBaseURL@"index.php?c=blog&func=addcomment"
//&blog_id=8&user_id=19&comment=Comment

#pragma mark - NEWS SECTION
/************************NEWS SECTION****************************/

#define kNewsLatestURL kBaseURL@"index.php?c=news&func=postslatest"
//&user_id=3&uni_list=10,12
#define kNewsViewMoreURL kBaseURL@"index.php?c=news&func=viewmore"
//&user_id=3&timestamp=1374900637

#define kNewsRefreshURL kBaseURL@"index.php?c=news&func=refresh"
//&user_id=3&timestamp=1375178921&oldtimestamp=1374149778

#define kNewsLikeURL kBaseURL@"index.php?c=news&func=likenews"
//&news_id=8&user_id=7

#define kNewsDisLikeURL kBaseURL@"index.php?c=news&func=unlikenews"
//&news_id=8&user_id=7

#define kNewsLikeFullURL kBaseURL@"index.php?c=news&func=likenews1"
//&news_id=8&user_id=7

#define kNewsDisLikeFullURL kBaseURL@"index.php?c=news&func=unlikenews1"
//&news_id=8&user_id=7

#define kNewsReadCountURL kBaseURL@"index.php?c=news&func=updatereadcount"
//&news_id=8&user_id=7

#define kNewsAllCommentsURL kBaseURL@"index.php?c=news&func=getAllComments"
//&news_id=7&user_id=3

#define kNewsAddCommentURL kBaseURL@"index.php?c=news&func=addcomment"
//&news_id=8&user_id=19&comment=Comment

#define kNewsAddPostURL kBaseURL@"index.php?c=news&func=addnews"
//&uni_id=12&user_id=1&news_description=description%20goes%20here
//news_image

#define kNewsDeleteURL kBaseURL@"index.php?c=news&func=removenews"
//&news_id=13

#pragma mark - GROUP SECTION
/*******************************GROUP SECTION***************************************/

#define kGroupListAll kBaseURL@"index.php?c=group&func=getallgroups"
//&user_id=73

#define kGroupJoin kBaseURL@"index.php?c=group&func=joingroup"
//&user_id=1&group_id=3

#define kGroupRemoveRequest kBaseURL@"index.php?c=group&func=removerequest"
//&user_id=1&group_id=3

#define kAddGroupURL kBaseURL@"index.php?c=group&func=creategroup"
//&user_id=3&uni_id=10&group_name=mygroup

#define kGetAllUsers kBaseURL@"index.php?c=user&func=getallusers"
//&user_id=1

#define joinGroupRequestURL kBaseURL @"index.php?c=group&func=joingroup1"
#define IgnoreGroupRequestURL kBaseURL @"index.php?c=group&func=ignoregroup"

/*******************************CHAT SECTION***************************************/
#define kChatGetLatest kBaseURL@"index.php?c=group&func=latestchat"
//&group_id=6

#define kChatViewMore kBaseURL@"index.php?c=group&func=viewmore"
//&group_id=6&oldest_timestamp=1375960083

#define kChatRefresh kBaseURL@"index.php?c=group&func=refresh"
//&group_id=6&latest_timestamp=1375961796

#define kChatAdd kBaseURL@"index.php?c=group&func=addchat"
//&user_id=76&group_id=6&chat_text=good%20evening&chat_image=imagedata
#define USER_ID @"user_id"
#define group_id @"group_id"
#define chat_text @"chat_text"

/*******************************RATING SECTION***************************************/
#define kRatingListURL kBaseURL@"index.php?c=rating&func=professorlist"

#define kRatingAddProffesorURL kBaseURL@"index.php?c=rating&func=addprofessor"
//&user_id=1&professor_name=Frank&university_id=25&professor_email=professor@example.com

#define kRatingAddRatingURL kBaseURL@"index.php?c=rating&func=addrating"
//&user_id=1&professor_id=415&easy_rating=3&explain_rating=3
//&interest_rating=2&available_rating=3&course_name=toc&year=2008&user_comment=Comment%20goes%20here

#define kRatingViewAllURL kBaseURL@"index.php?c=rating&func=getprofessorratings"
//&professor_id=415&user_id=1

#define kRatingLikeURL kBaseURL@"index.php?c=rating&func=likerating"
//&rating_id=7&user_id=1

#define kRatingDisLikeURL kBaseURL@"index.php?c=rating&func=unlikerating"
//&rating_id=7&user_id=1

#define kRatingReportURL kBaseURL@"index.php?c=rating&func=reportrating"
//&rating_id=7&user_id=1
//&professor_id=415&rated_by=3


#define kSMGroupUpdates kBaseURL@"index.php?c=notification1&func=getgroupupdates"
//&userid=1

#define kSMNotifications kBaseURL@"index.php?c=notification1&func=getAllNotification"
//&user_id=80

#define kSMPrivateMessages kBaseURL@"index.php?c=notification1&func=getprivatemessageupdates"
//&userid=1

#define kRulesURL kBaseURL@"index.php?c=content&func=rulesPage"

#define kRatingRemoveURL kBaseURL@"index.php?c=rating&func=removerating"
//&rating_id=1

#pragma mark - CONTENT SECTION
/************************REGISTRATION****************************/

#define kAboutUsURL kBaseURL@"index.php?c=content&func=aboutPage"
#define kTermsURL kBaseURL@"index.php?c=content&func=termsPage"
#define kPrivacyURL kBaseURL@"index.php?c=content&func=privacyPage"
#define kFacebookURL @"http://www.facebook.com"


#pragma mark - SETTINGS
/************************SETTINGS****************************/
#define kUpdateSettingsURL kBaseURL@"index.php?c=notification1&func=updatesettings"
//&user_id=1&notifications=0&group_messages=0&private_messages=0

#define kViewProfileURL kBaseURL@"index.php?c=user&func=View_Profile"
#define keyFORUserProfileResponse @"User_data"
#define keyFORUserNewsFeeds @"News"

//&id=3
//http://openxcellaus.info/myu/ws/index.php?c=user&func=view_profile&user_id=103


#define kChangePasswordURL kBaseURL@"index.php?c=user&func=changepassword"
//&user_id=103&old_password=123456&new_password=123

#define kChangeProfilePicURL kBaseURL@"index.php?c=user&func=edit_profile_pic"
//profile_pic

#define kUpdateProfileURL kBaseURL@"index.php?c=user&func=Edit_Profile"
//&id=76&name=abc&university=25&uni_name=abc&department=ComputerScience&bio=Biogoeshere&phone_number=1234&gender=Male&birthday=1999-07-01
#define kUpdateGroupInfoURL kBaseURL@"index.php?c=group&func=updategroupinfo"

#define kLeaveGroupURL kBaseURL@"index.php?c=group&func=leavegroupbyadmin"

#define kInviteUserToGroupURL kBaseURL@"index.php?c=group&func=sendgroupinvite"

#define kLeaveGroupOnlyYouURL kBaseURL@"index.php?c=group&func=leavegroup"
/* SET XMPP CONSTANT */

#define HOST_NAME @"54.229.113.185"
#define DOMAIN_NAME @"@ip-172-31-42-152"
#define GROUP_CHAT_DOMAIN @"@conference.ip-172-31-42-152"
#define ACCEPT_GROUP_INVITATION_REQUEST kBaseURL@"index.php?c=group&func=joingroup1"
#define UPLOAD_CHAT_IMAGE kBaseURL@"index.php?c=uploadimage"
#define FIRE_NOTI_FROM_RIGHT_SIDE @"Firenotifromrightside"
#define CLOSE_NOTI_FROM_RIGHT_SIDE @"CLOSEnotifromrightside"

/* Search users */

#define SEARCH_USER kBaseURL @"index.php?c=user&func=search_users"
#define SEARCH_USER_CHAR @"search_term"
#define SEARCH_RESULT @"search_results"



/* GET ALL OLD ONE TO ONE CHAT */

#define GET_ONE_to_ONE_CHAT kBaseURL @"index.php?c=message&func=view_conversation"
#define SELF_ID_KEY @"sender_id"
#define FRIEND_ID_KEY @"user_id"
#define RECIEVER_ID_KEY @"receiver_id"
#define MESSAGE_KEY @"message"

/* Send one to one Messege */

#define SEND_ONE_TO_ONE_MES kBaseURL @"index.php?c=message&func=SendMsg"

/* Get All User's Name, User_ID, Profile_pic */

#define GET_ALL_USER_LIST_FROM_GROUP kBaseURL @"index.php?c=group&func=getuser_list"

/* POST OLD TIMESTAMP */

#define POST_OLD_TIMESTAMP kBaseURL @"index.php?c=group&func=updateTime"
//group_id=&user_id=
//&group_id=8&user_id=103

/* VIEW ALL MEDIA */
#define VIEW_ALL_MEDIA kBaseURL @"index.php?c=group&func=getAllMedia"
//&group_id=1

/* GET OLD CHAT WIHOUT TIMESTAMP FOR FIRSTTIME */

#define GET_ALL_OLD_CHATS_WITHOUT_TIMESTAMP kBaseURL @"index.php?c=group&func=latestchat"
//&group_id=9&user_id=142
//http://www.openxcellaus.info/myu/ws/index.php?c=group&func=latestchat&group_id=9&user_id=142




