//
//  NewsViewController.m
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "NewsViewController.h"
#import "AddNewPostViewController.h"
#import "CommentViewController.h"
#import "ImageZoomViewController.h"

#import "GlobalCustomCell.h"

#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import <OHAttributedLabel/OHAttributedLabel.h>
#import "PullToRefreshView.h"

#import "MyAppManager.h"
#import "WSManager.h"
#import "NewsFeed.h"
#import "ProfileViewController.h"
#import "CustomBadge.h"

@interface NewsViewController () <PullToRefreshViewDelegate,UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewTBLHeader;
    IBOutlet UIImageView *imgNavBar;
    IBOutlet UIButton *btnChat;
    IBOutlet UIActivityIndicatorView *actIndicator;
    IBOutlet UIView *viewSectionHeader;
    PullToRefreshView *pull;
    BOOL isViewMoreCalled;
    NSInteger selectednews_id;
}
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isAppInGuestMode)
    {
        canPostNews=NO;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromRightNavigationCnTlR:) name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClosesearchFromRightNavigationCnTlR:) name:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    }
    
    tblView.tableHeaderView=viewSectionHeader;
    [self updatemodelclass];

    NSLog(@"The Subscribed uni:%@ and useuni: %@",strSubscribedUni,strUserUniId);
    
    if (canPostNews && ([strSubscribedUni isEqualToString:strUserUniId]))
    {
        if ([[strUserUniId removeNull] length]==0)
        {
            viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
            viewTBLHeader.alpha=0.0;
            tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
        }
        else
        {
            viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7, 320.0, 40.0);
            viewTBLHeader.alpha=1.0;
            tblView.frame=CGRectMake(0.0,84.0+iOS7,320.0,416.0+iPhone5ExHeight-40.0);
        }
    }
    else
    {
        viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7, 320.0, 40.0);
        viewTBLHeader.alpha=0.0;
        tblView.frame=CGRectMake(0.0,44.0+iOS7,320.0,416.0+iPhone5ExHeight);
    }
    
    pull=[[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)tblView];
    [pull setDelegate:self];
    [tblView addSubview:pull];
    [tblView reloadData];
    
    if (!isAppInGuestMode) {
        if ([[[dictUserInfo objectForKey:@"faculty"]removeNull] isEqualToString:@"yes"])
        {
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
            lpgr.minimumPressDuration = 1.0;
            lpgr.delegate = self;
            [tblView addGestureRecognizer:lpgr];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MyAppManager sharedManager] updatenotificationbadge];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateNotificationBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatenotificationbadge) name:kNotifyUpdateNotificationBadge object:nil];
    [self updatenotificationbadge];
    
    if (shouldInviteToSignUp)
    {
        [[MyAppManager sharedManager] signOutFromApp];
        shouldInviteToSignUp=YES;
        [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        return;
    }
    
    if ([arrNews count]==0)
    {
        [self loadlatestnews];
    }
    else
    {
        [self refreshnews];
    }
    
    [tblView reloadData];
}
-(void)updatenotificationbadge
{
    NSString *strBadgeCount = [NSString stringWithFormat:@"%d",unread_notificationcount];
    [UIApplication sharedApplication].applicationIconBadgeNumber=unread_notificationcount;

    if ([strBadgeCount intValue] > 0)
    {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[CustomBadge class]])
            {
                [subview removeFromSuperview];
            }
        }
        
        CustomBadge *theBadge = [CustomBadge customBadgeWithString:strBadgeCount withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor]  withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]  withScale:0.80 withShining:YES];
        [theBadge setFrame:CGRectMake(318.0-theBadge.frame.size.width,btnChat.frame.origin.y-(theBadge.frame.size.height/2.0),theBadge.frame.size.width,theBadge.frame.size.height)];
        [self.view addSubview:theBadge];
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

-(void)showLoader
{
    [actIndicator startAnimating];
}
-(void)hideLoader
{
    [actIndicator stopAnimating];
}

