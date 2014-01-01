//
//  ProfileViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

#import "AppDelegate.h"
#import "UIImage+Scale.h"
#import "FLButton.h"
#import "ImageCell.h"


@interface ProfileViewController (PRIVATE_FUNCTIONS)

- (void)loadAllImages;
- (void)saveImagesToDB:(NSArray *)imagesArray;
- (void)showImages:(NSInteger)tag;
- (void)deleteImage:(id)sender;
@end

@implementation ProfileViewController
@synthesize currentSelection;
//@synthesize scrollView;
@synthesize tblView;
@synthesize tempLabel;
@synthesize lblName;
@synthesize profilePicView;
@synthesize userProfile,isProfileTwo,displayArray;
@synthesize subview;
@synthesize request;

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
    [profilePicView setImageWithProfile:userProfile];
    //    [[NSUserDefaults standardUserDefaults]setObject:@"5" forKey:@"ORIGINAL_AVTAR"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSaveProfile) name:NOTIFICATION_PROFILE_SAVED object:nil];
    self.navigationItem.title = @"";
    isProfileTwo = NO;
    btnImageViews = [[NSMutableArray alloc]init];
    
    if (!userProfile)
    {
        userProfile = [[DAL sharedInstance] getProfileByID:[Utility userID]];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:userProfile.user_id];
    }
    else
    {
        isProfileTwo = YES;
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:userProfile.user_id];
    }
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [lbl setMinimumFontSize:14];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@""];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setTag:1];
    [titleView addSubview:lbl];
    [profilePicView getWhiteBorderImage];
	// Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    [btnFollow addTarget:self action:@selector(followID:) forControlEvents:UIControlEventTouchUpInside];
    if ([userProfile.user_id isEqualToString:[Utility userID]])
    {
        [btnFollow setHidden:YES];
    }
    else if ([[DAL sharedInstance] isFollowing:userProfile.user_id])
    {
        [btnFollow setHidden:NO];
        [btnFollow setImage:[UIImage imageNamed:@"following"] forState:UIControlStateNormal];
        [btnFollow setImage:[UIImage imageNamed:@"following"] forState:UIControlStateHighlighted];
        
    }
    else if (![[DAL sharedInstance] isFollowing:userProfile.user_id])
    {
        [btnFollow setHidden:NO];
        [btnFollow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btnFollow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateHighlighted];
    }
    
    
    self.subview.layer.borderWidth = 2.5f;
    self.subview.alpha = 0.0;
    self.subview.layer.borderColor = [[UIColor blackColor] CGColor];
    self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    self.subview.backgroundColor=[UIColor whiteColor];
    
}

#pragma mark Bounce Animation


-(UIImage *)cropCenterToSize:(CGSize)newSize :(UIImage *)Image
{
    UIImage *resultingImage;
    if(Image.size.height==newSize.height)
    {
        resultingImage=[[UIImage alloc]init];
        resultingImage= Image;
    }
    else{
        float widthratio=Image.size.width/newSize.width;
        float heightratio=Image.size.height/newSize.height;
        float finalratio=MIN(widthratio, heightratio);
        UIImage *cropped = [UIImage imageWithCGImage:Image.CGImage scale:finalratio orientation:Image.imageOrientation];
        
        CGRect rectimgView = CGRectMake(0,0,newSize.width,newSize.height);
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:rectimgView];
        imgView.image=cropped;
        imgView.contentMode=UIViewContentModeCenter;
        imgView.clipsToBounds=YES;
        
        UIGraphicsBeginImageContext(rectimgView.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [imgView.layer renderInContext:context];
        resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"newimage height=%f,width=%f\n Image height=%f,width=%f",resultingImage.size.height,resultingImage.size.width,Image.size.height,Image.size.width);
    }
    return resultingImage;
}

- (IBAction)showAnimation:(id)sender
{
    
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         self.subview.alpha = 0.5;
     }
                     completion:^(BOOL finished){
                         [self bounceOutAnimationStoped];
                     }];
}
- (void)bounceOutAnimationStoped
{
    
    
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.subview withLabel:@"Loading"];
    
    imgBigProfile.image = [UIImage imageNamed:@""];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         self.subview.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
}

- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
         self.subview.alpha = 1.0;
     }
                     completion:^(BOOL finished){
                         [self animationStoped];
                     }];
}
- (void)animationStoped
{
    strImageBigOrSmall =@"1";
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ORIGINAL_AVTAR"]isEqualToString:@"5"]) {
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"ORIGINAL_AVTAR221"]isEqualToString:@"555"]) {
        
        NSURL *iamgeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://theoutdoorloop.com/api/original_avatar.php?userid=%@",userProfile.user_id]];
        request =[ASIHTTPRequest requestWithURL:iamgeUrl];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        //[[ASIDownloadCache sharedCache] shouldRespectCacheControlHeaders:NO];
        [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
        [request setDelegate:self];
        [request startAsynchronous];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"555" forKey:@"ORIGINAL_AVTAR221"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }else{
        
        NSString *imgStrin1234 =  [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:[Utility getProfilePicURLBIG:userProfile.user_id]]];
        imgBigProfile.image = [UIImage imageWithContentsOfFile:imgStrin1234];
        [loadingActivityIndicator removeFromSuperview];
    }
    
    }else{
    
    
    NSString *imgStrin1234 =  [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:[Utility getProfilePicURLBIG:userProfile.user_id]]];
    if (imgStrin1234==nil) {
        
        NSURL *iamgeUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://theoutdoorloop.com/api/original_avatar.php?userid=%@",userProfile.user_id]];
        request =[ASIHTTPRequest requestWithURL:iamgeUrl];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        //[[ASIDownloadCache sharedCache] shouldRespectCacheControlHeaders:NO];
        [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
        [request setDelegate:self];
        [request startAsynchronous];
        
       
        
        
    }else{
        
        imgBigProfile.image = [UIImage imageWithContentsOfFile:imgStrin1234];
        [loadingActivityIndicator removeFromSuperview];
    }
}
   // 
    
}



