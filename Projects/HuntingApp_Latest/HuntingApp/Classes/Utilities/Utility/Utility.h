//
//  Utility.h
//  HuntingApp
//
//  Created by Habib Ali on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject<RequestWrapperDelegate>
{
    WebServices *getProfileRequest;
    WebServices *loadAlbumRequest;
    WebServices *getLatLongRequest;
    WebServices *saveFavLocRequest;
    BOOL isProfileLoading;
    DejalActivityView *loadingActivityIndicator;
    NSString *countyToFollow;
    
}

@property (nonatomic, retain) NSString *currentUserIDToLoad;
@property (nonatomic) BOOL shouldRate; 

+ (Utility *)sharedInstance;

+ (NSData *)compressImage:(UIImage *)image limit:(NSInteger)limit;

+ (NSString *)stringFromImage:(UIImage *)image limit:(NSInteger)limit;

+ (UIImage *)imageFromString:(NSString *)string;

+ (NSString *)getLocationCountyAndState;

+ (NSString *)getLocationCityAndCountry;

+ (NSString *)getLocationCounty;

+ (NSString *)getLocationState;

+ (NSDictionary *)getLocationDict;

+ (NSString *)token;

+ (NSString *)userID;

+ (void)showServerError;

+ (UIBarButtonItem*) barButtonItemWithImageName:(NSString*)imgName Selector:(SEL)selector Target:(id)sender;

+ (NSString *)getStateAbbreviationForState:(NSString *)state;

+ (NSArray *)getAllStatesList;

+ (NSArray *)getAllCountiesListOfState:(NSString *)state;

+ (void)createAlbum:(NSString*)userID;

+ (NSString *)getImageURL:(NSString *)imgID;

+ (NSString *)getProfilePicURL:(NSString *)userID;

//+ (CGSize)getStringSizeForString:(NSString *)string;
+ (CGSize)getStringSizeForString:(NSString *)string  withFontSize:(float)size andMaxWidth:(float)maxWidth;

+ (BOOL)validateEmail:(NSString *)email;

+ (void)logout;

-(void) parseJsonImageUpload:(UIImage*)img withImageId:(NSString *)imgID;

- (void)addFavouriteLocationToUserProfile:(NSString *)location forViewController:(UIViewController*)controller;

// Getting complete profile functions
- (void)getCompleteProfileAndThenSaveToDB:(NSString *)userid;

- (void)saveUserProfileToDB:(NSDictionary *)userInfo;

- (void)saveFavLocations:(NSDictionary *)userInfo;

- (void)saveFavLocToDB:(NSDictionary *)params;

- (void)saveFollowingFriends:(NSDictionary*)userInfo;

- (void)saveFollowingFriendsToDB:(NSDictionary*)params;

- (void)saveFollowersFriends:(NSDictionary*)userInfo;

- (void)saveFollowersFriendsToDB:(NSDictionary*)params;

- (void)getAlbumOfUser:(NSString *)userID;

- (void)saveAlbumsToDB:(NSArray *)albums;

+ (NSDate *)getDateFromString:(NSString *)str;

+ (NSString *)getStringFromCurrentDate;
+ (NSString *)getProfilePicURLBIG:(NSString *)userID;
@end
