//
//  MapViewControllerViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewControllerViewController.h"
#import "UIImage+Scale.h"
#import "CustomMapAnnotationView.h"
#import <MapKit/MkAnnotation.h>
#import "FLButton.h"
#import "ProfileViewController.h"
#import "CustomTimeLineFooter.h"
#import "NSString+Additions.h"
#import "TimeLineCell.h"

@interface MapViewControllerViewController (Private)
- (void)getAllNotifications;
- (void)showFavLocations;
- (void)setUpTimelineView;
- (void)saveImagesToDB:(NSArray *)imageDicts;
- (void)showTimeLineContents;
- (void)getFavLocations;
- (void)navtoProfileView:(id)sender;
- (NSArray *)getDistinctImagesFromNotificationArray;
- (BOOL)isSearchImageArrayContainsID:(NSString *)ID;
- (void)processNotificationArray;
- (void)addImagesInTimeLineViewInBackgroundFromArray:(NSArray *)array;
@end

@implementation MapViewControllerViewController
@synthesize timeLine;


@synthesize mapView,isCurrentViewMapView;

static int count = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldReload = YES;
    notificationsArray = [[NSMutableArray alloc]init];
    imageFromSearch = [[NSMutableArray alloc]init];
    picArray = [[NSMutableArray alloc] init];
    hasAppearedFirstTime = YES;
    likeSelected = NO;
    commentSelected = NO;
    IDSelected = @"aaa";
    isloading = NO;
    shouldShowMapTypeDropDown = NO;
    shouldLoadTimeLine = YES;
    picArray = [[NSMutableArray alloc]init];
    [self getFavLocations];
    
    NotificationViewController *controller = [[[NotificationViewController alloc] initWithStyle:UITableViewStylePlain andItemsArray:picArray] autorelease];
    controller.delegate = self;
    popOverController = [[WEPopoverController alloc] initWithContentViewController:controller];
    
        
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.4230;
    coordinate.longitude = -98.7372;

    MKCoordinateRegion region;
    region.center = coordinate;
    region.span.longitudeDelta = 25.0f;
    region.span.latitudeDelta = 25.0f;
    [mapView setRegion:region];

    [mapView setMapType:MKMapTypeHybrid];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
   
    btnImageViews = [[NSMutableArray alloc] init];
    lblViews = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
    
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [imgView setImage:[UIImage imageNamed:@"MapNavBar"]];
    UIButton *loopView = [[[UIButton alloc] initWithFrame:CGRectMake(40, 12, 113, 19)] autorelease];
    [loopView setImage:[UIImage imageNamed:@"the-loop.png"] forState:UIControlStateNormal];
    [loopView setImage:[UIImage imageNamed:@"the-loop-yellow.png"] forState:UIControlStateHighlighted];
    [loopView addTarget:self action:@selector(loopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *mapBtn = [[[UIButton alloc] initWithFrame:CGRectMake(188, 3, 39, 38)] autorelease];
    [mapBtn setImage:[UIImage imageNamed:@"m-active.png"] forState:UIControlStateNormal];
    [mapBtn setImage:[UIImage imageNamed:@"m-active.png"] forState:UIControlStateHighlighted];
    mapBtn.tag = 98;
    [mapBtn addTarget:self action:@selector(changeHomeView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *timelineBtn = [[[UIButton alloc] initWithFrame:CGRectMake(240, 6, 25, 32)] autorelease];
    [timelineBtn setImage:[UIImage imageNamed:@"t.png"] forState:UIControlStateNormal];
    [timelineBtn setImage:[UIImage imageNamed:@"t.png"] forState:UIControlStateHighlighted];
    timelineBtn.tag = 99;
    [timelineBtn addTarget:self action:@selector(changeHomeView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *dirView = [[[UIButton alloc] initWithFrame:CGRectMake(290, 9, 25, 26)] autorelease];
    [dirView setTag:1];
    [dirView addTarget:self action:@selector(loopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [dirView setImage:[UIImage imageNamed:@"direction"] forState:UIControlStateNormal];
    [dirView setImage:[UIImage imageNamed:@"direction"] forState:UIControlStateHighlighted];
    
    [titleView addSubview:imgView];
    [titleView addSubview:loopView];
    [titleView addSubview:mapBtn];
    [titleView addSubview:timelineBtn];
    [titleView addSubview:dirView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLocations) name:NOTIFICATION_FAV_LOC_ADDED object:nil];
    mapTypeController = [[MapTypeTableViewController alloc] initWithStyle:UITableViewStylePlain andItemsArray:nil];
    favLocController = [[FavLocTableViewController alloc]initWithStyle:UITableViewStylePlain andItemsArray:favLocations];
    
    NSString *firstView = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_VIEW];
    if ([firstView isEqualToString:@"0"])
    {
        [mapView setHidden:NO];
        [timeLine setHidden:YES];
        isCurrentViewMapView = YES;
    }
    else
    {
        [mapView setHidden:YES];
        [timeLine setHidden:NO];
        isCurrentViewMapView = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [favLocController setSelectedRow:-1];
    [self.navigationController.navigationBar addSubview:titleView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (shouldReload)
        [self setUpTimelineView];
    shouldReload = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeAllRequests];
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    
    [bg release];
    bg = nil;
    [lblTimeline release];
    lblTimeline = nil;
    [self setTimeLine:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [self removeAllRequests];
    RELEASE_SAFELY(imageIDLiked);
    RELEASE_SAFELY(imageIDToFetch);
    RELEASE_SAFELY(imageFromSearch);
    RELEASE_SAFELY(notificationsArray);
    RELEASE_SAFELY(favLocController);
    RELEASE_SAFELY(mapTypeController);
    RELEASE_SAFELY(btnImageViews);
    RELEASE_SAFELY(lblViews);
    RELEASE_SAFELY(picArray);
    RELEASE_SAFELY(favLocations);
    RELEASE_SAFELY(titleView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mapView release];
    
    RELEASE_SAFELY(popOverController);
    [bg release];
    [lblTimeline release];
    RELEASE_SAFELY(mapView);
    [timeLine release];
    [super dealloc];
}


# pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    CustomMapAnnotationView *annView = nil;
    static NSString *defaultPinID = @"Annotation";
    annView = (CustomMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (!annView)
    {
        annView = [[[CustomMapAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }
    myPos *ann = (myPos *)annotation;
    if ([ann.title containsString:@";"])
    {
        Picture *pic = nil;
        for (Picture *picture in picArray) 
        {
            if (picture.location && [picture.location isEqualToString:ann.title])
            {
                pic = [picture retain];
                break;
            }
        }
        if (pic)
        {
            [annView setTag:0];
            [annView.btnThumbnail setTag:[[[pic.pic_id componentsSeparatedByString:@"-"]lastObject]intValue]];
            
            if (pic.image)
                [annView setImage:[UIImage imageWithData:pic.image.image]];
            else
            {
                [annView setImage:[UIImage imageNamed:@"loading"]];
                [annView.imgView setImageWithImage:pic];
            }
            [annView.lblName setText:[[pic.desc componentsSeparatedByString:@":"]lastObject]];
        }
        else 
        {
            return [[[MKAnnotationView alloc] init] autorelease];
        }
        RELEASE_SAFELY(pic);
    }
    else
    {
        [annView.btnThumbnail setTag:[[Utility userID]intValue]];
        [annView setTag:1];
        Profile *profile = [[DAL sharedInstance] getProfileByID:[Utility userID]];
        if (profile.picture)
        {
            [annView setImage:[UIImage imageWithData:profile.picture]];
        }
        else {
            [annView.imgView setImageWithProfile:profile];
        }
        [annView.lblName setText:@"Me"];
        
        
    }
    annView.centerOffset = CGPointMake(0, -60);
    return annView;
}

- (void)mapView:(MKMapView *)amapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CustomMapAnnotationView *customView = (CustomMapAnnotationView *)view;
    if (view.tag ==0)
    {
        [self pictureSelected:customView.btnThumbnail];
    }
    else if (view.tag ==1){
        [self navtoProfileView:customView.btnThumbnail];
    }
    [amapView deselectAnnotation:view.annotation animated:NO];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    CustomMapAnnotationView *customView = (CustomMapAnnotationView *)view;
    if (view.tag ==0)
    {
        [self pictureSelected:customView.btnThumbnail];
    }
    else if (view.tag ==1){
        [self navtoProfileView:customView.btnThumbnail];
    }
}

- (IBAction)changeHomeView:(id)sender 
{
    [self removeAllRequests];
    
    UIButton *mapBtn = (UIButton *)[titleView viewWithTag:98];
    UIButton *timelineBtn = (UIButton *)[titleView viewWithTag:99];
    int ind = ((UIButton *)sender).tag;
    if (ind == 98)
    {
        [mapBtn setImage:[UIImage imageNamed:@"m-active.png"] forState:UIControlStateNormal];
        [mapBtn setImage:[UIImage imageNamed:@"m-active.png"] forState:UIControlStateHighlighted];
        [timelineBtn setImage:[UIImage imageNamed:@"t.png"] forState:UIControlStateNormal];
        [timelineBtn setImage:[UIImage imageNamed:@"t.png"] forState:UIControlStateHighlighted];
        [self.mapView setHidden:NO];
        [timeLine setHidden:YES];
        [self loopButtonTapped:mapBtn];
        isCurrentViewMapView =YES;
    }
    else 
    {
        isCurrentViewMapView = NO;
        [mapBtn setImage:[UIImage imageNamed:@"m.png"] forState:UIControlStateNormal];
        [mapBtn setImage:[UIImage imageNamed:@"m.png"] forState:UIControlStateHighlighted];
        [timelineBtn setImage:[UIImage imageNamed:@"t-active.png"] forState:UIControlStateNormal];
        [timelineBtn setImage:[UIImage imageNamed:@"t-active.png"] forState:UIControlStateHighlighted];
        [self.mapView setHidden:YES];
        [timeLine setHidden:NO];
    }
    [self showTimeLineContents];
    //[self performSelectorInBackground:@selector(setUpTimelineView) withObject:nil];
}

- (void)showLocations
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_FAV_LOC_ADDED object:nil];
    [self getFavLocations];
    [self searchImageForQuery:[self generateQueryKey]];
    [self showFavLocations];
    
}

- (void)getFavLocations
{
    if (favLocations)
        RELEASE_SAFELY(favLocations);

    favLocations = [[[DAL sharedInstance] getFavLocationsOfCurrentUser] retain];
}

- (void)showFavLocations
{
    
    [self getFavLocations];
    [mapView removeAnnotations:mapView.annotations];
    for (Location *loc in favLocations) 
    {
        myPos *ann = [[[myPos alloc] init] autorelease];
        [ann setTitle:[NSString stringWithFormat:@"%@",loc.description]];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [loc.latitude doubleValue];
        coordinate.longitude = [loc.longitude doubleValue];
        ann.coordinate = coordinate;
        [mapView addAnnotation:ann];
    }
}

#pragma mark - request wrapper delegate
- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    isloading = NO;
    if (searchImageRequest)
    {
        [searchImageRequest setDelegate:nil];
        RELEASE_SAFELY(searchImageRequest);
    }
    if (getNotificationsRequest) 
    {
        getNotificationsRequest.delegate = nil;
        RELEASE_SAFELY(getNotificationsRequest);
    }
    [loadingActivityIndicator removeFromSuperview];
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_LIKE])
    {
        if(likeRequest)
        {
            likeRequest.delegate = nil;
            RELEASE_SAFELY(likeRequest);
        }
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            DLog(@"Image liked successfully");
        }
        [self getImageInfo:imageIDLiked];
        RELEASE_SAFELY(imageIDLiked);
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION]isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE]) 
    {
        if(getImageRequest)
        {
            getImageRequest.delegate = nil;
            RELEASE_SAFELY(getImageRequest);
        }
        if ([[jsonDict objectForKey:@"data"] count]>0)
        {
            NSDictionary *imgInfo = [[[jsonDict objectForKey:@"data"] objectAtIndex:0]objectForKey:@"data"];
            NSString *ID = imageIDToFetch;
            NSString *caption = [imgInfo objectForKey:KWEB_SERVICE_IMAGE_TITLE];
            NSNumber *likes_count = [NSNumber numberWithInt:[[imgInfo objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]];
            Picture *picture = [[DAL sharedInstance] getImageByImageID:ID];
            [picture setCaption:caption];
            [picture setLikes_count:likes_count];
            [[DAL sharedInstance] saveContext];
            RELEASE_SAFELY(imageIDToFetch);
            [self showTimeLineContents];
        }
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_NOTIFICATIONS] && [jsonDict objectForKey:@"data"])
    {
        [notificationsArray removeAllObjects];
        if ([jsonDict objectForKey:@"data"] && ![[jsonDict objectForKey:@"data"] isEqual:[NSNull null]])
            [notificationsArray addObjectsFromArray:[jsonDict objectForKey:@"data"]];
        [self processNotificationArray];
        NSArray *arr = [self getDistinctImagesFromNotificationArray];
        [imageFromSearch removeAllObjects];
        [imageFromSearch addObjectsFromArray:arr];
        [self saveImagesToDB:imageFromSearch];
        if (isCurrentViewMapView)
        {
            [self showFavLocations];
        }
        
    }
    else if ([jsonDict objectForKey:@"data"])
    {
        if ([[jsonDict objectForKey:@"data"] count]>0)
        {
            [imageFromSearch removeAllObjects];
            [imageFromSearch addObjectsFromArray:[jsonDict objectForKey:@"data"]];
            
            [self addImageSearchToNotifications:imageFromSearch];
        }
        [self getAllNotifications];
    }
    else 
    {
        [Utility showServerError];
    }
}

- (void)saveImagesToDB:(NSArray *)imageDicts
{
    int ind = 0;
    for (NSDictionary *dict in imageDicts) 
    {
        NSDictionary *imageDict = [dict objectForKey:@"data"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"Timeline-%d",ind] forKey:PICTURE_ID_KEY];
        if ([imageDict objectForKey:KWEB_SERVICE_IMAGE_TITLE])
            [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_TITLE] forKey:PICTURE_CAPTION_KEY];
        if ([imageDict objectForKey:KWEB_SERVICE_IMAGE_LOCATION])
            [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_LOCATION] forKey:PICTURE_LOCATION_KEY];
        if ([imageDict objectForKey:PICTURE_LIKES_COUNT_KEY])
            [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]] forKey:PICTURE_LIKES_COUNT_KEY];
        if ([imageDict objectForKey:PICTURE_COMMENT_COUNT_KEY])
            [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]] forKey:PICTURE_COMMENT_COUNT_KEY];
        [params setObject:[Utility getImageURL:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID]] forKey:PICTURE_IMAGE_URL_KEY];
        [params setObject:[NSString stringWithFormat:@"%@:%@",[imageDict objectForKey:KWEB_SERVICE_USERID],[imageDict objectForKey:KWEB_SERVICE_NAME]] forKey:PICTURE_USER_DESC_KEY];
        [params setObject:[NSString stringWithFormat:@"%@:PostedBy:%@",[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID],[imageDict objectForKey:KWEB_SERVICE_NAME]] forKey:PICTURE_DESC_KEY];
        
        if ([[DAL sharedInstance] createOtherUserImageWithParams:params])
            ind++;
    }
    if (!picArray)
    {
        picArray = [[NSMutableArray alloc] init];
    }
    [picArray removeAllObjects];
    
    [picArray addObjectsFromArray:[[DAL sharedInstance] getAllImagesByPartialID:@"Timeline-"]];
    if (!isCurrentViewMapView)
        [self showTimeLineContents];
}