#pragma marka -ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request123
{
    // Use when fetching binary data
    NSData *responseData = [request123 responseData];
    UIImage *image123 = [[UIImage imageWithData:responseData] retain];
    
    if ([strImageBigOrSmall isEqualToString:@"1"]) {
        
        imgBigProfile.image=[UIImage imageWithCGImage:image123.CGImage];
        [[NSUserDefaults standardUserDefaults]setObject:@"55" forKey:@"ORIGINAL_AVTAR"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [loadingActivityIndicator removeFromSuperview];
        
    }else{
        
        profilePicView.image=[UIImage imageWithCGImage:image123.CGImage];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request123
{
    NSError *error = [request123 error];
    NSLog(@"%@",[error description]);
}


-(IBAction)cancleBtnPressed :(id)sender{
    
    imgBigProfile.image = nil;
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         self.subview.alpha = 0;
         self.subview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
         
     }
                     completion:^(BOOL finished){

    }];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (userProfile)
    {
        Profile *profile = [[DAL sharedInstance] getProfileByID:userProfile.user_id]; 
        RELEASE_SAFELY(userProfile);
        userProfile = [profile retain];
    }
    else
        userProfile = [[[DAL sharedInstance] getProfileByID:[Utility userID]] retain];
    
    if (userProfile)
    {
        UILabel *lbl = (UILabel *)[titleView viewWithTag:1];
        [lbl setText:userProfile.name];
        [lblName setText:userProfile.name];        
        strImageBigOrSmall =@"0";
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ORIGINAL_AVTAR"]isEqualToString:@"5"]) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ORIGINAL_AVTAR12"]isEqualToString:@"55"]) {

                
                request =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[Utility getProfilePicURL:userProfile.user_id]]];
                [request setDownloadCache:[ASIDownloadCache sharedCache]];
                //[[ASIDownloadCache sharedCache] shouldRespectCacheControlHeaders:NO];
                [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
                [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
                [request setDelegate:self];
                [request startAsynchronous];
                [[NSUserDefaults standardUserDefaults]setObject:@"555" forKey:@"ORIGINAL_AVTAR12"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }else{
                
                NSString *imgStrin =  [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:[Utility getProfilePicURL:userProfile.user_id]]];
                 profilePicView.image = [UIImage imageWithContentsOfFile:imgStrin];
                [loadingActivityIndicator removeFromSuperview];
            }
            
        }else{
            
            
            NSString *imgStrin1234 =  [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:[Utility getProfilePicURL:userProfile.user_id]]];
            if (imgStrin1234==nil) {
                
                profilePicView.image = [UIImage imageNamed:@"Unknown-person.png"];
                [profilePicView setImageWithProfile:userProfile];
                
            }else{
                
                profilePicView.image = [UIImage imageWithContentsOfFile:imgStrin1234];
                //[loadingActivityIndicator removeFromSuperview];
            }
        }
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate createAlbums:userProfile.user_id];
        int picCount = [[DAL sharedInstance] getPicCountOfProfile:userProfile.user_id];
        lblPicture.text = [NSString stringWithFormat:@"%d pictures",picCount];
        if (picCount == 0)
            lblPicture.text = [NSString stringWithFormat:@"%d pictures",[userProfile.image_count intValue]];
        int followerCount = [[DAL sharedInstance] getFollowersCountOfUserID:userProfile.user_id];
        lblFollowers.text = [NSString stringWithFormat:@"%d followers",followerCount];
        int followingCount = [[DAL sharedInstance] getFollowingCountOfUserID:userProfile.user_id];
        lblFollowing.text = [NSString stringWithFormat:@"%d following",followingCount];
        lblProfileBio.text = userProfile.bio;
    }
    [self.navigationController.navigationBar addSubview:titleView];
    [self changeSection:[NSNumber numberWithInt:currentSelection]];
    if (![userProfile.user_id isEqualToString:[Utility userID]] ||  self.navigationController.tabBarController.selectedIndex!=3)
    {
        self.navigationItem.leftBarButtonItem = [Utility barButtonItemWithImageName:@"left-arrow" Selector:@selector(popViewController) Target:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (loadImagesRequest)
    {
        [loadImagesRequest setDelegate:nil];
        RELEASE_SAFELY(loadImagesRequest);
    }
    [super viewWillDisappear:animated];
    RELEASE_SAFELY(userProfile);
    [titleView removeFromSuperview];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)dealloc
{
    RELEASE_SAFELY(displayArray);
    
    if (loadImagesRequest)
    {
        [loadImagesRequest setDelegate:nil];
        RELEASE_SAFELY(loadImagesRequest);
    }
    if (deleteImageRequest)
    {
        [deleteImageRequest setDelegate:nil];
        RELEASE_SAFELY(deleteImageRequest);
    }
    if (followRequest)
    {
        [followRequest setDelegate:nil];
        RELEASE_SAFELY(followRequest);
    }
//    for (UIButton *btn in btnImageViews) {
//        RELEASE_SAFELY(btn);
//    }
    RELEASE_SAFELY(followersArray);
    RELEASE_SAFELY(followingArray);
    RELEASE_SAFELY(titleView);
    RELEASE_SAFELY(btnImageViews);
    RELEASE_SAFELY(userProfile);
    RELEASE_SAFELY(picturesArray);
    loadImagesRequest.delegate = nil;
    RELEASE_SAFELY(loadImagesRequest);
    [profilePicView release];
    //[scrollView release];
    [tempLabel release];
    [lblPicture release];
    [btnFollowing release];
    [btnFollowers release];
    [btnPictures release];
    [lblName release];
    [lblFollowing release];
    [lblFollowers release];
    [lblProfileBio release];
    [btnFollow release];
    [tblView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setProfilePicView:nil];
    //[self setScrollView:nil];
    [self setTempLabel:nil];
    [lblPicture release];
    lblPicture = nil;
    [btnFollowing release];
    btnFollowing = nil;
    [btnFollowers release];
    btnFollowers = nil;
    [btnPictures release];
    btnPictures = nil;
    [self setLblName:nil];
    [lblFollowing release];
    lblFollowing = nil;
    [lblFollowers release];
    lblFollowers = nil;
    [lblProfileBio release];
    lblProfileBio = nil;
    [btnFollow release];
    btnFollow = nil;
    [self setTblView:nil];
    userProfile = nil;
    [userProfile release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - REQUEST WRAPPER DELEGATE

- (void)requestWrapperDidReceiveResponse:(NSString *)response withHttpStautusCode:(HttpStatusCodes)statusCode withRequestUrl:(NSURL *)requestUrl withUserInfo:(NSDictionary *)userInfo
{
    [loadingActivityIndicator removeFromSuperview];
    if (loadImagesRequest)
    {
        [loadImagesRequest setDelegate:nil];
        RELEASE_SAFELY(loadImagesRequest);
    }
    if (deleteImageRequest)
    {
        [deleteImageRequest setDelegate:nil];
        RELEASE_SAFELY(deleteImageRequest);
    }
    if (followRequest)
    {
        [followRequest setDelegate:nil];
        RELEASE_SAFELY(followRequest);
    }
    NSDictionary *jsonDict = [WebServices parseJSONString:response];
    if ([jsonDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_VIEW_IMAGE])
    {
        if ([[jsonDict objectForKey:@"data"]count]>0)
        {
            NSArray *imagesArray = [jsonDict objectForKey:@"data"];
            [self saveImagesToDB:imagesArray];
        }
        else {
            tempLabel.text = @"No pictures uploaded yet";
            [tempLabel setHidden:NO];

        }
    }
    else if ([[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_DELETE])
    {
        DLog(@"Image deleted");
    }
    else if ([jsonDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_FOLLOW_FRIEND])
    {
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            [btnFollow setImage:[UIImage imageNamed:@"following"] forState:UIControlStateNormal];
            [btnFollow setImage:[UIImage imageNamed:@"following"] forState:UIControlStateHighlighted];
            BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Follow Friend" message:@"Congratulations!!! Now you can follow your friend's hunting expeditions and much more" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
            [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:[Utility userID]];
        }
    }
    else if ([jsonDict objectForKey:@"data"] && [[userInfo objectForKey:KWEB_SERVICE_ACTION] isEqualToString:KWEB_SERVICE_ACTION_UNFOLLOW])
    {
        if ([[jsonDict objectForKey:@"data"] objectForKey:@"success"])
        {
            DLog(@"friend unfollowed");
        }
    }
    else 
    {
        [Utility showServerError];
    }
    
}

- (IBAction)changeSection:(id)sender 
{
    if ([sender isKindOfClass:[UIButton class]]) 
        currentSelection = ((UIButton *)sender).tag;
    else {
        currentSelection = [((NSNumber *)sender) intValue];
    }
//    for (UIView *view in [scrollView subviews]) {
//        [view removeFromSuperview];
//    }
    switch (currentSelection) {
        case 0:
        {
            tempLabel.text = @"No followings added!!!";
            [tempLabel setHidden:YES];
            //[self.scrollView setContentSize:CGSizeMake(280,157)];
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateNormal];
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateHighlighted];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            RELEASE_SAFELY(followingArray);
            followingArray = [[[DAL sharedInstance]getFollowingOfUserID:userProfile.user_id] retain];
            if (followingArray && [followingArray count]!=0)
            {
                [self showImages:currentSelection];
            }
            else {
                [tempLabel setHidden:NO];
                [self.tblView reloadData];
            }
            
        }
            break;
        case 1:
        {
            tempLabel.text = @"No one is following you!!!";
            [tempLabel setHidden:YES];
            
            //[self.scrollView setContentSize:CGSizeMake(280,157)];
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateNormal];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateHighlighted];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            RELEASE_SAFELY(followersArray);
            followersArray = [[[DAL sharedInstance]getFollowersOfUserID:userProfile.user_id] retain];
            if (followersArray && [followersArray count]!=0)
            {
            
                [self showImages:currentSelection];
            }
            else {
                [tempLabel setHidden:NO];
                [self.tblView reloadData];
            }
            
        }
            break;
        case 2:
        {
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnFollowing setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateNormal];
            [btnFollowers setImage:[UIImage imageNamed:@"tooltip.png"] forState:UIControlStateHighlighted];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateNormal];
            [btnPictures setImage:[UIImage imageNamed:@"tooltip-active.png"] forState:UIControlStateHighlighted];
            [tempLabel setHidden:YES];
            RELEASE_SAFELY(picturesArray);
            picturesArray = [[[DAL sharedInstance] getAllPicturesOfUser:userProfile.user_id] retain];
            if (picturesArray && [picturesArray count]==0)
            {
                loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
                [self loadAllImages];
                [self.tblView reloadData];
            }
            else 
            {
                [self showImages:currentSelection];
                [self loadAllImages];

            }
        }
            break;
        default:
            break;
    }
}

