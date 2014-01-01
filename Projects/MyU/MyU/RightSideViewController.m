//
//  RightSideViewController.m
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RightSideViewController.h"
#import "RightSideCell.h"
#import "NSString+Utilities.h"
#import "ProfileViewController.h"
#import "CommentViewController.h"
#import "FullRatingViewController.h"
#import "RateProfessorViewController.h"
#import "XMPPRoomHybridStorage.h"
#import "ChatViewController.h"
#import "GlobalVariables.h"
@interface RightSideViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,rateProfessiorDelegate>
{
    IBOutlet UITextField *txtSearch;
    IBOutlet UITableView *tblView;
    IBOutlet UIButton *btnGroup;
    IBOutlet UIButton *btnChat;
    IBOutlet UIButton *btnNews;
    
    NSMutableArray *arrGroupUpdates;
    NSMutableArray *arrPrivateMessages;
    
    BOOL isGroupUpdatesLoading;
    BOOL isNotificationLoading;
    BOOL isPrivateMessagesLoading;
    BOOL isUserSearching;
    BOOL isProfileLoading;
    
    NSInteger selectedtab;
    NSString *StrGroup_id;
    NSInteger index_Selected;
    
    NSMutableArray *arrUserList;
    NSMutableDictionary *_dictaccUserID;
    NSMutableDictionary *dictGroupSetting;
    NSMutableArray *arrGetallChat;
    NSString *strTheUserId;
    
}
@property (nonatomic,strong)NSMutableArray *arrUserNewsFeeds;
@property (nonatomic,strong)NSMutableArray *arrusersList;
@property (nonatomic,strong)NSMutableDictionary *_dictUserDetails;
@end