- (void)setUpTimelineView
{
    NSString *queryKey = [self generateQueryKey];
    if (![queryKey isEmptyString])
    {
        [self searchImageForQuery:queryKey];        
        if (!picArray)
        {
            picArray = [[NSMutableArray alloc] init];
        }
        [picArray removeAllObjects];
        [picArray addObjectsFromArray:[[DAL sharedInstance] getAllImagesByPartialID:@"Timeline-"]];
        if (!isCurrentViewMapView)
            [self showTimeLineContents];
        else {
            [self showFavLocations];
        }
        
    }
    else
    {
//        for (UIView *view in [timelineView subviews]) {
//            [view removeFromSuperview];
//        }
        [timeLine reloadData];
        [lblTimeline setHidden:NO];
    }        
}

- (NSString *)generateQueryKey
{
    NSString *queryKey = @"";
    for (Location *loc in favLocations) {
        NSString *desc = [loc description];
        if ([queryKey isEmptyString])
            queryKey = [queryKey stringByAppendingFormat:@"%@",desc];
        else
            queryKey = [queryKey stringByAppendingFormat:@",%@",desc];
    }
    return queryKey;
}

- (void)searchImageForQuery:(NSString *)queryKey
{
    if (!isloading && ![queryKey isEmptyString])
    {
        isloading = YES;
        loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading Images..."];
        if (searchImageRequest)
        {
            [searchImageRequest setDelegate:nil];
            RELEASE_SAFELY(searchImageRequest);
        }
        searchImageRequest = [[WebServices alloc]init];
        [searchImageRequest setDelegate:self];
        [searchImageRequest searchImageByValue:queryKey andKey:KWEB_SERVICE_IMAGE_LOCATION];
    }

}

