//
//  Utility.m
//  HuntingApp
//
//  Created by Habib Ali on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "LocationTracker.h"
#import "AppDelegate.h"
#import "UIImage+Scale.h"
#import "ASIFormDataRequest.h"
#import "iRate.h"

@implementation Utility

@synthesize currentUserIDToLoad,shouldRate;

static Utility *singletonInstance = nil;

+ (Utility *)sharedInstance {
    
    if (singletonInstance == nil) {
        
        singletonInstance = [[super allocWithZone:NULL] init];
    }
    return singletonInstance;
}

-(id) init {
    
    self = [super init];
    if (self ) {
        isProfileLoading = NO;
        self.shouldRate = YES;
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;    
}

- (id)retain {
    
    return self;
}


- (NSUInteger)retainCount {
    
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

- (oneway void)release
{
    
}

-(void) dealloc
{
    RELEASE_SAFELY(countyToFollow);
    if (getProfileRequest)
    {
        getProfileRequest.delegate = nil;
        RELEASE_SAFELY(getProfileRequest);
    }
    if (loadAlbumRequest)
    {
        loadAlbumRequest.delegate = nil;
        RELEASE_SAFELY(loadAlbumRequest);
    }
    if (getLatLongRequest)
    {
        getLatLongRequest.delegate = nil;
        RELEASE_SAFELY(getLatLongRequest);
    }
    if (saveFavLocRequest)
    {
        saveFavLocRequest.delegate = nil;
        RELEASE_SAFELY(saveFavLocRequest);
    }
    RELEASE_SAFELY(currentUserIDToLoad);
    [super dealloc];
}

#pragma mark 
#pragma user methods

+(NSData *)compressImage:(UIImage *)image limit:(NSInteger)limit
{
    NSData *imgData = UIImagePNGRepresentation(image);
    NSUInteger currentLength = [imgData length];
    DLog(@"%i",currentLength);
    while (currentLength>limit)//500000 
    {
        NSUInteger prevLength = currentLength;
        imgData = UIImagePNGRepresentation([image scaleToSize:CGSizeMake(image.size.width/2, image.size.height/2)]);
        image = [UIImage imageWithData:imgData];
        currentLength = [imgData length];
        DLog(@"%i",currentLength);
        if (prevLength == currentLength)
            break;
    }
    DLog(@"%i",[imgData length]);
    return imgData;
}

+ (NSString *)stringFromImage:(UIImage *)image limit:(NSInteger)limit
{
    NSData *imgData = [[self class] compressImage:image limit:limit];
    return [NSString base64StringFromData:imgData];
}

+ (UIImage *)imageFromString:(NSString *)string
{
    NSData *imgData = [NSData dataFromBase64String:string];
    return [UIImage imageWithData:imgData];
}

/**
 @method        barButtonItemWithImageName
 @description   return UIBArButtonItem 
 @param         imgName
 @param         selector
 #param         sender
 @returns       UIBarButtonItem 
 */
+(UIBarButtonItem*) barButtonItemWithImageName:(NSString*)imgName Selector:(SEL)selector Target:(id)sender
{
    // Initialize the Left Bar Button 
    UIImage *buttonImage = [UIImage imageNamed:imgName];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *aBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:aButton] autorelease];
    
    // Set the Target and Action for aButton
    [aButton addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];
    return aBarButtonItem;
}


- (void)getCompleteProfileAndThenSaveToDB:(NSString *)userid
{
    if (!isProfileLoading)
    {
        isProfileLoading = YES;
        if (currentUserIDToLoad)
            RELEASE_SAFELY(currentUserIDToLoad);
        currentUserIDToLoad = [userid retain];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *controller = ((UINavigationController *)delegate.tabBarController.selectedViewController);
        if (![[DAL sharedInstance] getProfileByID:userid] || [userid isEqualToString:[Utility userID]])
            loadingActivityIndicator = [DejalBezelActivityView activityViewForView:controller.view withLabel:@"Loading..."];
        if (getProfileRequest)
        {
            getProfileRequest.delegate = nil;
            RELEASE_SAFELY(getProfileRequest);
        }
        getProfileRequest = [[WebServices alloc]init];
        [getProfileRequest setDelegate:self];
        [getProfileRequest getUserProfileInfoByUserID:userid];
    }
}