@implementation RightSideViewController
@synthesize _dictUserDetails;
@synthesize arrUserNewsFeeds;
@synthesize imgSegmentUpper;
@synthesize arrusersList;
@synthesize strGroupOrPersonName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kSIDEBARCOLOR;
    [txtSearch setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    txtSearch.text=@"";
    dictGroupSetting = [[NSMutableDictionary alloc] init];
    arrGroupUpdates=[[NSMutableArray alloc]init];
    arrNotifications=[[NSMutableArray alloc]init];
    arrPrivateMessages=[[NSMutableArray alloc]init];
    
    isGroupUpdatesLoading=NO;
    isNotificationLoading=NO;
    isPrivateMessagesLoading=NO;
    isUserSearching = NO;
    isProfileLoading = NO;
    
    selectedtab=1;
    [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
    [btnChat setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
    [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self loadnotifications];
    
    [tblView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedata) name:kNotifyUpdateData object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateNotificationBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedata) name:kNotifyUpdateNotificationBadge object:nil];
    
    
    switch (selectedtab)
    {
        case 0:
        {
            [btnGroup setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
            [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
            [self loadgroupupdates];
        }
            break;
            
        case 1:
        {
            [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
            [btnChat setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
            [self loadnotifications];
        }
            break;
            
        case 2:
        {
            [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
            [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
            [btnNews setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [self loadprivatemessages];
        }
            break;
            
        case 3:
        {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        }
            break;
            
        default:
            break;
    }
    
    [tblView reloadData];
}

-(void)updatedata
{
    switch (selectedtab) {
        case 0:
        {
            [btnGroup setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
            [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
            [self loadgroupupdates];
        }
            break;
            
        case 1:
        {
            [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
            [btnChat setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
            [self loadnotifications];
        }
            break;
            
        case 2:
        {
            [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
            [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
            [btnNews setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
            [self loadprivatemessages];
        }
            break;
            
        default:
            break;
    }
    
    [tblView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    txtSearch.text =@"";
    selectedtab=1;
    [txtSearch resignFirstResponder];
}

-(void)ReloadNotiFicationData
{
    [tblView reloadData];
}
-(void)ReloadNotiFicationDataNewsDeleted
{
    [tblView reloadData];
}
-(IBAction)btnGroupClicked:(id)sender
{
    selectedtab=0;
    [tblView reloadData];
    [btnGroup setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
    [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
    [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self loadgroupupdates];
    
    [tblView reloadData];
}
-(IBAction)btnNotificationsClicked:(id)sender
{
    selectedtab=1;
    [tblView reloadData];
    [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
    [btnChat setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
    [btnNews setBackgroundImage:nil forState:UIControlStateNormal];
    [self loadnotifications];
    [tblView reloadData];
}
-(IBAction)btnNewsClicked:(id)sender
{
    selectedtab=2;
    [tblView reloadData];
    [btnGroup setBackgroundImage:nil forState:UIControlStateNormal];
    [btnChat setBackgroundImage:nil forState:UIControlStateNormal];
    [btnNews setBackgroundImage:[UIImage imageNamed:@"tabbg_sel.png"] forState:UIControlStateNormal];
    
    [self loadprivatemessages];

    [tblView reloadData];
}


#pragma mark - WS METHODS
-(void)loadgroupupdates
{
    if (!isGroupUpdatesLoading) {
        isGroupUpdatesLoading=YES;
        //NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"userid",@"",@"groupids",@"",@"timestamp",nil];
        //,@"80",@"groupids"
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"userid",@"",@"groupids",@"",@"timestamp",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSMGroupUpdates stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(groupupdateloaded:) withfailureHandler:@selector(groupupdateloaded:) withCallBackObject:self];
        [obj startRequest];
    }
}
-(void)groupupdateloaded:(id)sender
{
    isGroupUpdatesLoading=NO;
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrGroupUpdates removeAllObjects];
        [arrGroupUpdates addObjectsFromArray:[dictResponse objectForKey:@"all"]];
        
        if (selectedtab==0)
        {
            [tblView reloadData];
        }
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)loadnotifications
{
    if (!isNotificationLoading) {
        isNotificationLoading=YES;
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSMNotifications stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(notificationloaded:) withfailureHandler:@selector(notificationloaded:) withCallBackObject:self];
        [obj startRequest];
    }
}

-(void)notificationloaded:(id)sender
{
    [[MyAppManager sharedManager] updatenotificationbadge];

    isNotificationLoading=NO;
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrNotifications removeAllObjects];
        [arrNotifications addObjectsFromArray:[dictResponse objectForKey:@"notifications"]];
        
        if (selectedtab==1)
        {
            [tblView reloadData];
        }
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}

-(void)loadprivatemessages
{
    if (!isPrivateMessagesLoading) {
        isPrivateMessagesLoading=YES;
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"userid",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSMPrivateMessages stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(privatemessageloaded:) withfailureHandler:@selector(privatemessageloaded:) withCallBackObject:self];
        [obj startRequest];
    }
}

-(void)privatemessageloaded:(id)sender
{
    isPrivateMessagesLoading=NO;
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrPrivateMessages removeAllObjects];
        [arrPrivateMessages addObjectsFromArray:[dictResponse objectForKey:@"message_list"]];
        
        if (selectedtab==2)
        {
            [tblView reloadData];
        }
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}


#pragma mark - TABLEVIEW METHODS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (selectedtab)
    {
        case 0:
        {
            return [arrGroupUpdates count];
        }
            break;
            
        case 1:
        {
            return [arrNotifications count];
        }
            break;
            
        case 2:
        {
            return [arrPrivateMessages count];
        }
            break;
            
        case 3:
        {
            return [arrusersList count];
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",selectedtab];
    RightSideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[RightSideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
  
    switch (selectedtab)
    {
        case 0:
        {
            cell.theCellType=CellType_Group_Updates;
            [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"groupinfo"] objectForKey:@"picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_group"]];
            
            cell.lblBadge.text=[NSString stringWithFormat:@" %@ ",[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"count"]];
            
            cell.lblViewHeader.text=[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"groupinfo"] objectForKey:@"name"];
            cell.lblViewHeader.textColor=[UIColor whiteColor];
            
            if ([[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] count]>0)
            {
                if ([[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"message"] removeNull] length]>0)
                {
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: %@",[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"name"] removeNull],[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"message"] removeNull]]];
                    [attString setFontName:@"Helvetica" size:12.0];
                    
                    [attString setTextColor:[UIColor whiteColor]];
                    [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"name"] removeNull] length]+1)];
                    
                    cell.lblattributed.attributedText=attString;
                }
                else
                {
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ posted an image.",[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"name"] removeNull]]];
                    [attString setFontName:@"Helvetica" size:12.0];
                    
                    [attString setTextColor:[UIColor whiteColor]];
                    [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"name"] removeNull] length])];
                    
                    cell.lblattributed.attributedText=attString;
                }
            }
            else
            {
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]init];
                cell.lblattributed.attributedText=attString;
            }
           
            cell.isSelectedBG=((indexPath.row%2)==0)?YES:NO;
        }
            break;
            
        case 2:
        {
            cell.theCellType=CellType_Private_Messages;
            [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"userinfo"] objectForKey:@"thumbnail"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
            
            cell.lblBadge.text=[NSString stringWithFormat:@" %@ ",[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"count"]];
            
            cell.lblViewHeader.text=[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"userinfo"] objectForKey:@"name"];
            cell.lblViewHeader.textColor=[UIColor whiteColor];

            
            @try {
                NSData *strMessageData = [[[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"message"] removeNull] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSString *strTheMessage = [[NSString alloc] initWithData:strMessageData encoding:NSNonLossyASCIIStringEncoding];
                
                if ([[strTheMessage removeNull]length]==0)
                {
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"message"] removeNull]]];
                    [attString setFontName:@"Helvetica" size:12.0];
                    [attString setTextColor:[UIColor whiteColor]];
                    cell.lblattributed.attributedText=attString;
                }
                else
                {
                    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",strTheMessage]];
                    [attString setFontName:@"Helvetica" size:12.0];
                    [attString setTextColor:[UIColor whiteColor]];
                    cell.lblattributed.attributedText=attString;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"The exx:%@",exception.description);
//                cell.lblattributed.text=[[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"lastmessage"] objectForKey:@"message"] removeNull];

            }
            @finally {
                
            }
            
            
            
            
            cell.isSelectedBG=((indexPath.row%2)==0)?YES:NO;
            
        }
            break;
            
        case 1:
        {
            cell.isSelectedBG=((indexPath.row%2)==0)?YES:NO;
            cell.lblBadge.text=[NSString stringWithFormat:@"%@", [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"timestamp"] removeNull] formattedTime]];
