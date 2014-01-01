//
//  FriendsProfileVC.m
//  Suvi
//
//  Created by Vivek Rajput on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsProfileVC.h"
#import "PhotoZoomViewController.h"
#import "StyleLabel.h"
#import "AllFeedsCustomCell.h"
#import "Constants.h"
#import "MyAppManager.h"
static NSUInteger selectedIndexPath;

@interface FriendsProfileVC ()
{
    IBOutlet StyleLabel *lblUserName;
    IBOutlet StyleLabel *lblSchoolName;
    IBOutlet StyleLabel *lblNumOfFriends;
    
    //Friends Info
    NSMutableDictionary *dictFriendINFO;
}
@end

@implementation FriendsProfileVC

@synthesize action,arrContent,PageCount,strTotalPageCount,shouldShowOnlyOneFeed,TblView;
@synthesize admin_id;
@synthesize strFrom;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dictWebViews=[[NSMutableDictionary alloc]init];
    [[SDWebImageDownloader sharedDownloader]setExecutionOrder:SDWebImageDownloaderLIFOExecutionOrder];
    //When Watch Video
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationController.navigationBar.hidden=TRUE;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    TblView.tableHeaderView = viewHeader;
    
    if (!shouldShowOnlyOneFeed)
    {
         pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.TblView withClient:self];
    }

    webData = [[NSMutableData alloc]init];
    self.action = @"";
    self.strTotalPageCount = @"0";
    self.arrContent = [[NSMutableArray alloc]init];
    [self _startSend];
    
    if (shouldShowOnlyOneFeed)
    {
        [self HideShowAllButtons:NO wink:YES note:YES imgName:@"bgnavbar" lblWidth:217];
    }
    else
    {
        [self HideShowAllButtons:YES wink:NO note:NO imgName:@"bgnavbar" lblWidth:153];
    }
    
    if ([strFrom isEqualToString:@"FriendRequestView"])
    {
        [self HideShowAllButtons:YES wink:YES note:YES imgName:@"bgnavbar" lblWidth:217];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(friendfeedsupdated:) name:@"kUpdateFriendFeeds" object:nil];
}
-(void)HideShowAllButtons:(BOOL)addfriend wink:(BOOL)winkfriend note:(BOOL)notefriend imgName:(NSString*)TopImg lblWidth:(CGFloat)width
{
    imgTopNavBar.image = [UIImage imageNamed:TopImg];
    btnAddFriend.hidden = addfriend;
    btnWinkFriend.hidden = winkfriend;
    btnNoteFriend.hidden = notefriend;
    lblUserNameTOP.frame = CGRectMake(lblUserNameTOP.frame.origin.x, lblUserNameTOP.frame.origin.y, width, lblUserNameTOP.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (shouldLoadUpdates)
    {
        shouldLoadUpdates=NO;
        [pullToRefreshManager_ performSelector:@selector(tableViewReloadFinished) withObject:nil afterDelay:1.0];
        [self _startSend];
    }
    else
    {
        if (!shouldShowOnlyOneFeed)
        {
            [pullToRefreshManager_ performSelector:@selector(tableViewReloadFinished) withObject:nil afterDelay:1.0];
            
            if (shouldUpdateFriendFeeds)
            {
                [self _startSend];
            }
        }
    }
}
-(void)friendfeedsupdated:(NSNotification *)notification
{
    shouldUpdateFriendFeeds=YES;
}
-(IBAction)ClickBack:(id)sender
{
    AddViewFlag=50;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)viewProfilePic:(id)sender
{
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[dictFriendINFO valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    PhotoZoomViewController *obj=[[PhotoZoomViewController alloc]init];
    obj.imgURL = imgURL;
    [self presentModalViewController:obj animated:YES];

}
-(IBAction)AddComment:(id)sender
{
     selectedIndexPath = ((UIButton *)sender).tag;
     ViewFeed *myFeed = [self.arrContent objectAtIndex:selectedIndexPath];
    
    shouldOpenKeyBoardforComment=([((UIButton *)sender).titleLabel.text isEqualToString:@"Comment"])?YES:NO;
    
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
        [dict setValue:[myFeed.vIamAt removeNull] forKey:@"strYouTubeTitle"];
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
    
     AddCommentView *objAddCommentView = [[AddCommentView alloc]initWithNibName:@"AddCommentView" bundle:nil];
     objAddCommentView.iActivityID = myFeed.iActivityID;
     objAddCommentView.vType_of_post = myFeed.vType_of_content;
    objAddCommentView.dictAllData=[dict copy];
    
     [self.navigationController presentModalViewController:objAddCommentView animated:YES];
}

#pragma mark - _startSend

-(void)_startSend
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    { 
        self.action = @"_startSend";
        [[AppDelegate sharedInstance]showLoader];
        NSMutableData *postData = [NSMutableData data];
        NSString *strPostURL=[NSString stringWithFormat:@"userID=%@&iFriendsID=%@&page=0",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],self.admin_id];

        [postData appendData: [[strPostURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        
        [urlRequest setURL:[NSURL URLWithString:strgetFriendFeeds]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)_startSendNextData:(NSString *)count
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        if (!shouldShowOnlyOneFeed)
        {
            [pullToRefreshManager_ tableViewReloadFinished];
        }
        return;
    }
    else
    { 
        self.action = @"_startSendNextData";
        
        NSString *strPG = [NSString stringWithFormat:@"%@",count];
        if ([strPG isEqualToString:self.strTotalPageCount])
        {
            [self.TblView reloadData];
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            return;
        }
        else
        {
            [[AppDelegate sharedInstance]showLoader];
            //:index.php?c=feeds&func=frontPageOfFriend&userID=187&iFriendsID=13&page=0
            NSMutableData *postData = [NSMutableData data];
            [postData appendData: [[[NSString stringWithFormat:@"userID=%@&iFriendsID=%@&page=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],self.admin_id,strPG]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            NSMutableURLRequest *urlRequest;
            urlRequest = [[NSMutableURLRequest alloc] init];
            
            [urlRequest setURL:[NSURL URLWithString:strgetFriendFeeds]];

            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:postData];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            [urlRequest setTimeoutInterval:kTimeOutInterval];

            connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        }
    }
    
}
#pragma mark - NSUrl Delegate
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString{    
    [self _receiveDidStopWithStatus:statusString];
}
#pragma mark - Receive Data
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [[AppDelegate sharedInstance]hideLoader];
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        if (!shouldShowOnlyOneFeed)
        {
            [pullToRefreshManager_ tableViewReloadFinished];
        }
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
    if (dictionary ==(id) [NSNull null])
    {
        if (!shouldShowOnlyOneFeed)
        {
            [pullToRefreshManager_ tableViewReloadFinished];
        }
        
        return;
    }
    else if ([self.action isEqualToString:@"_Like"])
    {
        self.action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictionary objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            self.action = @"";
            ViewFeed* myFeed =[self.arrContent objectAtIndex:selectedIndexPath];
            int awayScore = [myFeed.Total_like_unlikes intValue];
            if ([myFeed.canLike isEqualToString:@"Yes"] && [myFeed.canUnLike isEqualToString:@"Yes"])
            {
                myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]+1];
                myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]];
                awayScore+=1;
            }
            else
            {
                myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]+1];
                myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]-1];
            }
            if ([myFeed.canLike isEqualToString:@"Yes"])
            {
                myFeed.canLike = @"No";
                myFeed.canUnLike = @"Yes";
            }
            else
            {
                myFeed.canLike = @"Yes";
                myFeed.canUnLike = @"No";
            }

            [TblView reloadData];
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
        }
        else
        {
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            DisplayAlertWithTitle(APP_Name, strMSG);
            return;
        }
    }
    else if ([self.action isEqualToString:@"_UNLike"])
    {
        self.action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictionary objectForKey:@"MESSAGE"]]] ;
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            self.action = @"";
            ViewFeed* myFeed =[self.arrContent objectAtIndex:selectedIndexPath];
            int awayScore = [myFeed.Total_like_unlikes intValue];
            if ([myFeed.canLike isEqualToString:@"Yes"] && [myFeed.canUnLike isEqualToString:@"Yes"])
            {
                myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]];
                myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]+1];
                awayScore =  awayScore+1;
            }
            else
            {
                myFeed.vLikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vLikersIDs_count intValue]-1];
                myFeed.vUnlikersIDs_count =[NSString stringWithFormat:@"%d",[myFeed.vUnlikersIDs_count intValue]+1];
                awayScore =  awayScore;
            }
            
            if ([myFeed.canUnLike isEqualToString:@"Yes"])
            {
                myFeed.canUnLike = @"No";
                myFeed.canLike = @"Yes";
            }
            else
            {
                myFeed.canUnLike = @"Yes";
                myFeed.canLike = @"No";
            }

            [TblView reloadData];
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
        }
        else
        {
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            DisplayAlertWithTitle(APP_Name, strMSG);
            return;
        }
    }
    else if ([self.action isEqualToString:@"_startSend"])
    {
        self.action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        if ([strMSG isEqualToString:@""])
        {
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
        
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            dictFriendINFO = [[NSMutableDictionary alloc]initWithDictionary:[dictionary objectForKey:@"LoggedinUser"]];
            
            BOOL shouldHideAddButton=([[dictFriendINFO objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
                                      [[dictFriendINFO objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])?NO:YES;
            
            [self HideShowAllButtons:shouldHideAddButton wink:(![[dictFriendINFO objectForKey:@"isAlreadyFrnd"] isEqualToString:@"YES"]) note:(![[dictFriendINFO objectForKey:@"isAlreadyFrnd"] isEqualToString:@"YES"]) imgName:@"bgnavbar" lblWidth:217];
            
            lblUserNameTOP.text = [NSString stringWithFormat:@"%@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_fname"]]];
            
            lblUserName.colors=[NSArray arrayWithObjects:
                                [UIColor colorWithWhite:1.0 alpha:1.0],
                                [UIColor colorWithWhite:1.0 alpha:0.8],
                                nil];
            lblUserName.textAlignment=UITextAlignmentLeft;
            [lblUserName setShadowOffset:CGSizeMake(0,0) radius:2.0];
            
            lblSchoolName.colors=[NSArray arrayWithObjects:
                                    [UIColor colorWithWhite:1.0 alpha:1.0],
                                    [UIColor colorWithWhite:1.0 alpha:0.8],
                                    nil];
            lblSchoolName.textAlignment=UITextAlignmentLeft;
            [lblSchoolName setShadowOffset:CGSizeMake(0,0) radius:2.0];

            
            lblNumOfFriends.colors=[NSArray arrayWithObjects:
                                    [UIColor colorWithWhite:1.0 alpha:1.0],
                                    [UIColor colorWithWhite:1.0 alpha:0.8],
                                    nil];
            lblNumOfFriends.textAlignment=UITextAlignmentLeft;
            [lblNumOfFriends setShadowOffset:CGSizeMake(0,0) radius:2.0];
            
            lblUserName.text = [NSString stringWithFormat:@"%@ %@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_fname"]],[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_lname"]]];
            lblSchoolName.text = [NSString stringWithFormat:@"%@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"school"]]];
            lblNumOfFriends.text = [NSString stringWithFormat:@"%@ Friends \u2022 %@ in Common",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"numFriends"]],[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"No_of_mutualFriends"]]];
            
            
            int count=[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"numFriends"]] intValue];
            BOOL isPopular = ([[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"eAccountStatus"] isEqualToString:@"Popular"])?YES:NO;
            int badgecount=(count>=100)?100:((count>=50)?50:((count>=20)?20:0));
            imgBadge.image = [UIImage imageNamed:[NSString stringWithFormat:@"badge%@_%d.png",(isPopular)?@"p":@"",badgecount]];
            
            
            [imgProfile setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
            
            [imgCoverPic setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"COVERPIC_URL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
            
            UIImage *imgCover = imgCoverPic.image;
            float widthCover = [[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"width_coverPic"] floatValue];
            float heightCover = [[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"height_coverPic"] floatValue];
        widthCover=MAX(100, widthCover);
        heightCover=MAX(100, heightCover);

            float viewheight=MAX((heightCover*320.0)/widthCover, 160.0);
            float imgdiff=(viewheight==160.0)?((160.0-((heightCover*320.0)/widthCover))/2.0):0.0;
            imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
            btnCoverPic.frame = imgCoverPic.frame;
            viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
            
            imgCoverPic.image = imgCover;
            TblView.tableHeaderView = viewHeader;
            
            [self.arrContent removeAllObjects];
            
            
            
            self.strTotalPageCount =[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Page_COUNT"]];
            
            for (int i =0; i<[[dictionary valueForKey:@"USER_RECORDS"] count]; i++)
            {
                NSMutableDictionary *dict = [[[dictionary valueForKey:@"USER_RECORDS"]objectAtIndex:i] copy];
                
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
                else if ([myFeed.vType_of_content isEqualToString:@"winked"])
                {
                    myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wink_id"]]];
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

                [self.arrContent addObject:myFeed];
                
            } 
            
            [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
            
            if (shouldUpdateFriendFeeds)
            {
                shouldUpdateFriendFeeds=NO;
                
                if ([self.arrContent count]>0)
                {
                    [self.TblView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
            }
        }
        else if ([strMSG isEqualToString:@"DATA NOT FOUND."])
        {
            if ([dictionary objectForKey:@"LoggedinUser"]) {
                dictFriendINFO = [[NSMutableDictionary alloc]initWithDictionary:[dictionary objectForKey:@"LoggedinUser"]];
                
                lblUserNameTOP.text = [NSString stringWithFormat:@"%@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_fname"]]];
                
                lblUserName.colors=[NSArray arrayWithObjects:
                                    [UIColor colorWithWhite:1.0 alpha:1.0],
                                    [UIColor colorWithWhite:1.0 alpha:0.8],
                                    nil];
                lblUserName.textAlignment=UITextAlignmentLeft;
                [lblUserName setShadowOffset:CGSizeMake(0,0) radius:2.0];
                
                lblSchoolName.colors=[NSArray arrayWithObjects:
                                      [UIColor colorWithWhite:1.0 alpha:1.0],
                                      [UIColor colorWithWhite:1.0 alpha:0.8],
                                      nil];
                lblSchoolName.textAlignment=UITextAlignmentLeft;
                [lblSchoolName setShadowOffset:CGSizeMake(0,0) radius:2.0];
                
                
                lblNumOfFriends.colors=[NSArray arrayWithObjects:
                                        [UIColor colorWithWhite:1.0 alpha:1.0],
                                        [UIColor colorWithWhite:1.0 alpha:0.8],
                                        nil];
                lblNumOfFriends.textAlignment=UITextAlignmentLeft;
                [lblNumOfFriends setShadowOffset:CGSizeMake(0,0) radius:2.0];
                
                lblUserName.text = [NSString stringWithFormat:@"%@ %@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_fname"]],[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"admin_lname"]]];
                lblSchoolName.text = [NSString stringWithFormat:@"%@",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"school"]]];
                lblNumOfFriends.text = [NSString stringWithFormat:@"%@ Friends \u2022 %@ in Common",[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"numFriends"]],[self removeNull:[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"No_of_mutualFriends"]]];
                
                
                int count=[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"numFriends"]] intValue];
                BOOL isPopular = ([[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"eAccountStatus"] isEqualToString:@"Popular"])?YES:NO;
                int badgecount=(count>=100)?100:((count>=50)?50:((count>=20)?20:0));
                imgBadge.image = [UIImage imageNamed:[NSString stringWithFormat:@"badge%@_%d.png",(isPopular)?@"p":@"",badgecount]];
                
                
                [imgProfile setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
                
                [imgCoverPic setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"COVERPIC_URL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
                
                UIImage *imgCover = imgCoverPic.image;
                float widthCover = [[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"width_coverPic"] floatValue];

                float heightCover = [[[dictionary objectForKey:@"LoggedinUser"]valueForKey:@"height_coverPic"] floatValue];
                widthCover=MAX(100, widthCover);
                heightCover=MAX(100, heightCover);
                float viewheight=MAX((heightCover*320.0)/widthCover, 160.0);
                float imgdiff=(viewheight==160.0)?((160.0-((heightCover*320.0)/widthCover))/2.0):0.0;
                imgCoverPic.frame = CGRectMake(0,imgdiff,320.0,(heightCover*320.0)/widthCover);
                btnCoverPic.frame = imgCoverPic.frame;
                viewHeader.frame = CGRectMake(0, 0, 320.0,viewheight);
                
                imgCoverPic.image = imgCover;
                TblView.tableHeaderView = viewHeader;
                [TblView reloadData];
            }
            
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
        else
        {
            DisplayAlertWithTitle(APP_Name, strMSG);
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
    }
    else if ([self.action isEqualToString:@"_startSendNextData"])
    {
        self.action = @"";
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        if ([strMSG isEqualToString:@""])
        {
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
        
        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            for (int i =0; i<[[dictionary valueForKey:@"USER_RECORDS"] count]; i++)
            {
                NSMutableDictionary *dict = [[[dictionary valueForKey:@"USER_RECORDS"]objectAtIndex:i] copy];
                
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
                else if ([myFeed.vType_of_content isEqualToString:@"winked"])
                {
                    myFeed.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wink_id"]]];
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
                
                [self.arrContent addObject:myFeed];
                
            }
            
            [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
        }
        else if ([strMSG isEqualToString:@"DATA NOT FOUND."])
        {
            DisplayAlertWithTitle(APP_Name,@"No More Feed Available!");
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
        else
        {
            DisplayAlertWithTitle(APP_Name, strMSG);
            if (!shouldShowOnlyOneFeed)
            {
                [pullToRefreshManager_ tableViewReloadFinished];
            }
            
            return;
        }
    }
}
-(void)ReloadTableData
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    TblView.alpha=1;
    [UIView commitAnimations];
    [TblView reloadData];
    if (!shouldShowOnlyOneFeed)
    {
        [pullToRefreshManager_ tableViewReloadFinished];
    }
}

#pragma mark - Create CommentView
#pragma mark - Remove NULL

-(NSString *)removeNull:(NSString *)str
{
    if (![str isKindOfClass:[NSString class]])
    {
        return @"";
    }
    
    return [str removeNull];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]]];
    
    TblView.frame=CGRectMake(0,44+iOS7ExHeight,320,417+iPhone5ExHeight);
    
    if (!shouldShowOnlyOneFeed)
    {
        [pullToRefreshManager_ tableViewScrolled];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!shouldShowOnlyOneFeed)
    {
        [pullToRefreshManager_ tableViewReleased];
    }
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    if (![strTotalPageCount isEqualToString:@"0"])
    {
        if (!shouldShowOnlyOneFeed)
        {
            self.PageCount++;
            NSString *strPG = [NSString stringWithFormat:@"%d",self.PageCount];
            
            if ([strPG isEqualToString:self.strTotalPageCount])
            {
                [self.TblView reloadData];
                [pullToRefreshManager_ performSelector:@selector(tableViewReloadFinished) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
                
                [pullToRefreshManager_ performSelector:@selector(tableViewReloadFinished) withObject:nil afterDelay:1.2f];
            }
            else
            {
                [self _startSendNextData:strPG];
            }
        }
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!shouldShowOnlyOneFeed)
    {
        [pullToRefreshManager_ relocatePullToRefreshView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TblView.scrollEnabled=(shouldShowOnlyOneFeed)?NO:YES;
    return (shouldShowOnlyOneFeed)?0:[self.arrContent count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewFeed *myFeed = [self.arrContent objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@%@",myFeed.vType_of_content,myFeed.iActivityID];
    
    AllFeedsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AllFeedsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withIndex:indexPath.row dataMyFeed:myFeed isFromHome:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.btnProfilePic.userInteractionEnabled=NO;
    
    //HEADER--
    
    if([myFeed.vType_of_content isEqualToString:@"birthdaywish"])
    {
        cell.imgProfilePic.image=[UIImage imageNamed:@"birthdaycake.png"];
        cell.imgProfilePic.backgroundColor=[UIColor lightGrayColor];
    }
    else
    {
        [cell.imgProfilePic setImageWithURL:[NSURL URLWithString:myFeed.imgURL] placeholderImage:[UIImage imageNamed:@"sync.png"]];
        cell.imgProfilePic.backgroundColor=[UIColor clearColor];
    }
    
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
        [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:myFeed.imgURLPOST] placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
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
                NSString *embeddedHtml = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {background-color: transparent;color: white;} </style></head><body style=\"margin:0\"> <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"310.0f\" height=\"310.0f\"></embed></body></html>",myFeed.imgURLPOST];
                [cell.webViewVideo loadHTMLString:embeddedHtml baseURL:nil];
                
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
            [cell.imgViewPicture setImageWithURL:[NSURL URLWithString:[strAlbumCoverURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"sync.png"]];
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
//        cell.btnViewPicture.tag = [[NSString stringWithFormat:@"%@",[self removeNull:myFeed.iFriendsID]] integerValue];
//        [cell.btnViewPicture addTarget:self action:@selector(btnViewProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
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
//        cell.btnViewPicture.tag =cell.btnViewPicture.tag = [[NSString stringWithFormat:@"%@",[self removeNull:myFeed.iAdminID]] integerValue];;
//        
//        [cell.btnViewPicture addTarget:self action:@selector(btnViewProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
    cell.btnDisLike.userInteractionEnabled=([myFeed.canUnLike isEqualToString:@"No"])?NO:YES;
    
    //pp12
    [cell.btnComment setTitleColor:([myFeed.hasCommented isEqualToString:@"Yes"])?cell.viewUpperBorder.backgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [cell.btnLike setImage:([myFeed.canLike isEqualToString:@"No"])?[UIImage imageNamed:@"imgbtnlike-h"]:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
    [cell.btnDisLike setImage:([myFeed.canUnLike isEqualToString:@"No"])?[UIImage imageNamed:@"imgbtndislike-h"]:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];
    
    [cell.btnLike addTarget:self action:@selector(Like:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDisLike addTarget:self action:@selector(UNLike:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikeCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCommentCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDisLikeCount addTarget:self action:@selector(AddComment:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewFeed *myFeed = [self.arrContent objectAtIndex:indexPath.row];
    float finalHeight = [myFeed.labelHeight floatValue];
    if([myFeed.vType_of_content isEqualToString:@"image"])
    {
        float imageoriginy=([myFeed.labelHeight floatValue]==0)?52:(58.0+[myFeed.labelHeight floatValue]+10.0);
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
        
        finalHeight=imageoriginy+imageheight+34.0+5.0;
    }
    else if([myFeed.vType_of_content isEqualToString:@"video"])
    {
        float imageoriginy=([myFeed.labelHeight floatValue]==0)?52:(58.0+[myFeed.labelHeight floatValue]+10.0);
        finalHeight=imageoriginy+(([myFeed.strYouTubeId length]!=0)?90.0:310.0)+34.0+5.0;
    }
    else if([myFeed.vType_of_content isEqualToString:@"music"]
            || [myFeed.vType_of_content isEqualToString:@"wrote"]
            || [myFeed.vType_of_content isEqualToString:@"birthdaywish"]
            || [myFeed.vType_of_content isEqualToString:@"profile_update"]
            || [myFeed.vType_of_content isEqualToString:@"nowfriends"]
            || [myFeed.vType_of_content isEqualToString:@"badge"])
    {
        float imageoriginy=([myFeed.labelHeight floatValue]==0)?52:(58.0+[myFeed.labelHeight floatValue]+10.0);
        imageoriginy=([myFeed.vType_of_content isEqualToString:@"profile_update"])?73.0:imageoriginy;
        imageoriginy=([myFeed.vType_of_content isEqualToString:@"badge"])?52:imageoriginy;
        
        if ([myFeed.vType_of_content isEqualToString:@"nowfriends"])
        {
            imageoriginy-=5.0;
        }

        float midheight=(([myFeed.vType_of_content isEqualToString:@"badge"])?48:69);
        midheight=(([myFeed.vType_of_content isEqualToString:@"wrote"])?0:midheight);
        
        finalHeight=imageoriginy+midheight+34.0+5.0;
    }
    else if([myFeed.vType_of_content isEqualToString:@"location"])
    {
        float imageoriginy=([myFeed.labelHeight floatValue]==0)?52:(58.0+[myFeed.labelHeight floatValue]+10.0);
        finalHeight=imageoriginy+90.0+34.0+5.0;
    }
    else
    {
        finalHeight =58.0+[myFeed.labelHeight floatValue]+10.0+34.0+5.0;
    }
    
    return finalHeight;

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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

#pragma mark - Watch Video
-(IBAction)WatchVideo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ViewFeed *myFeed = [self.arrContent objectAtIndex:btn.tag];
    WatchVideoViewController *objWatchVideoViewController = [[WatchVideoViewController alloc]initWithNibName:@"WatchVideoViewController" bundle:nil];
    objWatchVideoViewController.imgURLPOST=myFeed.imgURLPOST;
    [self presentModalViewController:objWatchVideoViewController animated:YES];
}
#pragma mark - Like
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
-(void)setZoomInEffect3:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1.5,1.5);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}
-(void)setZoomOutEffect3:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1,1);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}

-(IBAction)Like:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    selectedIndexPath=[sender tag];
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    
    [self performSelector:@selector(setZoomInEffect:) withObject:btn];
    
    [self performSelector:@selector(setZoomOutEffect:) withObject:btn afterDelay:0.2];
    
    if ([myFeed.canLike isEqualToString:@"Yes"])
    {
        ViewFeed *myFeed = [self.arrContent objectAtIndex:selectedIndexPath];
        [self _Like:myFeed.vType_of_content :myFeed.iActivityID];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Liked this post");
    }
}

-(void)_Like:(NSString *)type :(NSString *)iActivityID
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        self.action = @"_Like";
        
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
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
#pragma mark - UNLike
-(IBAction)UNLike:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    selectedIndexPath=[sender tag];
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    
    [self performSelector:@selector(setZoomInEffect2:) withObject:btn];
    
    [self performSelector:@selector(setZoomOutEffect2:) withObject:btn afterDelay:0.2];
    
    
    if ([myFeed.canUnLike isEqualToString:@"Yes"])
    {
        ViewFeed *myFeed = [self.arrContent objectAtIndex:selectedIndexPath];
        [self _UNLike:myFeed.vType_of_content :myFeed.iActivityID];
        //[self performSelectorInBackground:@selector(unlikeInBackground) withObject:nil];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Disliked this post");
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
        self.action = @"_UNLike";
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
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

#pragma mark - Wink
-(IBAction)btnWinkPressed:(id)sender
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [self performSelector:@selector(setZoomInEffect3:) withObject:(UIButton *)sender];
        [self performSelector:@selector(setZoomOutEffect3:) withObject:(UIButton *)sender afterDelay:0.2];
        [self performSelectorInBackground:@selector(winkinbg) withObject:nil];
    }
}

-(void)winkinbg
{
    NSMutableData *postData = [NSMutableData data];
    [postData appendData: [[[NSString stringWithFormat:@"userID=%@&iFriendsID=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[self.admin_id intValue]]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *urlRequest;
    urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:strWinked]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSMutableDictionary *dictT = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
    NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictT objectForKey:@"MESSAGE"]]] ;
    [self performSelectorOnMainThread:@selector(winkComplete:) withObject:strMSG waitUntilDone:YES];
}
-(void)winkComplete:(NSString *)strMSG
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    else if ([strMSG isEqualToString:@"SUCCESS"])
    {
        NSString *strWinkedMsg = [NSString stringWithFormat:@"You have winked at %@",lblUserNameTOP.text];
        DisplayAlertWithTitle(@"Winked!", strWinkedMsg);
    }
    else
    {
        DisplayAlertWithTitle(@"Note", strMSG);
        return;
    }
}
#pragma mark - Post On Friends Wall
-(IBAction)btnpostPressed:(id)sender
{
    if(!tfautoExpandPost.isFirstResponder)
    {
        SetKeyBoardTag = YES;
        [self AddAutoExpandTextField];
        containerView.frame = CGRectMake(-2, self.view.frame.size.height - 38, 327, 45);
        [tfautoExpandPost becomeFirstResponder];
    }
}

#pragma mark - Send Request To Friend
-(IBAction)btnSendFriendRequest:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;

    [self performSelector:@selector(sendfrreq) withObject:nil afterDelay:0.5];
}

-(void)sendfrreq
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&frndIDs=%@&sometext=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],self.admin_id,@""]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:kSendFriendRequestURL]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        
        
        NSData *myData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSMutableDictionary *dictT = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictT objectForKey:@"MESSAGE"]]];
        
        if ([strMSG isEqualToString:@""])
        {
            return;
        }
        else if ([strMSG isEqualToString:@"SUCCESS"])
        {
            DisplayAlert(@"Friend request sent!");
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

#pragma mark - View All Comments
#pragma mark - TapGesture
-(void)btnProfilePicClicked:(id)sender
{
    
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",myFeed.strOldProfilePic]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgURL,@"imgURL", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoZoom" object:dict];
}
-(void)btnMusicPicClicked:(id)sender
{
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    NSString *strAlbumCoverURL=[NSString stringWithFormat:@"%@",myFeed.strYouTubeId];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",strAlbumCoverURL]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imgURL,@"imgURL", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoZoom" object:dict];
}
-(void)btnMapClicked:(id)sender
{
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:myFeed.dcLatitude,@"dcLatitude",myFeed.dcLongitude,@"dcLongitude",myFeed.vIamAt,@"vAddress",myFeed.vIamAt2,@"vAddress2",myFeed.admin_fname,@"vName", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MapviewController" object:dict];
}

