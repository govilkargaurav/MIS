//
//  MyFeedsViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyFeedsViewController.h"
#import "MyAppManager.h"
#import "IIViewDeckController.h"
#import "PhotoZoomViewController.h"
#import "AllFeedsCustomCell.h"
#import "CustomBadge.h"

static NSUInteger selectedIndexPath;

@interface MyFeedsViewController ()
{
    BOOL isExpand;
    IBOutlet UIButton *btnAddPost;
}
@end

@implementation MyFeedsViewController
@synthesize action,dataCoverImage,dataProfileImage,imgFlag,TblView,viewHeader;

#pragma mark - Notification Count
-(void)updateNotificationCOUNTMyFeed:(NSNotification *)notif
{
     [[SDWebImageDownloader sharedDownloader]setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
    NSString *strNotiCount = [NSString stringWithFormat:@"%@",[notif.object valueForKey:@"total_badges"]];
    if([[self removeNull:strNotiCount] integerValue]!=0)
    {
        CustomBadge *PendingRequestCountBadge = [CustomBadge customBadgeWithString:[self removeNull:strNotiCount] withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.7 withShining:YES];
        [PendingRequestCountBadge setFrame:CGRectMake(35,5+iOS7ExHeight, PendingRequestCountBadge.frame.size.width, PendingRequestCountBadge.frame.size.height)];
        PendingRequestCountBadge.tag = 160160;
        [self.view addSubview:PendingRequestCountBadge];
        [self.view bringSubviewToFront:PendingRequestCountBadge];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showWinkCount" object:notif.object];
    }
    else
    {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[CustomBadge class]])
            {
                if (subview.tag==160160)
                {
                    [subview removeFromSuperview];
                }
            }
        }
    }
}
-(void)hideNotificationCOUNTMyFeed
{
    for (UIView *subview in self.view.subviews)
    {
        if ([subview isKindOfClass:[CustomBadge class]])
        {
            if (subview.tag==160160)
            {
                [subview removeFromSuperview];
            }
        }
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    dictWebViews=[[NSMutableDictionary alloc]init];
    
    //When Watch Video
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNotificationCOUNTMyFeed:) name:@"updateNotificationCOUNTMyFeed" object:[[NSUserDefaults standardUserDefaults]objectForKey:@"LaunchOption"]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideNotificationCOUNTMyFeed) name:@"hideNotificationCOUNTMyFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bgpostrefresh:) name:kNotifyBGPostRefresh object:nil];
    [[MyAppManager sharedManager] startBackGroundUpload];
    
    webData = [[NSMutableData alloc]init];
    dataProfileImage=[[NSMutableData alloc]init];
    dataCoverImage=[[NSMutableData alloc]init];
    
    self.action = @"";
    self.imgFlag = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateImage:) name:@"updateCoverPic" object:nil];
    [self customiseNavBar];
    
    TblView.tableHeaderView = viewHeader;
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.TblView];
    [pull setDelegate:self];
    [self.TblView addSubview:pull];
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.TblView withClient:self];
    
    [self refreshHeader];
    [[AppDelegate sharedInstance]showLoader];
    [self performSelector:@selector(updateInitialTable) withObject:nil afterDelay:0.5];
    
    [TblView setContentOffset:CGPointMake(0, 1.0)];
}

-(void)updateInitialTable
{
    [self updateJSONDataWithArray:[NSMutableArray array] deleteArray:[NSMutableArray array] removedFriendsArray:[NSMutableArray array] updatedFriendsArray:[NSMutableArray array] updatedLikesArray:[NSMutableArray array] updateJSON:NO appendUpdateAtStart:YES];
    
    if ([[MyAppManager sharedManager] arrMyFeeds]==0)
    {
        strPostSuccessful = @"RefreshView";
        strPostSuccessful = @"0";
        [self performSelector:@selector(loadFeeds) withObject:nil afterDelay:0.1];
    }
    else
    {
        [[AppDelegate sharedInstance]hideLoader];
        [self loadFeedUpdates];
    }
}
-(void)customiseNavBar
{
    self.navigationController.navigationBar.hidden=TRUE;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    UIButton *btnOption = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOption setBackgroundColor:[UIColor clearColor]];
    [btnOption setImage:[UIImage imageNamed:@"btnprevious"] forState:UIControlStateNormal];
    [btnOption setFrame:CGRectMake(0,iOS7ExHeight, 54, 45)];
    [btnOption addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOption];
    
    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnContact setBackgroundColor:[UIColor clearColor]];
    [btnContact setImage:[UIImage imageNamed:@"btnfriendsection"] forState:UIControlStateNormal];
    [btnContact setFrame:CGRectMake(211,iOS7ExHeight, 54, 45)];
    [btnContact addTarget:self action:@selector(pushfriendview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContact];
    
    lblUserNameTOP.text = [NSString stringWithFormat:@"%@",[self removeNull:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_fname"]]];
    
    viewmenu.frame=CGRectMake(0,-8.0+iOS7ExHeight, 320.0, 57.0);
}

-(void)refreshHeader
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
    [self updateInviteCount];
    
    BOOL isPopular = ([[userDefaults valueForKey:@"eAccountStatus"] isEqualToString:@"Popular"])?YES:NO;
    
    int count=[[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"numFriends"]] intValue];
    int badgecount=(count>=100)?100:((count>=50)?50:((count>=20)?20:0));
    imgBadge.image = [UIImage imageNamed:[NSString stringWithFormat:@"badge%@_%d.png",(isPopular)?@"p":@"",badgecount]];
    
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    imgProfile.tag=1001;
    [imgProfile setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    
    NSURL *imgURLCover = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"COVERPIC_URL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    imgCoverPic.tag=1003;
    [imgCoverPic setImageWithURL:imgURLCover placeholderImage:[UIImage imageNamed:@""]];
    
    float widthCover = [[userDefaults valueForKey:@"width_coverPic"] floatValue];

    float heightCover = [[userDefaults valueForKey:@"height_coverPic"] floatValue];
    widthCover=MAX(100, widthCover);
    heightCover=MAX(100, heightCover);
    
    float viewheight=MAX((heightCover*320.0)/widthCover, 225.0);
    float imgdiff=(viewheight==225.0)?((225.0-((heightCover*320.0)/widthCover))/2.0):0.0;
    imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
    btnCoverPic.frame = imgCoverPic.frame;
    viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
    TblView.tableHeaderView = viewHeader;

    NSString *strSchoolName = [NSString stringWithFormat:@"%@",[self removeNull:[userDefaults valueForKey:@"school"]]];
    if ([strSchoolName isEqualToString:@""])
    {
        lblUserName.text = [NSString stringWithFormat:@""];
    }
    else
    {
        lblUserName.text = [NSString stringWithFormat:@"%@",[self removeNull:[userDefaults valueForKey:@"school"]]];
    }
    
    NSString *strnumFriends = [NSString stringWithFormat:@"%@",[self removeNull:[userDefaults valueForKey:@"numFriends"]]];
    if ([strnumFriends isEqualToString:@""])
    {
        lblNumOfFriends.text = [NSString stringWithFormat:@""];
    }
    else
    {
        lblNumOfFriends.text = [NSString stringWithFormat:@"%@ Friends",[self removeNull:[userDefaults valueForKey:@"numFriends"]]];
    }
    
    lblUserName.colors=[NSArray arrayWithObjects:
                        [UIColor colorWithWhite:1.0 alpha:1.0],
                        [UIColor colorWithWhite:1.0 alpha:0.8],
                        nil];
    lblUserName.textAlignment=UITextAlignmentLeft;
    [lblUserName setShadowOffset:CGSizeMake(0,0) radius:2.0];
    
    lblNumOfFriends.colors=[NSArray arrayWithObjects:
                        [UIColor colorWithWhite:1.0 alpha:1.0],
                        [UIColor colorWithWhite:1.0 alpha:0.8],
                        nil];
    lblNumOfFriends.textAlignment=UITextAlignmentLeft;
    [lblNumOfFriends setShadowOffset:CGSizeMake(0,0) radius:2.0];
    
    lblstatus.colors=[NSArray arrayWithObjects:
                      [UIColor colorWithWhite:1.0 alpha:1.0],
                      [UIColor colorWithWhite:1.0 alpha:0.8],
                      nil];
    lblstatus.textAlignment=UITextAlignmentLeft;
    [lblstatus setShadowOffset:CGSizeMake(0,0) radius:0.5];
}
-(void)updateInviteCount
{
    NSString *strREQCount = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]valueForKey:@"Received_Request_count"]];
    
    if([[self removeNull:strREQCount] integerValue]!=0)
    {
        CustomBadge *PendingRequestCountBadge = [CustomBadge customBadgeWithString:[self removeNull:strREQCount] withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.7 withShining:YES];
        [PendingRequestCountBadge setFrame:CGRectMake(240,0+iOS7ExHeight, PendingRequestCountBadge.frame.size.width, PendingRequestCountBadge.frame.size.height)];
        [self.view addSubview:PendingRequestCountBadge];
    }
    else
    {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[CustomBadge class]])
            {
                [subview removeFromSuperview];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateInviteCount];
    
    [[MyAppManager sharedManager] startBackGroundUpload];

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LaunchOption"] objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"])
    {
        NSDictionary *dictNotificationReceiver = [[NSDictionary alloc]initWithDictionary:[[[NSUserDefaults standardUserDefaults]objectForKey:@"LaunchOption"]valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNotificationCOUNTMyFeed" object:dictNotificationReceiver];
    }
    
    [self updateJSONDataWithArray:[NSMutableArray array] deleteArray:[NSMutableArray array] removedFriendsArray:[NSMutableArray array] updatedFriendsArray:[NSMutableArray array]  updatedLikesArray:[NSMutableArray array] updateJSON:NO appendUpdateAtStart:YES];
    
    if (shouldLoadUpdates)
    {
        shouldLoadUpdates=NO;
        TblView.delegate = nil;
        TblView.dataSource = nil;
        self.TblView.contentOffset = CGPointMake(0, -65);
        [pull setState:PullToRefreshViewStateLoading];
        [self performSelector:@selector(loadFeedUpdates) withObject:nil afterDelay:0.01];
    }
}


-(void)bgpostrefresh:(NSNotification *)notification
{
    [self updateJSONDataWithArray:nil deleteArray:nil removedFriendsArray:nil updatedFriendsArray:nil updatedLikesArray:nil updateJSON:NO appendUpdateAtStart:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - DATA UPDATES
-(void)loadFeeds
{
    [self updateInviteCount];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        [[AppDelegate sharedInstance]hideLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        DisplayNoInternate;
        return;
    }
    else
    {
        NSMutableData *postData = [NSMutableData data];
        NSString *strURL=[NSString stringWithFormat:@"userID=%@&isSync=NO&dtSyncDateTime=",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        
        [postData appendData: [[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:strgetMyFeeds]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        NSError *theError;
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&theError];
        [pull finishedLoading];
        [[AppDelegate sharedInstance]hideLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        if (theError)
        {
            DisplayAlert(theError.localizedDescription)
            return;
        }
        
//        NSString *strResp=[[NSString alloc]initWithData:myData encoding:NSUTF8StringEncoding];
//        NSLog(@"Hiii the lodd strResp:%@",strResp);
//
        
        NSMutableDictionary *dictFeedData = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        
        if (dictFeedData ==(id) [NSNull null])
        {
            return;
        }
       
        if ([dictFeedData objectForKey:@"LoggedinUser"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictFeedData objectForKey:@"LoggedinUser"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self refreshHeader];

        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictFeedData objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            NSMutableArray *arrRecords=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"USER_RECORDS"]];
            [self updateJSONDataWithArray:arrRecords deleteArray:[NSMutableArray array] removedFriendsArray:[NSMutableArray array] updatedFriendsArray:[NSMutableArray array] updatedLikesArray:[NSMutableArray array] updateJSON:YES appendUpdateAtStart:YES];
        }
    }
}

#pragma mark -

-(void)loadFeedUpdates
{
    [self updateInviteCount];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        [[AppDelegate sharedInstance]hideLoadingView];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        DisplayNoInternate;
        return;
    }
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
        NSString *strFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
        
        NSMutableData *postData = [NSMutableData data];
        
        NSMutableDictionary *dictJSONData=[strFileName getDataFromFile];
        NSString *strURL;
        
        if ([[dictJSONData objectForKey:@"success"] isEqualToString:@"0"]) {
            strURL=[NSString stringWithFormat:@"userID=%@&isSync=NO&dtSyncDateTime=",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        else
        {
            strURL=[NSString stringWithFormat:@"userID=%@&isSync=YES&dtSyncDateTime=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[strFileName getDataFromFile] objectForKey:@"lastsync"]];
        }
        
        
        [postData appendData: [[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:strgetMyFeeds]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        NSError *theError;
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&theError];
        [pull finishedLoading];
        [[AppDelegate sharedInstance]hideLoadingView];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        if (theError)
        {
            DisplayAlert(theError.localizedDescription)
            return;
        }
        
        NSMutableDictionary *dictFeedData = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        
        if (dictFeedData ==(id) [NSNull null])
        {
            return;
        }
        
        if ([dictFeedData objectForKey:@"LoggedinUser"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictFeedData objectForKey:@"LoggedinUser"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self refreshHeader];
        
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictFeedData objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            NSMutableArray *arrRecords=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"USER_RECORDS"]];
            NSMutableArray *arrdeletedRecords=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"deleted_id"]];
            NSMutableArray *arrremovedFriends=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"removedFrnds"]];
            NSMutableArray *arrupdatedFriends=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"updatedProfiles"]];
            NSMutableArray *arrupdatedLikes=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"updatedData"]];
            //updatedLikesArray:arrupdatedLikes
            
            [self updateJSONDataWithArray:arrRecords deleteArray:arrdeletedRecords  removedFriendsArray:arrremovedFriends updatedFriendsArray:arrupdatedFriends  updatedLikesArray:arrupdatedLikes  updateJSON:YES appendUpdateAtStart:YES];
        }
        else
        {
            [self updateJSONDataWithArray:[NSMutableArray array] deleteArray:[NSMutableArray array]  removedFriendsArray:[NSMutableArray array] updatedFriendsArray:[NSMutableArray array] updatedLikesArray:[NSMutableArray array] updateJSON:NO appendUpdateAtStart:YES];
        }
    }
}
-(void)foregroundRefresh:(NSNotification *)notification
{
    TblView.delegate = nil;
    TblView.dataSource = nil;
    self.TblView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self performSelector:@selector(loadFeedUpdates) withObject:nil afterDelay:0.01];
}
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideNotificationCOUNTMyFeed" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideWinkCount" object:nil];
    [self performSelector:@selector(loadFeedUpdates) withObject:nil afterDelay:0.01];
}