//            cell.lblBadge.text=[NSString stringWithFormat:@"122d"];
            
            if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_like"])
            {
                cell.theCellType=CellType_Notification_Simple;
                [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"liked_by_user_info"] objectForKey:@"thumbnail"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ liked your post",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"liked_by_user_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"liked_by_user_info"] objectForKey:@"name"] removeNull] length])];
                
                cell.lblattributed.attributedText=attString;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_comment"])
            {
                cell.theCellType=CellType_Notification_Simple;
                [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"thumbnail"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ commented on your post: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull],[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"comment_text"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Oblique" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ commented on your post: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"comment_text"] removeNull] length])];
                cell.lblattributed.attributedText=attString;
                
                cell.lblBadge.text=[NSString stringWithFormat:@" %@ ", [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"timestamp"] removeNull] formattedTime]];
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"rating_like"])
            {
                cell.theCellType=CellType_Notification_Simple;
                cell.imgView.contentMode=UIViewContentModeCenter;
                cell.imgView.image=[UIImage imageNamed:@"prof_ratinglike"];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Someone liked your rating of %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0,[@"Someone" length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([@"Someone liked your rating of " length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Italic" size:12.0 range:NSMakeRange(0, [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"comment_text"] removeNull] length])];
                cell.lblattributed.attributedText=attString;
                
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"request_apporved"])
            {
                cell.theCellType=CellType_Notification_Simple;
                cell.imgView.contentMode=UIViewContentModeCenter;
                cell.imgView.image=[UIImage imageNamed:@"prof_ratinglike"];
                
                NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Congrats! %@ has been added. Rate now!",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(10,[[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"Congrats! %@ has been added. ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]] length], [@"Rate now!" length])];
                cell.lblattributed.attributedText=attString;
                
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"group_request"])
            {
                cell.theCellType=CellType_Notification_Invite;
                [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"thumbnail"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ is requesting to join your group: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull],[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull]]];
                
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ is requesting to join your group: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull] length])];
                
                cell.lblattributed.attributedText=attString;
                cell.btnAccept.tag = indexPath.row + 5000;
                [cell.btnAccept addTarget:self action:@selector(acceptInvitationAsaAdminInGROUP:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnIgnore.tag = indexPath.row + 4000;
                [cell.btnIgnore addTarget:self action:@selector(ignoreGroupRequest:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.btnAccept setImage:[UIImage imageNamed:@"btnaccept_small.png"] forState:UIControlStateNormal];

            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"group_invite"])
            {
                cell.theCellType=CellType_Notification_Invite;
                [cell.imgView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"invited_by_user_info"] objectForKey:@"thumbnail"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"]];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ is inviting you to join the group: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"invited_by_user_info"] objectForKey:@"name"] removeNull],[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull]]];
                
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull] length])];
                
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ is inviting you to join the group: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"invited_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull] length])];

                cell.lblattributed.attributedText=attString;
                cell.btnAccept.tag = indexPath.row + 5000;                
                cell.btnIgnore.tag = indexPath.row + 4000;
                [cell.btnAccept setImage:[UIImage imageNamed:@"btnjoin_small.png"] forState:UIControlStateNormal];
                
                [cell.btnAccept addTarget:self action:@selector(joinGroupRequest:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnIgnore addTarget:self action:@selector(ignoreGroupRequest:) forControlEvents:UIControlEventTouchUpInside];

            }
        }
            break;
        
        case 3:
        {
            cell.theCellType=CellType_User_Searching;
            cell.isSelectedBG=((indexPath.row%2)==0)?YES:NO;
            cell.lblattributed.text=[[[arrusersList objectAtIndex:indexPath.row] valueForKey:@"name"] removeNull];
            [cell.imgView setImageWithURL:[[arrusersList objectAtIndex:indexPath.row] valueForKey:@"profilepic"] placeholderImage:[UIImage imageNamed:@"default_user"]];
        }break;
            
        default:
        {
            
        }
            break;
    }

    
    return cell;
}