# pragma mark - Request wrapper delegate

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if (getProfileRequest)
    {
        getProfileRequest.delegate = nil;
        RELEASE_SAFELY(getProfileRequest);
    }
    if (loadAlbumRequest)
    {
        loadAlbumRequest.delegate = nil;
        RELEASE_SAFELY(loadAlbumRequest);
    }
    if (getLatLongRequest)
    {
        getLatLongRequest.delegate = nil;
        RELEASE_SAFELY(getLatLongRequest);
    }
    if (saveFavLocRequest)
    {
        saveFavLocRequest.delegate = nil;
        RELEASE_SAFELY(saveFavLocRequest);
    }
    if ([jsonDict objectForKey:@"results"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_FIND_LOCATION])
    {
        NSLog(@"%@",jsonDict);
        [self saveFavLocToDB:jsonDict];
    }
    else if([[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_FAV_LOCATION] && [jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] objectForKey:@"success"])
    {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"OutdoorLoop" message:@"Location added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        [loadingActivityIndicator removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAV_LOC_ADDED object:nil];
    }
    else if ([jsonDict objectForKey:@"data"] && [[jsonDict objectForKey:@"data"] count]>0 && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_PROFILE])
    {
        //if (![[DAL sharedInstance] getProfileByID:currentUserIDToLoad])
        [self methodsForSavingDataInProfile:jsonDict];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![[iRate sharedInstance] ratedThisVersion] && [defaults objectForKey:@"HasUsedFirstTime"] && [[defaults objectForKey:@"HasUsedFirstTime"]isEqualToString:@"1"] && self.shouldRate)
        {
            self.shouldRate = NO;
            [[iRate sharedInstance] promptForRating];
        }
        if ([defaults objectForKey:@"HasUsedFirstTime"])
            [defaults setObject:@"1" forKey:@"HasUsedFirstTime"];
        else 
        {
            [defaults setObject:@"0" forKey:@"HasUsedFirstTime"];
        }
        //else
        //    [self performSelectorInBackground:@selector(backgroundMethodsForSavingDataInProfile:) withObject:jsonDict];
    }
    else if ([jsonDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE])
    {
        [loadingActivityIndicator removeFromSuperview];
        if ([[jsonDict objectForKey:@"data"] count]>0)
            [self saveAlbumsToDB:[jsonDict objectForKey:@"data"]];
        isProfileLoading = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PROFILE_SAVED object:nil];
    }
    else {
        [loadingActivityIndicator removeFromSuperview];
        [[self class] showServerError];
        isProfileLoading = NO;
    }
    
}

- (void)methodsForSavingDataInProfile:(NSDictionary *)jsonDict
{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self saveUserProfileToDB:[[[jsonDict objectForKey:@"data"]objectAtIndex:0]objectForKey:@"data"]];
    [self saveFavLocations:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self saveFollowingFriends:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self saveFollowersFriends:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self getAlbumOfUser:currentUserIDToLoad];
    //[self performSelectorOnMainThread:@selector(getAlbumOfUser:) withObject:currentUserIDToLoad waitUntilDone:YES];
    //[pool drain];
}


- (void)backgroundMethodsForSavingDataInProfile:(NSDictionary *)jsonDict
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self saveUserProfileToDB:[[[jsonDict objectForKey:@"data"]objectAtIndex:0]objectForKey:@"data"]];
    [self saveFavLocations:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self saveFollowingFriends:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self saveFollowersFriends:[[jsonDict objectForKey:@"data"]objectAtIndex:0]];
    [self performSelectorOnMainThread:@selector(getAlbumOfUser:) withObject:currentUserIDToLoad waitUntilDone:YES];
    [pool drain];
}

- (void)saveUserProfileToDB:(NSDictionary *)userInfo
{
    
    int picCount = [[userInfo objectForKey:@"images_count"] intValue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if ([currentUserIDToLoad isEqualToString:[Utility userID]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:KWEB_SERVICE_NAME] forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_NAME] forKey:PROFILE_NAME_KEY];
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_EMAIL] forKey:PROFILE_EMAIL_KEY];
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_PHONE] forKey:PROFILE_PHONE_KEY];
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_USERID] forKey:PROFILE_USER_ID_KEY];
    [dict setObject:[NSNumber numberWithInt:picCount] forKey:PROFILE_IMAGE_COUNT_KEY];
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_PREFERENCE] forKey:PROFILE_PREFERENCE_KEY];
    [dict setObject:[userInfo objectForKey:KWEB_SERVICE_BIO] forKey:PROFILE_BIO_KEY];
    [dict setObject:[NSNumber numberWithBool:[[userInfo objectForKey:KWEB_SERVICE_PRIVACY]boolValue]] forKey:PROFILE_IS_PRIVATE_KEY];
    [dict setObject:[NSNumber numberWithInt:[[userInfo objectForKey:KWEB_SERVICE_TYPE]intValue]] forKey:PROFILE_ACCOUNT_TYPE_KEY];
    
    [[DAL sharedInstance] makeNewUserProfile:dict];
        
    RELEASE_SAFELY(dict);
            
}