- (void)addImagesInTimeLineViewInBackgroundFromArray:(NSArray *)array
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    [pool drain];
}

- (void)showTimeLineContents
{

    
    if (picArray && [picArray count]!=0)
    {
        if (!isCurrentViewMapView)
        {
            
            [timeLine reloadData];
            [lblTimeline setHidden:YES];
        }
        else
        {
            [self showFavLocations];
        }

    }
    else {
        [timeLine reloadData];
        [lblTimeline setHidden:NO];
    }
    
    

}

- (void)pictureSelected:(id)sender
{
    likeSelected = NO;
    commentSelected = NO;
    UIButton *btn = (UIButton *)sender;
    NSString *ID = [NSString stringWithFormat:@"Timeline-%d",btn.tag];
    selectedImage = [[DAL sharedInstance]getImageByImageID:ID];

    [self performSegueWithIdentifier:@"AlbumView" sender:self];
}

- (void)likeSelected:(id)sender
{
    likeSelected = YES;
    commentSelected = NO;
    UIButton *btn = (UIButton *)sender;
    NSString *ID = [NSString stringWithFormat:@"Timeline-%d",btn.tag];
    if (imageIDToFetch)
        RELEASE_SAFELY(imageIDToFetch);
    imageIDToFetch = [ID retain];
    selectedImage = [[DAL sharedInstance]getImageByImageID:ID];
    if (likeRequest)
    {
        likeRequest.delegate = nil;
        RELEASE_SAFELY(likeRequest);
    }
    likeRequest = [[WebServices alloc] init];
    [likeRequest setDelegate:self];
    ID = [[selectedImage.image_url componentsSeparatedByString:@"="]lastObject];
    if (imageIDLiked)
        RELEASE_SAFELY(imageIDLiked);
    imageIDLiked = [ID retain];
    [likeRequest likeImage:ID];
}