- (void)didSaveProfile
{
    DLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (userProfile)
    {
        NSLog(@"%@",[Utility userID]);
        Profile *profile = [[DAL sharedInstance] getProfileByID:userProfile.user_id]; 
        RELEASE_SAFELY(userProfile);
        userProfile = [profile retain];
    }
    else
        userProfile = [[[DAL sharedInstance] getProfileByID:[Utility userID]] retain];
    if (userProfile)
    {
        UILabel *lbl = (UILabel *)[titleView viewWithTag:1];
        [lbl setText:userProfile.name];
        [lblName setText:userProfile.name];

        
        NSString *imgStrin1234 =  [[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:[NSURL URLWithString:[Utility getProfilePicURL:userProfile.user_id]]];
        if (imgStrin1234==nil) {
            
            profilePicView.image = [UIImage imageNamed:@"Unknown-person.png"];
            [profilePicView setImageWithProfile:userProfile];
            
        }else{
            
            profilePicView.image = [UIImage imageWithContentsOfFile:imgStrin1234];
            //[loadingActivityIndicator removeFromSuperview];
        }
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate createAlbums:userProfile.user_id];
        int picCount = [[DAL sharedInstance] getPicCountOfProfile:userProfile.user_id];
        lblPicture.text = [NSString stringWithFormat:@"%d pictures",picCount];
        if (picCount == 0)
            lblPicture.text = [NSString stringWithFormat:@"%d pictures",[userProfile.image_count intValue]];
        int followerCount = [[DAL sharedInstance] getFollowersCountOfUserID:userProfile.user_id];
        lblFollowers.text = [NSString stringWithFormat:@"%d followers",followerCount];
        int followingCount = [[DAL sharedInstance] getFollowingCountOfUserID:userProfile.user_id];
        lblFollowing.text = [NSString stringWithFormat:@"%d following",followingCount];
        lblProfileBio.text = userProfile.bio;
        [self changeSection:[NSNumber numberWithInt:currentSelection]];
    }
}