#pragma mark -
-(void)loadOlderFeeds
{
    [self updateInviteCount];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        [[AppDelegate sharedInstance]hideLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [pullToRefreshManager_ tableViewReloadFinished];
        DisplayNoInternate;
        return;
    }
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
        NSString *strFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
        
        NSMutableData *postData = [NSMutableData data];
        NSString *strURL=[NSString stringWithFormat:@"userID=%@&isSync=NO&dtSyncDateTime=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[strFileName getDataFromFile] objectForKey:@"oldestfeed"]];
        
        [postData appendData: [[strURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:strgetMyFeeds]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        NSError *theError;
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&theError];
        [pullToRefreshManager_ tableViewReloadFinished];
        [[AppDelegate sharedInstance]hideLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        if (theError)
        {
            DisplayAlert(theError.localizedDescription)
            return;
        }

        NSMutableDictionary *dictFeedData = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        
        if (dictFeedData ==(id) [NSNull null])
        {
            return;
        }
        
        if ([dictFeedData objectForKey:@"LoggedinUser"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictFeedData objectForKey:@"LoggedinUser"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        [self refreshHeader];
        
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictFeedData objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        else if ([strMSG isEqualToString:@"SUCCESS"])
        {
            NSMutableArray *arrRecords=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"USER_RECORDS"]];
            NSMutableArray *arrdeletedRecords=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"deleted_id"]];
            NSMutableArray *arrremovedFriends=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"removedFrnds"]];
            NSMutableArray *arrupdatedFriends=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"updatedProfiles"]];
            NSMutableArray *arrupdatedLikes=[[NSMutableArray alloc]initWithArray:[dictFeedData valueForKey:@"updatedData"]];
            //updatedLikesArray:arrupdatedLikes
            [self updateJSONDataWithArray:arrRecords deleteArray:arrdeletedRecords  removedFriendsArray:arrremovedFriends updatedFriendsArray:arrupdatedFriends updatedLikesArray:arrupdatedLikes updateJSON:YES appendUpdateAtStart:NO];
        }
        else if ([strMSG isEqualToString:@"DATA NOT FOUND."])
        {
            DisplayAlertWithTitle(APP_Name, @"No More Feed Available!");
            return;
        }
        else
        {
            DisplayAlertWithTitle(APP_Name, strMSG);
            return;
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isExpand)
    {
        TblView.frame=CGRectMake(0,106.0+iOS7ExHeight,320,460-49-57+iPhone5ExHeight);
    }
    else
    {
        TblView.frame=CGRectMake(0,49.0+iOS7ExHeight,320,460-49+iPhone5ExHeight);
    }
    
//    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]]];
    [pullToRefreshManager_ tableViewScrolled];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [pullToRefreshManager_ tableViewReleased];
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[AppDelegate sharedInstance]showLoader];
    [self performSelector:@selector(loadOlderFeeds) withObject:nil afterDelay:1.0f];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [pullToRefreshManager_ relocatePullToRefreshView];
}
-(void)updateJSONDataWithArray:(NSMutableArray *)updateArray deleteArray:(NSMutableArray *)deleteArray removedFriendsArray:(NSMutableArray *)removedFriendsArray  updatedFriendsArray:(NSMutableArray *)updatedFriendsArray updatedLikesArray:(NSMutableArray *)updatedLikesArray updateJSON:(BOOL)shouldupdateJSON  appendUpdateAtStart:(BOOL)appendUpdateAtStart
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
    
    NSString *strFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
    NSMutableArray *oldDataArray=[[NSMutableArray alloc]init];
    NSMutableArray *finalDataArray=[[NSMutableArray alloc]init];
    
    BOOL shouldUpdateLastSyncTime=YES;
    NSString *strLastSyncTime;
    
    if ([[strFileName getDataFromFile] objectForKey:@"USER_RECORDS"])
    {
        NSDictionary *dictTemp=[strFileName getDataFromFile];
        [oldDataArray addObjectsFromArray:[dictTemp objectForKey:@"USER_RECORDS"]];
        strLastSyncTime=[NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"lastsync"]];
        
        NSInteger totalfeedschange=[updateArray count]+[deleteArray count]+[removedFriendsArray count]+[updatedFriendsArray count]+[updatedLikesArray count];
        
        shouldUpdateLastSyncTime=(totalfeedschange>0)?YES:NO;
    }