- (void)saveFavLocations:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:HAVE_SHOWN_LOC_ALERT];
    if ([currentUserIDToLoad isEqualToString:[Utility userID]])
    {
        if ([userInfo objectForKey:@"1"] && ![[userInfo objectForKey:@"1"] isKindOfClass:[NSNull class]] && [[userInfo objectForKey:@"1"] count]>0 )
        {
            NSArray *arr = [userInfo objectForKey:@"1"] ;
            for (NSDictionary *locdict in arr) 
            {
                NSDictionary *dict = [locdict objectForKey:@"fav_locations"];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                NSString *county = [[[dict objectForKey:KWEB_SERVICE_LOCATION_TITLE] componentsSeparatedByString:@";"] objectAtIndex:0];
                NSString *state = [[[dict objectForKey:KWEB_SERVICE_LOCATION_TITLE] componentsSeparatedByString:@";"] objectAtIndex:1];
                [params setObject:[dict objectForKey:@"id"] forKey:LOCATION_ID_KEY];
                [params setObject:county forKey:COUNTY_NAME_KEY];
                [params setObject:state forKey:STATE_NAME_KEY];
                [params setObject:[dict objectForKey:KWEB_SERVICE_LOCATION_LATITUDE] forKey:LOCATION_LATITUDE_KEY];
                [params setObject:[dict objectForKey:KWEB_SERVICE_LOCATION_LONGITUDE] forKey:LOCATION_LONGITUDE_KEY];
                [params setObject:currentUserIDToLoad forKey:PROFILE_USER_ID_KEY];
                [params setObject:[dict objectForKey:@"type"] forKey:@"type"];
                [[DAL sharedInstance] addFavLocToUserProfile:params];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAV_LOC_ADDED object:nil];
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:HAVE_SHOWN_LOC_ALERT] isEqualToString:@"0"])
        {
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"OutdoorLoop" message:@"Go to the settings screen to add a location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

+ (NSString *)getLocationCountyAndState
{
    NSDictionary *dict = [[LocationTracker sharedInstance] getLocationDictionary];
    NSString *location = nil;
    if ([dict count]>0 && [dict objectForKey:COUNTY_NAME_KEY] && [dict objectForKey:STATE_NAME_KEY])
    {
        location = [NSString stringWithFormat:@"%@;%@",[dict objectForKey:COUNTY_NAME_KEY],[[self class] getStateAbbreviationForState:[dict objectForKey:STATE_NAME_KEY]]];
    }
    return location;
}

+ (NSString *)getLocationCityAndCountry
{
    NSDictionary *dict = [[LocationTracker sharedInstance] getLocationDictionary];
    NSString *location = nil;
    if ([dict count]>0)
    {
        location = [NSString stringWithFormat:@"%@,%@",[dict objectForKey:CITY_NAME_KEY],[dict objectForKey:COUNTRY_NAME_KEY]];
    }
    return location;
}

+ (NSString *)getLocationCounty
{
    NSDictionary *dict = [[LocationTracker sharedInstance] getLocationDictionary];
    NSString *location = nil;
    if ([dict count]>0 && [dict objectForKey:COUNTY_NAME_KEY])
    {
        location = [NSString stringWithFormat:@"%@",[dict objectForKey:COUNTY_NAME_KEY]];
    }
    return location;
}

+ (NSString *)getLocationState
{
    NSDictionary *dict = [[LocationTracker sharedInstance] getLocationDictionary];
    NSString *location = nil;
    if ([dict count]>0 && [dict objectForKey:STATE_NAME_KEY])
    {
        location = [NSString stringWithFormat:@"%@",[[self class] getStateAbbreviationForState:[dict objectForKey:STATE_NAME_KEY]]];
    }
    return location;
}

+ (NSDictionary *)getLocationDict
{
    NSDictionary *dict = nil;
    if ([[LocationTracker sharedInstance] getLocationDictionary].count!=0)
        dict = [[LocationTracker sharedInstance] getLocationDictionary];
    return dict;
}

+ (NSString *)token
{
     return [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_TOKEN];
}

+ (NSString *)userID
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:PROFILE_USER_ID_KEY])
        return [[NSUserDefaults standardUserDefaults]objectForKey:PROFILE_USER_ID_KEY];
    else {
        return nil;
    }
}