- (void)loadAllImages
{
    if (loadImagesRequest)
    {
        [loadImagesRequest setDelegate:nil];
        RELEASE_SAFELY(loadImagesRequest);
    }
    loadImagesRequest = [[WebServices alloc] init];
    [loadImagesRequest setDelegate:self];
    [loadImagesRequest getAllImagesOfUser:userProfile.user_id];
}

- (void)saveImagesToDB:(NSArray *)imagesArray
{
    [Utility createAlbum:userProfile.user_id];
    for (NSDictionary *dict in imagesArray) 
    {
        NSDictionary *imageDict = [dict objectForKey:@"data"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_TITLE] forKey:PICTURE_CAPTION_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID] forKey:PICTURE_ID_KEY];
        [params setObject:[imageDict objectForKey:KWEB_SERVICE_IMAGE_LOCATION] forKey:PICTURE_LOCATION_KEY];
        [params setObject:[NSData dataFromBase64String:[imageDict objectForKey:KWEB_SERVICE_IMAGE]] forKey:PICTURE_IMAGE_KEY];
        [params setObject:[Utility getImageURL:[imageDict objectForKey:KWEB_SERVICE_IMAGE_ID]] forKey:PICTURE_IMAGE_URL_KEY];
        NSString *category = [imageDict objectForKey:KWEB_SERVICE_ALBUM_DESCRIPTION];
        if (category && [[DAL sharedInstance]getAlbumIDFromAlbumName:category])
            [params setObject:[[DAL sharedInstance]getAlbumIDFromAlbumName:category] forKey:ALBUM_ID_KEY];
        [params setObject:userProfile.user_id forKey:PROFILE_USER_ID_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_LIKES_COUNT_KEY]intValue]] forKey:PICTURE_LIKES_COUNT_KEY];
        [params setObject:[NSNumber numberWithInt:[[imageDict objectForKey:PICTURE_COMMENT_COUNT_KEY]intValue]] forKey:PICTURE_COMMENT_COUNT_KEY];
        [[DAL sharedInstance] createImageWithParams:params];
        RELEASE_SAFELY(params);
        
        
    }
    int picCount = [[DAL sharedInstance] getPicCountOfProfile:userProfile.user_id];
    lblPicture.text = [NSString stringWithFormat:@"%d pictures",picCount];
    if (picCount == 0)
        lblPicture.text = [NSString stringWithFormat:@"%d pictures",[userProfile.image_count intValue]];
    int previousCount = picturesArray.count;
    RELEASE_SAFELY(picturesArray);
    picturesArray = [[[DAL sharedInstance] getAllPicturesOfUser:userProfile.user_id] retain];
    if (self.currentSelection ==2 && previousCount!=picCount)
        [self changeSection:[NSNumber numberWithInt:self.currentSelection]];
    
}