//    else if ([updateArray count]==0)
//    {
//        return;
//    }
    
    for (int i=0; i<[removedFriendsArray count]; i++)
    {
        NSString *strFriendID=[NSString stringWithFormat:@"%@",[[removedFriendsArray objectAtIndex:i] objectForKey:@"iFriendsID"]];
        
        for (int i=([oldDataArray count]-1); i>=0; i--)
        {
            NSDictionary *dictFeed=[NSDictionary dictionaryWithDictionary:[oldDataArray objectAtIndex:i]];
            NSString *strAdmin=[NSString stringWithFormat:@"%@",[[dictFeed objectForKey:@"iAdminID"] removeNull]];
            BOOL feedExists=NO;
            
            if ([strAdmin isEqualToString:strFriendID])
            {
                feedExists=YES;
            }
            
            if (feedExists)
            {
                [oldDataArray removeObjectAtIndex:i];
            }
        }
    }
    
    for (int i=0; i<[deleteArray count]; i++)
    {
        NSDictionary *dictupdateFeed=[NSDictionary dictionaryWithDictionary:[deleteArray objectAtIndex:i]];
        
        for (int i=([oldDataArray count]-1); i>=0; i--)
        {
            NSDictionary *dictFeed=[NSDictionary dictionaryWithDictionary:[oldDataArray objectAtIndex:i]];
            NSString *strTypeOfContent=[NSString stringWithFormat:@"%@",[[dictFeed objectForKey:@"vType_of_content"] removeNull]];
            BOOL feedExists=NO;
            
            if ([strTypeOfContent isEqualToString:@"activity"])
            {
                if ([[[dictFeed objectForKey:@"iActivityID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"location"])
            {
                if ([[[dictFeed objectForKey:@"iGroupLocationID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"image"])
            {
                if ([[[dictFeed objectForKey:@"iImageID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"video"])
            {
                if ([[[dictFeed objectForKey:@"iVideoID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"music"])
            {
                if ([[[dictFeed objectForKey:@"iMusicID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"wrote"])
            {
                if ([[[dictFeed objectForKey:@"wrote_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"birthdaywish"])
            {
                if ([[[dictFeed objectForKey:@"birthdaywish_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"nowfriends"])
            {
                if ([[[dictFeed objectForKey:@"nowfriends_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"badge"])
            {
                if ([[[dictFeed objectForKey:@"badge_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"profile_update"])
            {
                if ([[[dictFeed objectForKey:@"profileupdate_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"winked"])
            {
                if ([[[dictFeed objectForKey:@"wink_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            
            if (feedExists)
            {
                [oldDataArray removeObjectAtIndex:i];
            }
        }
    }
    
    for (int j=0; j<[updateArray count]; j++)
    {
        NSDictionary *dictupdateFeed=[NSDictionary dictionaryWithDictionary:[updateArray objectAtIndex:j]];
        
        for (int i=([oldDataArray count]-1); i>=0; i--)
        {
            NSDictionary *dictFeed=[NSDictionary dictionaryWithDictionary:[oldDataArray objectAtIndex:i]];
            NSString *strTypeOfContent=[NSString stringWithFormat:@"%@",[[dictFeed objectForKey:@"vType_of_content"] removeNull]];
            BOOL feedExists=NO;
            
            if ([strTypeOfContent isEqualToString:@"activity"])
            {
                if ([[[dictFeed objectForKey:@"iActivityID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"location"])
            {
                if ([[[dictFeed objectForKey:@"iGroupLocationID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iGroupLocationID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"image"])
            {
                if ([[[dictFeed objectForKey:@"iImageID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iImageID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"video"])
            {
                if ([[[dictFeed objectForKey:@"iVideoID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iVideoID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"music"])
            {
                if ([[[dictFeed objectForKey:@"iMusicID"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iMusicID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"wrote"])
            {
                if ([[[dictFeed objectForKey:@"wrote_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"birthdaywish"])
            {
                if ([[[dictFeed objectForKey:@"birthdaywish_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if ([strTypeOfContent isEqualToString:@"nowfriends"])
            {
                if ([[[dictFeed objectForKey:@"nowfriends_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"badge"])
            {
                if ([[[dictFeed objectForKey:@"badge_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"profile_update"])
            {
                if ([[[dictFeed objectForKey:@"profileupdate_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            else if([strTypeOfContent isEqualToString:@"winked"])
            {
                if ([[[dictFeed objectForKey:@"wink_id"] removeNull] isEqualToString:[[dictupdateFeed objectForKey:@"iActivityID"] removeNull]]) {
                    feedExists=YES;
                }
            }
            
            if (feedExists)
            {
                [oldDataArray removeObjectAtIndex:i];
            }
        }
    }
    
    for (int i=0; i<[updatedFriendsArray count]; i++)
    {
        for (int j=0; j<[oldDataArray count];j++)
        {
            NSString *strUpdatedUID=[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_id"]];
            NSString *strOldUID=[NSString stringWithFormat:@"%@",[[[oldDataArray objectAtIndex:j] objectForKey:@"UserInfo"] objectForKey:@"admin_id"]];
            
            if ([strUpdatedUID isEqualToString:strOldUID])
            {
                if (![[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"birthdaywish"])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    [theDict setObject:[updatedFriendsArray objectAtIndex:i] forKey:@"UserInfo"];
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
            }
            
            if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"wrote"])
            {
                NSString *striAdminUID=[[oldDataArray objectAtIndex:j] objectForKey:@"iAdminID"];
                
                if ([strUpdatedUID isEqualToString:striAdminUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@%@%@",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull],([[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull]length]>0)?@" ":@"",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_lname"] removeNull]] forKey:@"wrotedOn_Name"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"Just wrote a note on %@'s page",[theDict objectForKey:@"wrotedOn_Name"]] forKey:@"generalText"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"image_path"]] forKey:@"wrotedOn_image_path"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"school"]] forKey:@"wroteOn_School"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
            }
            else if([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"nowfriends"])
            {
                NSString *striAdminUID=[[oldDataArray objectAtIndex:j] objectForKey:@"iAdminID"];
                
                if ([strUpdatedUID isEqualToString:striAdminUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    NSString *strFriendName=[NSString stringWithFormat:@"%@",[theDict objectForKey:@"fullname_iAdminID"]];
                    [theDict setObject:[NSString stringWithFormat:@"%@%@%@",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull],([[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull]length]>0)?@" ":@"",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_lname"] removeNull]] forKey:@"fullname_iAdminID"];
                    
                    NSMutableString *strActivityText=[[NSMutableString alloc]initWithFormat:@"%@",[theDict objectForKey:@"vActivityText"]];
                    
                    NSString *newActString = [strActivityText stringByReplacingOccurrencesOfString:strFriendName withString:[theDict objectForKey:@"fullname_iAdminID"]];
                    [strActivityText setString:newActString];
                    [theDict setObject:strActivityText forKey:@"vActivityText"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"image_path"]] forKey:@"image_path_iAdminID"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
                
                NSString *striFriendUID=[[oldDataArray objectAtIndex:j] objectForKey:@"iFriendsID"];
                
                if ([strUpdatedUID isEqualToString:striFriendUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    NSString *strFriendName=[NSString stringWithFormat:@"%@",[theDict objectForKey:@"fullname_iFriendsID"]];
                    [theDict setObject:[NSString stringWithFormat:@"%@%@%@",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull],([[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull]length]>0)?@" ":@"",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_lname"] removeNull]] forKey:@"fullname_iFriendsID"];
                    
                    NSMutableString *strActivityText=[[NSMutableString alloc]initWithFormat:@"%@",[theDict objectForKey:@"vActivityText"]];
                    
                    NSString *newActString = [strActivityText stringByReplacingOccurrencesOfString:strFriendName withString:[theDict objectForKey:@"fullname_iFriendsID"]];
                    [strActivityText setString:newActString];
                    [theDict setObject:strActivityText forKey:@"vActivityText"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"image_path"]] forKey:@"image_path_iFriendsID"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
                
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"birthdaywish"])
            {
                NSString *striAdminUID=[[oldDataArray objectAtIndex:j] objectForKey:@"iAdminID"];
                
                if ([strUpdatedUID isEqualToString:striAdminUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@%@%@",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull],([[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull]length]>0)?@" ":@"",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_lname"] removeNull]] forKey:@"birthdaywishdOn_Name"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"Wish %@ a Happy Birthday!",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"]] forKey:@"vActivityText"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"school"]] forKey:@"birthdaywishOn_School"];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"image_path"]] forKey:@"birthdaywishdOn_image_path"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"badge"])
            {
                NSString *striAdminUID=[[oldDataArray objectAtIndex:j] objectForKey:@"iAdminID"];
                
                if ([strUpdatedUID isEqualToString:striAdminUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@ just unlocked badge!",[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"]] forKey:@"vActivityText"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"winked"])
            {
                NSString *striAdminUID=[[oldDataArray objectAtIndex:j] objectForKey:@"winkedByID"];
                
                if ([strUpdatedUID isEqualToString:striAdminUID])
                {
                    NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                    
                    [theDict setObject:[NSString stringWithFormat:@"%@%@%@ just winked at you!",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull],([[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_fname"] removeNull]length]>0)?@" ":@"",[[[updatedFriendsArray objectAtIndex:i] objectForKey:@"admin_lname"] removeNull]] forKey:@"vActivityText"];
                    
                    [oldDataArray replaceObjectAtIndex:j withObject:theDict];
                }
            }
        }
    }
    
    //Updated Feeds
    for (int i=0; i<[updatedLikesArray count]; i++)
    {
        for (int j=0; j<[oldDataArray count];j++)
        {
            NSString *striActivityID;
            NSString *strUpiActivityID;
            
            if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"activity"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"iActivityID"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"iActivityID"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"location"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"iGroupLocationID"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"iGroupLocationID"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"image"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"iImageID"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"iImageID"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"wrote"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"wrote_id"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"wrote_id"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"video"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"iVideoID"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"iVideoID"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"music"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"iMusicID"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"iMusicID"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"nowfriends"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"nowfriends_id"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"nowfriends_id"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"profile_update"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"profileupdate_id"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"profileupdate_id"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"birthdaywish"])//
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"birthdaywish_id"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"birthdaywish_id"];
            }
            else if ([[[oldDataArray objectAtIndex:j] objectForKey:@"vType_of_content"] isEqualToString:@"badge"])
            {
                striActivityID=[[oldDataArray objectAtIndex:j] objectForKey:@"badge_id"];
                strUpiActivityID=[[updatedLikesArray objectAtIndex:i] objectForKey:@"badge_id"];
            }
            
            if ([striActivityID isEqualToString:strUpiActivityID])
            {
                NSMutableDictionary *theDict=[[NSMutableDictionary alloc]initWithDictionary:[oldDataArray objectAtIndex:j]];
                
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"Comment_counts"] forKey:@"Comment_counts"];
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"vLikersIDs_count"] forKey:@"vLikersIDs_count"];
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"vUnlikersIDs_count"] forKey:@"vUnlikersIDs_count"];
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"canLike"] forKey:@"canLike"];
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"hasCommented"] forKey:@"hasCommented"];
                [theDict setObject:[[updatedLikesArray objectAtIndex:i] objectForKey:@"canUnLike"] forKey:@"canUnLike"];
                
                [oldDataArray replaceObjectAtIndex:j withObject:theDict];
            }
        }
    }
    
    if (appendUpdateAtStart)
    {
        [finalDataArray addObjectsFromArray:updateArray];
        [finalDataArray addObjectsFromArray:oldDataArray];
    }
    else
    {
        [finalDataArray addObjectsFromArray:oldDataArray];
        [finalDataArray addObjectsFromArray:updateArray];
    }
    
    //tsLastUpdateDt
    
    
    if (shouldupdateJSON)
    {
        NSString *strCurrentTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSString *strLatestFeedTime;
        BOOL shouldUseLatestFeedTime=NO;
        NSMutableDictionary *dictJSONWrite=[[NSMutableDictionary alloc]init];
        [dictJSONWrite setObject:finalDataArray forKey:@"USER_RECORDS"];
        
        
        if ([finalDataArray count]>0)
        {
            NSString *strLatest=[NSString stringWithFormat:@"%@",[[finalDataArray objectAtIndex:0] objectForKey:@"tsLastUpdateDt"]];
            strLatestFeedTime=[NSString stringWithFormat:@"%f",[strLatest longLongValue]+1.0];
            
            if ([strLatestFeedTime longLongValue]>[strCurrentTime longLongValue])
            {
                shouldUseLatestFeedTime=YES;
            }
        }
        
        [dictJSONWrite setObject:(shouldUpdateLastSyncTime)?((shouldUseLatestFeedTime)?strLatestFeedTime:strCurrentTime):strLastSyncTime forKey:@"lastsync"];
        
//        NSString *strCurrentTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//        NSMutableDictionary *dictJSONWrite=[[NSMutableDictionary alloc]init];
//        [dictJSONWrite setObject:finalDataArray forKey:@"USER_RECORDS"];
//        [dictJSONWrite setObject:(shouldUpdateLastSyncTime)?strCurrentTime:strLastSyncTime forKey:@"lastsync"];

        if ([[finalDataArray lastObject] objectForKey:@"tsLastUpdateDt"]!=nil)
        {
            [dictJSONWrite setObject:[[finalDataArray lastObject] objectForKey:@"tsLastUpdateDt"] forKey:@"oldestfeed"];
            [dictJSONWrite writeToFileName:strFileName];
        }
        else
        {
//            DisplayAlert(kLastUpdateTimeNotReceived);
        }
    }
    
    
    [[[MyAppManager sharedManager] arrMyFeeds] removeAllObjects];
    
    NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
    NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
    NSString *filePath = [NSString stringWithFormat:@"%@/bgpost_%@.plist",dirPath,strUserId];
    NSMutableArray *theMainFeedArray=[[NSMutableArray alloc]init];
    
    if ([[[MyAppManager sharedManager] fileManager] fileExistsAtPath:filePath])
    {
        NSMutableArray *arrBGPosts=[[NSMutableArray alloc]initWithContentsOfFile:filePath];
        
        for (int i=0; i<[arrBGPosts count]; i++)
        {
            NSMutableDictionary *dict = [[arrBGPosts objectAtIndex:i] copy];
            ViewFeed *myFeed = [[ViewFeed alloc]init];
            myFeed.isLocal=YES;
            myFeed.vType_of_content =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vType_of_content"]];
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[dict objectForKey:@"iActivityID"]];
            
            if ([myFeed.vType_of_content isEqualToString:@"activity"])
            {
                
            }
            else if ([myFeed.vType_of_content isEqualToString:@"location"])
            {
                myFeed.dcLatitude =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"dcLatitude"]];
                myFeed.dcLongitude =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"dcLongitude"]];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"image"])
            {
                myFeed.imageWidth=[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageWidth"]];
                myFeed.imageHeight=[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageHeight"]];
                myFeed.imgURLPOST=[NSString stringWithFormat:@"%@",[dict objectForKey:@"filePath"]];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"video"])
            {
                myFeed.strYouTubeId=[NSString stringWithFormat:@"%@",(([[dict objectForKey:@"params"] objectForKey:@"video_url"]))?[[dict objectForKey:@"params"] objectForKey:@"video_url"]:@""];
                myFeed.imgURLPOST=[NSString stringWithFormat:@"%@",([dict objectForKey:@"filePath"])?[dict objectForKey:@"filePath"]:@""];
                myFeed.strYouTubeTitle=[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vTitle"]];
            }
            else if ([myFeed.vType_of_content isEqualToString:@"music"])
            {
                myFeed.strYouTubeId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"filePath"]];
                myFeed.strYouTubeTitle =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vMusicName"]];
                myFeed.strAlbumTitle =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vMusicName2"]];
            }
            
            myFeed.iAdminID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"iAdminID"]];
            
            
            myFeed.Total_like_unlikes=[NSString stringWithFormat:@"0"];
            myFeed.vLikersIDs_count=[NSString stringWithFormat:@"0"];
            myFeed.vUnlikersIDs_count=[NSString stringWithFormat:@"0"];
            myFeed.canLike =[NSString stringWithFormat:@"YES"];
            myFeed.hasCommented =[NSString stringWithFormat:@"No"];
            myFeed.canUnLike =[NSString stringWithFormat:@"YES"];
            
            myFeed.tsInsertDt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tsInsertDt"]];
            myFeed.unixTimeStamp = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tsInsertDt"]];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
            
            double unixTimeStampDDD =[myFeed.unixTimeStamp integerValue];
            NSTimeInterval _interval=unixTimeStampDDD;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            myFeed.feedDate = date;
            myFeed.tsLastUpdateDt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tsInsertDt"]];
            
            myFeed.admin_fname=[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"admin_fname"]];
            myFeed.admin_lname=[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"admin_lname"]];
            myFeed.imgURL=[[NSString stringWithFormat:@"%@",[userDefaults valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            myFeed.vActivityText =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vActivityText"]];
            myFeed.vImWithflname = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"params"] objectForKey:@"vImWithflname"]];
            myFeed.vIamAt = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"params"] objectForKey:@"vIamAt"] removeNull]];
            myFeed.vIamAt2 = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"params"] objectForKey:@"vIamAt2"] removeNull]];
            
            if ([myFeed.vType_of_content isEqualToString:@"location"])
            {
                myFeed.strAttributed=[NSString stringWithFormat:@"%@%@", myFeed.vActivityText,([myFeed.vImWithflname isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",myFeed.vImWithflname]];
            }
            else
            {
                myFeed.strAttributed=[NSString stringWithFormat:@"%@%@%@%@", myFeed.vActivityText,([myFeed.vImWithflname isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",myFeed.vImWithflname],([myFeed.vIamAt isEqualToString:@""])?@"":[NSString stringWithFormat:@" - at %@",myFeed.vIamAt],([myFeed.vIamAt2 isEqualToString:@""])?@"":[NSString stringWithFormat:@" %@",myFeed.vIamAt2]];
            }
            
            NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:myFeed.strAttributed];
            [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
            NSString *strRange1;
            NSRange rangeFinal1;
            if(![[myFeed.vImWithflname removeNull] isEqualToString:@""])
            {
                strRange1 = myFeed.strAttributed;
                rangeFinal1 = [strRange1 rangeOfString:myFeed.vImWithflname];
                [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal1];
                [attString setTextColor:[UIColor blackColor] range:rangeFinal1];
            }
            
            NSString* strRange2;
            NSRange rangeFinal2;
            if(![[myFeed.vIamAt removeNull] isEqualToString:@""])
            {
                strRange2 = myFeed.strAttributed;
                rangeFinal2 = [strRange2 rangeOfString:myFeed.vIamAt];
                [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
                [attString setTextColor:[UIColor blackColor] range:rangeFinal2];
            }
            
            myFeed.labelHeight = [attString heightforAttributedStringWithWidth:290.0];
            myFeed.Comment_counts =  [NSString stringWithFormat:@"0"];
            
            [theMainFeedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:myFeed,@"feed",myFeed.feedDate,@"date",nil]];
            //[[[MyAppManager sharedManager] arrMyFeeds] addObject:myFeed];
        }
    }

    for (int i =0; i<[finalDataArray count]; i++)
    {
        NSMutableDictionary *dict = [[finalDataArray objectAtIndex:i] copy];
        ViewFeed *myFeed = [[ViewFeed alloc]init];
        myFeed.vType_of_content =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vType_of_content"]]];
        
        if ([myFeed.vType_of_content isEqualToString:@"activity"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iActivityID"]]];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"location"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iGroupLocationID"]]];
            myFeed.dcLatitude =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"dcLatitude"]]];
            myFeed.dcLongitude =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"dcLongitude"]]];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"image"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iImageID"]]];
            myFeed.imageHeight=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"height"]]];
            myFeed.imageWidth=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"width"]]];
            myFeed.imgURLPOST=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"url"]]];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"video"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iVideoID"]]];
            myFeed.strYouTubeId=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"video_url"]]];
            myFeed.strYouTubeTitle=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vTitle"]]];
            myFeed.imgURLPOST=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"url"]]];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"music"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iMusicID"]]];
            myFeed.strYouTubeId=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"music_img"]]];
            myFeed.strYouTubeTitle = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vMusicName"]]];
            myFeed.strAlbumTitle = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vMusicName2"]]];
        }
        else if([myFeed.vType_of_content isEqualToString:@"wrote"])
        {
            //generalText,wrote_id,wroteBy_id,wrotedBy_image_path,wrotedBy_Name,UserInfo;
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrote_id"]]];
            
            myFeed.generalText =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"generalText"]]];
            myFeed.wroteBy_id =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteBy_id"]]];
            myFeed.wrotedOn_Name = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrotedOn_Name"]]];
            myFeed.wrotedOn_image_path =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrotedOn_image_path"]]];
            myFeed.wroteOn_hasFriends = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteOn_hasFriends"]]];
            myFeed.wroteOn_School= [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteOn_School"]]];
        }
        else if([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywish_id"]]];
            myFeed.birthdaywishdOn_Name = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishdOn_Name"]]];
            myFeed.birthdaywishdOn_image_path =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishdOn_image_path"]]];
            myFeed.birthdaywishOn_hasFriends = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishOn_hasFriends"]]];
            myFeed.birthdaywishOn_School= [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishOn_School"]]];
        }
        //nowfriends
        else if([myFeed.vType_of_content isEqualToString:@"profile_update"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"profileupdate_id"]]];
            myFeed.strOldProfilePic =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"old_profilePic"]]];
        }
        else if([myFeed.vType_of_content isEqualToString:@"badge"])
        {
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"badge_id"]]];
            myFeed.badge_friends =[[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"num_of_frnds"]]] integerValue];
            NSString *streAccountStatus=[NSString stringWithFormat:@"%@",[self removeNull:[[dict objectForKey:@"UserInfo"]valueForKey:@"eAccountStatus"]]];
            myFeed.isUserPrivate=([streAccountStatus isEqualToString:@"Private"])?YES:NO;
        }
        else if([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            //hasNoOfFriends_iFriendsID,school_iFriendsID
            myFeed.hasNoOfFriends_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"hasNoOfFriends_iFriendsID"]]];
            myFeed.school_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"school_iFriendsID"]]];
            
            myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"nowfriends_id"]]];
            //Friend Detail
            myFeed.image_path_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"image_path_iFriendsID"]]];
            myFeed.iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iFriendsID"]]];
            myFeed.fullname_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"fullname_iFriendsID"]]];
        }
        
        myFeed.iAdminID = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"UserInfo"]valueForKey:@"admin_id"]];
        myFeed.Total_like_unlikes = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Comment_counts"]];
        myFeed.vLikersIDs_count = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vLikersIDs_count"]];
        myFeed.vUnlikersIDs_count = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vUnlikersIDs_count"]];
        myFeed.canLike =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"canLike"]]];
        myFeed.hasCommented =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"hasCommented"]]];
        myFeed.canUnLike =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"canUnLike"]]];
        myFeed.tsInsertDt = [self removeNull:[dict objectForKey:@"tsInsertDt"]];
        myFeed.unixTimeStamp = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"unixTimeStamp"]]];
        
        double unixTimeStampDDD =[myFeed.unixTimeStamp integerValue];
        NSTimeInterval _interval=unixTimeStampDDD;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        myFeed.feedDate = date;
        myFeed.tsLastUpdateDt = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"tsLastUpdateDt"]]];
        
        //Post Owner Details
        myFeed.admin_fname=[NSString stringWithFormat:@"%@",[self removeNull:[[dict objectForKey:@"UserInfo"]valueForKey:@"admin_fname"]]];
        myFeed.admin_lname=[NSString stringWithFormat:@"%@",[self removeNull:[[dict objectForKey:@"UserInfo"]valueForKey:@"admin_lname"]]];
        myFeed.imgURL=[NSString stringWithFormat:@"%@",[self removeNull:[[dict objectForKey:@"UserInfo"]valueForKey:@"image_path"]]];
        
        myFeed.vActivityText = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vActivityText"]]];
        
        myFeed.vImWithflname = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vImWithflname"]]];
        myFeed.vIamAt = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"vIamAt"] removeNull]];
        myFeed.vIamAt2 = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"vIamAt2"] removeNull]];
        
        if ([myFeed.vType_of_content isEqualToString:@"location"])
        {
            myFeed.strAttributed=[NSString stringWithFormat:@"%@%@", myFeed.vActivityText,([myFeed.vImWithflname isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",myFeed.vImWithflname]];
        }
        else
        {
            myFeed.strAttributed=[NSString stringWithFormat:@"%@%@%@%@", myFeed.vActivityText,([myFeed.vImWithflname isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",myFeed.vImWithflname],([myFeed.vIamAt isEqualToString:@""])?@"":[NSString stringWithFormat:@" - at %@",myFeed.vIamAt],([myFeed.vIamAt2 isEqualToString:@""])?@"":[NSString stringWithFormat:@" %@",myFeed.vIamAt2]];
        }
        
        if ([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            NSMutableAttributedString *attStringFriends=[[NSMutableAttributedString alloc] init];
            myFeed.labelHeight=[attStringFriends heightforAttributedStringWithWidth:290.0];
        }
        else
        {
            NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:myFeed.strAttributed];
            [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
            
            if ([myFeed.vType_of_content isEqualToString:@"badge"]||
                [myFeed.vType_of_content isEqualToString:@"profile_update"])
            {
                NSString* strRange =myFeed.strAttributed;
                NSRange rangeFinal= [strRange rangeOfString:[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname]];
                [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
                [attString setTextColor:[UIColor blackColor] range:rangeFinal];
                
                myFeed.labelHeight = [attString heightforAttributedStringWithWidth:265.0];
            }
            else
            {
                NSString *strRange1;
                NSRange rangeFinal1;
                if(![[myFeed.vImWithflname removeNull] isEqualToString:@""])
                {
                    strRange1 = myFeed.strAttributed;
                    rangeFinal1 = [strRange1 rangeOfString:myFeed.vImWithflname];
                    [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal1];
                    [attString setTextColor:[UIColor blackColor] range:rangeFinal1];
                }
                
                NSString* strRange2;
                NSRange rangeFinal2;
                if(![[myFeed.vIamAt removeNull] isEqualToString:@""])
                {
                    strRange2 = myFeed.strAttributed;
                    rangeFinal2 = [strRange2 rangeOfString:myFeed.vIamAt];
                    [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
                    [attString setTextColor:[UIColor blackColor] range:rangeFinal2];
                }
                
                myFeed.labelHeight = [attString heightforAttributedStringWithWidth:290.0];
            }
        }
        
        myFeed.Comment_counts =  [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"Comment_counts"]]];
        
        [theMainFeedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:myFeed,@"feed",myFeed.feedDate,@"date",nil]];
        //[[[MyAppManager sharedManager] arrMyFeeds] addObject:myFeed];
    }
    
    
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *temp = [theMainFeedArray mutableCopy];
    [temp sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
    [[[MyAppManager sharedManager] arrMyFeeds]  removeAllObjects];
    
    for (int i=0; i<[temp count]; i++)
    {
        [[[MyAppManager sharedManager] arrMyFeeds]  addObject:[[temp objectAtIndex:i] objectForKey:@"feed"]];
    }

    
    [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
}


-(void)ReloadTableData
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    TblView.alpha=1;
    [UIView commitAnimations];
    TblView.delegate = self;
    TblView.dataSource = self;
    [TblView reloadData];
    
    [pullToRefreshManager_ tableViewReloadFinished];
}

#pragma mark - IMAGE UPDATE
-(void)pushfriendview
{
    AddViewFlag = 3;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)AddComment:(id)sender
{
    selectedIndexPath = ((UIButton *)sender).tag;
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:selectedIndexPath];
    
    shouldOpenKeyBoardforComment=([((UIButton *)sender).titleLabel.text isEqualToString:@"Comment"])?YES:NO;
    
    if (myFeed.isLocal)
    {
        DisplayAlert(@"Please wait until feed syncs with server.");
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:myFeed.iActivityID forKey:@"iActivityID"];
    [dict setValue:myFeed.vType_of_content forKey:@"vType_of_content"];
    [dict setValue:myFeed.imageHeight forKey:@"imageHeight"];
    [dict setValue:myFeed.imageWidth forKey:@"imageWidth"];
    [dict setValue:myFeed.imgURLPOST forKey:@"imgURLPOST"];
    [dict setValue:myFeed.imgURL forKey:@"imgURL"];
    [dict setValue:myFeed.feedDate forKey:@"feedDate"];
    [dict setValue:myFeed.vLikersIDs_count forKey:@"vLikersIDs_count"];
    [dict setValue:myFeed.vUnlikersIDs_count forKey:@"vUnlikersIDs_count"];
    [dict setValue:myFeed.vActivityText forKey:@"vActivityText"];
    [dict setValue:myFeed.vImWithflname forKey:@"vImWithflname"];
    [dict setValue:myFeed.vIamAt forKey:@"vIamAt"];
    [dict setValue:myFeed.vIamAt2 forKey:@"vIamAt2"];
    [dict setValue:myFeed.labelHeight forKey:@"labelHeight"];
    [dict setValue:myFeed.canLike forKey:@"canLike"];
    [dict setValue:myFeed.hasCommented forKey:@"hasCommented"];
    [dict setValue:myFeed.canUnLike forKey:@"canUnLike"];
    [dict setValue:myFeed.admin_fname forKey:@"admin_fname"];
    [dict setValue:myFeed.admin_lname forKey:@"admin_lname"];
    [dict setValue:myFeed.Comment_counts forKey:@"Comment_counts"];
    [dict setValue:@"1" forKey:@"isFromHome"];
    
    if([myFeed.vType_of_content isEqualToString:@"wrote"])
    {
        [dict setValue:myFeed.generalText forKey:@"generalText"];
        [dict setValue:myFeed.wroteBy_id forKey:@"wroteBy_id"];
        [dict setValue:myFeed.wrotedOn_Name forKey:@"wrotedOn_Name"];
        [dict setValue:myFeed.wrotedOn_image_path forKey:@"wrotedOn_image_path"];
        [dict setValue:myFeed.wroteOn_School forKey:@"wroteOn_School"];
        [dict setValue:myFeed.wroteOn_hasFriends forKey:@"wroteOn_hasFriends"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
    {
        [dict setValue:myFeed.birthdaywishdOn_Name forKey:@"birthdaywishdOn_Name"];
        [dict setValue:myFeed.birthdaywishdOn_image_path forKey:@"birthdaywishdOn_image_path"];
        [dict setValue:myFeed.birthdaywishOn_School forKey:@"birthdaywishOn_School"];
        [dict setValue:myFeed.birthdaywishOn_hasFriends forKey:@"birthdaywishOn_hasFriends"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"video"])
    {
        [dict setValue:myFeed.strYouTubeId forKey:@"strYouTubeId"];
        [dict setValue:myFeed.strYouTubeTitle forKey:@"strYouTubeTitle"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"music"])
    {
        [dict setValue:myFeed.strYouTubeId forKey:@"strYouTubeId"];
        [dict setValue:myFeed.strYouTubeTitle forKey:@"strYouTubeTitle"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"location"])
    {
        [dict setValue:[self removeNull:myFeed.vIamAt] forKey:@"strYouTubeTitle"];
        [dict setValue:[self removeNull:myFeed.vIamAt2] forKey:@"vIamAt2"];
        [dict setValue:myFeed.dcLatitude forKey:@"dcLatitude"];
        [dict setValue:myFeed.dcLongitude forKey:@"dcLongitude"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"profile_update"])
    {
        [dict setValue:[self removeNull:myFeed.strOldProfilePic] forKey:@"strOldProfilePic"];
    }
    else if ([myFeed.vType_of_content isEqualToString:@"badge"])
    {
        [dict setValue:[NSString stringWithFormat:@"%d",myFeed.badge_friends] forKey:@"badge_friends"];
        [dict setValue:(myFeed.isUserPrivate)?@"pri":@"pub" forKey:@"isUserPrivate"];
    }
    
    AddViewFlag = 5;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnStatusSelectedClicked:(id)sender
{
    if (!isExpand)
    {
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/(180*4.0))];
        fullRotation.duration = 0.3f;
        [btnAddPost.layer addAnimation:fullRotation forKey:@"360"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5f];
        viewmenu.frame=CGRectMake(0,49.0+iOS7ExHeight, 320.0, 57.0);
        TblView.frame=CGRectMake(0,106.0+iOS7ExHeight,320,460-49-57+iPhone5ExHeight);
        [UIView commitAnimations];
        
        isExpand = YES;
    }
    else
    {
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:-((360*M_PI)/(180*4.0))];
        fullRotation.duration = 0.3f;
        [btnAddPost.layer addAnimation:fullRotation forKey:@"360"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5f];
        viewmenu.frame=CGRectMake(0,-8.0+iOS7ExHeight, 320.0, 57.0);
        TblView.frame=CGRectMake(0,49.0+iOS7ExHeight,320,460-49+iPhone5ExHeight);
        [UIView commitAnimations];
        
        isExpand = NO;
    }
}

-(void)startRotateButton
{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    //fullRotation.toValue = [NSNumber numberWithFloat:-90.0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/(180*4.0))];
    fullRotation.duration = 0.3f;
    //fullRotation.repeatCount = 1;
    [btnAddPost.layer addAnimation:fullRotation forKey:@"360"];
}
-(void)stopRotateButton
{
    [btnAddPost.layer removeAnimationForKey:@"360"];
}


-(IBAction)ShareCliked:(id)sender
{
    [self btnStatusSelectedClicked:nil];

    [self.view endEditing:YES];
    AddViewFlag = 1;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnLocationClicked:(id)sender
{
    [self btnStatusSelectedClicked:nil];

    [self.view endEditing:YES];
    AddViewFlag = 2;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)CameraClicked:(id)sender
{
    [self btnStatusSelectedClicked:nil];

    [self.view endEditing:YES];
    CoverORProfileORIMGPost = 0;
    UIActionSheet *Actionsheet1=[[UIActionSheet alloc]initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
    Actionsheet1.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    Actionsheet1.tag = 20;
    [Actionsheet1 showInView:[UIApplication sharedApplication].keyWindow];
}
-(IBAction)videoPost:(id)sender
{
    [self btnStatusSelectedClicked:nil];

    [self.view endEditing:YES];
    UIActionSheet *Actionsheet1=[[UIActionSheet alloc]initWithTitle:@"Select Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Video",@"Choose Video",@"From YouTube",nil];
    Actionsheet1.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    Actionsheet1.tag = 30;
    [Actionsheet1 showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)postVideoFromYouTube
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YouTube Video" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
    alert.tag=200;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Paste YouTube Link:";
    [alert textFieldAtIndex:0].delegate=self;
    [alert textFieldAtIndex:0].font=[UIFont systemFontOfSize:14.0f];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==200)
    {
        if (buttonIndex==1)
        {
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            
            if ([[alertView textFieldAtIndex:0].text rangeOfString:@"youtu"].location == NSNotFound)
            {
                DisplayAlert(@"Please enter valid YouTube URL.");
                return;
            }
            
            if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
            {
                DisplayNoInternate;
                return;
            }
            
            [[AppDelegate sharedInstance]showLoaderWithtext:@"" andDetailText:@"Validating YouTube URL..."];
            [dictYouTube removeAllObjects];
            
            NSMutableString *strYTBId=[[NSMutableString alloc]initWithString:[[alertView textFieldAtIndex:0].text removeNull]];
            NSArray *arrYTB=[strYTBId componentsSeparatedByString:@"v="];
            if ([arrYTB count]==2)
            {
                [strYTBId setString:[arrYTB objectAtIndex:1]];
                NSArray *arrYTB2=[strYTBId componentsSeparatedByString:@"&"];
                [strYTBId setString:[arrYTB2 objectAtIndex:0]];
            }
            else
            {
                [strYTBId setString:[strYTBId stringByReplacingOccurrencesOfString:@"http://www.youtube.com/embed/" withString:@""]];
                [strYTBId setString:[strYTBId stringByReplacingOccurrencesOfString:@"http://youtu.be/" withString:@""]];
            }
            
            NSMutableData *youtubeData=[[NSMutableData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?v=2&alt=json",strYTBId]]];
            
            [[AppDelegate sharedInstance]hideLoader];
            
            if (youtubeData)
            {
                NSMutableDictionary *dictYouTube2=[NSJSONSerialization JSONObjectWithData:youtubeData options:NSJSONReadingAllowFragments error:nil];
                if (!dictYouTube2)
                {
                    DisplayAlert(@"Invalid YouTube URL!");
                    return;
                }
                else
                {
                    if (!dictYouTube)
                    {
                        dictYouTube=[[NSMutableDictionary alloc]init];
                    }
                    
                    [dictYouTube addEntriesFromDictionary:dictYouTube2];
                    [dictYouTube setObject:strYTBId forKey:@"YouTubeId"];
                }
            }
            else
            {
                DisplayAlert(@"Invalid YouTube URL!");
                return;
            }
            
            AddViewFlag = 9;
            NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
            
        }
    }
}

-(IBAction)musicPost:(id)sender
{
    [self btnStatusSelectedClicked:nil];

    [self.view endEditing:YES];
    
#if TARGET_IPHONE_SIMULATOR
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Music Library Not Available in iPhone Simulator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
#elif TARGET_OS_IPHONE
    
    AddViewFlag = 6;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
#endif
    
}

#pragma mark - CONNECTION METHODS

-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString
{
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [[AppDelegate sharedInstance]hideLoader];
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        return;
    }
    else
    {
        NSError *error;
        NSData *storesData = [statusString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONReadingMutableLeaves error:&error];
        [self setData:dict];
    }
}

-(void)setData:(NSDictionary*)dictionary
{
    if([self.action isEqualToString:@"_deleteHandler"])
    {
        self.action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictionary objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            [[[MyAppManager sharedManager] arrMyFeeds] removeObjectAtIndex:selectedIndexPath];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
            
            NSString *strFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
            NSMutableArray *oldDataArray=[[NSMutableArray alloc]init];
            NSMutableDictionary *dictoldData=[[NSMutableDictionary alloc]initWithDictionary:[strFileName getDataFromFile]];
            [oldDataArray addObjectsFromArray:[dictoldData objectForKey:@"USER_RECORDS"]];
            
            [oldDataArray removeObjectAtIndex:selectedIndexPath];
            
            NSMutableDictionary *dictJSONWrite=[[NSMutableDictionary alloc]init];
            [dictJSONWrite setObject:oldDataArray forKey:@"USER_RECORDS"];
            [dictJSONWrite setObject:[dictoldData objectForKey:@"lastsync"] forKey:@"lastsync"];
            
            if ([dictoldData objectForKey:@"oldestfeed"]!=nil)
            {
                [dictJSONWrite setObject:[dictoldData objectForKey:@"oldestfeed"] forKey:@"oldestfeed"];
                [dictJSONWrite writeToFileName:strFileName];
            }
            else
            {
//                DisplayAlert(kLastUpdateTimeNotReceived);
            }

            [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
        }
        else
        {
            DisplayAlertWithTitle(APP_Name, strMSG);
            return;
        }
    }
    if ([self.action isEqualToString:@"image_update"]) 
    {
        self.action=@"";
        if ([dictionary objectForKey:@"USER_DETAIL"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictionary objectForKey:@"USER_DETAIL"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSNotification *notif = [NSNotification notificationWithName:@"updateProfilePic" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
            
            [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
        }
    }
}

-(NSString *)removeNull:(NSString *)str
{
    if (![str isKindOfClass:[NSString class]])
    {
        return @"";
    }
    
    return [str removeNull];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MyAppManager sharedManager] arrMyFeeds] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@%@",myFeed.vType_of_content,myFeed.iActivityID];
    
    AllFeedsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AllFeedsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withIndex:indexPath.row dataMyFeed:myFeed isFromHome:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.btnProfilePic.tag = indexPath.row;
    
    
    if ([myFeed.vType_of_content isEqualToString:@"winked"])
    {
        cell.theFeedType=FEED_TYPE_WINKED;
        
        [cell.imgProfilePic setImageWithURL:[NSURL URLWithString:myFeed.imgURL] placeholderImage:[UIImage imageNamed:@"sync.png"]];
        cell.imgProfilePic.backgroundColor=[UIColor clearColor];
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:myFeed.strAttributed];
        [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
        
        NSString *strRange =myFeed.strAttributed;
        NSRange rangeFinal= [strRange rangeOfString:[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname]];
        [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
        [attString setTextColor:[UIColor blackColor] range:rangeFinal];
        
        CGRect myrect = cell.lbl_Badge_ProfileUpdate.frame;
        myrect.size.height = [myFeed.labelHeight floatValue];
        cell.lbl_Badge_ProfileUpdate.frame = myrect;
        cell.lbl_Badge_ProfileUpdate.attributedText = attString;
        cell.lbl_Badge_ProfileUpdate.numberOfLines = 0;
        cell.lbl_Badge_ProfileUpdate.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.btnProfilePic.tag = [[NSString stringWithFormat:@"%@",[self removeNull:myFeed.iAdminID]] integerValue];
        
        [cell.btnProfilePic addTarget:self action:@selector(btnViewProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnProfilePic.userInteractionEnabled=YES;
        
        cell.lblDate.text=[NSString stringWithFormat:@"%@",[self removeNull:[myFeed.feedDate FormatedDate]]];
    }
    else
    {
        //HEADER--
        
        if([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
        {
            cell.imgProfilePic.image=[UIImage imageNamed:@"birthdaycake.png"];
            cell.imgProfilePic.backgroundColor=[UIColor lightGrayColor];
            cell.btnProfilePic.userInteractionEnabled=NO;
        }
        else
        {
            [cell.imgProfilePic setImageWithURL:[NSURL URLWithString:myFeed.imgURL] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            cell.imgProfilePic.backgroundColor=[UIColor clearColor];
            cell.btnProfilePic.userInteractionEnabled=(![myFeed.iAdminID isEqualToString:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]])?YES:NO;
        }
        
        cell.btnProfilePic.tag = indexPath.row;
        [cell.btnProfilePic addTarget:self action:@selector(viewFriendsProfile:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblUserName.text=[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname];
        
        cell.lblDate.text=[NSString stringWithFormat:@"%@",[self removeNull:[myFeed.feedDate FormatedDate]]];
        cell.lblLikeCount.text=[NSString stringWithFormat:@"%@",[self removeNull:myFeed.vLikersIDs_count]];
        cell.lblDisLikeCount.text=[NSString stringWithFormat:@"%@",[self removeNull:myFeed.vUnlikersIDs_count]];
        cell.lblCommentCount.text=[NSString stringWithFormat:@"%@",[self removeNull:myFeed.Total_like_unlikes]];
        
        //MIDDLE--
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:myFeed.strAttributed];
        [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
        NSString *strRange=myFeed.strAttributed;
        
        if(![[myFeed.vImWithflname removeNull] isEqualToString:@""])
        {
            NSRange rangeFinal=[strRange rangeOfString:myFeed.vImWithflname];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal];
        }
        
        if(![[myFeed.vIamAt removeNull] isEqualToString:@""])
        {
            NSRange rangeFinal=[strRange rangeOfString:myFeed.vIamAt];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal];
        }
        
        if ([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            NSRange rangeFinal= [strRange rangeOfString:[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal];
            
            NSRange rangeFinal2= [strRange rangeOfString:[NSString stringWithFormat:@"%@",myFeed.fullname_iFriendsID]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal2];
        }
        
        CGRect myrect = cell.lblattributed.frame;
        myrect.size.height = [myFeed.labelHeight floatValue];
        cell.lblattributed.frame = myrect;
        cell.lblattributed.attributedText = attString;
        cell.lblattributed.numberOfLines = 0;
        cell.lblattributed.lineBreakMode = NSLineBreakByWordWrapping;
        
        if ([myFeed.vType_of_content isEqualToString:@"image"])
        {
            cell.theFeedType=FEED_TYPE_IMAGE;
            cell.imgViewPicture.tag=(([myFeed.imageHeight floatValue]>=310) && !([myFeed.imageWidth floatValue]>[myFeed.imageHeight floatValue]))?500500:0;
            
            if (myFeed.isLocal)
            {
                if (cell.imgViewPicture.tag==500500)
                {
                    cell.imgViewPicture.image=[[UIImage imageWithContentsOfFile:myFeed.imgURLPOST] cropCenterToSize:CGSizeMake(310, 310)];
                }
                else
                {
                    cell.imgViewPicture.contentMode=UIViewContentModeScaleAspectFit;
                    cell.imgViewPicture.image=[UIImage imageWithContentsOfFile:myFeed.imgURLPOST];
                }
            }
            else
            {
                [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:myFeed.imgURLPOST] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            }
            
            cell.btnViewPicture.tag = indexPath.row;
            [cell.btnViewPicture addTarget:self action:@selector(thumbnilImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"video"])
        {
            if([myFeed.strYouTubeId length]!=0)
            {
                cell.theFeedType=FEED_TYPE_YTB_VIDEO;
                
                NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:[self removeNull:myFeed.strYouTubeTitle]];
                [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [[self removeNull:myFeed.strYouTubeTitle] length])];
                cell.lblCellDetailTitle.attributedText = attString;
                
                cell.webViewVideo.delegate=self;
                //                NSString *embeddedHtml = [NSString stringWithFormat:@"<iframe width=\"147\" height=\"84\" src=\"http://www.youtube.com/embed/%@?feature=player_detailpage\" frameborder=\"0\" allowfullscreen></iframe>",myFeed.strYouTubeId];
                //                [cell.webViewVideo loadHTMLString:embeddedHtml baseURL:nil];
                
                
                if ([dictWebViews objectForKey:myFeed.strYouTubeId])
                {
                    cell.webViewVideo=[dictWebViews objectForKey:myFeed.strYouTubeId];
                }
                else
                {
                    float videowidth=cell.webViewVideo.frame.size.width;
                    float videoheight=cell.webViewVideo.frame.size.height;
                    
                    NSString *embeddedHtml = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width =%f\"/></head><body style=\"background:#000;margin-top:0px;margin-left:0px\"><div><object width=\"%f\" height=\"%f\"><param name=\"movie\" value=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%f\" height=\"%f\"></embed></object></div></body></html>",videowidth,videowidth,videoheight,myFeed.strYouTubeId,myFeed.strYouTubeId,videowidth,videoheight];
                    
                    [cell.webViewVideo loadHTMLString:embeddedHtml baseURL:nil];
                    
                    [dictWebViews setObject:cell.webViewVideo forKey:myFeed.strYouTubeId];
                }
            }
            else
            {
                cell.theFeedType=FEED_TYPE_VIDEO;
                
                if ([dictWebViews objectForKey:myFeed.imgURLPOST])
                {
                    cell.webViewVideo=[dictWebViews objectForKey:myFeed.imgURLPOST];
                }
                else
                {
                    
                    if (myFeed.isLocal)
                    {
                        NSMutableString *strVideoPath=[[NSMutableString alloc]initWithString:[[MyAppManager sharedManager]strTempUploaderDirPath]];
                        [strVideoPath appendString:@"/"];
                        NSRange renge= NSMakeRange(0, strVideoPath.length);
                        [strVideoPath replaceOccurrencesOfString:@"/" withString:@"//" options:NSCaseInsensitiveSearch range:renge];
                        renge= NSMakeRange(0, strVideoPath.length);
                        [strVideoPath replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:renge];
                        [strVideoPath insertString:@"file://" atIndex:0];
                        
                        NSString *embeddedHtml = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {background-color: transparent;color: white;} </style></head><body style=\"margin:0\"> <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"310.0f\" height=\"310.0f\"></embed></body></html>",myFeed.imgURLPOST];
                        [cell.webViewVideo loadHTMLString:embeddedHtml baseURL:[NSURL URLWithString:strVideoPath]];
                    }
                    else
                    {
                        NSString *embeddedHtml = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {background-color: transparent;color: white;} </style></head><body style=\"margin:0\"> <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"310.0f\" height=\"310.0f\"></embed></body></html>",myFeed.imgURLPOST];
                        [cell.webViewVideo loadHTMLString:embeddedHtml baseURL:nil];
                    }

                    
                    [dictWebViews setObject:cell.webViewVideo forKey:myFeed.imgURLPOST];
                }
            }
        }
        else if ([myFeed.vType_of_content isEqualToString:@"music"])
        {
            cell.theFeedType=FEED_TYPE_MUSIC;
            cell.btnViewPicture.tag=indexPath.row;
            
            NSString *strAlbumCoverURL=[NSString stringWithFormat:@"%@",myFeed.strYouTubeId];
            if ([[strAlbumCoverURL removeNull] length]==0)
            {
                [cell.imgViewPicture setImage:[UIImage imageNamed:@"default_music.png"]];
                cell.btnViewPicture.userInteractionEnabled=NO;
            }
            else
            {
                [cell.btnViewPicture addTarget:self action:@selector(btnMusicPicClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnViewPicture.userInteractionEnabled=YES;
                
                if (myFeed.isLocal)
                {
                    cell.imgViewPicture.image=[[UIImage imageWithContentsOfFile:strAlbumCoverURL] squareImage];
                }
                else
                {
                    [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:[strAlbumCoverURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"sync.png"]];
                }
            }
            
            NSString *strMusic=[NSString stringWithFormat:@"Listening to %@ %@",[self removeNull:myFeed.strYouTubeTitle],[self removeNull:myFeed.strAlbumTitle]];
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strMusic];
            
            NSRange rangeFinal1 = [strMusic rangeOfString:@"Listening to"];
            [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal1];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal1];
            
            NSRange rangeFinal2 = [strMusic rangeOfString:[self removeNull:myFeed.strYouTubeTitle]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal2];
            
            NSRange rangeFinal3 = [strMusic rangeOfString:[self removeNull:myFeed.strAlbumTitle]];
            [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal3];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal3];
            
            cell.lblCellDetailTitle.attributedText = attString;
            
        }
        else if([myFeed.vType_of_content isEqualToString:@"profile_update"])
        {
            cell.theFeedType=FEED_TYPE_PROFILEPIC_UPDATE;
            cell.btnViewPicture.tag=indexPath.row;
            [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:myFeed.strOldProfilePic] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            [cell.btnViewPicture addTarget:self action:@selector(btnProfilePicClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (![myFeed.iAdminID isEqualToString:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]])
            {
                cell.btnProfilePic.userInteractionEnabled=YES;
                [cell.btnProfilePic addTarget:self action:@selector(viewFriendsProfile:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.btnProfilePic.userInteractionEnabled=NO;
            }
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:myFeed.strAttributed];
            [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
            
            NSString *strRange =myFeed.strAttributed;
            NSRange rangeFinal= [strRange rangeOfString:[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal];
            
            cell.lblCellDetailTitle.attributedText=attString;
        }
        else if([myFeed.vType_of_content isEqualToString:@"badge"])
        {
            cell.theFeedType=FEED_TYPE_BADGE;
            
            int count=myFeed.badge_friends;
            int badgecount=(count>=100)?100:((count>=50)?50:((count>=20)?20:0));
            [cell.imgViewPicture setImage:[UIImage imageNamed:[NSString stringWithFormat:@"badge%@_%d.png",(myFeed.isUserPrivate)?@"p":@"",badgecount]]];
            
            if (![myFeed.iAdminID isEqualToString:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]])
            {
                cell.btnProfilePic.userInteractionEnabled=YES;
                [cell.btnProfilePic addTarget:self action:@selector(viewFriendsProfile:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.btnProfilePic.userInteractionEnabled=NO;
            }
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:myFeed.strAttributed];
            [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [myFeed.strAttributed length])];
            
            NSString *strRange =myFeed.strAttributed;
            NSRange rangeFinal= [strRange rangeOfString:[NSString stringWithFormat:@"%@ %@",myFeed.admin_fname,myFeed.admin_lname]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal];
            [attString setTextColor:[UIColor blackColor] range:rangeFinal];
            
            cell.lblCellDetailTitle.attributedText=attString;
        }
        else if ([myFeed.vType_of_content isEqualToString:@"location"])
        {
            cell.theFeedType=FEED_TYPE_LOCATION;
            cell.btnViewPicture.tag=indexPath.row;
            
            [cell.btnViewPicture addTarget:self action:@selector(btnMapClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *strLocation=[NSString stringWithFormat:@"At %@ %@",[self removeNull:myFeed.vIamAt],[self removeNull:myFeed.vIamAt2]];
            
            NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strLocation];
            
            NSRange rangeFinal1 = [strLocation rangeOfString:@"At"];
            [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal1];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal1];
            
            NSRange rangeFinal2 = [strLocation rangeOfString:[self removeNull:myFeed.vIamAt]];
            [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal2];
            
            NSRange rangeFinal3 = [strLocation rangeOfString:[self removeNull:myFeed.vIamAt2]];
            [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal3];
            [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal3];
            
            cell.lblCellDetailTitle.attributedText = attString;
            
            int mapwidth=[[NSString stringWithFormat:@"%f",cell.imgViewPicture.frame.size.width] integerValue];
            int mapheight=[[NSString stringWithFormat:@"%f",cell.imgViewPicture.frame.size.height] integerValue];
            
            NSString *strMapURL=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&size=%dx%d&maptype=roadmap&sensor=false&scale=5&zoom=15&markers=%@,%@",myFeed.dcLatitude,myFeed.dcLongitude,mapwidth,mapheight,myFeed.dcLatitude,myFeed.dcLongitude];
            [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:[strMapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            
            //http://maps.googleapis.com/maps/api/staticmap?center=37.446754,-77.572746&size=150x150&maptype=roadmap&sensor=false&scale=5&zoom=15&markers=37.446754,-77.572746
        }
        else if ([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            cell.theFeedType=FEED_TYPE_NOWFRIENDS;
            
            [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:myFeed.image_path_iFriendsID] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            cell.btnViewPicture.tag = [[NSString stringWithFormat:@"%@",[self removeNull:myFeed.iFriendsID]] integerValue];
            [cell.btnViewPicture addTarget:self action:@selector(btnViewProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
            //hasNoOfFriends_iFriendsID,school_iFriendsID
            
            cell.lblWroteOn_Name.text = [NSString stringWithFormat:@"👥 %@",[NSString stringWithFormat:@"%@",myFeed.fullname_iFriendsID]];
            cell.lblWroteOn_School.text = [NSString stringWithFormat:@"%@",[self removeNull:myFeed.school_iFriendsID]];
            cell.lblWroteOn_NumOfFriend.text = [NSString stringWithFormat:@"%@ Friends",[self removeNull:myFeed.hasNoOfFriends_iFriendsID]];
        }
        else if ([myFeed.vType_of_content isEqualToString:@"wrote"])
        {
            cell.theFeedType=FEED_TYPE_WROTE;
        }
        else if([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
        {
            cell.theFeedType=FEED_TYPE_BIRTHDAY;
            
            [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:myFeed.birthdaywishdOn_image_path] placeholderImage:[UIImage imageNamed:@"sync.png"]];
            cell.btnViewPicture.tag =cell.btnViewPicture.tag = [[NSString stringWithFormat:@"%@",[self removeNull:myFeed.iAdminID]] integerValue];;
            
            [cell.btnViewPicture addTarget:self action:@selector(btnViewProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.lblWroteOn_Name.text = [NSString stringWithFormat:@"%@",[self removeNull:myFeed.birthdaywishdOn_Name]];
            cell.lblWroteOn_School.text = [NSString stringWithFormat:@"%@",[self removeNull:myFeed.birthdaywishOn_School]];
            cell.lblWroteOn_NumOfFriend.text = [NSString stringWithFormat:@"%@ Friends",[self removeNull:myFeed.birthdaywishOn_hasFriends]];
        }
        
        
        //FOOTER--
        //LIKE-DISLIKE-COMMENT-DELETE
        cell.btnLike.tag=indexPath.row;
        cell.btnDisLike.tag=indexPath.row;
        cell.btnComment.tag=indexPath.row;
        cell.btnLikeCount.tag=indexPath.row;
        cell.btnCommentCount.tag=indexPath.row;
        cell.btnDisLikeCount.tag=indexPath.row;
        
        cell.btnLike.userInteractionEnabled=([myFeed.canLike isEqualToString:@"No"])?NO:YES;
        
        //pp12
        [cell.btnComment setTitleColor:([myFeed.hasCommented isEqualToString:@"Yes"])?cell.viewUpperBorder.backgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        cell.btnDisLike.userInteractionEnabled=([myFeed.canUnLike isEqualToString:@"No"])?NO:YES;
        
        [cell.btnLike setImage:([myFeed.canLike isEqualToString:@"No"])?[UIImage imageNamed:@"imgbtnlike-h"]:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
        [cell.btnDisLike setImage:([myFeed.canUnLike isEqualToString:@"No"])?[UIImage imageNamed:@"imgbtndislike-h"]:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];

        
        [cell.btnLike addTarget:self action:@selector(Like:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDisLike addTarget:self action:@selector(UNLike:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLikeCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCommentCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDisLikeCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    }
     
    
    cell.tag = indexPath.row + 1 ;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest:)];
    tapGest.numberOfTapsRequired = 2;
    tapGest.delegate = self;
    [cell addGestureRecognizer:tapGest];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:indexPath.row];
    float finalHeight = [myFeed.labelHeight floatValue];
    float imageoriginy=([myFeed.labelHeight floatValue]==0)?52:(58.0+[myFeed.labelHeight floatValue]+10.0);
    if([myFeed.vType_of_content isEqualToString:@"image"])
    {
        float imageheight = 0.0;
        if([myFeed.imageHeight floatValue]>=310)
        {
            if ([myFeed.imageWidth floatValue]>[myFeed.imageHeight floatValue])
            {
                imageheight=[myFeed.imageHeight floatValue]*310.0/[myFeed.imageWidth floatValue];
            }
            else
            {
                imageheight=310.0;
            }
        }
        else
        {
            imageheight=[myFeed.imageHeight floatValue];
        }
        
        finalHeight=imageoriginy+imageheight;
    }
    else if([myFeed.vType_of_content isEqualToString:@"video"])
    {
        finalHeight=imageoriginy+(([myFeed.strYouTubeId length]!=0)?90.0:310.0);
    }
    else if([myFeed.vType_of_content isEqualToString:@"music"]
            || [myFeed.vType_of_content isEqualToString:@"wrote"]
            || [myFeed.vType_of_content isEqualToString:@"birthdaywish"]
            || [myFeed.vType_of_content isEqualToString:@"profile_update"]
            || [myFeed.vType_of_content isEqualToString:@"nowfriends"]
            || [myFeed.vType_of_content isEqualToString:@"badge"])
    {
        imageoriginy=([myFeed.vType_of_content isEqualToString:@"profile_update"])?73.0:imageoriginy;
        imageoriginy=([myFeed.vType_of_content isEqualToString:@"badge"])?52:imageoriginy;
        
        if ([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            imageoriginy-=5.0;
        }

        
        float midheight=(([myFeed.vType_of_content isEqualToString:@"badge"])?48:69);
        midheight=(([myFeed.vType_of_content isEqualToString:@"wrote"])?0:midheight);
        
        finalHeight=imageoriginy+midheight;
    }
    else if ([myFeed.vType_of_content isEqualToString:@"winked"])
    {
        finalHeight = MAX(52.0,[myFeed.labelHeight floatValue]+25.0)-34.0-5.0;
    }
    else if([myFeed.vType_of_content isEqualToString:@"location"])
    {
        finalHeight=imageoriginy+90.0;
    }
    else
    {
        finalHeight =58.0+[myFeed.labelHeight floatValue]+10.0;
    }
    
    return (finalHeight+34.0+5.0);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        self.viewDeckController.leftLedge = MAX(indexPath.row*44,10);
    }
    else
    {
        self.viewDeckController.rightLedge = MAX(indexPath.row*44,10);
    }
}

#pragma mark - CELL ELEMENT METHODS
-(void)btnViewProfileClicked:(id)sender
{
    if ([sender tag]==[[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] integerValue])
    {
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%d",[sender tag]] forKey:@"admin_id"];
    AddViewFlag = 8;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)viewFriendsProfile:(id)sender
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:[sender tag]];
    
    if ([myFeed.iAdminID integerValue]==[[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] integerValue])
    {

    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:myFeed.iAdminID forKey:@"admin_id"];
        AddViewFlag = 8;
        NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}
- (void)videoFullScreen:(id)sender
{
    AddViewFlag = 50;
    if([[UIApplication sharedApplication]respondsToSelector:@selector(setStatusBarHidden: withAnimation:)])
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationNone];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)videoExitFullScreen:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(IBAction)WatchVideo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:btn.tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:myFeed.imgURLPOST forKey:@"imgURLPOST"];
    AddViewFlag = 51;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

#pragma mark -
-(IBAction)btnProfilePicChangeClicked:(id)sender
{
    [self.view endEditing:YES];
    CoverORProfileORIMGPost = 1;
    self.imgFlag = @"";
    isSelectedImageCover=NO;
    
    UIActionSheet *Actionsheet1=[[UIActionSheet alloc]initWithTitle:@"How would you like to set your profile picture?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
    Actionsheet1.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    Actionsheet1.tag = 1001;
    [Actionsheet1 showInView:[UIApplication sharedApplication].keyWindow];
}
-(IBAction)btnCoverPicChangeClicked:(id)sender
{
    [self.view endEditing:YES];
    CoverORProfileORIMGPost = 2;
    self.imgFlag = @"";
    isSelectedImageCover=YES;
    
    UIActionSheet *Actionsheet1=[[UIActionSheet alloc]initWithTitle:@"How would you like to set your cover?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
    Actionsheet1.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    Actionsheet1.tag = 1001;
    [Actionsheet1 showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)openCamera
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"TakePhoto" forKey:@"imgFlag"];
    AddViewFlag = 40;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)openLibrary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"ChoosePhoto" forKey:@"imgFlag"];
    AddViewFlag = 40;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)TakeVideo
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {   
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"TakeVideo" forKey:@"imgFlag"];
        AddViewFlag = 40;
        NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    else
    {
        DisplayAlertWithTitle(@"Note!!", @"Camera is not available on your device");
        return;
    }
}
-(void)ChooseVideo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"ChooseVideo" forKey:@"imgFlag"];
    AddViewFlag = 40;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==10)
    {
        if (buttonIndex==0)
        {
            ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:selectedIndexPath];
            [self _deleteHandler:myFeed.vType_of_content :myFeed.iActivityID];
        }
    }
    else if(actionSheet.tag==20)
    {
        if (buttonIndex==0)
        {
            [self openCamera];
        }
        if (buttonIndex==1)
        {
            [self openLibrary];
        }
    }
    else if(actionSheet.tag==30)
    {
        if (buttonIndex==0)
        {
            [self TakeVideo];
        }
        else if (buttonIndex==1)
        {
            [self ChooseVideo];
        }
        else if(buttonIndex==2)
        {
            [self postVideoFromYouTube];
        }
    }
    else if(actionSheet.tag==1001)
    {
        switch (buttonIndex){
            case 0:
            {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.videoMaximumDuration=20;
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    [self presentModalViewController:picker animated:YES];
                }
            }
                break;
            case 1:{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentModalViewController:picker animated:YES];
            }
                break;
        }
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([self.imgFlag isEqualToString:@"TakePhoto"] || [self.imgFlag isEqualToString:@"ChoosePhoto"]) 
    {
        UIImage *resultingImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([self.imgFlag isEqualToString:@"TakePhoto"])
        {
            UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);
        }
        
        if (resultingImage)
        {
            [self dismissModalViewControllerAnimated:NO];
            [self performSelector:@selector(NotiforIMGPost:) withObject:resultingImage afterDelay:0.5];
        }
    }
    else if([self.imgFlag isEqualToString:@"TakeVideo"] || [self.imgFlag isEqualToString:@"ChooseVideo"])
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        if ([mediaType isEqualToString:@"public.movie"])
        {
            NSURL *videoURL = [[info objectForKey:UIImagePickerControllerMediaURL] copy];
            if ([self.imgFlag isEqualToString:@"TakeVideo"]) 
            {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) 
                {
                    UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                }  
            }
            self.imgFlag = @"";
            [self dismissModalViewControllerAnimated:NO];
            [self performSelector:@selector(NotiforVideoPost:) withObject:videoURL afterDelay:0.5];
        }
    }
    else
    {
        UIImage *resultingImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(resultingImage, nil, nil, nil);
        }
        
        if (isSelectedImageCover)
        {
            imgCoverPic.image=resultingImage;
            
            UIImage *imgCover = imgCoverPic.image;
            float widthCover = imgCoverPic.frame.size.width;
            float heightCover = imgCoverPic.frame.size.height;
            float viewheight=MAX((heightCover*320.0)/widthCover, 225.0);
            float imgdiff=(viewheight==225.0)?((225.0-((heightCover*320.0)/widthCover))/2.0):0.0;
            imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
            btnCoverPic.frame = imgCoverPic.frame;
            viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
            imgCoverPic.image = imgCover;
            TblView.tableHeaderView = viewHeader;
            NSData *theImageData=UIImagePNGRepresentation(resultingImage);
            [dataCoverImage setData:theImageData];
            
        }
        else
        {
            imgProfile.image=resultingImage;
            NSData *theImageData=UIImagePNGRepresentation(resultingImage);
            [dataProfileImage setData:theImageData];
        }

        [self performSelector:@selector(_updateImage)];
        [picker dismissModalViewControllerAnimated:YES];
    }
}

-(void)NotiforVideoPost:(NSURL *)url
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:url forKey:@"videoURL"];
    AddViewFlag = 4;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(void)NotiforIMGPost:(UIImage *)image
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:image forKey:@"imgToPost"];
    AddViewFlag = 7;
    NSNotification *notif = [NSNotification notificationWithName:@"presentIt" object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.imgFlag = @"";
    [self  dismissModalViewControllerAnimated:YES];    
}
-(void)_updateImage
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance] showLoaderWithtext:@"Updating Image" andDetailText:@"Please Wait"];
        
        NSData *imgData;
        NSString  *urlstring;
        self.action=@"image_update";
        
        if (isSelectedImageCover)
        {
            UIImage *img = imgCoverPic.image;
            float widthCover = img.size.width;
            float heightCover = img.size.height;
            float viewheight=MAX((heightCover*320.0)/widthCover, 225.0);
            float imgdiff=(viewheight==225.0)?((225.0-((heightCover*320.0)/widthCover))/2.0):0.0;
            imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
            btnCoverPic.frame = imgCoverPic.frame;
            imgCoverPic.image=img;
            viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
            TblView.tableHeaderView = viewHeader;
            [TblView reloadData];
            
            imgData = dataCoverImage;
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kCoverImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
            
            TblView.tableHeaderView = viewHeader;
            [TblView reloadData];
        }
        else
        {
            imgData =dataProfileImage;
            imgProfile.image = [imgProfile.image squareImage];
            
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kProfileImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (isSelectedImageCover)
        {
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
        }
        else
        {
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}
-(void)_updateImage:(NSNotification *)notif
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance] showLoaderWithtext:@"Updating Image" andDetailText:@"Please Wait"];
        
        NSData *imgData;
        NSString  *urlstring;
        self.action=@"image_update";
        
        if (isSelectedImageCover) 
        {
            UIImage *img = [notif.object valueForKey:@"imgPost"];
            float widthCover = img.size.width;
            float heightCover = img.size.height;
            float viewheight=MAX((heightCover*320.0)/widthCover, 225.0);
            float imgdiff=(viewheight==225.0)?((225.0-((heightCover*320.0)/widthCover))/2.0):0.0;
            imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
            btnCoverPic.frame = imgCoverPic.frame;
            imgCoverPic.image=img;
            viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
            TblView.tableHeaderView = viewHeader;
            [TblView reloadData];
            
            imgData = UIImagePNGRepresentation([notif.object valueForKey:@"imgPost"]);
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kCoverImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
            
            TblView.tableHeaderView = viewHeader;
            [TblView reloadData];
        }
        else
        {
            imgData = UIImagePNGRepresentation([notif.object valueForKey:@"imgPost"]);
            imgProfile.image = [[notif.object valueForKey:@"imgPost"] squareImage];
            
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kProfileImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (isSelectedImageCover)
        {
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
        }
        else
        {
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}

#pragma mark -
-(void)tapGest:(UITapGestureRecognizer *)gest
{
    selectedIndexPath = gest.view.tag-1;
    ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:(long)gest.view.tag-1];
    if ([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
    {
        DisplayAlertWithTitle(APP_Name, @"You can not delete Birthday post!!!");
        return;
    }
    else if ([myFeed.vType_of_content isEqualToString:@"nowfriends"]||
             [myFeed.vType_of_content isEqualToString:@"badge"])
    {
        DisplayAlertWithTitle(APP_Name, @"You can not delete this post!!!");
        return;
    }
    else if ([myFeed.iAdminID isEqualToString:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]])
    {
        UIActionSheet *Actionsheet1=[[UIActionSheet alloc]initWithTitle:@"Do you want to delete this post?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil,nil];
        Actionsheet1.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        Actionsheet1.tag = 10;
        [Actionsheet1 showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        DisplayAlertWithTitle(APP_Name, @"You can not delete friends post!!!");
        return;
    }
}
-(void)_deleteHandler:(NSString *)type :(NSString *)iActivityID
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        self.action = @"_deleteHandler";
        [[AppDelegate sharedInstance] showLoaderWithtext:@"Deleting Post" andDetailText:@"Please Wait"];
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&vType_of_content=%@&iActivityID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],type,iActivityID]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strDeletePost]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    } 
}

#pragma mark - Like Unlike
-(void)setZoomInEffect:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"imgbtnlike-h"] forState:UIControlStateNormal];
    
    btn.transform = CGAffineTransformMakeScale(1.5,1.5);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}
-(void)setZoomOutEffect:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1,1);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
    
    [btn setImage:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
}

-(void)setZoomInEffect2:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"imgbtndislike-h"] forState:UIControlStateNormal];
    
    btn.transform = CGAffineTransformMakeScale(1.5,1.5);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}