- (void)commentSelected:(id)sender
{
    commentSelected = YES;
    likeSelected = NO;
    UIButton *btn = (UIButton *)sender;
    NSString *ID = [NSString stringWithFormat:@"Timeline-%d",btn.tag];
    selectedImage = [[DAL sharedInstance]getImageByImageID:ID];
    [self performSegueWithIdentifier:@"AlbumView" sender:self];
}


- (void)navtoProfileView:(id)sender
{
    
    UIButton *btn;
    if ([sender isKindOfClass:[UIButton class]])
    {
        btn = (UIButton *)sender;
        IDSelected = [NSString stringWithFormat:@"%d",btn.tag];
    }
    else if ([sender isKindOfClass:[NSNotification class]])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PROFILE_SAVED object:nil];
        
    }
    ;
    Profile *profile = [[DAL sharedInstance] getProfileByID:IDSelected];
    if (profile)
        [self performSegueWithIdentifier:@"ProfileView" sender:profile];
    else {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(navtoProfileView:) name:NOTIFICATION_PROFILE_SAVED object:nil];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:IDSelected];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    shouldReload = NO;
    if ([[segue identifier] isEqualToString:@"AlbumView"])
    {
        shouldLoadTimeLine = NO;
        AlbumViewController *controller = (AlbumViewController *)[segue destinationViewController];
        [controller setDelegate:self];
        [controller setComeFromView:1];
        [controller setPic:selectedImage];
        [controller setPicArray:[NSArray arrayWithArray:picArray]];
        if (likeSelected || commentSelected)
        {
            [controller setGotoCommentView:commentSelected];
            [controller setIsLikeBtnSelected:likeSelected];
        }
    }
    else if ([[segue identifier] isEqualToString:@"ProfileView"]) 
    {
        shouldLoadTimeLine = NO;
        IDSelected =@"aaa";
        ProfileViewController *controller = [segue destinationViewController];
        [controller setUserProfile:((Profile *)sender)];
    }
}