- (IBAction)thumbnilImage:(id)sender
{
    ViewFeed *myFeed = [self.arrContent objectAtIndex:[sender tag]];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",myFeed.imgURLPOST]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    PhotoZoomViewController *obj=[[PhotoZoomViewController alloc]init];
    obj.imgURL = imgURL;
    [self presentModalViewController:obj animated:YES];
}

#pragma mark - EXTRA METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"kUpdateFriendFeeds" object:nil];
    lblSchoolName = nil;
    lblNumOfFriends = nil;
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

#pragma mark - Add AutoExpand TextField
-(void)AddAutoExpandTextField
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(-2, self.view.frame.size.height, 323, 45)];
    
	tfautoExpandPost = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 7, 250, 25)];
    tfautoExpandPost.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
	tfautoExpandPost.minNumberOfLines = 1;
	tfautoExpandPost.maxNumberOfLines = 6;
	tfautoExpandPost.returnKeyType = UIReturnKeyGo; //just as an example
	tfautoExpandPost.font = [UIFont systemFontOfSize:15.0f];
	tfautoExpandPost.delegate = self;
//    [tfautoExpandPost setPlaceHolderTextView:@"Write a note..."];
    tfautoExpandPost.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    tfautoExpandPost.backgroundColor = [UIColor clearColor];
    tfautoExpandPost.textColor = [UIColor blackColor];
    
    [[tfautoExpandPost layer] setMasksToBounds:YES];
    [[tfautoExpandPost layer] setCornerRadius:5.0f];
    [[tfautoExpandPost layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[tfautoExpandPost layer] setBorderWidth:1.0f];
    [[tfautoExpandPost layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[tfautoExpandPost layer] setShadowOffset:CGSizeMake(0, 0)];
    [[tfautoExpandPost layer] setShadowRadius:2.0];
    
    [self.view addSubview:containerView];
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(-2, 2, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tfautoExpandPost.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:tfautoExpandPost];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width -65, 12, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Post" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [doneBtn setTitleColor:RGBCOLOR(242.0, 108.0, 79.0) forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
-(void)resignTextView
{
    [tfautoExpandPost resignFirstResponder];
    NSString *strPostComment = [tfautoExpandPost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strPostComment length]>0)
    {
        if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
        {
            DisplayNoInternate;
            return;
        }
        else
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            
            [self performSelectorInBackground:@selector(notePostinBG:) withObject:strPostComment];
            
        }
    }
    containerView.frame = CGRectMake(-2, self.view.frame.size.height, 327, 45);
}
-(void)notePostinBG:(NSString*)strPostComment
{
    NSURL *urlPost=[NSURL URLWithString:strPostonwall];
    NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
    [dictPostParameters setObject:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] forKey:@"userID"];
    [dictPostParameters setObject:self.admin_id forKey:@"frndIDS"];
    [dictPostParameters setObject:strPostComment forKey:@"vActivityText"];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:urlPost];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData  *body = [[NSMutableData alloc] init];
    
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    for (NSString *theKey in [dictPostParameters allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostParameters objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postRequest setHTTPBody:body];
    
//    NSMutableData *postData = [NSMutableData data];
//    [postData appendData: [[[NSString stringWithFormat:@"userID=%@&frndIDS=%d&vActivityText=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[self.admin_id intValue],strPostComment]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    NSMutableURLRequest *urlRequest;
//    urlRequest = [[NSMutableURLRequest alloc] init];
//    [urlRequest setURL:[NSURL URLWithString:strPostonwall]];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [urlRequest setHTTPBody:postData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSData *myData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSMutableDictionary *dictT = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:nil];
    NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictT objectForKey:@"MESSAGE"]]] ;
    
    [self performSelectorOnMainThread:@selector(notePostDone:) withObject:strMSG waitUntilDone:YES];
    
}
-(void)notePostDone:(NSString *)strMSG
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    else if ([strMSG isEqualToString:@"SUCCESS"])
    {
        tfautoExpandPost.text = @"";
    }
    else
    {
        DisplayAlertWithTitle(@"Note", strMSG);
        return;
    }
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
    if (SetKeyBoardTag)
    {
        containerView.frame = containerFrame;
    }
    SetKeyBoardTag = NO;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
    if (SetKeyBoardTag)
    {
        [containerView removeFromSuperview];
    }
    SetKeyBoardTag = NO;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}
@end
