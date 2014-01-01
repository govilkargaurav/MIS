//
//  LeftViewController.m
//  ViewDeckExample
//


#import "LeftViewController.h"
#import "IIViewDeckController.h"
#import "SettingViewController.h"
#import "AddCommentView.h"
#import "CustomBadge.h"

@implementation LeftViewController
@synthesize action;
@synthesize arrContent;
@synthesize PageCount,strTotalPageCount,tblView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoading = NO;
    strMyorFriendsActivity = @"_MyActivitiesGET";
    
    self.action = @"";
    self.strTotalPageCount = @"0";
    self.arrContent = [[NSMutableArray alloc]init];
    webData = [[NSMutableData alloc]init];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfilePic) name:@"updateProfilePic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MyorFriendsActivity) name:@"_GetActivities" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showWinkCount:) name:@"showWinkCount" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HideWinkCount) name:@"HideWinkCount" object:nil];
    
    self.view.backgroundColor = RGBCOLOR(33, 33, 33);//[UIColor colorWithPatternImage:[UIImage imageNamed:@"GreyBG.png"]];
    NSNotification *notif = [NSNotification notificationWithName:@"updateProfilePic" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
    CGRect tblframe=tblView.frame;
    tblframe.size.height+=iPhone5ExHeight;
    tblView.frame=tblframe;
}

-(void)updateProfilePic
{
    lblUsername.text = [NSString stringWithFormat:@"%@ %@",[self removeNull:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_fname"]],[self removeNull:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_lname"]]];
    NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    imgUserProfilePic.tag=1001;
    [imgUserProfilePic setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Home MyFeed Setting
-(IBAction)btnCliked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            FlagView1=btn.tag+1;

            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller)
            {
                if ([controller.centerController isKindOfClass:[UINavigationController class]])
                {
                    UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
                    if ([cc respondsToSelector:@selector(tableView)])
                    {
                        [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];    
                    }
                }
                [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
            }];
            NSNotification *notif = [NSNotification notificationWithName:@"pushIt" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        break;
            
        case 1:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HideWinkCount" object:nil];
            
            FlagView1=btn.tag+1;
            
            [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller)
             {
                if ([controller.centerController isKindOfClass:[UINavigationController class]])
                {
                    UITableViewController* cc = (UITableViewController*)((UINavigationController*)controller.centerController).topViewController;
                    if ([cc respondsToSelector:@selector(tableView)])
                    {
                        [cc.tableView deselectRowAtIndexPath:[cc.tableView indexPathForSelectedRow] animated:NO];    
                    }
                }
                [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0]; // mimic delay... not really necessary
            }];
            NSNotification *notif = [NSNotification notificationWithName:@"pushIt" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        break;
        
        case 2:
        {
            SettingViewController *obj=[[SettingViewController alloc]init];
            [self.navigationController pushViewController:obj animated:YES];             
        }
        break;
    }
}

