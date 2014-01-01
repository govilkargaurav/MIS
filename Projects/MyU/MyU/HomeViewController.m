//
//  HomeViewController.m
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//


#import "HomeViewController.h"
#import "CommentViewController.h"
#import "ImageZoomViewController.h"

#import "GlobalCustomCell.h"

#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "UIImageView+WebCache.h"

#import <OHAttributedLabel/OHAttributedLabel.h>
#import "PullToRefreshView.h"

#import "MyAppManager.h"
#import "WSManager.h"
#import "BlogFeed.h"
#import "CustomBadge.h"

@interface HomeViewController () <PullToRefreshViewDelegate,UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewTBLHeader;
    IBOutlet UIImageView *imgNavBar;
    IBOutlet UIActivityIndicatorView *actIndicator;
    PullToRefreshView *pull;
    BOOL isViewMoreCalled;
    IBOutlet UIButton *btnChat;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!isAppInGuestMode)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromRightNavigationCnTlR:) name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClosesearchFromRightNavigationCnTlR:) name:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    }

    tblView.tableHeaderView=viewTBLHeader;
    [self updatemodelclass];

    pull=[[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)tblView];
    [pull setDelegate:self];
    [tblView addSubview:pull];
    [tblView reloadData];
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
    }
    else
    {
        if ([arrHome count]==0)
        {
            [self loadlatestblogs];
        }
        else
        {
            [self refreshblogs];
        }
        
        [tblView reloadData];
    }
}
-(void)updatenotificationbadge
{
    NSString *strBadgeCount = [NSString stringWithFormat:@"%d",unread_notificationcount];
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

-(void)searchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:320];
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL Finished){
        
    }];
}
-(void)ClosesearchFromRightNavigationCnTlR:(id)sender{
    [self.mm_drawerController setMaximumRightDrawerWidth:250];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

//multiple-eqal entry
//fb-email nt wrkn
//tkn mr tme
//n ldr prgrs
- (IBAction)btnMenuOptionsClicked:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)btnFriendsSectionClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
    }
    else
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }
}
-(IBAction)btnScrollToTopClicked:(id)sender
{
    if([arrHomeModel count]>0)
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
    [self performSelector:@selector(refreshblogs) withObject:nil afterDelay:0.01];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (((scrollView.contentOffset.y+300)>(scrollView.contentSize.height-scrollView.frame.size.height)) && !isViewMoreCalled)
    {
        isViewMoreCalled=YES;
        [self viewmoreblogs];
    }
}

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

