//
//  ChangeAdminViewCtr.m
//  MyU
//
//  Created by Imac 2 on 10/2/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ChangeAdminViewCtr.h"

@interface ChangeAdminViewCtr () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tbl_Set_Admin;
    IBOutlet UITextField *tf_Search;
    NSString *strCheckMarkGroupId;
    NSMutableArray *arrUsersLocal;
    IBOutlet UIImageView *imgBG;
}
@end

@implementation ChangeAdminViewCtr
@synthesize ArryUsers,strGroup_Id,strGroup_Admin_Id;

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
    
    imgBG.image=[imgBG.image resizableImageWithCapInsets:UIEdgeInsetsMake(70.0, 70.0, 70.0, 70.0)];
    arrUsersLocal = [[NSMutableArray alloc]init];
    for (int i = 0; i < [ArryUsers count]; i++)
    {
        if ([[[ArryUsers objectAtIndex:i] objectForKey:@"user_id"] isEqualToString:strGroup_Admin_Id])
        {
            strCheckMarkGroupId = [NSString stringWithFormat:@"%@",strGroup_Admin_Id];
            [ArryUsers removeObjectAtIndex:i];
            break;
        }
    }
    
    arrUsersLocal = [ArryUsers mutableCopy];
    [tbl_Set_Admin reloadData];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUsersLocal count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:indexPath.row] objectForKey:@"username"]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.textLabel.textColor = RGBCOLOR(60, 60, 60);
    
    NSString *strUser_Id = [NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
    
    if ([strUser_Id isEqualToString:strCheckMarkGroupId])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
         cell.accessoryType = UITableViewCellAccessoryNone;

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
    strCheckMarkGroupId = [NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:indexPath.row] objectForKey:@"user_id"]];
    [tbl_Set_Admin reloadData];
}

-(IBAction)btnDonePressed:(id)sender
{
    if ([strCheckMarkGroupId isEqualToString:strGroup_Admin_Id])
    {
        kGRAlert(@"Please select admin");
        return;
    }
    else
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroup_Admin_Id,@"old_admin_id",strGroup_Id,@"group_id",strCheckMarkGroupId,@"new_admin_id",nil];
        
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLeaveGroupURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(LeaveGroupSuccess:) withfailureHandler:@selector(LeaveGroupfailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoader];
        [obj startRequest];
    }
}
-(void)LeaveGroupSuccess:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        //VJAY
        shouldBackToRoot=YES;
        
        BOOL isGroupRemoved=NO;
        for (int i=0; i<[arrJoinedGroups count]; i++)
        {
            if ([[[arrJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:[[dictResponse objectForKey:@"updated_group_info"]objectForKey:@"group_id"]])
            {
                if (!isGroupRemoved)
                {
                    [[dictGroups objectForKey:@"joined"] removeObjectAtIndex:i];
                    isGroupRemoved=YES;
                    break;
                }
            }
        }
        
        [[dictGroups objectForKey:@"unjoined"] addObject:[dictResponse objectForKey:@"updated_group_info"]];

        [self dismissViewControllerAnimated:NO completion:nil];
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
-(void)LeaveGroupfailed:(id)sender
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)searchUsersLocally
{
    if (arrUsersLocal.count > 0)
    {
        [arrUsersLocal removeAllObjects];
    }
    
    if ([[tf_Search.text removeNull] length]==0)
    {
        [arrUsersLocal addObjectsFromArray:ArryUsers];
        [tbl_Set_Admin reloadData];
        return;
    }
    
    for (int i=0; i<[ArryUsers count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[ArryUsers objectAtIndex:i] objectForKey:@"username"]] rangeOfString:[tf_Search.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrUsersLocal addObject:[ArryUsers objectAtIndex:i]];
        }
    }
    
    [tbl_Set_Admin reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(searchUsersLocally) withObject:nil afterDelay:0.0];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
   // tblView.frame=CGRectMake(11.0,173.0,299.0,71.0+iPhone5ExHeight);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
   // tblView.frame=CGRectMake(11.0,173.0,299.0,229.0+iPhone5ExHeight);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
