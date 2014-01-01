//
//  ProfileViewController.m
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageZoomViewController.h"
#import "GroupInviteViewController.h"
#import "EditProfileViewController.h"
#import "CommentViewController.h"
#import "ImageZoomViewController.h"
#import "ChatViewController.h"
#import "UIButton+WebCache.h"
#import "GlobalCustomCell.h"
#import "NewsFeed.h"
#import "GlobalVariables.h"
@interface ProfileViewController () <UITableViewDelegate,UITableViewDataSource,OHAttributedLabelDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewProfile;
    IBOutlet UILabel *lblTitleHeader;
    IBOutlet UIButton *imgProfilePic;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblUniversity;
    IBOutlet UILabel *lblBioGraphy;
    IBOutlet UIButton *btnEdit;
    
    NSMutableDictionary *dictTheUser;
    NSInteger selectednews_id;
    
    IBOutlet UIImageView *imgProfileBox;
    IBOutlet UIButton *btnGroupInvite;
    IBOutlet UIButton *btnPrivateMessage;
    
    IBOutlet UILabel *lblRecentPosts;
}
@end

@implementation ProfileViewController
@synthesize strGroupOrPersonName;
@synthesize isProfileViewMine,strTheUserId;
@synthesize arrGetallChat,isProfileViewFromComment;