-(void)setZoomOutEffect2:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1,1);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
    
    [btn setImage:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];
}

-(IBAction)Like:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    selectedIndexPath=[sender tag];
    ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:[sender tag]];
    
    [self performSelector:@selector(setZoomInEffect:) withObject:btn];
    
    [self performSelector:@selector(setZoomOutEffect:) withObject:btn afterDelay:0.2];
    
    if (myFeed.isLocal)
    {
        DisplayAlert(@"Please wait until feed syncs with server.");
        return;
    }
    
    if ([myFeed.canLike isEqualToString:@"Yes"])
    {
        [self performSelectorInBackground:@selector(likeInBackground) withObject:nil];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Liked this post");
    }
}

-(void)likeInBackground
{
    @autoreleasepool
    {
        ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:selectedIndexPath];
        [self _Like:myFeed.vType_of_content :myFeed.iActivityID];
    }
}

-(void)_Like:(NSString *)type :(NSString *)iActivityID
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        return;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&vType_of_content=%@&iActivityID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],type,iActivityID]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strLikeFeed]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        NSError *theError;
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&theError];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (theError)
        {
            DisplayAlert(theError.localizedDescription);
            return;
        }

        NSMutableDictionary *dictT = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        [self likeComplete:dictT];
    }
}

-(void)likeComplete:(NSMutableDictionary *)dictT
{
    NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictT objectForKey:@"MESSAGE"]]] ;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    
    if ([strMSG isEqualToString:@"SUCCESS"])
    {
        ViewFeed *myFeed =[[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:selectedIndexPath];
        
        if ([myFeed.canLike isEqualToString:@"Yes"] && [myFeed.canUnLike isEqualToString:@"Yes"])
        {
            myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]+1];
        }
        else
        {
            myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]+1];
            if (![myFeed.vUnlikersIDs_count isEqualToString:@"0"])
            {
                myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]-1];
            }
        }
        
        myFeed.canLike = @"No";
        myFeed.canUnLike = @"Yes";
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
        NSString *strFileName=[NSString stringWithFormat:@"user_home_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
        NSMutableArray *oldDataArray=[[NSMutableArray alloc]init];
        NSMutableDictionary *dictoldData=[[NSMutableDictionary alloc]initWithDictionary:[strFileName getDataFromFile]];
        [oldDataArray addObjectsFromArray:[dictoldData objectForKey:@"USER_RECORDS"]];
        NSMutableDictionary *dicOldArr  =[[NSMutableDictionary alloc]initWithDictionary: [oldDataArray objectAtIndex:selectedIndexPath]];
        
        [dicOldArr setObject:[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]] forKey:@"vLikersIDs_count"];
        [dicOldArr setObject:[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]] forKey:@"vUnlikersIDs_count"];
        [dicOldArr setObject:@"No" forKey:@"canLike"];
        [dicOldArr setObject:@"Yes" forKey:@"canUnLike"];
        
        [oldDataArray replaceObjectAtIndex:selectedIndexPath withObject:dicOldArr];
        
        NSMutableDictionary *dictJSONWrite=[[NSMutableDictionary alloc]init];
        [dictJSONWrite setObject:oldDataArray forKey:@"USER_RECORDS"];
        [dictJSONWrite setObject:[dictoldData objectForKey:@"lastsync"] forKey:@"lastsync"];
        if ([dictoldData objectForKey:@"oldestfeed"])
        {
            [dictJSONWrite setObject:[dictoldData objectForKey:@"oldestfeed"] forKey:@"oldestfeed"];
            [dictJSONWrite writeToFileName:strFileName];
        }
        else
        {
//            DisplayAlert(kLastUpdateTimeNotReceived);
        }
    }
    
    [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
}