- (void)loopButtonTapped:(UIButton *)button
{
    
    if (!popOverController.isPopoverVisible && button) 
    {
        NotificationViewController *controller;
        CGRect frame = CGRectZero;
        if (button.tag == 0)
        {
            if ([picArray count]!=0 || notificationsArray.count!=0)
            {
                controller = [[[NotificationViewController alloc] initWithStyle:UITableViewStylePlain andItemsArray:picArray andNotificationsArray:notificationsArray] autorelease];
                frame = CGRectMake(20, 0, 100, 0);
                controller.delegate = self;
                [popOverController setContentViewController:controller];
                [popOverController presentPopoverFromRect:frame
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES];
                [self searchImageForQuery:[self generateQueryKey]];
            }
            else {
                [self searchImageForQuery:[self generateQueryKey]];
            }
            
        }
        else if (button.tag == 98) 
        {
            if (shouldShowMapTypeDropDown)
            {
                controller = mapTypeController;
                frame = CGRectMake(20, 0, 365, 0);
                controller.delegate = self;
                [popOverController setContentViewController:controller];
                [popOverController presentPopoverFromRect:frame
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES];
            }
            shouldShowMapTypeDropDown = YES;
        }
        else if (button.tag == 1) 
        {
            if (isCurrentViewMapView)
            {
                int index = -1;
                if(favLocController)
                {
                    index = favLocController.selectedRow;
                    RELEASE_SAFELY(favLocController);
                }
                favLocController = [[FavLocTableViewController alloc]initWithStyle:UITableViewStylePlain andItemsArray:favLocations];
                [favLocController setSelectedRow:index];
                controller = favLocController;
                
                frame = CGRectMake(320, 0, 365, 0);
                controller.delegate = self;
                [popOverController setContentViewController:controller];
                [popOverController presentPopoverFromRect:frame
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionRight
                                                 animated:YES];
            }
        }

        
    }
    else 
    {
        [popOverController dismissPopoverAnimated:YES];
        
    }
}