+ (void)showServerError
{
    BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"Server Error" message:@"You are not connected to the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    RELEASE_SAFELY(alert);
}

+ (NSString *)getStateAbbreviationForState:(NSString *)state
{
    NSString *stateCode = nil;
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"CountyList" ofType:@"plist"];
    NSDictionary *obj = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *counties = [obj objectForKey:@"Counties"];
    for (NSDictionary *dict in counties) {
        if ([[dict objectForKey:@"State"] isEqualToString:state])
        {
            stateCode = [dict objectForKey:@"StateCode"];
            break;
        }
    }
    return stateCode;
}

+ (NSArray *)getAllStatesList
{
    NSMutableArray *stateList = [[NSMutableArray alloc] init];
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"CountyList" ofType:@"plist"];
    NSDictionary *obj = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *counties = [obj objectForKey:@"Counties"];
    for (NSDictionary *dict in counties) {
        [stateList addObject:[dict objectForKey:@"StateCode"]];
    }
    [stateList autorelease];
    return stateList;
}

+ (NSArray *)getAllCountiesListOfState:(NSString *)state
{
    NSMutableArray *countyList = [NSMutableArray array];
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"CountyList" ofType:@"plist"];
    NSDictionary *obj = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *counties = [obj objectForKey:@"Counties"];
    for (NSDictionary *dict in counties) {
        if ([state isEqualToString:[dict objectForKey:@"State"]] || [state isEqualToString:[dict objectForKey:@"StateCode"]])
        {
            NSArray *list = [dict objectForKey:@"StateCounty"];
            for (NSDictionary *dict2 in list) {
                [countyList addObject:[dict2 objectForKey:@"CountyName"]];
            }
            break;
        }
    }
    NSArray *customCounties = [[DAL sharedInstance] getCountiesFromState:state];
    for (NSString *county in customCounties) 
    {
        if (![countyList containsObject:county])
        {
            [countyList addObject:county];
        }
    }
    countyList = [NSMutableArray arrayWithArray:[countyList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    return countyList;
}

+ (void)createAlbum:(NSString *)userID
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",[[self class]userID]);
    [delegate createAlbums:[[self class]userID]];
}

+ (NSString *)getImageURL:(NSString *)imgID
{
    NSString *url = [NSString stringWithFormat:@"%@%@=%@",KIMAGE_LOAD_URL,KWEB_SERVICE_IMAGE_ID,imgID];
    return url;
}

+ (NSString *)getProfilePicURL:(NSString *)userID
{
    NSString *url = [NSString stringWithFormat:@"%@%@=%@",KIMAGE_LOAD_URL,KWEB_SERVICE_USERID,userID];
    return url;
}

+ (NSString *)getProfilePicURLBIG:(NSString *)userID
{
    NSString *url = [NSString stringWithFormat:@"http://theoutdoorloop.com/api/original_avatar.php?userid=%@",userID];
    return url;
}

/*
+ (CGSize)getStringSizeForString:(NSString *)string
{
    CGSize maximumSize = CGSizeMake(250, 9999);
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:12];
    CGSize labelSize = [string sizeWithFont:dateFont 
                          constrainedToSize:maximumSize 
                              lineBreakMode:UILineBreakModeTailTruncation];
    
    return labelSize;
    
    
}
*/

+ (CGSize)getStringSizeForString:(NSString *)string  withFontSize:(float)size andMaxWidth:(float)maxWidth
{
    CGSize maximumSize = CGSizeMake(maxWidth, 99999);
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:size];
    CGSize labelSize = [string sizeWithFont:dateFont 
                          constrainedToSize:maximumSize 
                              lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize;
    
    
}


+ (BOOL)validateEmail:(NSString *)emailStr {  
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:emailStr];
    DLog(@"%d",isValid);
    return isValid;
} 

+ (void)logout
{
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) logout];
}

