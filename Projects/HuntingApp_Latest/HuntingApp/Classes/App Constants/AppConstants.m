//
//  AppConstants.m
//  HuntingApp
//
//  Created by Habib Ali on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppConstants.h"

// Core data Files
NSString* const kCoreDataStorePath =                @"HuntingApp 2.xcdatamodeld.sqlite";
NSString* const kDefaultCDStorePath =               @"HuntingApp 2.xcdatamodeld";
NSString* const kCDMomdFileName=                    @"HuntingApp";

// Notifications
NSString* const NOTIFICATION_LOCATION_TRACKED=      @"LocationTracked";
NSString* const NOTIFICATION_PROFILE_SAVED=         @"profile_saved";
NSString* const NOTIFICATION_FAV_LOC_ADDED=         @"location_saved";
NSString* const NOTIFICATION_PROFILE_COMP_SAVED=    @"profile_completely_saved";

// Location Tracker constants
NSString* const COUNTRY_NAME_KEY=                   @"country_name";
NSString* const COUNTRY_CODE_KEY=                   @"country_code";
NSString* const CITY_NAME_KEY=                      @"city_name";
NSString* const STATE_NAME_KEY=                     @"state_name";
NSString* const COUNTY_NAME_KEY=                    @"county_name";

// User defaults
NSString* const LOGIN_STATE=                        @"login_state";
NSString* const NOTIFICATION_READ=                  @"notificaion_read";
NSString* const DEVICE_TOKEN=                       @"device_token";
NSString* const LOGIN_TOKEN=                        @"token";
NSString* const USER_TWITTER_INFO=                  @"twitter_info";
NSString* const USER_FACEBOOK_INFO=                 @"facebook_info";
NSString* const FIRST_VIEW=                         @"first_view";
NSString* const HAVE_SHOWN_LOC_ALERT=               @"have_shown_loc_alert";
NSString* const LOAD_PROFILE_IMAGE_FROM_SERVER=     @"load_profile_image";

// WEB SRVICE CONSTANTS
NSString* const KWEB_SERVICE_FORMAT=                @"format";
NSString* const KWEB_SERVICE_FORMAT_JSON=           @"json";
NSString* const kServerUri=                         @"http://theoutdoorloop.com/api/index.php";
NSString* const kGoogleApiUri=                      @"http://maps.googleapis.com/maps/api/geocode/json?";
NSString* const KIMAGE_LOAD_URL=                    @"http://theoutdoorloop.com/api/photo.php?";
NSString* const KFILE_LOAD_URL=                     @"http://theoutdoorloop.com/api/upload/";

// For Actions
NSString* const KWEB_SERVICE_ACTION=                @"action";
NSString* const KWEB_SERVICE_ACTION_NEW_ACCOUNT=    @"new_account";
NSString* const KWEB_SERVICE_ACTION_UPDATE_ACCOUNT= @"update_account";
NSString* const KWEB_SERVICE_ACTION_LOGIN=          @"login";
NSString* const KWEB_SERVICE_ACTION_PROFILE=        @"profile";
NSString* const KWEB_SERVICE_ACTION_NEW_ALBUM=      @"new_album";
NSString* const KWEB_SERVICE_ACTION_UPLOAD_IMAGE=   @"upload";
NSString* const KWEB_SERVICE_ACTION_VIEW_ALBUM=     @"view_album";
NSString* const KWEB_SERVICE_ACTION_VIEW_IMAGE=     @"view_image";
NSString* const KWEB_SERVICE_ACTION_UPDATE_ALBUM=   @"update_album";
NSString* const KWEB_SERVICE_ACTION_FIND_LOCATION=  @"find_location";
NSString* const KWEB_SERVICE_ACTION_SEARCH_IMAGE=   @"search_image";
NSString* const KWEB_SERVICE_ACTION_FAV_LOCATION=   @"new_fav_location";
NSString* const KWEB_SERVICE_ACTION_SEARCH_FRIEND=  @"search_friend";
NSString* const KWEB_SERVICE_ACTION_FOLLOW_FRIEND=  @"follow";
NSString* const KWEB_SERVICE_ACTION_LIKE=           @"like";
NSString* const KWEB_SERVICE_ACTION_COMMENT=        @"new_comment";
NSString* const KWEB_SERVICE_ACTION_DELETE=         @"delete";
NSString* const KWEB_SERVICE_ACTION_UNFOLLOW=       @"unfollow";
NSString* const KWEB_SERVICE_ACTION_UPLOAD_FILE=    @"upload_file";
NSString* const KWEB_SERVICE_ACTION_FORGET=         @"forget";
NSString* const KWEB_SERVICE_ACTION_NOTIFICATIONS=  @"notifications";
NSString* const KWEB_SERVICE_ACTION_GET_LOCATION=   @"view_location";