#pragma mark ACCEPT GROUP INVITATION REQUEST
/** It will send a Push Alert to end user that he has successfully added in Group **/

-(void)acceptInvitationAsaAdminInGROUP:(id)sender{
    
    NSString *strDomainNameOfaUser = [NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"group_info"] objectForKey:@"id"]];
    strDomainNameOfaUser = [strDomainNameOfaUser stringByAppendingFormat:@"%@",GROUP_CHAT_DOMAIN];
    NSLog(@"%@",[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)]);
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"requested_by_user_info"] objectForKey:@"id"],@"user_id",[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"group_info"] objectForKey:@"id"],@"group_id",[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"notification_id"],@"notification_id",[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"requested_by_user_info"] objectForKey:@"id"],@"userID",strDomainNameOfaUser,@"conferanceID",@"Request Accepted",@"Messege",@"request",@"type", nil];
    
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[ACCEPT_GROUP_INVITATION_REQUEST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(sendNotificationAcceptanceCertificate:) withfailureHandler:@selector(failTOsendNotificationAcceptanceCertificate:) withCallBackObject:self];
    [obj startRequest];
}
-(void)sendNotificationAcceptanceCertificate :(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [self btnNotificationsClicked:nil];
        kGRAlert(@"User has successfully added in group");
    }
}
-(void)failTOsendNotificationAcceptanceCertificate :(id)sender
{
    
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedtab)
    {
        case 0:
        {
            return 80.0;
        }
            break;
            
        case 1:
        {
            NSMutableAttributedString *attString;
            
            if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_like"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ liked your post",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"liked_by_user_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"liked_by_user_info"] objectForKey:@"name"] removeNull] length])];
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5, 53.0)+1;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_comment"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ commented on your post: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull],[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"comment_text"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Oblique" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ commented on your post: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"commented_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"comment_text"] removeNull] length])];
                
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5, 53.0)+1;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"rating_like"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Someone liked your rating of %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0,[@"Someone" length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([@"Someone liked your rating of " length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull] length])];
                
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5, 53.0)+1;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"request_apporved"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Congrats! %@ has been added. Rate now!",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]]];
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(10,[[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"Congrats! %@ has been added. ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"professor_info"] objectForKey:@"name"] removeNull]] length], [@"Rate now!" length])];
                
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5, 53.0)+1;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"group_request"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ is requesting to join your group: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull],[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull]]];
                
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull] length])];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ is requesting to join your group: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull] length])];
                
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5+20, 53.0)+10+1;
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"group_invite"])
            {
                attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ is inviting you to join the group: %@",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"invited_by_user_info"] objectForKey:@"name"] removeNull],[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull]]];
                
                [attString setFontName:@"Helvetica" size:12.0];
                [attString setTextColor:[UIColor whiteColor]];
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange(0, [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"requested_by_user_info"] objectForKey:@"name"] removeNull] length])];
                
                [attString setFontName:@"Helvetica-Bold" size:12.0 range:NSMakeRange([[NSString stringWithFormat:@"%@ is inviting you to join the group: ",[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"invited_by_user_info"] objectForKey:@"name"] removeNull]] length], [[[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"group_info"] objectForKey:@"name"] removeNull] length])];
                
                float thebody_height=[[attString heightforAttributedStringWithWidth:150.0]floatValue];
                return MAX(9+thebody_height+5+20, 53.0)+10+1;
            }
            
            return 44.0;
        }
            break;
            
        case 2:
        {
            return 70.0;
        }
            break;
            
        case 3:
        {
            return 50;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedtab) {
        case 3:
        {
            if (!isProfileLoading)
            {
                ProfileViewController *obj = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
                obj.isProfileViewMine=NO;
                obj.strTheUserId = [[arrusersList objectAtIndex:indexPath.row] valueForKey:@"user_id"];
                [self.navigationController pushViewController:obj animated:YES];
            }
        }
            break;
            
            case 1:
        {
            @try
            {
                NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_id"] removeNull],@"notification_id",nil];
                WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kUpdateBadgeNotificationURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
                [obj performSelector:@selector(startRequest) withObject:nil];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            
            
            if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_like"] || [[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"post_comment"])
            {
                CommentViewController *obj=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
                obj.commenttype = CommentTypeNotification;
                obj.selectedindex = indexPath.row;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:obj animated:NO completion:^{}];
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"rating_like"])
            {
                FullRatingViewController *obj=[[FullRatingViewController alloc]initWithNibName:@"FullRatingViewController" bundle:nil];
                obj.selectedratingindex=indexPath.row;
                obj.isNotificationRating=YES;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:obj animated:NO completion:^{}];
            }
            else if ([[[[arrNotifications objectAtIndex:indexPath.row] objectForKey:@"notification_type"] removeNull] isEqualToString:@"request_apporved"])
            {
                RateProfessorViewController *obj=[[RateProfessorViewController alloc]initWithNibName:@"RateProfessorViewController" bundle:nil];
                obj.selectedratingindex=indexPath.row;
                obj.isNotificationRating=YES;
                obj._delegate = self;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:obj animated:NO completion:^{}];
            }
        }
            break;
            
            case 0:
            StrGroup_id = [[[arrGroupUpdates objectAtIndex:indexPath.row] valueForKey:@"groupinfo"] valueForKey:@"id"];
            strGroupOrPersonName =[[[arrGroupUpdates objectAtIndex:indexPath.row] valueForKey:@"groupinfo"] valueForKey:@"name"];
            [self getAllGroupUserasaList:[arrGroupUpdates objectAtIndex:indexPath.row]];
            [dictGroupSetting removeAllObjects];
            [dictGroupSetting addEntriesFromDictionary:[[arrGroupUpdates objectAtIndex:indexPath.row] objectForKey:@"group_settings"]];
            break;
            
            case 2:
//            if (!isProfileLoading)
//            {
        {
                //isProfileLoading = YES;
                strTheUserId = [[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"userinfo"] objectForKey:@"id"];
                strProfilePicURLofFriend =[[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"userinfo"] objectForKey:@"thumbnail"];
                strGroupOrPersonName = [[[arrPrivateMessages objectAtIndex:indexPath.row] objectForKey:@"userinfo"] objectForKey:@"name"];
            ChatViewController *obj=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
            obj.isFlag=YES;
            obj.strGroupOrPersonName = strGroupOrPersonName;
            obj.strTheUserId = strTheUserId;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            isGroupChat = NO;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController presentViewController:obj animated:NO completion:^{}];
//            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void)loadOldChat:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
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
    
    
}

-(void)failToloadOldChat:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        //kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - G GET ALL USER
/* G GET ALL USER LIST AVAILABLE IN GROUP CHAT */
-(void) getAllGroupUserasaList:(id)sender{
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[[sender valueForKey:@"groupinfo"] valueForKey:@"id"],group_id,nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ALL_USER_LIST_FROM_GROUP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(userLoaded:) withfailureHandler:@selector(failToloadUsers:) withCallBackObject:self];
    [obj startRequest];
}

-(void)userLoaded:(id)sender
{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    arrUserList = [[NSMutableArray alloc] init];
    _dictaccUserID = [[NSMutableDictionary alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        for (int i=0; i<[[dictResponse objectForKey:@"userlist"] count]; i++) {
            NSLog(@"%@",[[dictResponse objectForKey:@"userlist"] objectAtIndex:i]);
            [_dictaccUserID setObject:[[dictResponse objectForKey:@"userlist"] objectAtIndex:i] forKey:[[[dictResponse objectForKey:@"userlist"] objectAtIndex:i] valueForKey:@"user_id"]];
        }
        [self enterInChatRoom:StrGroup_id];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)failToloadUsers:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)enterInChatRoom :(id)sender{
    
    if (!xmppRoom.isJoined && ISFirstTimeInChatView) {
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:moc];
        NSFetchRequest *fetchReq12 = [[NSFetchRequest alloc] init];
        [fetchReq12 setEntity:entityDesc];
        NSError *error;
        NSArray *messages12 = [moc executeFetchRequest:fetchReq12 error:&error];
        
        for (NSManagedObject *moc12 in messages12) {
            [moc deleteObject:moc12];
        }
    }
    
    xmppRoomStorage = [XMPPRoomHybridStorage sharedInstance];
    NSString *STRrealJID = [NSString stringWithFormat:@"%@%@",sender,GROUP_CHAT_DOMAIN];
    XMPPJID *roomRealJid = [XMPPJID jidWithString:STRrealJID];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomRealJid];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom activate:[[self appDelegate] xmppStream]];
    [xmppRoom joinRoomUsingNickname:[dictUserInfo valueForKey:@"username"] history:nil];
    ISFirstTimeInChatView = YES;
    ChatViewController *obj=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    obj.isFlag=YES;
    obj.strGroupId=sender;
    obj._dictGroupInfo = _dictaccUserID;
    obj.dictGroupSettings=dictGroupSetting;
    obj.strGroupOrPersonName =strGroupOrPersonName;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    isGroupChat = YES;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController presentViewController:obj animated:NO completion:^{}];
}