- (void)showImages:(NSInteger)tag
{

    [tblView reloadData];
}

-(void)pictureSelected:(id)sender 
{
    UIButton *button = (UIButton *)sender;
    if (selectedPicture)
        RELEASE_SAFELY(selectedPicture);
    selectedPicture = [[[DAL sharedInstance] getImageByImageID:[NSString stringWithFormat:@"%d",button.tag]] retain];
    [self performSegueWithIdentifier:@"AlbumView" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"AlbumView"])
    {
        AlbumViewController *controller = (AlbumViewController *)[segue destinationViewController];
        [controller setDelegate:self];
        [controller setPic:selectedPicture];
        [controller setPicArray:[NSArray arrayWithArray:picturesArray]];
        RELEASE_SAFELY(selectedPicture);
    }
    else if ([[segue identifier]isEqualToString:@"ProfileView"]) 
    {
        ProfileViewController *controller = (ProfileViewController *)[segue destinationViewController];
        Profile *selectedProfile = [[DAL sharedInstance] getProfileByID:selectedID];
        RELEASE_SAFELY(selectedID);
        [controller setUserProfile:selectedProfile];
    }
}




- (void)profileSelectedPUSH:(NSString *)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    
    
    
    //selectedID = [[NSString stringWithFormat:@"%d",sender.tag] retain];
    
    NSLog(@"%@",[[DAL sharedInstance] getProfileByID:sender]);
    
    if (![[DAL sharedInstance] getProfileByID:sender])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoProfileView:) name:NOTIFICATION_PROFILE_SAVED object:nil];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:sender];
    }
    else
        [self gotoProfileView:nil];
    
}




- (void)profileSelected:(UIButton *)sender
{
    //[self dismissModalViewControllerAnimated:YES];
    selectedID = [[NSString stringWithFormat:@"%d",sender.tag] retain];
    
    NSLog(@"%@",[[DAL sharedInstance] getProfileByID:selectedID]);
    
    if (![[DAL sharedInstance] getProfileByID:selectedID])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoProfileView:) name:NOTIFICATION_PROFILE_SAVED object:nil];
        [[Utility sharedInstance] getCompleteProfileAndThenSaveToDB:selectedID];
    }
    else
        [self gotoProfileView:nil];

}

- (void)gotoProfileView:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSegueWithIdentifier:@"ProfileView" sender:self];
}

- (void)followID:(id)sender
{
    if (followRequest)
    {
        [followRequest setDelegate:nil];
        RELEASE_SAFELY(followRequest);
    }
    followRequest = [[WebServices alloc] init];
    followRequest.delegate = self;

    if (![[DAL sharedInstance] isFollowing:userProfile.user_id])
    {
        [followRequest followFriend:userProfile.user_id];
    }
    else
    {
        Profile *profile = [[DAL sharedInstance] getProfileByID:[Utility userID]];
        Profile *followingProfile = [[DAL sharedInstance] getProfileByID:userProfile.user_id];
        [profile removeFollowingObject:followingProfile];
        [[DAL sharedInstance] saveContext];
        [btnFollow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btnFollow setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateHighlighted];
        [followRequest unFollowFriend:userProfile.user_id];
    }

}

- (void)popViewController
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PUSH"] isEqualToString:@"PUSH"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"PUSH1" forKey:@"PUSH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)disappearAlbumView
{
    [self dismissModalViewControllerAnimated:YES];
}