-(void) parseJsonImageUpload:(UIImage*)img withImageId:(NSString *)imgID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        
        NSData *imageData = UIImagePNGRepresentation(img);
        if (!imageData || imageData.length== 0) {
            DLog(@"imageData is null");
            return;
        }
        
        NSString *urlString =[[NSString alloc] initWithFormat:@"%@",kServerUri];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setTimeOutSeconds:600];
        [request setFile:imageData withFileName:imgID andContentType:@"image/png" forKey:@"file"];
        [request setPostValue:imgID forKey:KWEB_SERVICE_IMAGE_ID];
        [request setPostValue:[Utility userID] forKey:KWEB_SERVICE_USERID];
        [request startSynchronous];
        DLog(@"%@",request.responseString);
        
    }
    @catch (NSException *exception) {
        DLog(@"Exception %@",[exception description]);
    }    
    [pool drain];
}


- (void)addFavouriteLocationToUserProfile:(NSString *)location forViewController:(UIViewController*)controller
{
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:controller.view withLabel:@"Adding Location..."];
    if (getLatLongRequest)
    {
        [getLatLongRequest setDelegate:nil];
        RELEASE_SAFELY(getLatLongRequest);
    }
    getLatLongRequest = [[WebServices alloc] init];
    [getLatLongRequest setDelegate:self];
    [getLatLongRequest getLatLongForLocation:location];
    if (countyToFollow)
        RELEASE_SAFELY(countyToFollow);
    countyToFollow = [[NSString alloc] initWithString:[[location componentsSeparatedByString:@";"] objectAtIndex:0] ];
}

- (void)getAlbumOfUser:(NSString *)userID
{
    if (loadAlbumRequest)
    {
        [loadAlbumRequest setDelegate:nil];
        RELEASE_SAFELY(loadAlbumRequest);
    }
    loadAlbumRequest = [[WebServices alloc] init];
    [loadAlbumRequest setDelegate:self];
    [loadAlbumRequest getAllImagesOfUser:userID];
}

- (void)saveAlbumsToDB:(NSArray *)albums
{
    [[self class] createAlbum:currentUserIDToLoad];
    for (NSDictionary *dict in albums) 
    {
        NSDictionary *imageDict = [dict objectForKey:@"data"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_TITLE] forKey:PICTURE_CAPTION_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID] forKey:PICTURE_ID_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_LOCATION] forKey:PICTURE_LOCATION_KEY];
        [params setObject:[Utility getImageURL:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID]] forKey:PICTURE_IMAGE_URL_KEY];
        [params setObject:[NSData dataFromBase64String:[imageDict objectForKey:KWEB_SERVICE_IMAGE]] forKey:PICTURE_IMAGE_KEY];
        NSString *category = [imageDict objectForKey:KWEB_SERVICE_ALBUM_DESCRIPTION];
        if (category && [[DAL sharedInstance]getAlbumIDFromAlbumName:category])
            [params setObject:[[DAL sharedInstance]getAlbumIDFromAlbumName:category] forKey:ALBUM_ID_KEY];
        [params setObject:currentUserIDToLoad forKey:PROFILE_USER_ID_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]] forKey:PICTURE_LIKES_COUNT_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]] forKey:PICTURE_COMMENT_COUNT_KEY];
        [[DAL sharedInstance] createImageWithParams:params];
        RELEASE_SAFELY(params);
        
        
    }
}

