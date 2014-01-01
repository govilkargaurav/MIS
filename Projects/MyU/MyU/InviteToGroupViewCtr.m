//
//  InviteToGroupViewCtr.m
//  MyU
//
//  Created by Imac 2 on 10/3/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "InviteToGroupViewCtr.h"
#import "InvitePeopleCustomCell.h"

@interface InviteToGroupViewCtr () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tbl_Invite;
    IBOutlet UITextField *tf_Search;
    NSMutableArray *arrUsersLocal,*ArryUsersReload;
    NSMutableArray *arrUsersSelected;
    IBOutlet UIActivityIndicatorView *actIndicator;
    IBOutlet UIImageView *imgBG;
    IBOutlet UILabel *lblInviteLimit;
    NSMutableArray *arrInvitedUsers;
}

@end

@implementation InviteToGroupViewCtr
@synthesize ArryInvitedUsers,strgroup_remaining_count,strGroup_Id,strgroup_max_count;

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
    arrUsersLocal=[[NSMutableArray alloc]init];
    ArryUsersReload = [[NSMutableArray alloc]init];
    arrUsersSelected=[[NSMutableArray alloc]init];
    imgBG.image=[imgBG.image resizableImageWithCapInsets:UIEdgeInsetsMake(80.0, 80.0, 80.0, 80.0)];
    arrInvitedUsers=[[NSMutableArray alloc]initWithArray:[[[dictUpdatedGroupSettings objectForKey:@"invited_ids"] removeNull] componentsSeparatedByString:@","]];
    [arrUsersSelected addObjectsFromArray:[[[dictUpdatedGroupSettings objectForKey:@"invited_ids"] removeNull] componentsSeparatedByString:@","]];
    if ([arrAppUsers count]==0)
    {
        [self loaduserslist];
    }
    else
    {
        [arrUsersLocal addObjectsFromArray:arrAppUsers];
        [self RemoveInvitedUser];
        [ArryUsersReload addObjectsFromArray:arrUsersLocal];

        [tbl_Invite reloadData];
        [self hideLoader];
    }
    
    [self updateremaininglabel];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateremaininglabel
{
    lblInviteLimit.text=[NSString stringWithFormat:@"%d/%d",([strgroup_max_count integerValue]-[strgroup_remaining_count integerValue]),[strgroup_max_count integerValue]];
    [tbl_Invite reloadData];
}