-(IBAction)UNLike:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    selectedIndexPath=[sender tag];
    ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:[sender tag]];
    
    [self performSelector:@selector(setZoomInEffect2:) withObject:btn];
    
    [self performSelector:@selector(setZoomOutEffect2:) withObject:btn afterDelay:0.2];
    
    if (myFeed.isLocal)
    {
        DisplayAlert(@"Please wait until feed syncs with server.");
        return;
    }
    
    if ([myFeed.canUnLike isEqualToString:@"Yes"])
    {
        [self performSelectorInBackground:@selector(unlikeInBackground) withObject:nil];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Disliked this post");
    }
}
-(void)unlikeInBackground
{
    @autoreleasepool
    {
        ViewFeed *myFeed = [[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:selectedIndexPath];
        [self _UNLike:myFeed.vType_of_content :myFeed.iActivityID];
    }
}
-(void)_UNLike:(NSString *)type :(NSString *)iActivityID
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&vType_of_content=%@&iActivityID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],type,iActivityID]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strUNLikeFeed]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        NSError *theError;
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&theError];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (theError)
        {
            DisplayAlert(theError.localizedDescription);
            return;
        }
        
        NSMutableDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        [self unlikeComplete:dictResponse];
    }
}

-(void)unlikeComplete:(NSMutableDictionary *)dictionary
{
    NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictionary objectForKey:@"MESSAGE"]]] ;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    if ([strMSG isEqualToString:@"SUCCESS"])
    {
        ViewFeed *myFeed =[[[MyAppManager sharedManager]arrMyFeeds] objectAtIndex:selectedIndexPath];
        
        if ([myFeed.canLike isEqualToString:@"Yes"] && [myFeed.canUnLike isEqualToString:@"Yes"])
        {
            myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]+1];
        }
        else
        {
            myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]+1];
            if (![myFeed.vLikersIDs_count isEqualToString:@"0"])
            {
                myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]-1];
            }
        }
        
        myFeed.canUnLike = @"No";
        myFeed.canLike = @"Yes";
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
        NSString *strFileName=[NSString stringWithFormat:@"user_home_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
        NSMutableArray *oldDataArray=[[NSMutableArray alloc]init];
        NSMutableDictionary *dictoldData=[[NSMutableDictionary alloc]initWithDictionary:[strFileName getDataFromFile]];
        [oldDataArray addObjectsFromArray:[dictoldData objectForKey:@"USER_RECORDS"]];
        NSMutableDictionary *dicOldArr  =[[NSMutableDictionary alloc]initWithDictionary: [oldDataArray objectAtIndex:selectedIndexPath]];
        
        [dicOldArr setObject:[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]] forKey:@"vLikersIDs_count"];
        [dicOldArr setObject:[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]] forKey:@"vUnlikersIDs_count"];
        [dicOldArr setObject:@"Yes" forKey:@"canLike"];
        [dicOldArr setObject:@"No" forKey:@"canUnLike"];
        
        [oldDataArray replaceObjectAtIndex:selectedIndexPath withObject:dicOldArr];

        NSMutableDictionary *dictJSONWrite=[[NSMutableDictionary alloc]init];
        [dictJSONWrite setObject:oldDataArray forKey:@"USER_RECORDS"];
        [dictJSONWrite setObject:[dictoldData objectForKey:@"lastsync"] forKey:@"lastsync"];
        if ([dictoldData objectForKey:@"oldestfeed"])
        {
            [dictJSONWrite setObject:[dictoldData objectForKey:@"oldestfeed"] forKey:@"oldestfeed"];
            [dictJSONWrite writeToFileName:strFileName];
        }
        else
        {
//            DisplayAlert(kLastUpdateTimeNotReceived);
        }
    }
    
    [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
}