- (void)notificationSelected:(NSObject *)notification
{
    DLog(@"notification selected");
    if ([notification isKindOfClass:[NSString class]])
    {
        NSString *mapType = (NSString *)notification;
        if ([mapType isEqualToString:@"Standard"])
        {
            self.mapView.mapType = MKMapTypeStandard;
        }
        else if ([mapType isEqualToString:@"Hybrid"])
        {
            self.mapView.mapType = MKMapTypeHybrid;
        }
        else if ([mapType isEqualToString:@"Satellite"])
        {
            self.mapView.mapType = MKMapTypeSatellite;
        }
        [self changeHomeView:[titleView viewWithTag:98]];
    }
    else if ([notification isKindOfClass:[Location class]])
    {
        Location *loc = (Location *)notification;
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [loc.latitude doubleValue];
        coordinate.longitude = [loc.longitude doubleValue];
        
        MKCoordinateRegion region;
        region.center = coordinate;
        region.span.longitudeDelta = 0.007f;
        region.span.latitudeDelta = 0.007f;
        [mapView setRegion:region];
        if ([loc.loc_id isEqualToString:@"My Location"])
        {
            myPos *ann = [[[myPos alloc] init] autorelease];
            [ann setTitle:[NSString stringWithFormat:@"My Profile"]];
            ann.coordinate = coordinate;
            [mapView addAnnotation:ann];

        }
    }
    else 
    {
        NSDictionary *dict = (NSDictionary *)notification;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([dict objectForKey:PICTURE_ID_KEY])
        {
            [btn setTag:[[[[dict objectForKey:PICTURE_ID_KEY]componentsSeparatedByString:@"-"]lastObject]intValue]];
            [self pictureSelected:btn];
        }
        else 
        {
            [btn setTag:[[dict objectForKey:PROFILE_USER_ID_KEY]intValue]];
            [self navtoProfileView:btn];
        }
        
    }
    [popOverController dismissPopoverAnimated:YES];
}

- (void)disappearAlbumView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getAllNotifications
{
    if (getNotificationsRequest) 
    {
        getNotificationsRequest.delegate = nil;
        RELEASE_SAFELY(getNotificationsRequest);
    }
    getNotificationsRequest = [[WebServices alloc]init];
    getNotificationsRequest.delegate = self;
    [getNotificationsRequest getAllNotifications];
}

- (NSArray *)getDistinctImagesFromNotificationArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in notificationsArray) 
    {
        dict = [dict objectForKey:@"notifications"];
        NSString *imageID = [dict objectForKey:@"item_id"];
        if (![[dict objectForKey:@"component"] isEqualToString:@"image"] || [self isSearchImageArrayContainsID:imageID])
        {
            continue;
        }
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        [dict2 setObject:[dict objectForKey:@"item_id"] forKey:KWEB_SERVICE_IMAGE_ID];
        [dict2 setObject:[dict objectForKey:KWEB_SERVICE_USERID] forKey:KWEB_SERVICE_USERID];
        if ([[dict objectForKey:@"meta"]containsString:@"added"])
            [dict2 setObject:[[[dict objectForKey:@"meta"]componentsSeparatedByString:@" "]objectAtIndex:0] forKey:KWEB_SERVICE_NAME];
        else {
            Profile *profile = [[DAL sharedInstance]getProfileByID:[Utility userID]];
            [dict2 setObject:profile.name forKey:KWEB_SERVICE_NAME];
            [dict2 setObject:profile.user_id forKey:KWEB_SERVICE_USERID];
        }
        [dict2 setObject:@"" forKey:KWEB_SERVICE_IMAGE_TITLE];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObject:dict2 forKey:@"data"];
        [resultArray addObject:dict3];
    }
    DLog(@"%@",[resultArray description]);
    [resultArray addObjectsFromArray:imageFromSearch];
    DLog(@"%@",[resultArray description]);
    return resultArray;
}