-(void)RemoveInvitedUser
{
    NSMutableArray *ArryTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrUsersLocal count]; i++)
    {
        for (int j = 0; j < [ArryInvitedUsers count]; j++)
        {
            if ([[[ArryInvitedUsers objectAtIndex:j] valueForKey:@"user_id"] isEqualToString:[[arrUsersLocal objectAtIndex:i] objectForKey:@"id"]])
            {
                [ArryTemp addObject:[arrUsersLocal objectAtIndex:i]];
            }
        }
    }
    
    [arrUsersLocal removeObjectsInArray:ArryTemp];

}
- (IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

-(void)loaduserslist
{
    NSMutableDictionary *dictPara=[[NSMutableDictionary alloc]initWithObjectsAndKeys:strUserId,@"user_id", nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kGetAllUsers stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(userlistloaded:) withfailureHandler:@selector(userlistfailed:) withCallBackObject:self];
    [self showLoader];
    [obj startRequest];
}
-(void)userlistloaded:(id)sender
{
    [self hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
        
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrAppUsers removeAllObjects];
        [arrAppUsers addObjectsFromArray:[dictResponse objectForKey:@"user_info"]];
        [arrUsersLocal addObjectsFromArray:arrAppUsers];
        [self RemoveInvitedUser];
        [ArryUsersReload addObjectsFromArray:arrUsersLocal];
        [tbl_Invite reloadData];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)userlistfailed:(id)sender
{
    [self hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
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
#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArryUsersReload count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    InvitePeopleCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[InvitePeopleCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.isBigCell=YES;
    cell.imgMainBG.image=[[UIImage imageNamed:[NSString stringWithFormat:@"cellbgaddgroup_%d.png",((indexPath.row%2==0)?0:1)]] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0) resizingMode:UIImageResizingModeTile];
    cell.lblName.text=[[ArryUsersReload objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.btnInvite.tag=indexPath.row;
    [cell.btnInvite addTarget:self action:@selector(btnInviteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strUserInviteId=[NSString stringWithFormat:@"%@",[[ArryUsersReload objectAtIndex:indexPath.row]  objectForKey:@"id"]];
    [cell.btnInvite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btninvite%@.png",([arrUsersSelected containsObject:strUserInviteId])?@"db":@""]] forState:UIControlStateNormal];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(void)btnInviteClicked:(id)sender
{
    NSString *strUserInviteId=[NSString stringWithFormat:@"%@",[[ArryUsersReload objectAtIndex:[(UIButton *)sender tag]]  objectForKey:@"id"]];
    if(![arrUsersSelected containsObject:strUserInviteId])
    {
        if ([strgroup_remaining_count intValue]>0)
        {
            [arrUsersSelected addObject:strUserInviteId];
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strGroup_Id,@"group_id",strUserInviteId,@"userid_list",nil];
            
            [[MyAppManager sharedManager] showLoader];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kInviteUserToGroupURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(InviteSendSuccess:) withfailureHandler:@selector(InviteSendFailed:) withCallBackObject:self];
            [obj startRequest];
            
        }
        else if([strgroup_remaining_count intValue]==0)
        {
            NSString *strMSG=[NSString stringWithFormat:@"You have invite maximum num of users. You can not invite more users."];
            kGRAlert(strMSG);
        }
        else
        {
            NSString *strMSG=[NSString stringWithFormat:@"You can invite maximum %@ users.",strgroup_remaining_count];
            kGRAlert(strMSG);
        }
    }
//    else
//    {
//        [arrUsersSelected removeObject:strUserInviteId];
//    }
    
    InvitePeopleCustomCell *cell=(InvitePeopleCustomCell *)[tbl_Invite cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(UIButton *)sender tag] inSection:0]];
    [cell.btnInvite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btninvite%@.png",([arrUsersSelected containsObject:strUserInviteId])?@"db":@""]] forState:UIControlStateNormal];
    
    [self updateremaininglabel];

   /* if ([arrAppUsers count]==0) {
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people"];
    }
    else{
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people (%d/%d)",[arrUsersSelected count],group_maxinvite];
    }*/
}
-(void)InviteSendSuccess:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [dictUpdatedGroupSettings removeAllObjects];
        [dictUpdatedGroupSettings addEntriesFromDictionary:[dictResponse objectForKey:@"updated_group_info"]];
        shouldUpdateGroupSettings=YES;
        
        strgroup_remaining_count = [NSString stringWithFormat:@"%@",[[dictUpdatedGroupSettings objectForKey:@"group_remaining_count"] removeNull]];
        [arrUsersSelected removeAllObjects];
        [arrUsersSelected addObjectsFromArray:[[[dictUpdatedGroupSettings objectForKey:@"invited_ids"] removeNull] componentsSeparatedByString:@","]];

        BOOL isGroupUpdated=NO;
        for (int i=0; i<[arrJoinedGroups count]; i++)
        {
            if ([[[arrJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:[dictUpdatedGroupSettings objectForKey:@"group_id"]])
            {
                if (!isGroupUpdated)
                {
                    [[dictGroups objectForKey:@"joined"] replaceObjectAtIndex:i withObject:dictUpdatedGroupSettings];
                    isGroupUpdated=YES;
                    break;
                }
            }
        }
    }
    
    [self updateremaininglabel];
}
-(void)InviteSendFailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)searchUsersLocally
{
    [ArryUsersReload removeAllObjects];
    
    if ([[tf_Search.text removeNull] length]==0)
    {
        [ArryUsersReload addObjectsFromArray:arrUsersLocal];
        [self RemoveInvitedUser];
        [tbl_Invite reloadData];
        return;
    }
    
    for (int i=0; i<[arrUsersLocal count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:i] objectForKey:@"name"]] rangeOfString:[tf_Search.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [ArryUsersReload addObject:[arrUsersLocal objectAtIndex:i]];
        }
    }
/*
    if ([arrAppUsers count]==0) {
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people"];
    }
    else{
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people (%d/%d)",[arrUsersSelected count],group_maxinvite];
    }*/
    
    [tbl_Invite reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(searchUsersLocally) withObject:nil afterDelay:0.0];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