# pragma mark UITable view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (currentSelection) {
        case 0:
        {
            RELEASE_SAFELY(displayArray);
            displayArray = [[NSArray alloc] initWithArray:followingArray];
            return (!followingArray || followingArray.count==0)?0:ceil((float)followingArray.count/4);
        }
            break;
        case 1:
        {
            RELEASE_SAFELY(displayArray);
            displayArray = [[NSArray alloc] initWithArray:followersArray];
            return (!followersArray || followersArray.count==0)?0:ceil((float)followersArray.count/4);
        }
            break;
        case 2:
        {
            RELEASE_SAFELY(displayArray);
            displayArray = [[NSArray alloc] initWithArray:picturesArray];
            return (!picturesArray || picturesArray.count==0)?0:ceil((float)picturesArray.count/4);
        }
            break;
        default:
        {
            RELEASE_SAFELY(displayArray);
            displayArray = [[NSArray alloc] initWithArray:picturesArray];
            return (!picturesArray || picturesArray.count==0)?0:ceil((float)picturesArray.count/4);
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    int index= indexPath.row*4;
    if (index < displayArray.count)
    {
        FLButton *imgBtn = cell.btn1;
        [imgBtn.imageView getWhiteBorderImage];
        [imgBtn removeTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.btn1 viewWithTag:99])
        {
            [[cell.btn1 viewWithTag:99] removeFromSuperview];
        }
        [cell.btn1 setHidden:NO];
        if ([[displayArray objectAtIndex:index]isKindOfClass:[Picture class]])
        {
            UILongPressGestureRecognizer *gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
            if ([userProfile.user_id isEqualToString:[Utility userID]])
                [imgBtn addGestureRecognizer:gesture];
            Picture *pic = [displayArray objectAtIndex:index];
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
            [imgBtn removeTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
        else 
        {
            [cell.btn1 removeTarget:self action:@selector(handleGesture:) forControlEvents:UIControlEventAllEvents];
            Profile *profile = [displayArray objectAtIndex:index];
            if (!profile.picture)
            {
                [imgBtn setImageWithProfile:profile];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
            }
            else {
                [imgBtn setImageWithDataInBackGround:profile.picture];
            }
            [imgBtn setTag:[profile.user_id integerValue]];
            [imgBtn removeTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
    }
    else {
        [cell.btn1 setHidden:YES];
    }
    if (index < displayArray.count)
    {
        FLButton *imgBtn = cell.btn2;
        [imgBtn.imageView getWhiteBorderImage];
        [imgBtn removeTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.btn2 viewWithTag:99])
        {
            [[cell.btn2 viewWithTag:99] removeFromSuperview];
        }
        [cell.btn2 setHidden:NO];
        if ([[displayArray objectAtIndex:index]isKindOfClass:[Picture class]])
        {
            UILongPressGestureRecognizer *gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
            if ([userProfile.user_id isEqualToString:[Utility userID]])
                [imgBtn addGestureRecognizer:gesture];
            Picture *pic = [displayArray objectAtIndex:index];
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
            [imgBtn removeTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
        else 
        {
            [cell.btn2 removeTarget:self action:@selector(handleGesture:) forControlEvents:UIControlEventAllEvents];
            Profile *profile = [displayArray objectAtIndex:index];
            if (!profile.picture)
            {
                [imgBtn setImageWithProfile:profile];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
            }
            else {
                [imgBtn setImageWithDataInBackGround:profile.picture];
            }
            [imgBtn setTag:[profile.user_id integerValue]];
            [imgBtn removeTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
        
    }
    else {
        [cell.btn2 setHidden:YES];
    }
    if (index < displayArray.count)
    {
        FLButton *imgBtn = cell.btn3;
        [imgBtn.imageView getWhiteBorderImage];
        [imgBtn removeTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.btn3 viewWithTag:99])
        {
            [[cell.btn3 viewWithTag:99] removeFromSuperview];
        }
        [cell.btn3 setHidden:NO];
        if ([[displayArray objectAtIndex:index]isKindOfClass:[Picture class]])
        {
            UILongPressGestureRecognizer *gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
            if ([userProfile.user_id isEqualToString:[Utility userID]])
                [imgBtn addGestureRecognizer:gesture];
            Picture *pic = [displayArray objectAtIndex:index];
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
            [imgBtn removeTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
        else 
        {
            [cell.btn3 removeTarget:self action:@selector(handleGesture:) forControlEvents:UIControlEventAllEvents];
            Profile *profile = [displayArray objectAtIndex:index];
            if (!profile.picture)
            {
                [imgBtn setImageWithProfile:profile];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
            }
            else {
                [imgBtn setImageWithDataInBackGround:profile.picture];
            }
            [imgBtn setTag:[profile.user_id integerValue]];
            [imgBtn removeTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
    }
    else {
        [cell.btn3 setHidden:YES];
    }
    if (index < displayArray.count)
    {
        FLButton *imgBtn = cell.btn4;
        [imgBtn.imageView getWhiteBorderImage];
        [imgBtn removeTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        if ([cell.btn4 viewWithTag:99])
        {
            [[cell.btn4 viewWithTag:99] removeFromSuperview];
        }
        [cell.btn4 setHidden:NO];
        if ([[displayArray objectAtIndex:index]isKindOfClass:[Picture class]])
        {
            UILongPressGestureRecognizer *gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
            if ([userProfile.user_id isEqualToString:[Utility userID]])
                [imgBtn addGestureRecognizer:gesture];
            Picture *pic = [displayArray objectAtIndex:index];
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
            [imgBtn removeTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
        else 
        {
            [cell.btn4 removeTarget:self action:@selector(handleGesture:) forControlEvents:UIControlEventAllEvents];
            Profile *profile = [displayArray objectAtIndex:index];
            if (!profile.picture)
            {
                [imgBtn setImageWithProfile:profile];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                [imgBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateHighlighted];
            }
            else {
                [imgBtn setImageWithDataInBackGround:profile.picture];
            }
            [imgBtn setTag:[profile.user_id integerValue]];
            [imgBtn removeTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn addTarget:self action:@selector(profileSelected:) forControlEvents:UIControlEventTouchUpInside];
            index ++;
        }
    }
    else {
        [cell.btn4 setHidden:YES];
    }
    return cell;
    
}


# pragma mark - delete image method

- (void)handleGesture:(id)sender
{
    
    UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)sender;
    FLButton *btn = (FLButton *)gestureRecognizer.view;
    DLog(@"%d",btn.tag);
    
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) 
    {
        [btn.layer addAnimation:[self getShakeAnimation] forKey:@"transform"];
    }
    else 
    {
        DLog(@"long press ended");
        UIImageView *imgVw = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yellowCross"]] autorelease];
        [imgVw setFrame:CGRectMake(55, -8, 19, 25)];
        [imgVw setTag:99];
        [btn addSubview:imgVw];
        [btn.imageView getBorderImageOfColor:[UIColor yellowColor]];
        
        [btn removeTarget:self action:@selector(pictureSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    

}

- (void)deleteImage:(id)sender
{    
    FLButton *btn = (FLButton *)sender;
    DLog(@"%d",btn.tag);
    
    BlackAlertView *alert = [[[BlackAlertView alloc] initWithTitle:@"Delete Image" message:@"Are you sure, you want to delete this image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil]autorelease];
    [alert setTag:btn.tag];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!= alertView.cancelButtonIndex)
    {
        Picture *pic = [[DAL sharedInstance] getImageByImageID:[NSString stringWithFormat:@"%d",alertView.tag]];
        [[[DAL sharedInstance] managedObjectContext] deleteObject:pic];

        RELEASE_SAFELY(picturesArray);
        picturesArray = [[[DAL sharedInstance] getAllPicturesOfUser:userProfile.user_id] retain];
        RELEASE_SAFELY(displayArray);
        displayArray = [[NSArray alloc] initWithArray:picturesArray];
        
        int picCount = [[DAL sharedInstance] getPicCountOfProfile:userProfile.user_id];
        userProfile.image_count = [NSNumber numberWithInt:picCount];
        lblPicture.text = [NSString stringWithFormat:@"%d pictures",picCount];
        [[DAL sharedInstance] saveContext];
        [tblView reloadData];
        
        if (deleteImageRequest)
        {
            deleteImageRequest.delegate = nil;
            RELEASE_SAFELY(deleteImageRequest);
        }
        deleteImageRequest = [[WebServices alloc] init];
        deleteImageRequest.delegate = self;
        [deleteImageRequest deleteImage:[NSString stringWithFormat:@"%d",alertView.tag]];
    }
}


- (CAAnimation*)getShakeAnimation {
    
    CABasicAnimation *animation;
    CATransform3D transform;
    // Create the rotation matrix
    transform = CATransform3DMakeRotation(0.08, 0, 0, 1.0);
    // Create a basic animation to animate the layer's transform
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    // Assign the transform as the animation's value
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.autoreverses = YES;
    animation.duration = 0.1;
    animation.repeatCount = HUGE_VALF;
    return animation;
    
}

@end