- (BOOL)isSearchImageArrayContainsID:(NSString *)ID;
{
    BOOL contain = NO;
    for (NSDictionary *dict in imageFromSearch)
    {
        dict = [dict objectForKey:@"data"];
        if ([[dict objectForKey:KWEB_SERVICE_IMAGE_ID] isEqualToString:ID])
        {
            contain = YES;
            break;
        }
    }
    return contain;
}

- (void)processNotificationArray
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:notificationsArray];
    for (NSDictionary *dicti in resultArray) 
    {
        NSDictionary *dict = [dicti objectForKey:@"notifications"];
        if ([[dict objectForKey:@"userid"] isEqualToString:[Utility userID]])
        {
            [notificationsArray removeObject:dicti];
        }
    }
    for (NSDictionary *dict in notificationsArray)
    {
        dict = [dict objectForKey:@"notifications"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[[dict objectForKey:@"id"] stringValue] forKey:NOTIFICATION_ID_KEY];
        [param setObject:[dict objectForKey:@"meta"] forKey:NOTIFICATION_DATA_KEY];
        NSString *component = [dict objectForKey:@"component"];
        if ([component isEqualToString:@"image"])
        {
            [param setObject:[NSNumber numberWithBool:YES] forKey:NOTIFICATION_IS_PICTURE_KEY];
            [param setObject:[dict objectForKey:@"item_id"] forKey:NOTIFICATION_ITEM_ID_KEY];
        }
        else
        {
            [param setObject:[NSNumber numberWithBool:NO] forKey:NOTIFICATION_IS_PICTURE_KEY];
            [param setObject:[dict objectForKey:@"userid"] forKey:NOTIFICATION_ITEM_ID_KEY];
        }
        [param setObject:[dict objectForKey:@"date"] forKey:NOTIFICATION_DATE_KEY];
        [Utility getDateFromString:[dict objectForKey:@"date"]];
        [[DAL sharedInstance] createNotificationWith:param];
    }
}

- (void)addImageSearchToNotifications:(NSArray *)data
{
    for (NSDictionary *dict in data)
    {
        dict = [dict objectForKey:@"data"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"%@-%@",[dict objectForKey:KWEB_SERVICE_IMAGE_LOCATION],[dict objectForKey:KWEB_SERVICE_IMAGE_ID]] forKey:NOTIFICATION_ID_KEY];
        [params setObject:@"A new picture has been posted on" forKey:NOTIFICATION_DATA_KEY];
        [params setObject:[NSNumber numberWithBool:YES] forKey:NOTIFICATION_IS_PICTURE_KEY];
        [params setObject:[dict objectForKey:KWEB_SERVICE_IMAGE_ID] forKey:NOTIFICATION_ITEM_ID_KEY];
        [params setObject:[Utility getStringFromCurrentDate] forKey:NOTIFICATION_DATE_KEY];
        [[DAL sharedInstance] createNotificationWith:params];
    }
}

- (void)getImageInfo:(NSString *)imageID
{
    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    getImageRequest = [[WebServices alloc] init];
    [getImageRequest setDelegate:self];
    [getImageRequest getImage:imageID ofUser:[Utility userID]]; 
}

- (void)removeAllRequests
{
    [loadingActivityIndicator removeFromSuperview];
    if (likeRequest)
    {
        likeRequest.delegate = nil;
        RELEASE_SAFELY(likeRequest);
    }
    if(getImageRequest)
    {
        getImageRequest.delegate = nil;
        RELEASE_SAFELY(getImageRequest);
    }
    
    if (getNotificationsRequest) 
    {
        getNotificationsRequest.delegate = nil;
        RELEASE_SAFELY(getNotificationsRequest);
    }
    if (searchImageRequest) 
    {
        searchImageRequest.delegate = nil;
        RELEASE_SAFELY(searchImageRequest);
    }

}