-(void)btnProfilePicClicked:(id)sender
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:[sender tag]];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",myFeed.strOldProfilePic]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgURL,@"imgURL", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoZoom" object:dict];
}
-(void)btnMusicPicClicked:(id)sender
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:[sender tag]];
    NSString *strAlbumCoverURL=[NSString stringWithFormat:@"%@",myFeed.strYouTubeId];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",strAlbumCoverURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgURL,@"imgURL", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoZoom" object:dict];
}
-(void)btnMapClicked:(id)sender
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:[sender tag]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:myFeed.dcLatitude,@"dcLatitude",myFeed.dcLongitude,@"dcLongitude",myFeed.vIamAt,@"vAddress",myFeed.vIamAt2,@"vAddress2",myFeed.admin_fname,@"vName", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MapviewController" object:dict];
}

- (IBAction)thumbnilImage:(id)sender
{
    ViewFeed *myFeed = [[[MyAppManager sharedManager] arrMyFeeds] objectAtIndex:[sender tag]];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",myFeed.imgURLPOST]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgURL,@"imgURL", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoZoom" object:dict];
}
-(void)dealloc
{
    [self.TblView removeObserver:pull forKeyPath:@"contentOffset"];
}
#pragma mark - EXTRA METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyBGPostRefresh object:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