/* To get serarced user's Full Profile */

-(void)getFullProfile :(id)sender{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    _dictUserDetails = [[NSMutableDictionary alloc] init];
    arrUserNewsFeeds = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        _dictUserDetails = [dictResponse objectForKey:keyFORUserProfileResponse];
        if ([[dictResponse objectForKey:keyFORUserNewsFeeds] count]>0) {
            arrUserNewsFeeds = [dictResponse objectForKey:keyFORUserNewsFeeds];
        }
        /*ÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆ Send these ids to Profile View Controller ÆÆÆÆÆÆÆÆÆÆÆÆÆ*/
        
        ProfileViewController *obj = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        obj.isProfileViewMine=NO;
        obj.strGroupOrPersonName = [_dictUserDetails valueForKey:@"name"];
        obj.strTheUserId = [_dictUserDetails valueForKey:@"id"];
        [self.navigationController pushViewController:obj animated:YES];
        isProfileLoading = NO;
    }else{
        kGRAlert(@"oops ! It seems that server is busy. Please try again later.");
    }
}

-(void)failTogetProfile :(id)sender{
    isProfileLoading = NO;
    kGRAlert(@"oops ! It seems that server is not responding. Please try again later.");
    
}

-(IBAction)cancle:(id)sender
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    imgSegmentUpper.hidden=NO;
    tblView.frame = CGRectMake(0 ,84 +iOS7,320,484);
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    btnChat.hidden=NO;
    btnGroup.hidden=NO;
    btnNews.hidden = NO;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    selectedtab=100;
    [tblView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
    tblView.frame = CGRectMake(0, textField.frame.origin.y+33, self.view.frame.size.width, self.view.frame.size.height);
    btnChat.hidden=YES;
    btnGroup.hidden=YES;
    btnNews.hidden = YES;
    imgSegmentUpper.hidden=YES;
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchUsers:textField.text];
    [textField resignFirstResponder];
    return YES;
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

/* Search Users From calling webservice */
/* Search characters should be 3 and more then 3.*/

#pragma mark searching users

-(void)searchUsers:(id)sender{
    if (!isUserSearching) {
        isUserSearching=YES;
        NSString *strsearchChar = [NSString stringWithFormat:@"%@",sender];
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strsearchChar,SEARCH_USER_CHAR,nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[SEARCH_USER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(getUsersList:) withfailureHandler:@selector(failTogetUsersList:) withCallBackObject:self];
        [obj startRequest];
    }
}
/* Response Methods to call back URL */