-(void)updateProfilePicProfilveVC
{
    [[SDImageCache sharedImageCache]removeImageForKey:strUserProfilePic fromDisk:YES];
    [imgProfilePic setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [imgProfilePic setImageWithURL:[NSURL URLWithString:[strUserProfilePic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    strProfilePicURLofFriend = strUserProfilePic;
    NSLog(@"The pppdata:%@",dictUserInfo);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProfilePicProfilveVC) name:@"updateProfilePicProfilveVC" object:Nil];
    tblView.tableHeaderView=viewProfile;
    dictTheUser=[[NSMutableDictionary alloc]init];
    [arrPosts removeAllObjects];
    [arrUserNewsModel removeAllObjects];
    lblRecentPosts.alpha=0.0;
    imgProfilePic.userInteractionEnabled=NO;
    
    if (isProfileViewMine)
    {
        [dictTheUser addEntriesFromDictionary:dictUserInfo];
        [self updateprofilebox];
        btnEdit.hidden=NO;
        
//        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//        lpgr.minimumPressDuration=1.0;
//        [tblView addGestureRecognizer:lpgr];
    }
    else
    {
        btnEdit.hidden=YES;
        lblTitleHeader.text=@"";
        lblName.text=@"";
        lblUserName.text=@"";
        lblUniversity.text=@"";
        lblBioGraphy.text=@"";
        viewProfile.hidden=YES;
    }
    
    if (isProfileViewMine || [strTheUserId isEqualToString:strUserId])
    {
        btnGroupInvite.hidden=YES;
        btnPrivateMessage.hidden=YES;
    }
    
    if (isAppInGuestMode)
    {
        btnEdit.hidden=YES;
        lblTitleHeader.text=@"Guest";
        lblName.text=@"Guest";
        lblUniversity.text=[dictUserInfo objectForKey:@"universityname"];
        lblUserName.text=@"";
        lblBioGraphy.text=@"";
                            
        [imgProfilePic setImage:[UIImage imageNamed:@"default_user"] forState:UIControlStateNormal];
        
        float lbluniheight=[lblUniversity.text sizeWithFont:lblUniversity.font constrainedToSize:CGSizeMake(lblUniversity.frame.size.width, CGFLOAT_MAX)].height;
        
        CGRect theRect=lblUniversity.frame;
        theRect.size.height=lbluniheight;
        lblUniversity.frame=theRect;
        
        theRect=imgProfileBox.frame;
        
        theRect.size.height=lblUniversity.frame.origin.y+lblUniversity.frame.size.height+7.0-imgProfileBox.frame.origin.y;
        
        imgProfileBox.frame=theRect;
        
        imgProfileBox.image=[imgProfileBox.image resizableImageWithCapInsets:UIEdgeInsetsMake(90.0, 20.0, 30.0, 20.0)];
        
        theRect=viewProfile.frame;
        theRect.size.height=imgProfileBox.frame.size.height+20.0;
        viewProfile.frame=theRect;
        tblView.scrollEnabled=NO;
        [tblView reloadData];
    }
    else
    {
        [self performSelector:@selector(loadtheposts) withObject:nil afterDelay:1.0];
    }
}

-(void)updateprofilebox
{
    if (isAppInGuestMode) {
        return;
    }
    
    viewProfile.hidden=NO;

    lblTitleHeader.text=[[dictTheUser objectForKey:@"name"] removeNull];
    lblName.text=[[dictTheUser objectForKey:@"name"] removeNull];
    lblUserName.text=[[dictTheUser objectForKey:@"username"] removeNull];
    lblUniversity.text=[NSString stringWithFormat:@"%@%@%@",[[dictTheUser objectForKey:@"universityname"] removeNull],([[[dictTheUser objectForKey:@"department"] removeNull] length]>0)?@" - ":@"",[[dictTheUser objectForKey:@"department"] removeNull]];

    lblBioGraphy.text=[[dictTheUser objectForKey:@"bio"] removeNull];
    [imgProfilePic setImageWithURL:[NSURL URLWithString:[[[dictTheUser objectForKey:@"thumbnail"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];
    
    float lbluniheight=[lblUniversity.text sizeWithFont:lblUniversity.font constrainedToSize:CGSizeMake(lblUniversity.frame.size.width, CGFLOAT_MAX)].height;
    CGRect theRect=lblUniversity.frame;
    theRect.size.height=lbluniheight+1.0;
    lblUniversity.frame=theRect;
    
    float lblbioheight=[lblBioGraphy.text sizeWithFont:lblBioGraphy.font constrainedToSize:CGSizeMake(lblBioGraphy.frame.size.width, CGFLOAT_MAX)].height;
    theRect=lblBioGraphy.frame;
    theRect.origin.y=lblUniversity.frame.origin.y+lblUniversity.frame.size.height+7.0;
    theRect.size.height=lblbioheight+1.0;
    lblBioGraphy.frame=theRect;
    
    theRect=imgProfileBox.frame;
    
    theRect.size.height=lblBioGraphy.frame.origin.y+lblBioGraphy.frame.size.height+7.0-imgProfileBox.frame.origin.y-((lblbioheight>2.0)?0.0:7.0);
    imgProfileBox.frame=theRect;
    
    imgProfileBox.image=[imgProfileBox.image resizableImageWithCapInsets:UIEdgeInsetsMake(90.0, 20.0, 30.0, 20.0)];
    
    btnGroupInvite.hidden=YES;
    btnPrivateMessage.hidden=YES;
    
    theRect=viewProfile.frame;
    theRect.size.height=imgProfileBox.frame.size.height+20.0;
    viewProfile.frame=theRect;
    
    if (isProfileViewMine || isAppInGuestMode || [strTheUserId isEqualToString:strUserId])
    {
        btnGroupInvite.hidden=YES;
        btnPrivateMessage.hidden=YES;
    }
    else
    {
        btnGroupInvite.hidden=NO;
        btnPrivateMessage.hidden=NO;
        
        theRect=btnGroupInvite.frame;
        theRect.origin.y=viewProfile.frame.size.height;
        btnGroupInvite.frame=theRect;
        
        theRect=btnPrivateMessage.frame;
        theRect.origin.y=viewProfile.frame.size.height;
        btnPrivateMessage.frame=theRect;
        
        theRect=viewProfile.frame;
        theRect.size.height=viewProfile.frame.size.height+51.0;
        viewProfile.frame=theRect;
    }
    
    if ([arrPosts count]==0)
    {
        lblRecentPosts.alpha=0.0;
    }
    else
    {
        lblRecentPosts.alpha=1.0;
        theRect=lblRecentPosts.frame;
        theRect.origin.y=viewProfile.frame.size.height;
        lblRecentPosts.frame=theRect;
        
        theRect=viewProfile.frame;
        theRect.size.height=viewProfile.frame.size.height+33.0;
        viewProfile.frame=theRect;
    }
    
    tblView.tableHeaderView=viewProfile;

    [tblView reloadData];
}

-(IBAction)btnImageZoomClicked:(id)sender
{
    if (!isAppInGuestMode)
    {
        ImageZoomViewController *obj=[[ImageZoomViewController alloc]initWithNibName:@"ImageZoomViewController" bundle:nil];
        obj.strURL=[[dictTheUser objectForKey:@"profile_picture"] removeNull];
        obj.phototype=PhotoTypeProfilePic;
        [self.navigationController presentViewController:obj animated:YES completion:^{}];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    if (isAppInGuestMode) {
        return;
    }
    
    if (isProfileViewMine)
    {
        [dictTheUser removeAllObjects];
        [dictTheUser addEntriesFromDictionary:dictUserInfo];
        [self updateprofilebox];
    }
    
    [self updatemodelclass];
    
    [tblView reloadData];
}
-(void)loadtheposts
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,@"id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kViewProfileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(postloaded:) withfailureHandler:@selector(postloadfailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)postloaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if (isProfileViewMine) {
            [dictUserInfo removeAllObjects];
            [dictUserInfo addEntriesFromDictionary:[dictResponse objectForKey:@"User_data"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"user_info"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [dictTheUser addEntriesFromDictionary:[dictResponse objectForKey:@"User_data"]];
        
        [arrPosts removeAllObjects];
        [arrPosts addObjectsFromArray:[dictResponse objectForKey:@"News"]];
        
        [self updateprofilebox];

        [self updatemodelclass];
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
}
-(void)postloadfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(IBAction)btnGroupInviteClicked:(id)sender
{
    GroupInviteViewController *obj=[[GroupInviteViewController alloc]initWithNibName:@"GroupInviteViewController" bundle:nil];
    obj.strInvited_UserId=[NSString stringWithFormat:@"%@",strTheUserId];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
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
            
            NSDictionary *dictNewsSelected=(NSDictionary *)[arrPosts objectAtIndex:indexPath.row];
            NSLog(@"Hiii the news selected:%@ and the user id:%@",dictNewsSelected,strUserId);
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
-(void)updatemodelclass
{
    [arrUserNewsModel removeAllObjects];
    
    for (int i=0; i<[arrPosts count]; i++)
    {
        NSDictionary *dictBlogModel=(NSDictionary *)[arrPosts objectAtIndex:i];
        NewsFeed *objBlog=[[NewsFeed alloc]init];
        
        objBlog.news_id=[[[dictBlogModel objectForKey:@"id"] removeNull] integerValue];
        
        objBlog.strProfName=[[dictBlogModel objectForKey:@"professor_name"] removeNull];
        objBlog.strProfDepartment=[[dictBlogModel objectForKey:@"professor_department"] removeNull];
        objBlog.urlProfilePic=[NSURL URLWithString:[[[dictBlogModel objectForKey:@"professor_profilepic_thumb_url"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
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
        
        float theHeight=[[objBlog.attribUsed heightforAttributedStringWithWidth:280.0]floatValue];
        float thecellheight=0;
        thecellheight+=30.0;
        thecellheight+=30.0; //For News
        thecellheight+=MIN(theHeight,112.0);
        thecellheight+=10.0;
        thecellheight+=(objBlog.hasImage)?(objBlog.imgSize.height-((objBlog.imgSize.height>=200.0)?30.0:0.0)):0.0;
        thecellheight+=30.0;
        thecellheight+=10.0;
        
        objBlog.final_cell_height=thecellheight;
        
        [arrUserNewsModel addObject:objBlog];
    }
    
    [tblView reloadData];
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

-(IBAction)btnBackClicked:(id)sender
{
    if (isProfileViewFromComment)
    {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    else if (isProfileViewMine) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else
    {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TABLEVIEW METHODS
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Recent Posts";
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([arrPosts count])?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    lblRecentPosts.alpha=([arrPosts count]==0)?0.0:1.0;
    return [arrUserNewsModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",objNews.news_id];
    GlobalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[GlobalCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.isNewsCell=YES;
    
    [cell.imgProfilePic setImageWithURL:(isProfileViewMine)?[NSURL URLWithString:strUserProfilePic]:objNews.urlProfilePic  forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"default_user"]  options:SDWebImageRefreshCached];
    
    cell.imgProfilePic.userInteractionEnabled=NO;
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
        
        NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:indexPath.row];
        
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
    NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:indexPath.row];
    return objNews.final_cell_height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    obj.selectedindex=indexPath.row;
    obj.commenttype=CommentTypeProfileNews;
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
    obj.strURL=[[[NSString alloc]initWithFormat:@"%@",[[arrPosts objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"image"]] removeNull];
    obj.selectedindex=[(UIButton *)sender tag];
    obj.phototype=PhotoTypeProfilePosts;
    [self.navigationController presentViewController:obj animated:YES completion:^{}];
}
-(void)btnLikeClicked:(id)sender
{
    NSInteger btnindex=[(UIButton *)sender tag];
    NewsFeed *objNews=(NewsFeed *)[arrUserNewsModel objectAtIndex:btnindex];
    
    BOOL shouldLike=objNews.canLike;
    NSInteger likecount=[objNews.strLikeCount integerValue];
    
    GlobalCustomCell *cell=(GlobalCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnindex inSection:0]];
    [cell.btnLike setTitle:(shouldLike)?@"Unlike":@"    Like" forState:UIControlStateNormal];
    cell.lblLikeCount.text=[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
    
    [[arrPosts objectAtIndex:btnindex] setObject:(shouldLike)?@"0":@"1" forKey:@"can_like"];
    [[arrPosts objectAtIndex:btnindex] setObject:[NSString stringWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)] forKey:@"like_count"];
    
    objNews.canLike=!shouldLike;
    objNews.strLikeCount=[[NSString alloc] initWithFormat:@"%d",(shouldLike)?(likecount+1):(likecount-1)];
    
    [arrUserNewsModel replaceObjectAtIndex:btnindex withObject:objNews];
    
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[arrPosts objectAtIndex:btnindex] objectForKey:@"id"],@"news_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[(shouldLike)?kNewsLikeURL:kNewsDisLikeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)btnCommentClicked:(id)sender
{
    CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    obj.selectedindex=[(UIButton *)sender tag];
    obj.commenttype=CommentTypeProfileNews;
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
        obj.commenttype=CommentTypeProfileNews;
        
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

-(IBAction)btnEditProfileClicked:(id)sender
{
    EditProfileViewController *obj=[[EditProfileViewController alloc]initWithNibName:@"EditProfileViewController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}
-(IBAction)btnPrivateMessageClicked:(id)sender
{
    [self getAllOldChatOnetoOneUser:nil];
}

#pragma mark - Get one to one chat
-(void)getAllOldChatOnetoOneUser:(id)sender
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,SELF_ID_KEY,strUserId,FRIEND_ID_KEY,nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ONE_to_ONE_CHAT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(loadOldChat:) withfailureHandler:@selector(failToloadOldChat:) withCallBackObject:self];
    [obj startRequest];
}

-(void)loadOldChat:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"Hiii loadd %@",dictResponse);

    arrGetallChat = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrGetallChat addObjectsFromArray:[dictResponse objectForKey:@"message"]];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            //kGRAlert([strErrorMessage removeNull])
        }
    }
    
    ChatViewController *obj=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    obj.arrOnetoOneChat = arrGetallChat;
    obj.strGroupOrPersonName = lblName.text;
    obj.strTheUserId = strTheUserId;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    isGroupChat = NO;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self.navigationController presentViewController:obj animated:NO completion:^{}];
    [self presentViewController:obj animated:NO completion:^{}];
}

-(void)failToloadOldChat:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is faill %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


#pragma mark - DEFAULT METHODS

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
    imgProfilePic = nil;
    lblTitleHeader = nil;
    lblName = nil;
    lblUserName = nil;
    lblUniversity = nil;
    lblBioGraphy = nil;
    btnEdit = nil;
    [super viewDidUnload];
}
@end