// For profile
NSString* const KWEB_DEVICE_TOKEN_ID=               @"vDeviceToken";
NSString* const KWEB_SERVICE_NAME=                  @"name";
NSString* const KWEB_SERVICE_EMAIL=                 @"email";
NSString* const KWEB_SERVICE_BIO=                   @"bio";
NSString* const KWEB_SERVICE_LOCATION=              @"location";
NSString* const KWEB_SERVICE_PHONE=                 @"phone";
NSString* const KWEB_SERVICE_USERID=                @"userid";
NSString* const KWEB_SERVICE_AVATAR=                @"avatar";
NSString* const KWEB_SERVICE_AVATARBIG=             @"original_avatar";
NSString* const KWEB_SERVICE_PREFERENCE=            @"preference";
NSString* const KWEB_SERVICE_PASSKEY=               @"passkey";
NSString* const KWEB_SERVICE_TYPE=                  @"type";
NSString* const KWEB_SERVICE_PRIVACY=               @"privacy";
NSString* const KWEB_SERVICE_TWITTER_ID=            @"twitterid";
NSString* const KWEB_SERVICE_FACEBOOK_ID=           @"facebookid";
NSString* const KWEB_SERVICE_LAST_UPDATED=          @"last_updated";
NSString* const KWEB_SERVICE_FRIEND_ID=             @"friend_id";
NSString* const KWEB_SERVICE_ITEM_ID=               @"item_id";
NSString* const KWEB_SERVICE_COMPONENT=             @"component";
NSString* const KWEB_SERVICE_CONTENT=               @"content";
NSString* const KWEB_SERVICE_IS_CONFIRM=            @"1";

// For Albums
NSString* const KWEB_SERVICE_ALBUM_ID=              @"albumid";
NSString* const KWEB_SERVICE_ALBUM_TITLE=           @"title";
NSString* const KWEB_SERVICE_ALBUM_DESCRIPTION=     @"desc";
NSString* const KWEB_SERVICE_IMAGE=                 @"image";
NSString* const KWEB_SERVICE_IMAGE_LOCATION=        @"location";
NSString* const KWEB_SERVICE_IMAGE_TITLE=           @"title";
NSString* const KWEB_SERVICE_IMAGE_ID=              @"imageid";
NSString* const KWEB_SERVICE_ALBUM_COVER=           @"cover";

//For Comment
NSString* const KWEB_SERVICE_COMMENT_ID=            @"comment_id";

//For Google API
NSString* const KGOOGLE_API_ADDRESS=                @"address";
NSString* const KGOOGLE_API_SENSOR=                 @"sensor";

//For search queries
NSString* const KWEB_SERVICE_SEARCH_BY=             @"search_by";
NSString* const KWEB_SERVICE_SEARCH_VALUE=          @"value";
NSString* const KWEB_SERVICE_SEARCH_LIMIT=          @"limit";