- (void)saveFavLocToDB:(NSDictionary *)params
{
    if ([[params objectForKey:@"results"] count] >0 && [[params objectForKey:@"status"]isEqualToString:@"OK"])
    {
        NSDictionary *dict = [[params objectForKey:@"results"] objectAtIndex:0];
        NSArray *arr = [dict objectForKey:@"address_components"];
        NSString *county= nil;
        NSString *state = nil;
        for (NSDictionary *dict2 in arr) {
            if ([[[dict2 objectForKey:@"types"]objectAtIndex:0] isEqualToString:@"sublocality"])
            {
                if (countyToFollow)
                {
                    county = [NSString stringWithString:countyToFollow];
                    RELEASE_SAFELY(countyToFollow);
                }
                else {
                    county = [dict2 objectForKey:@"long_name"];
                }
                
            }
            else if ([[[dict2 objectForKey:@"types"]objectAtIndex:0] isEqualToString:@"administrative_area_level_2"])
            {
                if (countyToFollow)
                {
                    county = [NSString stringWithString:countyToFollow];
                    RELEASE_SAFELY(countyToFollow);
                }
                else {
                    county = [dict2 objectForKey:@"long_name"];
                }
            }
            
            if([[[dict2 objectForKey:@"types"]objectAtIndex:0] isEqualToString:@"administrative_area_level_1"])
            {
                state = [dict2 objectForKey:@"short_name"];
            }
        }
        NSString *lat = [[[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] description];
        NSString *lng = [[[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] description];
        if (county && state)
        {
            //hack
//            if ([state isEqualToString:@"PA"])
//                state = @"PY";
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:county forKey:COUNTY_NAME_KEY];
            [param setObject:state forKey:STATE_NAME_KEY];
            [param setObject:lat forKey:LOCATION_LATITUDE_KEY];
            [param setObject:lng forKey:LOCATION_LONGITUDE_KEY];
            [param setObject:[Utility userID] forKey:PROFILE_USER_ID_KEY];
            if ([[DAL sharedInstance] addFavLocToUserProfile:param])
            {
                NSMutableDictionary *locParams = [NSMutableDictionary dictionary];
                [locParams setObject:[NSString stringWithFormat:@"%@;%@",county,state] forKey:KWEB_SERVICE_LOCATION_TITLE];
                [locParams setObject:lat forKey:KWEB_SERVICE_LOCATION_LATITUDE];
                [locParams setObject:lng forKey:KWEB_SERVICE_LOCATION_LONGITUDE];
                if (saveFavLocRequest)
                {
                    saveFavLocRequest.delegate = nil;
                    RELEASE_SAFELY(saveFavLocRequest);
                }
                saveFavLocRequest = [[WebServices alloc] init];
                [saveFavLocRequest setDelegate:self];
                [saveFavLocRequest addFavLoc:locParams];
            }
        }
    }
    else {
        BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"OutdoorLoop" message:@"Location could not be added" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        [loadingActivityIndicator removeFromSuperview];
    }
}

- (void)saveFollowingFriends:(NSDictionary*)userInfo
{
    if ([userInfo objectForKey:@"2"] && ![[userInfo objectForKey:@"2"] isKindOfClass:[NSNull class]] && [[userInfo objectForKey:@"2"] count]>0 )
    {
        NSArray *arr = [userInfo objectForKey:@"2"];
        for (NSDictionary *dict in arr) {
            [self saveFollowingFriendsToDB:[dict objectForKey:@"following"]];
        }
    }
}

- (void)saveFollowingFriendsToDB:(NSDictionary*)params
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[params objectForKey:@"frienduserid"] forKey:PROFILE_USER_ID_KEY];
    [param setObject:[params objectForKey:KWEB_SERVICE_NAME] forKey:PROFILE_NAME_KEY];
    [[DAL sharedInstance] addFollowing:param inUserPofile:currentUserIDToLoad];
}

- (void)saveFollowersFriends:(NSDictionary*)userInfo
{
    if ([userInfo objectForKey:@"3"] && ![[userInfo objectForKey:@"3"] isKindOfClass:[NSNull class]] && [[userInfo objectForKey:@"3"] count]>0 )
    {
        NSArray *arr = [userInfo objectForKey:@"3"];
        for (NSDictionary *dict in arr) {
            [self saveFollowersFriendsToDB:[dict objectForKey:@"follower"]];
        }

    }
}

- (void)saveFollowersFriendsToDB:(NSDictionary*)params
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[params objectForKey:@"userid"] forKey:PROFILE_USER_ID_KEY];
    [param setObject:[params objectForKey:KWEB_SERVICE_NAME] forKey:PROFILE_NAME_KEY];
    [[DAL sharedInstance] addFollower:param inUserPofile:currentUserIDToLoad];
}


+ (NSDate *)getDateFromString:(NSString *)str
{
    NSDate *date = nil;
    //str = @"October 29, 2012, 5:27 pm"; 
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"MMMM d, yyyy, h:mm a"];
    date = [format dateFromString:str];
    DLog(@"%@------%@",[date description],[format stringFromDate:date]);
    return date;

}

+ (NSString *)getStringFromCurrentDate
{
    NSDateFormatter *format = [[[NSDateFormatter alloc]init] autorelease];
    [format setDateFormat:@"MMMM d, yyyy, h:mm a"];
    return [format stringFromDate:[NSDate date]];
}


@end