#pragma mark - NAVBAR METHODS
-(void)alertIfGuestMode
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Guest Mode" message:kGuestPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-Up", nil];
    alert.tag=24;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==24)
    {
        if (buttonIndex==1)
        {
            [[MyAppManager sharedManager] signOutFromApp];
            shouldInviteToSignUp=YES;
            [self.mm_drawerController dismissModalViewControllerAnimated:YES];
        }
    }
}

-(void)searchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:320];
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL Finished){
        
    }];
}
-(void)ClosesearchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:250];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

- (IBAction)btnMenuOptionsClicked:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)btnFriendsSectionClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
-(IBAction)btnAddNewPostClicked:(id)sender
{
    AddNewPostViewController *obj=[[AddNewPostViewController alloc]initWithNibName:@"AddNewPostViewController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}
-(IBAction)btnScrollToTopClicked:(id)sender
{
    if([arrNewsModel count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionTop
                               animated:YES];
    }
}

#pragma mark - PULL TO REFRESH
-(void)closePullToRefresh
{
    [pull setState:PullToRefreshViewStateNormal];
}
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    [self performSelector:@selector(refreshnews) withObject:nil afterDelay:0.01];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (((scrollView.contentOffset.y+300)>(scrollView.contentSize.height-scrollView.frame.size.height)) && !isViewMoreCalled)
    {
        isViewMoreCalled=YES;
        [self viewmorenews];
    }
}
#pragma mark - WEBSERVICES
-(void)refreshnews
{
    if ([dictNews objectForKey:@"timestamp"] && [dictNews objectForKey:@"oldtimestamp"])
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictNews objectForKey:@"timestamp"],@"timestamp",[dictNews objectForKey:@"oldtimestamp"],@"oldtimestamp",strSubscribedUni,@"uni_list",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsRefreshURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(newsrefreshed:) withfailureHandler:@selector(newsrefreshfailed:) withCallBackObject:self];
        [obj startRequest];
    }
    else
    {
        [self loadlatestnews];
    }
}
-(void)newsrefreshed:(id)sender
{
    [self hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableArray *arrNewsTemp=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"added_posts"]];
        [arrNewsTemp addObjectsFromArray:arrNews];
        
        for (int i=0; i<[[dictResponse objectForKey:@"updated_posts"] count]; i++)
        {
            for (int j=0; j<[arrNewsTemp count]; j++)
            {
                if ([[[[dictResponse objectForKey:@"updated_posts"] objectAtIndex:i]objectForKey:@"id"] isEqualToString:[[arrNewsTemp objectAtIndex:j]objectForKey:@"id"]])
                {
                    [arrNewsTemp replaceObjectAtIndex:j withObject:[[dictResponse objectForKey:@"updated_posts"] objectAtIndex:i]];
                }
            }
        }
        
        for (int i=0; i<[[dictResponse objectForKey:@"deleted_posts"] count];i++)
        {
            BOOL isDeleted=NO;
            for (int j=0; j<[arrNewsTemp count];j++)
            {
                if (!isDeleted)
                {
                    if ([[[[dictResponse objectForKey:@"deleted_posts"] objectAtIndex:i]objectForKey:@"id"] isEqualToString:[[arrNewsTemp objectAtIndex:j]objectForKey:@"id"]])
                    {
                        [arrNewsTemp removeObjectAtIndex:j];
                        isDeleted=YES;
                    }
                }
            }
        }
        
        [arrNews removeAllObjects];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrNews addObjectsFromArray:[arrNewsTemp sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        [self updatemodelclass];
        
        [dictNews setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        if ([arrNews count]>0)
        {
            NSLog(@"Hi... %@",[arrNews lastObject]);
            @try {
                
                NSLog(@"This is try block...");

                [dictNews setObject:[[arrNews lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
            }
            @catch (NSException *exception) {
                NSLog(@"The Exception Found:%@",exception);
            }
            @finally {
                NSLog(@"This is finally blockkk..");
            }
        }
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    [pull setState:PullToRefreshViewStateNormal];
}

-(void)updatemodelclass
{
    [arrNewsModel removeAllObjects];
    
    for (int i=0; i<[arrNews count]; i++)
    {
        NSDictionary *dictBlogModel=(NSDictionary *)[arrNews objectAtIndex:i];
        NewsFeed *objBlog=[[NewsFeed alloc]init];
        
        objBlog.news_id=[[[dictBlogModel objectForKey:@"id"] removeNull] integerValue];
        
        objBlog.strProfName=[[dictBlogModel objectForKey:@"professor_name"] removeNull];
        objBlog.professor_id=[[[dictBlogModel objectForKey:@"professor_id"] removeNull] integerValue];
        objBlog.strProfDepartment=[[dictBlogModel objectForKey:@"professor_department"] removeNull];
        objBlog.urlProfilePic=[NSURL URLWithString:[[[dictBlogModel objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        objBlog.strCreatedTimeStamp=[[dictBlogModel objectForKey:@"date_created"] removeNull];
        objBlog.strLikeCount=[[dictBlogModel objectForKey:@"like_count"] removeNull];
        objBlog.strCommentCount=[[dictBlogModel objectForKey:@"comment_count"] removeNull];
        
        objBlog.canLike=([[[dictBlogModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        
        //        NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrHome objectAtIndex:i] objectForKey:@"description"] removeNull]];
        //        [attrStrFull setFont:kFONT_HOMECELL];
        //        [attrStrFull setTextColor:[UIColor darkGrayColor]];
        //        objBlog.attribFull=[attrStrFull copy];
        
        NSData *charlieSendData = [[[dictBlogModel objectForKey:@"description"] removeNull] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *charlieSendString = [[NSString alloc] initWithData:charlieSendData encoding:NSNonLossyASCIIStringEncoding];
        objBlog.attribUsed=[charlieSendString attributedStringForHomeCellForFrame:CGRectMake(0, 0, 280.0,100.0) andFont:kFONT_HOMECELL andTag:[NSString stringWithFormat:@"homecr:%d",i]];
        
        objBlog.hasImage=([[[dictBlogModel objectForKey:@"image_640_1096"] removeNull] length]>0)?YES:NO;
        
        if (objBlog.hasImage)
        {
            float imgwidth=[[[dictBlogModel objectForKey:@"image_640_1096_width"] removeNull] floatValue];
            float imgheight=[[[dictBlogModel objectForKey:@"image_640_1096_height"] removeNull] floatValue];
            objBlog.img_width=imgwidth;
            objBlog.img_height=imgheight;
            objBlog.cell_tag=((imgwidth<=200.0) && (imgheight<=300.0))?0:2001;
            
            float wd=MIN(imgwidth,300.0);
            float ht=MIN((((imgwidth>300.0) && ((imgheight*300.0/imgwidth)<200.0))?(imgheight*300.0/imgwidth):imgheight), 200.0);
            objBlog.imgSize=CGSizeMake(wd, ht);
            
            objBlog.urlOriginal=[NSURL URLWithString:[[[dictBlogModel objectForKey:@"image"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objBlog.urlHD=[NSURL URLWithString:[[[dictBlogModel objectForKey:@"image_640_1096"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objBlog.urlBlur=[NSURL URLWithString:[[[dictBlogModel objectForKey:@"image_small_100_100"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        objBlog.isUpdated=([[[dictBlogModel objectForKey:@"is_updated"] removeNull] isEqualToString:@"1"])?YES:NO;
        objBlog.isPostedByAdmin=([[[dictBlogModel objectForKey:@"is_postedbyadmin"] removeNull] isEqualToString:@"1"])?YES:NO;
        
        float theHeight=[[objBlog.attribUsed heightforAttributedStringWithWidth:280.0]floatValue];
        float thecellheight=0;
        thecellheight+=30.0;
        thecellheight+=(objBlog.isPostedByAdmin)?0.0:30.0; //For News
        thecellheight+=MIN(theHeight,112.0);
        thecellheight+=10.0;
        thecellheight+=(objBlog.hasImage)?(objBlog.imgSize.height-((objBlog.imgSize.height>=200.0)?30.0:0.0)):0.0;
        thecellheight+=30.0;
        thecellheight+=10.0;
        
        objBlog.final_cell_height=thecellheight;
        
        [arrNewsModel addObject:objBlog];
    }
    
    [tblView reloadData];
}

-(void)newsrefreshfailed:(id)sender
{
    [self hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    
    [pull setState:PullToRefreshViewStateNormal];
}

-(void)loadlatestnews
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strSubscribedUni,@"uni_list",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsLatestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(latestnewsloaded:) withfailureHandler:@selector(latestnewsfailed:) withCallBackObject:self];
    [self showLoader];
    [obj startRequest];
}
-(void)latestnewsloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrNews removeAllObjects];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrNews addObjectsFromArray:[[dictResponse objectForKey:@"news_list"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        [self updatemodelclass];

        [dictNews removeAllObjects];
        [dictNews setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        if ([arrNews count]>0)
        {
            [dictNews setObject:[[arrNews lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
        }
        
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    [pull setState:PullToRefreshViewStateNormal];
    [self hideLoader];
}

-(void)latestnewsfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    
    [pull setState:PullToRefreshViewStateNormal];
    [self hideLoader];
}

-(void)viewmorenews
{
    if ([dictNews objectForKey:@"oldtimestamp"])
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictNews objectForKey:@"oldtimestamp"],@"timestamp",strSubscribedUni,@"uni_list",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsViewMoreURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(viewmorenewsloaded:) withfailureHandler:@selector(viewmorenewsfailed:) withCallBackObject:self];
        [obj startRequest];
    }
    else
    {
        [self loadlatestnews];
    }
}
-(void)viewmorenewsloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrNews addObjectsFromArray:[dictResponse objectForKey:@"news_list"]];
        
        NSMutableArray  *arrTempNews=[[NSMutableArray alloc]init];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrTempNews addObjectsFromArray:[arrNews sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        
        
        [dictNews setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        [arrNews removeAllObjects];
        [arrNews addObjectsFromArray:arrTempNews];
        [self updatemodelclass];

        if ([arrNews count]>0)
        {
            [dictNews setObject:[[arrNews lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
        }
        
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    isViewMoreCalled=NO;
}
-(void)viewmorenewsfailed:(id)sender
{
    [self hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    
    isViewMoreCalled=NO;
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNewsModel count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",objNews.news_id];
    GlobalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[GlobalCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.isNewsCell=(objNews.isPostedByAdmin)?NO:YES;
    
    
    [cell.imgProfilePic setImageWithURL:(objNews.professor_id==[strUserId integerValue])?((isAppInGuestMode)?objNews.urlProfilePic:[NSURL URLWithString:strUserProfilePic]):objNews.urlProfilePic forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"]];
    
    cell.imgProfilePic.tag=objNews.professor_id;
    
    [cell.imgProfilePic addTarget:self action:@selector(btnProfileViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblName.text=objNews.strProfName;
    cell.lblSubject.text=objNews.strProfDepartment;
    
    cell.lblTime.text=[objNews.strCreatedTimeStamp formattedTime];
    
    cell.lblattributed.delegate=self;
    cell.lblattributed.attributedText=objNews.attribUsed;
    
    cell.lblLikeCount.text=objNews.strLikeCount;
    cell.lblCommentCount.text=objNews.strCommentCount;
    [cell.btnLike setTitle:(objNews.canLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
    
    cell.imgMainBlurred.image=[UIImage imageNamed:@"bg_white"];
    cell.imgMain.image=[UIImage imageNamed:@"bg_white"];
    
    if (objNews.hasImage)
    {
        cell.imgMain.tag=objNews.cell_tag;
        cell.imgMainBlurred.tag=objNews.cell_tag;
        
        CGRect theRect=cell.imgMain.frame;
        theRect.size=objNews.imgSize;
        cell.imgMain.frame=theRect;
        cell.imgMainBlurred.frame=theRect;
        
        if ([dictImages objectForKey:objNews.urlHD])
        {
            cell.imgMain.image = [dictImages objectForKey:objNews.urlHD];
        }
        else
        {
            if ([dictImages objectForKey:objNews.urlBlur])
            {
                cell.imgMainBlurred.image = [dictImages objectForKey:objNews.urlBlur];
            }
            else
            {
                if (tblView.dragging == NO && tblView.decelerating == NO)
                {
                    [cell.imgMainBlurred setImageWithURL:objNews.urlBlur placeholderImage:nil];
                }
            }
            
            if (tblView.dragging == NO && tblView.decelerating == NO)
            {
                [cell.imgMain setImageWithURL:objNews.urlHD placeholderImage:nil];
            }
        }
        
        cell.imgwidth=objNews.img_width;
        cell.imgheight=objNews.img_height;
        cell.imgMain.alpha=1.0;
        cell.imgMainBlurred.alpha=1.0;
        cell.btnMain.alpha=1.0;
        cell.btnMain.tag=indexPath.row;
        [cell.btnMain addTarget:self action:@selector(btnImagePrivewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.imgwidth=0.0;
        cell.imgheight=0.0;
        cell.imgMain.image=nil;
        cell.imgMain.alpha=0.0;
        cell.imgMainBlurred.image=nil;
        cell.imgMainBlurred.alpha=0.0;
        cell.btnMain.alpha=0.0;
    }
    
    cell.btnLike.tag=indexPath.row;
    cell.btnComment.tag=indexPath.row;
    [cell.btnLike addTarget:self action:@selector(btnLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(btnCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [tblView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:indexPath];
        
        NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:indexPath.row];
        
        if (![dictImages objectForKey:objNews.urlHD])
        {
            if (![dictImages objectForKey:objNews.urlBlur])
            {
                [cell.imgMainBlurred setImageWithURL:objNews.urlBlur placeholderImage:nil];
            }
            
            [cell.imgMain setImageWithURL:objNews.urlHD placeholderImage:nil];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
} 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:indexPath.row];
    return objNews.final_cell_height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    obj.selectedindex=indexPath.row;
    obj.commenttype=CommentTypeNews;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}

-(void)btnProfileViewClicked:(id)sender
{
    if ([(UIButton *)sender tag] != [strUserId integerValue])
    {
        ProfileViewController *obj = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        obj.isProfileViewMine=NO;
        obj.strTheUserId = [NSString stringWithFormat:@"%d",[(UIButton *)sender tag]];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:tblView];
        NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:p];
        if (indexPath != nil)
        {
            NSLog(@"long press on table view at row %d", indexPath.row);
            //if user can post news...
            
            NSDictionary *dictNewsSelected=(NSDictionary *)[arrNews objectAtIndex:indexPath.row];
            
            if ([[[dictNewsSelected objectForKey:@"professor_id"] removeNull] isEqualToString:strUserId])
            {
                selectednews_id=[[[dictNewsSelected objectForKey:@"id"] removeNull] integerValue];
                
                GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                
                
                [self performSelector:@selector(setZoomInEffect:) withObject:cell];
                [self performSelector:@selector(setZoomOutEffect:) withObject:cell afterDelay:0.55];
                [self performSelector:@selector(promptfordelete) withObject:nil afterDelay:0.5];
            }
        }
    }
}

-(void)promptfordelete
{
    UIActionSheet *actSheet=[[UIActionSheet alloc]initWithTitle:@"Do you want to delete this news?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil,nil];
    actSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [actSheet showInView:self.view];
}


-(void)setZoomInEffect:(GlobalCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:@"cellbg_header-h"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}
-(void)setZoomOutEffect:(GlobalCustomCell *)cellSelected
{
    UIImage *imgBG=[UIImage imageNamed:@"cellbg_header"];
    cellSelected.imgMainBG.image=[imgBG stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"the selebtn :%d",buttonIndex);
    if (buttonIndex==0)
    {
        //Delete
        
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",selectednews_id],@"news_id",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kNewsDeleteURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(newsdeleted:) withfailureHandler:@selector(newsdeletefailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoaderWithtext:@"Deleting News..." andDetailText:@"Please Wait..."];
        [obj startRequest];

    }
    else if (buttonIndex==1)
    {
        //Cancel: Do Nothing..
    }
}

-(void)newsdeleted:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        BOOL entryFound=NO;
        NSInteger selectednews_index=0;
        for (int i=0; i<[arrNews count];i++)
        {
            if ([[[[arrNews objectAtIndex:i]objectForKey:@"id"] removeNull] integerValue]==selectednews_id)
            {
                entryFound=YES;
                selectednews_index=i;
                break;
            }
        }
        
        if (entryFound) {
            [arrNews removeObjectAtIndex:selectednews_index];
            [arrNewsModel removeObjectAtIndex:selectednews_index];
        }
        
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    [pull setState:PullToRefreshViewStateNormal];
}
-(void)newsdeletefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    
    [pull setState:PullToRefreshViewStateNormal];
}


-(void)btnImagePrivewClicked:(id)sender
{
    ImageZoomViewController *obj=[[ImageZoomViewController alloc]initWithNibName:@"ImageZoomViewController" bundle:nil];
    obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrNews objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"image"]] removeNull];
    obj.selectedindex=[(UIButton *)sender tag];
    obj.phototype=PhotoTypeNews;
    [self.navigationController presentViewController:obj animated:YES completion:^{}];
}
/*
 "can_like" = 1;
 "comment_count" = 0;
 "date_created" = 1375506973;
 description = "sdfsdag sdgasdg tewrewr";
 id = 23;
 image = "http://www.openxcellaus.info/myu/admin/files/ba440b64a0b0046fa0dccc49bfc748eb.jpg";
 "image_height" = 960;
 "image_width" = 677;
 "like_count" = 0;
 title = dsfasdfsd;
 */
-(void)btnLikeClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    NSInteger btnindex=[(UIButton *)sender tag];
    NewsFeed *objNews=(NewsFeed *)[arrNewsModel objectAtIndex:btnindex];
    
    BOOL shouldLike=objNews.canLike;
    NSInteger likecount=[objNews.strLikeCount integerValue];
    
    GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnindex inSection:0]];
    [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
    cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
    
    [[arrNews objectAtIndex:btnindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
    [[arrNews objectAtIndex:btnindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
    
    objNews.canLike=!shouldLike;
    objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
    
    [arrNewsModel replaceObjectAtIndex:btnindex withObject:objNews];

    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrNews objectAtIndex:btnindex] objectForKey:@"id"],@"news_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)btnCommentClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
        return;
    }
    
    CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    obj.selectedindex=[(UIButton *)sender tag];
    obj.commenttype=CommentTypeNews;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
	if ([[linkInfo.URL scheme] isEqualToString:@"homecr"])
    {
		NSString *theTAG = [linkInfo.URL resourceSpecifier];
        
        CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
        obj.selectedindex=[theTAG integerValue];
        obj.commenttype=CommentTypeNews;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj animated:NO completion:^{}];
        
		return NO;
	}
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",linkInfo.URL]]];
        return NO;
	}
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (canPostNews && ([strSubscribedUni isEqualToString:strUserUniId]))
    {
        if ([[strUserUniId removeNull] length]!=0)
        {
            if ((scrollView.contentOffset.y>=0) && (scrollView.contentOffset.y<(scrollView.contentSize.height-scrollView.frame.size.height)))
            {
                NSLog(@"Hiii the velocity :%f",velocity.y);
                viewTBLHeader.alpha=((velocity.y<=0.0))?0.0:1.0;
                tblView.frame=CGRectMake(0.0, ((velocity.y<=0.0)?84.0:44.0)+iOS7,320.0,416.0+iPhone5ExHeight-((velocity.y<=0.0)?40.0:0.0));
                
                if (velocity.y<=0.0)
                {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:0.5];
                    viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7,320.0,40.0);
                    viewTBLHeader.alpha=1.0;
                    [UIView commitAnimations];
                }
                else
                {
                    viewTBLHeader.frame=CGRectMake(0.0,4.0+iOS7,320.0, 40.0);
                    viewTBLHeader.alpha=0.0;
                }
            }
            else if(scrollView.contentOffset.y<=0)
            {
                viewTBLHeader.alpha=0.0;
                tblView.frame=CGRectMake(0.0,84.0+iOS7,320.0,416.0+iPhone5ExHeight-40.0);
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:0.5];
                viewTBLHeader.frame=CGRectMake(0.0,44.0+iOS7, 320.0, 40.0);
                viewTBLHeader.alpha=1.0;
                [UIView commitAnimations];
            }

        }
    }
}

#pragma mark - DEFAULT
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)dealloc
{
    [tblView removeObserver:pull forKeyPath:@"contentOffset"];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
