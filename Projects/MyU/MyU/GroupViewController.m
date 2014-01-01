//
//  GroupViewController.m
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "GroupViewController.h"
#import "AddNewGroupViewController.h"
#import "ChatViewController.h"
#import "GroupCustomCell.h"
#import "CustomBadge.h"

@interface GroupViewController () <UISearchBarDelegate>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *btnChat;
    NSMutableArray  *arrGroups;
    NSString *StrGroup_id;
    NSMutableDictionary *dictGroupSetting;
}

@end

@implementation GroupViewController
@synthesize arrUserList;
@synthesize _dictaccUserID;
@synthesize strGroupOrPersonName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    dictGroupSetting=[[NSMutableDictionary alloc]init];
    if (!isAppInGuestMode)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromRightNavigationCnTlR:) name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClosesearchFromRightNavigationCnTlR:) name:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    }
    
    searchBar.tintColor=kCustomGRBLDarkColor;
    arrGroups=[[NSMutableArray alloc]init];
    
    searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
    searchBar.alpha=1.0;
    
    [self loadgroups];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MyAppManager sharedManager] updatenotificationbadge];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateNotificationBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatenotificationbadge) name:kNotifyUpdateNotificationBadge object:nil];
    [self updatenotificationbadge];
    
    [arrJoinedGroups removeAllObjects];
    [arrUnJoinedGroups removeAllObjects];
    
    [arrJoinedGroups addObjectsFromArray:[dictGroups objectForKey:@"joined"]];
    [arrUnJoinedGroups addObjectsFromArray:[dictGroups objectForKey:@"unjoined"]];
    
    [arrGroups removeAllObjects];
    [arrGroups addObjectsFromArray:arrJoinedGroups];
    [arrGroups addObjectsFromArray:arrUnJoinedGroups];
    
    [self searchGroupsLocally];
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

-(void)searchBar:(UISearchBar *)searchBars textDidChange:(NSString *)searchText
{
    [self searchGroupsLocally];
}

