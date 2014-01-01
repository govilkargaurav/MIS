//
//  GroupInviteViewController.m
//  MyU
//
//  Created by Vijay on 10/14/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "GroupInviteViewController.h"

@interface GroupInviteViewController () <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblGroups;
    NSMutableArray *arrGroupsInvite;
    NSMutableArray *arrInvited;
}
@end

@implementation GroupInviteViewController
@synthesize strInvited_UserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)btnBackClicked:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrGroupsInvite=[[NSMutableArray alloc]init];
    arrInvited=[[NSMutableArray alloc]init];
    tblGroups.layer.cornerRadius=4.0;
    tblGroups.layer.borderColor=[UIColor grayColor].CGColor;
    tblGroups.layer.borderWidth=0.8;
    tblGroups.backgroundColor=[UIColor whiteColor];
    
    [self loadgrouplist];
}

-(void)loadgrouplist
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"admin_id",strInvited_UserId,@"invited_user_id",nil];

    NSString *strTheURL=[NSString stringWithFormat:@"%@index.php?c=group&func=getmygroups",kBaseURL];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[strTheURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(groupsloaded:) withfailureHandler:@selector(groupsloadfailed:) withCallBackObject:self];
    [[MyAppManager sharedManager] showLoader];
    [obj startRequest];
}
-(void)groupsloaded:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrGroupsInvite addObjectsFromArray:[dictResponse objectForKey:@"groups"]];
        
        for (int i=0; i<[arrGroupsInvite count]; i++)
        {
            NSMutableDictionary *dictData=[arrGroupsInvite objectAtIndex:i];
            if ([[dictData objectForKey:@"status"] isEqualToString:@"joined"])
            {
                [dictData setObject:@"Joined" forKey:@"vstatus"];
                
            }
            else if ([[dictData objectForKey:@"status"] isEqualToString:@"invited"])
            {
                [dictData setObject:@"Invited" forKey:@"vstatus"];

            }
            else if ([[dictData objectForKey:@"max_group_users"] integerValue]<=[[dictData objectForKey:@"group_remaining_count"] integerValue])
            {
                [dictData setObject:@"Maximum users invited" forKey:@"vstatus"];
            }
            else{
                [dictData setObject:@"" forKey:@"vstatus"];
            }
        }
        
        [tblGroups reloadData];
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
-(void)groupsloadfailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrGroupsInvite count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0, 43.0, tblGroups.frame.size.width, 1.0)];
        viewSeparater.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:viewSeparater];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrGroupsInvite objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[arrGroupsInvite objectAtIndex:indexPath.row] objectForKey:@"vstatus"]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.textLabel.textColor = RGBCOLOR(60, 60, 60);
    
    NSString *strGroup_Id = [NSString stringWithFormat:@"%@",[[arrGroupsInvite objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    if ([arrInvited containsObject:strGroup_Id])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = indexPath.row % 2?[UIColor clearColor]:RGBCOLOR(242, 242, 242);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arrGroupsInvite objectAtIndex:indexPath.row] objectForKey:@"vstatus"] length]==0)
    {
        NSString *strGroup_Id = [NSString stringWithFormat:@"%@",[[arrGroupsInvite objectAtIndex:indexPath.row] objectForKey:@"id"]];
        if ([arrInvited containsObject:strGroup_Id])
        {
            [arrInvited removeObject:strGroup_Id];
        }
        else
        {
            [arrInvited addObject:strGroup_Id];
        }
    }
    
    [tblGroups reloadData];
}

-(IBAction)btnDonePressed:(id)sender
{
    if ([arrInvited count]==0)
    {
        kGRAlert(@"Please select atleast one group to invite.");
        return;
    }
    else
    {
        //&user_id=124&group_list=1,2,3
        NSString *strGroupIds=[arrInvited componentsJoinedByString:@","];
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strInvited_UserId,@"user_id",strGroupIds,@"group_list",nil];
        NSString *strTheURL=[NSString stringWithFormat:@"%@index.php?c=group&func=sendmultiplegroupinvites",kBaseURL];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[strTheURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(invitedsuccess:) withfailureHandler:@selector(invitefailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoader];
        [obj startRequest];
    }
}
-(void)invitedsuccess:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Invitation sent successfully");
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
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
-(void)invitefailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