#pragma mark - My OR Friends
-(void)MyorFriendsActivity
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideNotificationCOUNT" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideNotificationCOUNTMyFeed" object:nil];
    
    [self updateProfilePic];
    [self _GetActivities];
}
-(void)showWinkCount:(NSNotification *)notif
{
    NSString *strNotiCount = [NSString stringWithFormat:@"%@",[notif.object valueForKey:@"wink_badges"]];
    if([[self removeNull:strNotiCount] integerValue]!=0)
    {
        CustomBadge *PendingRequestCountBadge = [CustomBadge customBadgeWithString:[self removeNull:strNotiCount] withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.7 withShining:YES];
        [PendingRequestCountBadge setFrame:CGRectMake(30,37+iOS7ExHeight, PendingRequestCountBadge.frame.size.width, PendingRequestCountBadge.frame.size.height)];
        [self.view addSubview:PendingRequestCountBadge];
        [self.view bringSubviewToFront:PendingRequestCountBadge];
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
-(void)HideWinkCount
{
    for (UIView *subview in self.view.subviews)
    {
        if ([subview isKindOfClass:[CustomBadge class]])
        {
            [subview removeFromSuperview];
        }
    }
}
#pragma mark - _GetActivities
-(IBAction)_GetActivitiesGET:(id)sender
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [self.arrContent removeAllObjects];
        [tblView reloadData];
        [self _GetActivities];
    }
}
-(void)_GetActivities
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    { 
        [btnMy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        isLoading = NO;
        strMyorFriendsActivity = @"_GetActivities";
        self.action = @"_GetActivities";
        self.strTotalPageCount = @"0";
        self.PageCount = 0;
 
        indicatorActivity.hidden = NO;
        [indicatorActivity startAnimating];
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&page=0",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strGetActivities]];
        
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)_startSendNextActivities:(NSString *)count
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    { 
        self.action = @"_startSendNextActivities";
        
        NSString *strPG = [NSString stringWithFormat:@"%@",count];
        if ([strPG isEqualToString:self.strTotalPageCount])
        {
            return;
        }
        else
        {
            indicatorActivity.hidden = NO;
            [indicatorActivity startAnimating];
            
            tblView.tableFooterView = viewFooter;
            [indicator startAnimating];
            
            NSMutableData *postData = [NSMutableData data];
            [postData appendData: [[[NSString stringWithFormat:@"userID=%@&page=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],strPG]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *urlRequest;
            urlRequest = [[NSMutableURLRequest alloc] init];
            [urlRequest setURL:[NSURL URLWithString:strGetActivities]]; 
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:postData];
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

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self _stopReceiveWithStatus:@"Connection failed"];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString
{
    [self _receiveDidStopWithStatus:statusString];
}

#pragma mark - Receive Data
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

-(void)setData:(NSMutableDictionary*)dictionary
{
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }
    //|| [self.action isEqualToString:@"_MYActivities"]
    if ([self.action isEqualToString:@"_GetActivities"] ||
        [self.action isEqualToString:@"_startSendNextActivities"])
    {
        [indicatorActivity stopAnimating];
        indicatorActivity.hidden = YES;

        NSString *strMSG =[NSString stringWithFormat:@"%@",[self removeNull:[dictionary objectForKey:@"MESSAGE"]]] ;

        if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            UIFont *myFont = [UIFont boldSystemFontOfSize:12];
            CGFloat constrainedSize = 201.0f;
            if ([self.action isEqualToString:@"_GetActivities"])
            {
                [self.arrContent removeAllObjects];
                self.strTotalPageCount =[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Page_COUNT"]];
            }
            
            for (int i =0; i<[[dictionary valueForKey:@"USER_RECORDS"] count]; i++)
            {
                NSMutableDictionary *dict = [[[dictionary valueForKey:@"USER_RECORDS"]objectAtIndex:i] copy];
                
                ViewActivity *myActivity = [[ViewActivity alloc]init];
                myActivity.vType_of_content = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vType_of_content"]]];
                myActivity.Status = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"Status"]]];
                myActivity.TagLine = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"TagLine"]]];
                myActivity.postOwner_fname = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"postOwner_fname"]]];
                myActivity.postOwner_lname = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"postOwner_lname"]]];
                
                if ([myActivity.vType_of_content isEqualToString:@"activity"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iActivityID"]]]; 
                }
                else if ([myActivity.vType_of_content isEqualToString:@"location"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iGroupLocationID"]]];
                    myActivity.dcLatitude =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"dcLatitude"]]];
                    myActivity.dcLongitude =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"dcLongitude"]]];
                }
                else if ([myActivity.vType_of_content isEqualToString:@"image"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iImageID"]]];
                    myActivity.imgURLPOST=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vimageName"]]];
                    myActivity.imageHeight=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"height"]]];
                    myActivity.imageWidth=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"width"]]];
                }
                else if ([myActivity.vType_of_content isEqualToString:@"video"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iVideoID"]]];
                    myActivity.imgURLPOST=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"url"]]];
                    myActivity.strYouTubeId=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"video_url"]]];
                    myActivity.strYouTubeTitle=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vTitle"]]];
                    
                }
                else if ([myActivity.vType_of_content isEqualToString:@"music"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iMusicID"]]];
                    myActivity.music_img=[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"music_img"]]];
                    myActivity.strYouTubeTitle = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vMusicName"]]];
                    myActivity.strAlbumTitle = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vMusicName2"]]];
                    
                }
                else if([myActivity.vType_of_content isEqualToString:@"wrote"])
                {
                    //generalText,wrote_id,wroteBy_id,wrotedBy_image_path,wrotedBy_Name,UserInfo;
                    
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrote_id"]]];
                    
                    myActivity.generalText =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"generalText"]]];
                    myActivity.wroteBy_id =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteBy_id"]]];
                    myActivity.wrotedOn_Name = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrotedOn_Name"]]];
                    myActivity.wrotedOn_image_path =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wrotedOn_image_path"]]];
                    myActivity.wroteOn_hasFriends = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteOn_hasFriends"]]];
                    myActivity.wroteOn_School= [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"wroteOn_School"]]];
                }
                else if([myActivity.vType_of_content isEqualToString:@"birthdaywish"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywish_id"]]];
                    myActivity.birthdaywishdOn_Name = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishdOn_Name"]]];
                    myActivity.birthdaywishdOn_image_path =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishdOn_image_path"]]];
                    myActivity.birthdaywishOn_hasFriends = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishOn_hasFriends"]]];
                    myActivity.birthdaywishOn_School= [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"birthdaywishOn_School"]]];
                    myActivity.admin_fname = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"admin_fname"]]];
                    myActivity.admin_lname = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"admin_lname"]]];
                }
                else if([myActivity.vType_of_content isEqualToString:@"profile_update"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"profileupdate_id"]]];
                    myActivity.strOldProfilePic = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"profileupdate_path"]]];
                }
                else if([myActivity.vType_of_content isEqualToString:@"badge"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"badge_id"]]];
                    myActivity.badge_friends =[[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"num_of_frnds"]]] integerValue];
                }
                else if([myActivity.vType_of_content isEqualToString:@"nowfriends"])
                {
                    myActivity.iActivityID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"nowfriends_id"]]];
                    
                    myActivity.image_path_iAdminID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"image_path_iAdminID"]]];
                    myActivity.fname_iAdminID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"fname_iAdminID"]]];
                    myActivity.lname_iAdminID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"lname_iAdminID"]]];
                    myActivity.hasNoOfFriends_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"hasNoOfFriends_iFriendsID"]]];
                    myActivity.school_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"school_iFriendsID"]]];
            
                    //Friend Detail
                    myActivity.image_path_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"image_path_iFriendsID"]]];
                    myActivity.iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iFriendsID"]]];
                    myActivity.fullname_iFriendsID =[NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"fullname_iFriendsID"]]];
                }

                myActivity.Comment_counts = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"Comment_counts"]]];
                
                myActivity.iAdminID = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"iAdminID"]]];
                myActivity.tsInsertDt = [self removeNull:[dict objectForKey:@"tsInsertDt"]];
                myActivity.unixTimeStamp = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"unixTimeStamp"]]];
                
                double unixTimeStampDDD =[myActivity.unixTimeStamp integerValue];
                NSTimeInterval _interval=unixTimeStampDDD;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                myActivity.feedDate = date;
                
                //Feed Owner Image
                myActivity.imgURL=[NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"image_path"]]];
                myActivity.vActivityText = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vActivityText"]]];
                myActivity.vIamAt = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vIamAt"]]];
                myActivity.vIamAt2 = [NSString stringWithFormat:@"%@",[self removeNull:[dict objectForKey:@"vIamAt2"]]];
                
                NSString *strForHeight=[NSString stringWithFormat:@"%@%@%@%@",myActivity.vActivityText,([myActivity.vImWithflname isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",myActivity.vImWithflname ],([myActivity.vIamAt isEqualToString:@""])?@"":[NSString stringWithFormat:@" at %@",myActivity.vIamAt],([myActivity.vIamAt2 isEqualToString:@""])?@"":[NSString stringWithFormat:@" %@",myActivity.vIamAt2]];
                CGSize textSize= [strForHeight sizeWithFont:myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)lineBreakMode:UILineBreakModeWordWrap];
                myActivity.labelHeight = [NSNumber numberWithFloat:textSize.height];

                myActivity.vImWithflname = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"vImWithflname"]]];
                myActivity.vLikersIDs_count = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"vLikersIDs_count"]]];
                myActivity.vUnlikersIDs_count = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"vUnlikersIDs_count"]]];
                myActivity.canLike = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"canLike"]]];
                myActivity.hasCommented = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"hasCommented"]]];
                myActivity.canUnLike = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"canUnLike"]]];

                //Notification Owner Image
                myActivity.image_NotiOwner = [NSString stringWithFormat:@"%@",[self removeNull:[dict valueForKey:@"image_NotiOwner"]]];
                [self.arrContent addObject:myActivity];
            }
            
            if ([self.action isEqualToString:@"_GetActivities"])
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:1];
                tblView.alpha=1;
                [UIView commitAnimations];
                [tblView reloadData];
            }
            else if ([self.action isEqualToString:@"_startSendNextActivities"])
            {
                isLoading = NO;
                [indicator stopAnimating];
                tblView.tableFooterView = nil;
                
                [self performSelectorOnMainThread:@selector(ReloadTableData) withObject:nil waitUntilDone:YES];
            }
        }
    }
}
-(void)ReloadTableData
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    tblView.alpha=1;
    [UIView commitAnimations];
    [tblView reloadData];
}

