//
//  AppConstants.h
//  HuntingApp
//
//  Created by Habib Ali on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// for color
#define UIColorFromHexString(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// for releasing pointers safely
#define RELEASE_SAFELY(__POINTER) { if(__POINTER) [__POINTER release]; __POINTER = nil; }

NSInteger logLevel;

#define kLogLevelDebug 1
#define kLogLevelInfo 2
#define kLogLevelWarn 3
#define kLogLevelError 4
#define LogMessage(LEVEL, format, ...)    \
if (LEVEL>=logLevel) {\
if ( LEVEL == kLogLevelError) DLog(@"ERROR:" format,##__VA_ARGS__); \
else if( LEVEL == kLogLevelWarn) DLog(@"WARN:" format,##__VA_ARGS__);        \
else if(LEVEL == kLogLevelInfo) DLog(@"INFO:" format,##__VA_ARGS__);        \
else if(LEVEL == kLogLevelDebug) DLog(@"DEBUG:" format,##__VA_ARGS__);}
#define LogRect(msg, someRect) LogMessage(kLogLevelDebug, @"%@: x: %f, y: %f, w: %f, h: %f, ", msg, someRect.origin.x,someRect.origin.y, someRect.size.width, someRect.size.height);
#define LogSize(msg, someSize) LogMessage(kLogLevelDebug, @"%@: w: %f, h: %f, ", msg, someSize.width, someSize.height);
#define LogPoint(msg, somePoint) LogMessage(kLogLevelDebug, @"%@: x: %f, y: %f, ", msg, somePoint.x, somePoint.y);


typedef enum {
    AccountTypeNormal = 0,
    AccountTypeFacebook,
    AccountTypeTwitter
} AccountType;


// Core data file names
extern NSString* const kCoreDataStorePath;
extern NSString* const kDefaultCDStorePath;
extern NSString* const kCDMomdFileName;

// Notifications
extern NSString* const NOTIFICATION_LOCATION_TRACKED; 
extern NSString* const NOTIFICATION_PROFILE_SAVED;
extern NSString* const NOTIFICATION_FAV_LOC_ADDED;
extern NSString* const NOTIFICATION_PROFILE_COMP_SAVED;

// Location Tracker constants
extern NSString* const COUNTRY_NAME_KEY;
extern NSString* const COUNTRY_CODE_KEY;
extern NSString* const CITY_NAME_KEY;
extern NSString* const STATE_NAME_KEY;
extern NSString* const COUNTY_NAME_KEY;

// User Defaults
extern NSString* const LOGIN_STATE;
extern NSString* const NOTIFICATION_READ;
extern NSString* const DEVICE_TOKEN;
extern NSString* const LOGIN_TOKEN;
extern NSString* const USER_TWITTER_INFO;
extern NSString* const USER_FACEBOOK_INFO;
extern NSString* const FIRST_VIEW;
extern NSString* const HAVE_SHOWN_LOC_ALERT;
extern NSString* const LOAD_PROFILE_IMAGE_FROM_SERVER;

//  web service app constants
extern NSString* const KWEB_SERVICE_FORMAT;
extern NSString* const KWEB_SERVICE_FORMAT_JSON;
extern NSString* const kServerUri;
extern NSString* const kGoogleApiUri;
extern NSString* const KIMAGE_LOAD_URL;
extern NSString* const KFILE_LOAD_URL;

//actions
extern NSString* const KWEB_SERVICE_ACTION;
extern NSString* const KWEB_SERVICE_ACTION_NEW_ACCOUNT;
extern NSString* const KWEB_SERVICE_ACTION_UPDATE_ACCOUNT;
extern NSString* const KWEB_SERVICE_ACTION_LOGIN;
extern NSString* const KWEB_SERVICE_ACTION_PROFILE;
extern NSString* const KWEB_SERVICE_ACTION_NEW_ALBUM;
extern NSString* const KWEB_SERVICE_ACTION_UPLOAD_IMAGE;
extern NSString* const KWEB_SERVICE_ACTION_VIEW_ALBUM;
extern NSString* const KWEB_SERVICE_ACTION_VIEW_IMAGE;
extern NSString* const KWEB_SERVICE_ACTION_UPDATE_ALBUM;
extern NSString* const KWEB_SERVICE_ACTION_FIND_LOCATION;
extern NSString* const KWEB_SERVICE_ACTION_SEARCH_IMAGE;
extern NSString* const KWEB_SERVICE_ACTION_FAV_LOCATION;
extern NSString* const KWEB_SERVICE_ACTION_SEARCH_FRIEND;
extern NSString* const KWEB_SERVICE_ACTION_FOLLOW_FRIEND;
extern NSString* const KWEB_SERVICE_ACTION_LIKE;
extern NSString* const KWEB_SERVICE_ACTION_COMMENT;
extern NSString* const KWEB_SERVICE_ACTION_DELETE;
extern NSString* const KWEB_SERVICE_ACTION_UNFOLLOW;
extern NSString* const KWEB_SERVICE_ACTION_UPLOAD_FILE;
extern NSString* const KWEB_SERVICE_ACTION_FORGET;
extern NSString* const KWEB_SERVICE_ACTION_NOTIFICATIONS;
extern NSString* const KWEB_SERVICE_ACTION_GET_LOCATION;

// for profile
extern NSString* const KWEB_SERVICE_NAME;
extern NSString* const KWEB_SERVICE_EMAIL;
extern NSString* const KWEB_SERVICE_BIO;
extern NSString* const KWEB_SERVICE_LOCATION;
extern NSString* const KWEB_SERVICE_PHONE;
extern NSString* const KWEB_SERVICE_USERID;
extern NSString* const KWEB_SERVICE_AVATAR;
extern NSString* const KWEB_SERVICE_PREFERENCE;
extern NSString* const KWEB_SERVICE_PASSKEY;
extern NSString* const KWEB_SERVICE_TYPE;
extern NSString* const KWEB_SERVICE_PRIVACY;
extern NSString* const KWEB_SERVICE_TWITTER_ID;
extern NSString* const KWEB_SERVICE_FACEBOOK_ID;
extern NSString* const KWEB_SERVICE_LAST_UPDATED;
extern NSString* const KWEB_SERVICE_FRIEND_ID;
extern NSString* const KWEB_SERVICE_ITEM_ID;
extern NSString* const KWEB_SERVICE_COMPONENT;
extern NSString* const KWEB_SERVICE_CONTENT;
extern NSString* const KWEB_SERVICE_IS_CONFIRM;


//For Albums
extern NSString* const KWEB_SERVICE_ALBUM_ID;
extern NSString* const KWEB_SERVICE_ALBUM_TITLE;
extern NSString* const KWEB_SERVICE_ALBUM_DESCRIPTION;
extern NSString* const KWEB_SERVICE_IMAGE;
extern NSString* const KWEB_SERVICE_IMAGE_TITLE;
extern NSString* const KWEB_SERVICE_IMAGE_ID;
extern NSString* const KWEB_SERVICE_IMAGE_LOCATION;
extern NSString* const KWEB_SERVICE_ALBUM_COVER;

// For Comment
extern NSString* const KWEB_SERVICE_COMMENT_ID;

//For Google API
extern NSString* const KGOOGLE_API_ADDRESS;
extern NSString* const KGOOGLE_API_SENSOR;

//For search queries
extern NSString* const KWEB_SERVICE_SEARCH_BY;
extern NSString* const KWEB_SERVICE_SEARCH_VALUE;
extern NSString* const KWEB_SERVICE_SEARCH_LIMIT;

//For location queries
extern NSString* const KWEB_SERVICE_LOCATION_ID;
extern NSString* const KWEB_SERVICE_LOCATION_TITLE;
extern NSString* const KWEB_SERVICE_LOCATION_LATITUDE;
extern NSString* const KWEB_SERVICE_LOCATION_LONGITUDE;
extern NSString* const KWEB_SERVICE_LOCATION_CITY;
extern NSString* const KWEB_SERVICE_LOCATION_COUNTRY;

// Core Data User Profile
extern NSString* const PROFILE_ENTITY;
extern NSString* const PROFILE_ACCOUNT_TYPE_KEY;
extern NSString* const PROFILE_BIO_KEY;
extern NSString* const PROFILE_EMAIL_KEY;
extern NSString* const PROFILE_IS_PRIVATE_KEY;
extern NSString* const PROFILE_NAME_KEY;
extern NSString* const PROFILE_PHONE_KEY;
extern NSString* const PROFILE_PICTURE_KEY;
extern NSString* const PROFILE_PREFERENCE_KEY;
extern NSString* const PROFILE_USER_ID_KEY;
extern NSString* const PROFILE_IMAGE_COUNT_KEY;


// Core Data Location
extern NSString* const LOCATION_ENTITY;
extern NSString* const LOCATION_ID_KEY;
extern NSString* const LOCATION_CITY_KEY;
extern NSString* const LOCATION_COUNTY_KEY;
extern NSString* const LOCATION_STATE_KEY;
extern NSString* const LOCATION_COUNTRY_KEY;
extern NSString* const LOCATION_LATITUDE_KEY;
extern NSString* const LOCATION_LONGITUDE_KEY;



// Core Data ALBUM
extern NSString* const ALBUM_ENTITY;
extern NSString* const ALBUM_ID_KEY;
extern NSString* const ALBUM_COVER_PHOTO_KEY;
extern NSString* const ALBUM_DESC_KEY;
extern NSString* const ALBUM_IS_PRIVATE_KEY;
extern NSString* const ALBUM_NAME_KEY;


// Core Data Picture
extern NSString* const PICTURE_ENTITY;
extern NSString* const PICTURE_ID_KEY;
extern NSString* const PICTURE_IMAGE_KEY;
extern NSString* const PICTURE_CAPTION_KEY;
extern NSString* const PICTURE_LOCATION_KEY;
extern NSString* const PICTURE_DESC_KEY;
extern NSString* const PICTURE_LIKES_COUNT_KEY;
extern NSString* const PICTURE_COMMENT_COUNT_KEY;
extern NSString* const PICTURE_IMAGE_URL_KEY;
extern NSString* const PICTURE_USER_DESC_KEY;

// Core Data Comment
extern NSString* const COMMENT_ENTITY;
extern NSString* const COMMENT_DATE_KEY;
extern NSString* const COMMENT_ID_KEY;

// Core Data Notification
extern NSString* const NOTIFICATION_ENTITY;
extern NSString* const NOTIFICATION_ID_KEY;
extern NSString* const NOTIFICATION_DATE_KEY;
extern NSString* const NOTIFICATION_DATA_KEY;
extern NSString* const NOTIFICATION_IS_PICTURE_KEY;
extern NSString* const NOTIFICATION_IS_READ_KEY;
extern NSString* const NOTIFICATION_ITEM_ID_KEY;