# pragma mark UITable view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"%d",picArray.count);
    return (!picArray || picArray.count==0)?0:(ceil((float)picArray.count/2));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCell *cell = (TimeLineCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeLine"];
    cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    int index= indexPath.row*2;
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        count--;
        GetImageInfo *getImageInfo = [[GetImageInfo alloc]init];
        getImageInfo.delegate = self;
        [getImageInfo getImageInfo:pic];
        
        FLButton *imgBtn = cell.btn1;
        [cell.btn1 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
            [imgBtn setImageWithImage:pic];
            [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
            [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
        }
        else {
            [imgBtn setImageWithDataInBackGround:pic.image.image];
        }
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomTimeLineFooter *view = cell.footer1;
        [cell.footer1 setHidden:NO];
        [view.btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        NSString *username = [[pic.user_desc componentsSeparatedByString:@":"]lastObject];
        username = [[username componentsSeparatedByString:@" "] objectAtIndex:0];
        [view.btnName setTitle:username forState:UIControlStateNormal];
        [view.btnName setTitle:username forState:UIControlStateHighlighted];
        [view.btnName setTag:[[[pic.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]integerValue]];
        [view.btnName addTarget:self action:@selector(navtoProfileView:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.btnLike setTag:[[[pic.pic_id componentsSeparatedByString:@"-"]lastObject]integerValue]];
        [view.btnLike addTarget:self action:@selector(likeSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.btnComment setTag:[[[pic.pic_id componentsSeparatedByString:@"-"]lastObject]integerValue]];
        [view.btnComment addTarget:self action:@selector(commentSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.lblLike setText:[NSString stringWithFormat:@"%d",[pic.likes_count intValue]]];
        [view.lblComment setText:[NSString stringWithFormat:@"%d",[pic.comments_count intValue]]];
        index ++;
    }
    else
    {
        [cell.btn1 setHidden:YES];
        [cell.footer1 setHidden:YES];
    }
    if (index < picArray.count)
    {
        Picture *pic = [picArray objectAtIndex:index];
        count--;
        GetImageInfo *getImageInfo = [[GetImageInfo alloc]init];
        getImageInfo.delegate = self;
        [getImageInfo getImageInfo:pic];
        
        FLButton *imgBtn = cell.btn2;
        [cell.btn2 setHidden:NO];
        [imgBtn.imageView getWhiteBorderImage];
        if (!pic.image)
        {
            [imgBtn setImageWithImage:pic];
            [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
            [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
        }
        else {
            [imgBtn setImageWithDataInBackGround:pic.image.image];
        }
        NSString *tag = [[pic.pic_id componentsSeparatedByString:@"-"] lastObject];
        [imgBtn setTag:[tag intValue]];
        [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        CustomTimeLineFooter *view = cell.footer2;
        [cell.footer2 setHidden:NO];
        [view.btnName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        NSString *username = [[pic.user_desc componentsSeparatedByString:@":"]lastObject];
        username = [[username componentsSeparatedByString:@" "] objectAtIndex:0];
        [view.btnName setTitle:username forState:UIControlStateNormal];
        [view.btnName setTitle:username forState:UIControlStateHighlighted];
        [view.btnName setTag:[[[pic.user_desc componentsSeparatedByString:@":"]objectAtIndex:0]integerValue]];
        [view.btnName addTarget:self action:@selector(navtoProfileView:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.btnLike setTag:[[[pic.pic_id componentsSeparatedByString:@"-"]lastObject]integerValue]];
        [view.btnLike addTarget:self action:@selector(likeSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.btnComment setTag:[[[pic.pic_id componentsSeparatedByString:@"-"]lastObject]integerValue]];
        [view.btnComment addTarget:self action:@selector(commentSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.lblLike setText:[NSString stringWithFormat:@"%d",[pic.likes_count intValue]]];
        [view.lblComment setText:[NSString stringWithFormat:@"%d",[pic.comments_count intValue]]];
        index ++;
    }
    else {
        [cell.btn2 setHidden:YES];
        [cell.footer2 setHidden:YES];
    }
    return cell;
    
}

# pragma mark - GetImageInfo Delegate

- (void)getImageInfoRequestCompleted:(GetImageInfo *)getImageInfoClass
{
    RELEASE_SAFELY(getImageInfoClass);
    count ++;
    if (count ==0)
    {
        count--;
        [timeLine reloadData];
    }
}


@end