#pragma mark - TABLEVIEW DELEAGTE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ViewActivity *myActivity = [self.arrContent objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [[NSBundle mainBundle]loadNibNamed:@"LeftViewTableCell" owner:self options:nil];
        cell = myLeftCell;
    }
    
    CGFloat constrainedSize = 140.0f;
    UIFont *myFont = [UIFont boldSystemFontOfSize:11];
    CGSize textSize= [myActivity.TagLine sizeWithFont:myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect labelFrame = myLeftCell.lblTitle.frame;
    labelFrame.size.height = MIN(textSize.height, 26);
    [myLeftCell.lblTitle setFrame:labelFrame];
    myLeftCell.lblTitle.text = [NSString stringWithFormat:@"%@",[self removeNull:myActivity.TagLine]];
    
    CGRect labelFrameDate = myLeftCell.lblDate.frame;
    labelFrameDate.origin.y = myLeftCell.lblTitle.frame.origin.y + myLeftCell.lblTitle.frame.size.height + 4.0;
    [myLeftCell.lblDate setFrame:labelFrameDate];
    myLeftCell.lblDate.text=[NSString stringWithFormat:@"%@",[self removeNull:[myActivity.feedDate FormatedDate]]];
    
    //Like , Unlike , comment logo
    if ([myActivity.Status isEqualToString:@"Liked"])
    {
        myLeftCell.imgComentLikeDislike.image = [UIImage imageNamed:@"like.png"];
    }
    else if ([myActivity.Status isEqualToString:@"Disliked"])
    {
        myLeftCell.imgComentLikeDislike.image = [UIImage imageNamed:@"dislike.png"];
    }
    else if ([myActivity.Status isEqualToString:@"Comment"])
    {
        myLeftCell.imgComentLikeDislike.image = [UIImage imageNamed:@"commentLeftView.png"];
    }
    
    //Cell
    //imgPostType = logos for location, video
    if ([myActivity.vType_of_content isEqualToString:@"activity"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@""];
        
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"image"])
    {
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [DddAvtar setValue:myActivity.imgURLPOST forKey:@"ImagePost"];
        [myLeftCell setDict:DddAvtar]; 
    }
    else if ([myActivity.vType_of_content isEqualToString:@"video"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@"video_logo.png"];
        [myLeftCell.imgPostType setContentMode:UIViewContentModeCenter];

        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"location"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@"Location.png"];
        [myLeftCell.imgPostType setContentMode:UIViewContentModeScaleAspectFill];

        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"music"])
    {
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [DddAvtar setValue:myActivity.music_img forKey:@"ImagePost"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"wrote"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@""];
        
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"birthdaywish"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@""];
        
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [DddAvtar setValue:myActivity.birthdaywishdOn_image_path forKey:@"ImagePost"];
        [myLeftCell setDict:DddAvtar];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"badge"]||
             [myActivity.vType_of_content isEqualToString:@"profile_update"]||
             [myActivity.vType_of_content isEqualToString:@"nowfriends"])
    {
        myLeftCell.imgPostType.image = [UIImage imageNamed:@""];
        
        NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
        [DddAvtar setValue:myActivity.image_NotiOwner forKey:@"urlAvtar"];
        [myLeftCell setDict:DddAvtar];
    }
    
    [myLeftCell.btnCell setTag:indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) >= [scrollView contentSize].height)
    {
        if (!isLoading)
        {
            if (![strTotalPageCount isEqualToString:@"0"])
            {
                self.PageCount+=1;
                NSString *strPG = [NSString stringWithFormat:@"%d",self.PageCount];
                
                isLoading = YES;
//                if ([self.action isEqualToString:@"_GetActivities"])
//                {
                    [self _startSendNextActivities:strPG];
//                }
//                else if ([self.action isEqualToString:@"_MYActivities"])
//                {
//                    [self _MYNextActivities:strPG];
//                }
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    viewActivity.frame = CGRectMake(0, 0, 280, 35);
    return viewActivity;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    Actionsheet1=nil;
}

-(IBAction)FeedTapped:(id)sender
{
    ViewActivity *myActivity = [self.arrContent objectAtIndex:[sender tag]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:myActivity.iActivityID forKey:@"iActivityID"];
    [dict setValue:myActivity.vType_of_content forKey:@"vType_of_content"];
    [dict setValue:myActivity.imageHeight forKey:@"imageHeight"];
    [dict setValue:myActivity.imageWidth forKey:@"imageWidth"];
    [dict setValue:myActivity.imgURLPOST forKey:@"imgURLPOST"];
    [dict setValue:myActivity.imgURL forKey:@"imgURL"];
    [dict setValue:myActivity.feedDate forKey:@"feedDate"];
    [dict setValue:myActivity.vLikersIDs_count forKey:@"vLikersIDs_count"];
    [dict setValue:myActivity.vUnlikersIDs_count forKey:@"vUnlikersIDs_count"];
    [dict setValue:myActivity.vActivityText forKey:@"vActivityText"];
    [dict setValue:myActivity.vImWithflname forKey:@"vImWithflname"];
    [dict setValue:myActivity.vIamAt forKey:@"vIamAt"];
    [dict setValue:myActivity.vIamAt2 forKey:@"vIamAt2"];
    
    [dict setValue:myActivity.labelHeight forKey:@"labelHeight"];
    [dict setValue:myActivity.canLike forKey:@"canLike"];
    [dict setValue:myActivity.hasCommented forKey:@"hasCommented"];
    [dict setValue:myActivity.canUnLike forKey:@"canUnLike"];
    [dict setValue:myActivity.postOwner_fname forKey:@"admin_fname"];
    [dict setValue:myActivity.postOwner_lname forKey:@"admin_lname"];
    [dict setValue:myActivity.Comment_counts forKey:@"Comment_counts"];
    if([myActivity.vType_of_content isEqualToString:@"wrote"])
    {
        [dict setValue:myActivity.generalText forKey:@"generalText"];
        [dict setValue:myActivity.wroteBy_id forKey:@"wroteBy_id"];
        [dict setValue:myActivity.wrotedOn_Name forKey:@"wrotedOn_Name"];
        [dict setValue:myActivity.wrotedOn_image_path forKey:@"wrotedOn_image_path"];
        [dict setValue:myActivity.wroteOn_School forKey:@"wroteOn_School"];
        [dict setValue:myActivity.wroteOn_hasFriends forKey:@"wroteOn_hasFriends"];
    }
    else if([myActivity.vType_of_content isEqualToString:@"music"])
    {
        [dict setValue:myActivity.music_img forKey:@"strYouTubeId"];
        [dict setValue:myActivity.strYouTubeTitle forKey:@"strYouTubeTitle"];
    }
    else if([myActivity.vType_of_content isEqualToString:@"video"])
    {
        
        [dict setValue:myActivity.strYouTubeId forKey:@"strYouTubeId"];
        [dict setValue:myActivity.strYouTubeTitle forKey:@"strYouTubeTitle"];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"birthdaywish"])
    {
        [dict setValue:myActivity.birthdaywishdOn_Name forKey:@"birthdaywishdOn_Name"];
        [dict setValue:myActivity.birthdaywishdOn_image_path forKey:@"birthdaywishdOn_image_path"];
        [dict setValue:myActivity.birthdaywishOn_School forKey:@"birthdaywishOn_School"];
        [dict setValue:myActivity.birthdaywishOn_hasFriends forKey:@"birthdaywishOn_hasFriends"];
        [dict setValue:myActivity.admin_fname forKey:@"admin_fname"];
        [dict setValue:myActivity.admin_lname forKey:@"admin_lname"];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"location"])
    {
        [dict setValue:[self removeNull:myActivity.vIamAt] forKey:@"strYouTubeTitle"];
        [dict setValue:[self removeNull:myActivity.vIamAt2] forKey:@"vIamAt2"];
        [dict setValue:myActivity.dcLatitude forKey:@"dcLatitude"];
        [dict setValue:myActivity.dcLongitude forKey:@"dcLongitude"];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"badge"])
    {
        [dict setValue:[NSString stringWithFormat:@"%d",myActivity.badge_friends] forKey:@"badge_friends"];
        //[dict setValue:(myFeed.isUserPrivate)?@"pri":@"pub" forKey:@"isUserPrivate"];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"profile_update"])
    {
        [dict setValue:myActivity.strOldProfilePic forKey:@"imgURL"];
        [dict setValue:myActivity.strOldProfilePic forKey:@"strOldProfilePic"];
    }
    else if ([myActivity.vType_of_content isEqualToString:@"nowfriends"])
    {
        //Myimage_path_iAdminID
        [dict setValue:myActivity.image_path_iAdminID forKey:@"imgURL"];
        [dict setValue:myActivity.fname_iAdminID forKey:@"admin_fname"];
        [dict setValue:myActivity.lname_iAdminID forKey:@"admin_lname"];
        [dict setValue:myActivity.hasNoOfFriends_iFriendsID forKey:@"hasNoOfFriends_iFriendsID"];
        [dict setValue:myActivity.school_iFriendsID forKey:@"school_iFriendsID"];

        //Friend
        [dict setValue:myActivity.image_path_iFriendsID forKey:@"image_path_iFriendsID"];
        [dict setValue:myActivity.iFriendsID forKey:@"iFriendsID"];
        [dict setValue:myActivity.fullname_iFriendsID forKey:@"fullname_iFriendsID"];

    }
    
    AddCommentView *objAddCommentView = [[AddCommentView alloc]initWithNibName:@"AddCommentView" bundle:nil];
    objAddCommentView.dictAllData = dict;
    objAddCommentView.iActivityID = myActivity.iActivityID;
    objAddCommentView.vType_of_post = myActivity.vType_of_content;
    [self.navigationController presentModalViewController:objAddCommentView animated:YES];
     
}
#pragma mark - GetPostDate
-(NSString *)str :(NSDate *)getDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    NSDate *dd = getDate;
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"LLLL dd,yyyy"];
    NSString *strReturn = [df stringFromDate:dd];
    return strReturn;
}
-(NSString *)removeNull:(NSString *)str
{
    if (![str isKindOfClass:[NSString class]])
    {
        return @"";
    }
    
    return [str removeNull];
}
#pragma mark - DEFAULT METHODS

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