-(void)searchGroupsLocally
{
    if (([[searchBar.text removeNull] length]==0))
    {
        [arrGroups removeAllObjects];
        [arrGroups addObjectsFromArray:arrJoinedGroups];
        [arrGroups addObjectsFromArray:arrUnJoinedGroups];
        [tblView reloadData];
        
        return;
    }
    
    [arrGroups removeAllObjects];
    
    for (int i=0; i<[arrJoinedGroups count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrJoinedGroups objectAtIndex:i] objectForKey:@"group_name"]] rangeOfString:[searchBar.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrGroups addObject:[arrJoinedGroups objectAtIndex:i]];
        }
    }
    
    for (int i=0; i<[arrUnJoinedGroups count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrUnJoinedGroups objectAtIndex:i] objectForKey:@"group_name"]] rangeOfString:[searchBar.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrGroups addObject:[arrUnJoinedGroups objectAtIndex:i]];
        }
    }
    
    [tblView reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBars
{
    searchBars.showsCancelButton=YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBars
{
    searchBar.showsCancelButton=NO;
    [searchBars resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}
-(IBAction)btnScrollToTopClicked:(id)sender
{
    if([arrGroups count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionTop
                               animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (IBAction)btnMenuOptionsClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)btnFriendsSectionClicked:(id)sender
{
    [searchBar resignFirstResponder];

    if (isAppInGuestMode) {
        [self alertIfGuestMode];
    }
    else{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }
}

-(IBAction)btnAddClicked:(id)sender
{
    if (isAppInGuestMode) {
        [self alertIfGuestMode];
        return;
    }

    AddNewGroupViewController *obj=[[AddNewGroupViewController alloc]initWithNibName:@"AddNewGroupViewController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}

#pragma mark - WEBSERVICES
/*
 joined =     (
 );
 unjoined =     (
 {
 "group_admin_id" = 3;
 "group_admin_name" = Mark;
 "group_id" = 4;
 "group_member_count" = 0;
 "group_name" = "my group";
 "group_pic" = "http://www.openxcellaus.info/myu/admin/files/group/groupthumbnail/93622dbd0207a6ef04efb8674b071aa7.jpg";
 "group_status" = unjoined;
 },
 */
-(void)loadgroups
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kGroupListAll stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(grouploaded:) withfailureHandler:@selector(grouploadfailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)grouploaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [dictGroups removeObjectForKey:@"joined"];
        [dictGroups removeObjectForKey:@"unjoined"];
        
        [dictGroups setObject:[dictResponse objectForKey:@"joined"] forKey:@"joined"];
        [dictGroups setObject:[dictResponse objectForKey:@"unjoined"] forKey:@"unjoined"];
        
        [arrJoinedGroups removeAllObjects];
        [arrUnJoinedGroups removeAllObjects];
        
        [arrJoinedGroups addObjectsFromArray:[dictGroups objectForKey:@"joined"]];
        [arrUnJoinedGroups addObjectsFromArray:[dictGroups objectForKey:@"unjoined"]];
        
        [arrGroups removeAllObjects];
        [arrGroups addObjectsFromArray:arrJoinedGroups];
        [arrGroups addObjectsFromArray:arrUnJoinedGroups];
        
        [self searchGroupsLocally];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)grouploadfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;

    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)joinGroupWithGroupId:(NSString *)strGroupId
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strGroupId,@"group_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kGroupJoin stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}

-(void)rejectRequestGroupWithGroupId:(NSString *)strGroupId
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strGroupId,@"group_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kGroupRemoveRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GroupCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[GroupCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    

    
    if ([[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_pic"] removeNull] length]>0)
    {
        [cell.imgGroupPic setImageWithURL:[NSURL URLWithString:[[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_pic"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_group"]];
    }
    else
    {
        [cell.imgGroupPic setImage:[UIImage imageNamed:@"default_group"]];
        [cell.imgGroupPic setContentMode:UIViewContentModeCenter];
    }
    
    cell.lblGroupName.text=[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_name"] removeNull];
    //cell.lblGroupBy.text=[NSString stringWithFormat:@"by %@",[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_admin_name"] removeNull]];
    cell.lblGroupMembers.text=[NSString stringWithFormat:@"%@ Members",[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_member_count"] removeNull]];
    
    cell.imgMainBG.image=[UIImage imageNamed:[NSString stringWithFormat:@"cellbg_lightgrey_%d.png",((indexPath.row%2==0)?0:1)]];
    
    if ([[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_status"] removeNull] isEqualToString:@"unjoined"])
    {
        cell.btnJoin.tag=indexPath.row;
        [cell.btnJoin removeTarget:self action:@selector(btnCancelRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnJoin addTarget:self action:@selector(btnJoinClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnJoin setImage:[UIImage imageNamed:@"btnJoin"] forState:UIControlStateNormal];
//        [cell.btnJoin setBackgroundImage:[UIImage imageNamed:@"btnOrange"] forState:UIControlStateNormal];
//        [cell.btnJoin setTitle:@"JOIN" forState:UIControlStateNormal];
//        [cell.btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [cell.btnJoin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
        
        cell.lblGroupUpdates.text=@"";
    }
    else if ([[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_status"] removeNull] isEqualToString:@"requested"])
    {
        cell.btnJoin.tag=indexPath.row;
        [cell.btnJoin removeTarget:self action:@selector(btnJoinClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnJoin addTarget:self action:@selector(btnCancelRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnJoin setImage:[UIImage imageNamed:@"btnRequested"] forState:UIControlStateNormal];

//        [cell.btnJoin setBackgroundImage:[UIImage imageNamed:@"btnGrey"] forState:UIControlStateNormal];
//        [cell.btnJoin setTitle:@"REQUESTED" forState:UIControlStateNormal];
//        [cell.btnJoin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [cell.btnJoin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.0]];
        
        cell.lblGroupUpdates.text=@"";
    }
    else
    {
        cell.lblGroupUpdates.text=[NSString stringWithFormat:@" %@ ",[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_member_count"] removeNull]];
    }
    
    return cell;
}

-(void)btnJoinClicked:(id)sender
{
    if (isAppInGuestMode) {
        [self alertIfGuestMode];
        return;
    }
    NSMutableDictionary *dictGroupTemp=[[NSMutableDictionary alloc]initWithDictionary:[arrGroups objectAtIndex:[(UIButton *)sender tag]]];
    [dictGroupTemp setObject:@"requested" forKey:@"group_status"];
    NSString *strGroupId=[NSString stringWithFormat:@"%@",[dictGroupTemp objectForKey:@"group_id"]];
    
    [self joinGroupWithGroupId:strGroupId];
    
    for (int i=0; i<[arrUnJoinedGroups count]; i++)
    {
        if ([[[arrUnJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:strGroupId])
        {
            [arrUnJoinedGroups replaceObjectAtIndex:i withObject:dictGroupTemp];
        }
    }
    [dictGroups setObject:arrUnJoinedGroups forKey:@"unjoined"];
    [self searchGroupsLocally];
}

-(void)btnCancelRequestClicked:(id)sender
{
    NSMutableDictionary *dictGroupTemp=[[NSMutableDictionary alloc]initWithDictionary:[arrGroups objectAtIndex:[(UIButton *)sender tag]]];
    [dictGroupTemp setObject:@"unjoined" forKey:@"group_status"];
    
    NSString *strGroupId=[NSString stringWithFormat:@"%@",[dictGroupTemp objectForKey:@"group_id"]];
    
    [self rejectRequestGroupWithGroupId:strGroupId];
    
    for (int i=0; i<[arrUnJoinedGroups count]; i++)
    {
        if ([[[arrUnJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:strGroupId])
        {
            [arrUnJoinedGroups replaceObjectAtIndex:i withObject:dictGroupTemp];
        }
    }
    
    [dictGroups setObject:arrUnJoinedGroups forKey:@"unjoined"];

    [self searchGroupsLocally];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!(([[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_status"] removeNull] isEqualToString:@"unjoined"]) || ([[[[arrGroups objectAtIndex:indexPath.row] objectForKey:@"group_status"] removeNull] isEqualToString:@"requested"])))
    {
        strGroupOrPersonName =[[arrGroups objectAtIndex:indexPath.row] valueForKey:@"group_name"];
        StrGroup_id = [[arrGroups objectAtIndex:indexPath.row] valueForKey:group_id];
        [self getAllGroupUserasaList:[arrGroups objectAtIndex:indexPath.row]];
        [dictGroupSetting removeAllObjects];
        [dictGroupSetting addEntriesFromDictionary:[arrGroups objectAtIndex:indexPath.row]];
    }
}

#pragma mark - G GET ALL USER
/* G GET ALL USER LIST AVAILABLE IN GROUP CHAT */
-(void) getAllGroupUserasaList:(id)sender{
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[sender valueForKey:@"group_id"],group_id,nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ALL_USER_LIST_FROM_GROUP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(userLoaded:) withfailureHandler:@selector(failToloadUsers:) withCallBackObject:self];
    [obj startRequest];
}

-(void)userLoaded:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    arrUserList = [[NSMutableArray alloc] init];
    _dictaccUserID = [[NSMutableDictionary alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        for (int i=0; i<[[dictResponse objectForKey:@"userlist"] count]; i++) {
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
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)enterInChatRoom :(id)sender{
    ISFirstTimeInChatView = YES;
    xmppRoomStorage = [XMPPRoomHybridStorage sharedInstance];
    NSString *STRrealJID = [NSString stringWithFormat:@"%@%@",sender,GROUP_CHAT_DOMAIN];
    XMPPJID *roomRealJid = [XMPPJID jidWithString:STRrealJID];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomRealJid dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    [xmppRoom activate: [[self appDelegate] xmppStream]];
    [xmppRoom fetchConfigurationForm];
    [xmppRoom addDelegate:[self appDelegate] delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:strUserId history:nil password:@"iphone1"];
    [self performSelector:@selector(ConfigureNewRoom:) withObject:xmppRoom afterDelay:3];
    
    ChatViewController *obj=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    obj.strGroupId=sender;
    obj._dictGroupInfo = _dictaccUserID;
    obj.strGroupOrPersonName= strGroupOrPersonName;
    obj.dictGroupSettings=dictGroupSetting;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    isGroupChat = YES;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController presentViewController:obj animated:NO completion:^{}];
}




- (void)ConfigureNewRoom:(XMPPRoom *)room{
    [room configureRoomUsingOptions:nil];
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ((scrollView.contentOffset.y>=0) && (scrollView.contentOffset.y<(scrollView.contentSize.height-scrollView.frame.size.height)))
    {
        searchBar.alpha=((velocity.y<=0.0))?0.0:1.0;
        tblView.frame=CGRectMake(0.0, ((velocity.y<=0.0)?88.0:44.0)+iOS7,320.0,416.0+iPhone5ExHeight-((velocity.y<=0.0)?44.0:0.0));
        
        if (velocity.y<=0.0)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
            searchBar.alpha=1.0;
            [UIView commitAnimations];
        }
        else
        {
            searchBar.frame=CGRectMake(0.0,0.0,320.0,44.0);
            searchBar.alpha=0.0;
        }
    }
    else if(scrollView.contentOffset.y<=0)
    {
        searchBar.alpha=0.0;
        tblView.frame=CGRectMake(0.0,88.0+iOS7,320.0,416.0+iPhone5ExHeight-44.0);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        searchBar.frame=CGRectMake(0.0,44.0+iOS7,320.0,44.0);
        searchBar.alpha=1.0;
        [UIView commitAnimations];
    }
}

#pragma mark - DEFAULT
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

#pragma mark XMPP ADD WITH DELEGATE

/* Add XMPP ALLOC INIT */

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