#pragma mark - WEBSERVICES
-(void)refreshblogs
{
    if ([dictHome objectForKey:@"timestamp"] && [dictHome objectForKey:@"oldtimestamp"])
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictHome objectForKey:@"timestamp"],@"timestamp",[dictHome objectForKey:@"oldtimestamp"],@"oldtimestamp",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogRefreshURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(blogrefreshed:) withfailureHandler:@selector(blogrefreshfailed:) withCallBackObject:self];
        [obj startRequest];
    }
    else
    {
        [self loadlatestblogs];
    }
}
-(void)blogrefreshed:(id)sender
{
    [self hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableArray *arrHomeTemp=[[NSMutableArray alloc]initWithArray:[dictResponse objectForKey:@"added_posts"]];
        [arrHomeTemp addObjectsFromArray:arrHome];
        
        for (int i=0; i<[[dictResponse objectForKey:@"updated_posts"] count]; i++)
        {
            for (int j=0; j<[arrHomeTemp count]; j++)
            {
                if ([[[[dictResponse objectForKey:@"updated_posts"] objectAtIndex:i]objectForKey:@"id"] isEqualToString:[[arrHomeTemp objectAtIndex:j]objectForKey:@"id"]])
                {
                    [arrHomeTemp replaceObjectAtIndex:j withObject:[[dictResponse objectForKey:@"updated_posts"] objectAtIndex:i]];
                }
            }
        }
        
        for (int i=0; i<[[dictResponse objectForKey:@"deleted_posts"] count];i++)
        {
            BOOL isDeleted=NO;
            for (int j=0; j<[arrHomeTemp count];j++)
            {
                if (!isDeleted)
                {
                    if ([[[[dictResponse objectForKey:@"deleted_posts"] objectAtIndex:i]objectForKey:@"id"] isEqualToString:[[arrHomeTemp objectAtIndex:j]objectForKey:@"id"]])
                    {
                        [arrHomeTemp removeObjectAtIndex:j];
                        isDeleted=YES;
                    }
                }
            }
        }
  
        [arrHome removeAllObjects];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrHome addObjectsFromArray:[arrHomeTemp sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        [self updatemodelclass];
        
        [dictHome setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        if ([arrHome count]>0)
        {
            [dictHome setObject:[[arrHome lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
        }
        
        [tblView reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    [pull setState:PullToRefreshViewStateNormal];
}

-(void)updatemodelclass
{
    /*
    "can_like" = 0;
    "comment_count" = 3;
    "date_created" = 1378830548;
    description = "paragraph\nparagraph \nParagraph\nbla bla\n";
    id = 16;
    image = "";
    "image_640_1096" = "";
    "image_640_1096_height" = "";
    "image_640_1096_width" = "";
    "image_height" = "";
    "image_small_100_100" = "";
    "image_small_100_100_height" = "";
    "image_small_100_100_width" = "";
    "image_width" = "";
    "is_updated" = 1;
    "like_count" = 2;
    title = testing;
     
     //@property (nonatomic,assign) NSInteger blog_id;
     @property (nonatomic,assign) NSString *strCreatedTimeStamp;
     @property (nonatomic,assign) NSString *strLikeCount;
     @property (nonatomic,assign) NSString *strCommentCount;
     @property (nonatomic,assign) BOOL *canLike;
     @property (nonatomic,assign) BOOL *hasImage;
     @property (nonatomic,assign) CGSize *imgSize;
     @property (nonatomic,assign) NSURL *urlBlur;
     @property (nonatomic,assign) NSURL *urlHD;
     @property (nonatomic,assign) NSURL *urlOriginal;
     @property (nonatomic,assign) NSMutableAttributedString *attribFull;
     @property (nonatomic,assign) NSMutableAttributedString *attribUsed;
     @property (nonatomic,assign) float *final_cell_height;
     @property (nonatomic,assign) BOOL *isUpdated;
     
     */
    
    [arrHomeModel removeAllObjects];
    
    for (int i=0; i<[arrHome count]; i++)
    {
        NSDictionary *dictBlogModel=(NSDictionary *)[arrHome objectAtIndex:i];
        BlogFeed *objBlog=[[BlogFeed alloc]init];
        
        objBlog.blog_id=[[[dictBlogModel objectForKey:@"id"] removeNull] integerValue];
        objBlog.strCreatedTimeStamp=[[dictBlogModel objectForKey:@"date_created"] removeNull];
        objBlog.strLikeCount=[[dictBlogModel objectForKey:@"like_count"] removeNull];
        objBlog.strCommentCount=[[dictBlogModel objectForKey:@"comment_count"] removeNull];

        objBlog.canLike=([[[dictBlogModel objectForKey:@"can_like"] removeNull] isEqualToString:@"1"])?YES:NO;
        
//        NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:[[[arrHome objectAtIndex:i] objectForKey:@"description"] removeNull]];
//        [attrStrFull setFont:kFONT_HOMECELL];
//        [attrStrFull setTextColor:[UIColor darkGrayColor]];
//        
//        objBlog.attribFull=[attrStrFull copy];
        
        objBlog.attribUsed=[[[dictBlogModel objectForKey:@"description"] removeNull] attributedStringForHomeCellForFrame:CGRectMake(0, 0, 280.0,100.0) andFont:kFONT_HOMECELL andTag:[NSString stringWithFormat:@"homecr:%d",i]];
        
        objBlog.hasImage=([[[dictBlogModel objectForKey:@"image_640_1096"] removeNull] length]>0)?YES:NO;
        float imgwidth;
        float imgheight;
        if (objBlog.hasImage)
        {
            imgwidth=[[[dictBlogModel objectForKey:@"image_640_1096_width"] removeNull] floatValue];
            imgheight=[[[dictBlogModel objectForKey:@"image_640_1096_height"] removeNull] floatValue];
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

        float theHeight=[[objBlog.attribUsed heightforAttributedStringWithWidth:280.0]floatValue];
        float thecellheight=0;
        thecellheight+=30.0;
        thecellheight+=MIN(theHeight,112.0);
        thecellheight+=10.0;
        thecellheight+=(objBlog.hasImage)?(objBlog.imgSize.height-((objBlog.imgSize.height>=200.0)?30.0:0.0)):0.0;
        thecellheight+=30.0;
        thecellheight+=10.0;

        
        objBlog.final_cell_height=thecellheight;
        
        [arrHomeModel addObject:objBlog];
        
    }
    
    [tblView reloadData];
}

-(void)blogrefreshfailed:(id)sender
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

-(void)loadlatestblogs
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogLatestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(latestblogsloaded:) withfailureHandler:@selector(latestblogsfailed:) withCallBackObject:self];
    [self showLoader];
    [obj startRequest];
}
-(void)latestblogsloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrHome removeAllObjects];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrHome addObjectsFromArray:[[dictResponse objectForKey:@"blog_list"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        [self updatemodelclass];
        
        [dictHome removeAllObjects];
        [dictHome setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        if ([arrHome count]>0)
        {
            [dictHome setObject:[[arrHome lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
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

-(void)latestblogsfailed:(id)sender
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

-(void)viewmoreblogs
{
    if ([dictHome objectForKey:@"oldtimestamp"])
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[dictHome objectForKey:@"oldtimestamp"],@"timestamp",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBlogViewMoreURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(viewmoreblogsloaded:) withfailureHandler:@selector(viewmoreblogsfailed:) withCallBackObject:self];
        [obj startRequest];
    }
    else
    {
        [self loadlatestblogs];
    }
}
-(void)viewmoreblogsloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrHome addObjectsFromArray:[dictResponse objectForKey:@"blog_list"]];

        NSMutableArray  *arrTempHome=[[NSMutableArray alloc]init];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"date_created" ascending:NO];
        [arrTempHome addObjectsFromArray:[arrHome sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        
        [dictHome setObject:[dictResponse objectForKey:@"timestamp"] forKey:@"timestamp"];
        [arrHome removeAllObjects];
        [arrHome addObjectsFromArray:arrTempHome];
        [self updatemodelclass];
        
        if ([arrHome count]>0)
        {
            [dictHome setObject:[[arrHome lastObject] objectForKey:@"date_created"] forKey:@"oldtimestamp"];
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
-(void)viewmoreblogsfailed:(id)sender
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
    return [arrHomeModel count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:indexPath.row];

    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",objBlog.blog_id];
    GlobalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[GlobalCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.lblTime.text=[objBlog.strCreatedTimeStamp formattedTime];

    cell.lblattributed.delegate=self;
    cell.lblattributed.attributedText=objBlog.attribUsed;
    
    cell.lblLikeCount.text=objBlog.strLikeCount;
    cell.lblCommentCount.text=objBlog.strCommentCount;
    [cell.btnLike setTitle:(objBlog.canLike)?@"    Like":@"Unlike" forState:UIControlStateNormal];
    
    cell.imgMainBlurred.image=[UIImage imageNamed:@"bg_white"];
    cell.imgMain.image=[UIImage imageNamed:@"bg_white"];

    if (objBlog.hasImage)
    {
        cell.imgMain.tag=objBlog.cell_tag;
        cell.imgMainBlurred.tag=objBlog.cell_tag;
        
        CGRect theRect=cell.imgMain.frame;
        theRect.size=objBlog.imgSize;
        cell.imgMain.frame=theRect;
        cell.imgMainBlurred.frame=theRect;
        
        if ([dictImages objectForKey:objBlog.urlHD])
        {
            cell.imgMain.image = [dictImages objectForKey:objBlog.urlHD];
        }
        else
        {
            if ([dictImages objectForKey:objBlog.urlBlur])
            {
                cell.imgMainBlurred.image = [dictImages objectForKey:objBlog.urlBlur];
            }
            else
            {
                if (tblView.dragging == NO && tblView.decelerating == NO)
                {
                    [cell.imgMainBlurred setImageWithURL:objBlog.urlBlur placeholderImage:nil];
                }
            }
            
            if (tblView.dragging == NO && tblView.decelerating == NO)
            {
                [cell.imgMain setImageWithURL:objBlog.urlHD placeholderImage:nil];
            }
        }
        
        cell.imgwidth=objBlog.img_width;
        cell.imgheight=objBlog.img_height;
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
        
        BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:indexPath.row];

        if (![dictImages objectForKey:objBlog.urlHD])
        {
            if (![dictImages objectForKey:objBlog.urlBlur])
            {
               [cell.imgMainBlurred setImageWithURL:objBlog.urlBlur placeholderImage:nil];
            }
            
            [cell.imgMain setImageWithURL:objBlog.urlHD placeholderImage:nil];
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
    BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:indexPath.row];
    return objBlog.final_cell_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    obj.selectedindex=indexPath.row;
    obj.commenttype=CommentTypeBlog;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];

}
-(void)btnImagePrivewClicked:(id)sender
{
    ImageZoomViewController *obj=[[ImageZoomViewController alloc]initWithNibName:@"ImageZoomViewController" bundle:nil];
    obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrHome objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"image"]] removeNull];
    obj.selectedindex=[(UIButton *)sender tag];
    obj.phototype=PhotoTypeBlog;
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
    }
    else
    {
        NSInteger btnindex=[(UIButton *)sender tag];
        BlogFeed *objBlog=(BlogFeed *)[arrHomeModel objectAtIndex:btnindex];
        
        BOOL shouldLike=objBlog.canLike;
        NSInteger likecount=[objBlog.strLikeCount integerValue];
        
        GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnindex inSection:0]];
        [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
        cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
        
        [[arrHome objectAtIndex:btnindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
        [[arrHome objectAtIndex:btnindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
        
        objBlog.canLike=!shouldLike;
        objBlog.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
        
        [arrHomeModel replaceObjectAtIndex:btnindex withObject:objBlog];
        
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrHome objectAtIndex:btnindex] objectForKey:@"id"],@"blog_id", nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kBlogLikeURL:kBlogDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
        [obj startRequest];
    }
}
-(void)btnCommentClicked:(id)sender
{
    if (isAppInGuestMode)
    {
        [self alertIfGuestMode];
    }
    else
    {
        CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
        obj.selectedindex=[(UIButton *)sender tag];
        obj.commenttype=CommentTypeBlog;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj animated:NO completion:^{}];
    }
}
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
	if ([[linkInfo.URL scheme] isEqualToString:@"homecr"])
    {
		NSString *theTAG = [linkInfo.URL resourceSpecifier];
        
        CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
        obj.selectedindex=[theTAG integerValue];
        obj.commenttype=CommentTypeBlog;

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