-(void)getUsersList:(id)sender{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    arrusersList = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"MESSAGE"]] isEqualToString:@"No records found"]){
            //kGRAlert(@"sorry! No records found");
        }else{
            arrusersList = [dictResponse objectForKey:SEARCH_RESULT];
            selectedtab=100;
            selectedtab = 3;
            [tblView reloadData];
        }
    }else{
        kGRAlert(@"oops ! It seems that user database has too many entries. To get faster response please write down atleast 3 characters into search field");
    }
    isUserSearching = NO;
}

-(void)failTogetUsersList:(id)sender{
    isUserSearching = NO;
     kGRAlert(@"oops ! It seems that server is not responding. Please try again later.");
}

#pragma mark Join Group Request + Ignore Group Request
-(void)joinGroupRequest:(id)sender
{
//    index_Selected = [(UIButton *)sender tag]-5000;
//    
//    NSDictionary *dictTemp = [NSDictionary dictionaryWithDictionary:[arrNotifications objectAtIndex:index_Selected]];
//    
//    //index.php?c=group&func=joingroup1&user_id=1&group_id=6&notification_id=9
//    NSMutableDictionary *dictPara=[NSMutableDictionary dictionary];
//    [dictPara setValue:strUserId forKey:@"user_id"];
//    [dictPara setValue:[[[dictTemp objectForKey:@"group_info"] objectForKey:@"id"] removeNull] forKey:@"group_id"];
//    [dictPara setValue:[[dictTemp objectForKey:@"notification_id"] removeNull] forKey:@"notification_id"];
//    
//    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[joinGroupRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(joinGroupRequestSuccessful:) withfailureHandler:@selector(joinGroupRequestFail:) withCallBackObject:self];
//    [obj startRequest];
    
    
    NSString *strDomainNameOfaUser = [NSString stringWithFormat:@"%@",[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"group_info"] objectForKey:@"id"]];
    strDomainNameOfaUser = [strDomainNameOfaUser stringByAppendingFormat:@"%@",GROUP_CHAT_DOMAIN];
    NSLog(@"%@",[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)]);
   NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"group_info"] objectForKey:@"id"],@"group_id",[[arrNotifications objectAtIndex:([(UIButton *)sender tag]-5000)] objectForKey:@"notification_id"],@"notification_id",@"",@"userID",strDomainNameOfaUser,@"conferanceID",@"Request Accepted",@"Messege",@"invite",@"type", nil];
    
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[ACCEPT_GROUP_INVITATION_REQUEST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(joinGroupRequestSuccessful:) withfailureHandler:@selector(joinGroupRequestFail:) withCallBackObject:self];
    [obj startRequest];
    
}

-(void)joinGroupRequestSuccessful:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [self btnNotificationsClicked:nil];
        kGRAlert(@"User has successfully added in group");
    }
}

-(void)joinGroupRequestFail:(id)sender{
}

-(void)ignoreGroupRequest:(id)sender
{
    index_Selected = [(UIButton *)sender tag]-4000;
    //index.php?c=group&func=removerequest&user_id=1&group_id=3
    
    NSDictionary *dictTemp = [NSDictionary dictionaryWithDictionary:[arrNotifications objectAtIndex:index_Selected]];
    
    NSMutableDictionary *dictPara=[NSMutableDictionary dictionary];
    [dictPara setValue:strUserId forKey:@"user_id"];
    [dictPara setValue:[[[dictTemp objectForKey:@"group_info"] objectForKey:@"id"] removeNull] forKey:@"group_id"];
    [dictPara setValue:[[dictTemp objectForKey:@"notification_id"] removeNull] forKey:@"notification_id"];
    
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[IgnoreGroupRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ignoreGroupRequestSuccessful:) withfailureHandler:@selector(ignoreGroupRequestFail:) withCallBackObject:self];
    [obj startRequest];
}
-(void)ignoreGroupRequestSuccessful:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [self btnNotificationsClicked:nil];
    }else{
    }
}
-(void)ignoreGroupRequestFail:(id)sender{
}
#pragma mark XMPP ADD WITH DELEGATE

/* Add XMPP ALLOC INIT */

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