//For location queries
NSString* const KWEB_SERVICE_LOCATION_ID=           @"location_id";
NSString* const KWEB_SERVICE_LOCATION_TITLE=        @"title";
NSString* const KWEB_SERVICE_LOCATION_LATITUDE=     @"latitude";
NSString* const KWEB_SERVICE_LOCATION_LONGITUDE=    @"longitude";
NSString* const KWEB_SERVICE_LOCATION_CITY=         @"city";
NSString* const KWEB_SERVICE_LOCATION_COUNTRY=      @"country";

// Core data profile entity

NSString* const PROFILE_ENTITY=                     @"Profile";
NSString* const PROFILE_ACCOUNT_TYPE_KEY=           @"acount_type";
NSString* const PROFILE_BIO_KEY=                    @"bio";
NSString* const PROFILE_EMAIL_KEY=                  @"email";
NSString* const PROFILE_IS_PRIVATE_KEY=             @"is_private";
NSString* const PROFILE_NAME_KEY=                   @"name";
NSString* const PROFILE_PHONE_KEY=                  @"phone";
NSString* const PROFILE_PICTURE_KEY=                @"picture";
NSString* const PROFILE_PREFERENCE_KEY=             @"preference";
NSString* const PROFILE_USER_ID_KEY=                @"user_id";
NSString* const PROFILE_IMAGE_COUNT_KEY=            @"image_count";

// CORE DATA LOCATION ENTITY CONSTANTS
NSString* const LOCATION_ENTITY=                    @"Location"; 
NSString* const LOCATION_ID_KEY=                    @"loc_id";
NSString* const LOCATION_CITY_KEY=                  @"city";
NSString* const LOCATION_COUNTRY_KEY=               @"country";
NSString* const LOCATION_COUNTY_KEY=                @"county";
NSString* const LOCATION_STATE_KEY=                 @"state";
NSString* const LOCATION_LATITUDE_KEY=              @"latitude";
NSString* const LOCATION_LONGITUDE_KEY=             @"longitude";


// CORE DATA ALBUM CONTANTS
NSString* const ALBUM_ENTITY=                       @"Album";
NSString* const ALBUM_ID_KEY=                       @"album_id";
NSString* const ALBUM_COVER_PHOTO_KEY=              @"cover_photo";
NSString* const ALBUM_DESC_KEY=                     @"desc";
NSString* const ALBUM_IS_PRIVATE_KEY=               @"is_private";
NSString* const ALBUM_NAME_KEY=                     @"name";


// CORE DATA PICTURE CONSTANTS
NSString* const PICTURE_ENTITY=                     @"Picture";
NSString* const PICTURE_ID_KEY=                     @"pic_id";
NSString* const PICTURE_IMAGE_KEY=                  @"image";
NSString* const PICTURE_CAPTION_KEY=                @"caption";
NSString* const PICTURE_LOCATION_KEY=               @"location";
NSString* const PICTURE_DESC_KEY=                   @"desc";
NSString* const PICTURE_LIKES_COUNT_KEY=            @"likes_count";
NSString* const PICTURE_COMMENT_COUNT_KEY=          @"comments_count";
NSString* const PICTURE_IMAGE_URL_KEY=              @"image_url";
NSString* const PICTURE_USER_DESC_KEY=              @"user_desc";


//COREDATA Comments Constants
NSString* const COMMENT_ENTITY=                     @"Comment";
NSString* const COMMENT_DATE_KEY=                   @"date";
NSString* const COMMENT_ID_KEY=                     @"comment_id";


// Core Data Notification
NSString* const NOTIFICATION_ENTITY=                @"Notification";
NSString* const NOTIFICATION_ID_KEY=                @"notID";
NSString* const NOTIFICATION_DATE_KEY=              @"notDate";
NSString* const NOTIFICATION_DATA_KEY=              @"notData";
NSString* const NOTIFICATION_IS_PICTURE_KEY=        @"isPicture";
NSString* const NOTIFICATION_IS_READ_KEY=           @"isRead";
NSString* const NOTIFICATION_ITEM_ID_KEY=           @"notItemID";