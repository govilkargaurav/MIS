//
//  ChatSettingsViewController.m
//  MyU
//
//  Created by Vijay on 9/21/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ChatSettingsViewController.h"
#import "ChatUserCustomCell.h"
#import "REPhotoCollectionController.h"
#import "Photo.h"
#import "ThumbnailView.h"
#import "UIImage+Utilities.h"
#import "ChangeAdminViewCtr.h"
#import "InviteToGroupViewCtr.h"

@interface ChatSettingsViewController () <UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imgGroupProfile;
    IBOutlet UITextField *txtGroupName;
    IBOutlet UISwitch *switchMute;
    IBOutlet UILabel *lblMemberCount;
    IBOutlet UIImageView *imgbgMember;
    IBOutlet UITableView *tblMember;
    IBOutlet UIButton *btnLeaveGroup;
    IBOutlet UILabel *lblGroupCreationTime;
    NSMutableArray *arrGroupUsers;
    BOOL Group_Picture_Changed;
}
@end

@implementation ChatSettingsViewController

@synthesize strGroupId,arrmediaBYmonth,dictGroupSettings,dictGroupUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)btnEditGroupProfilePic:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Choose from library" otherButtonTitles:@"Take from camera", nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (shouldBackToChat || shouldBackToRoot) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (shouldUpdateGroupSettings)
    {
        [dictGroupSettings removeAllObjects];
        [dictGroupSettings addEntriesFromDictionary:dictUpdatedGroupSettings];
        
        lblMemberCount.text = [NSString stringWithFormat:@"Members (%@/%@)",[[dictGroupSettings objectForKey:@"group_member_count"] removeNull],[[dictGroupSettings objectForKey:@"max_group_users"] removeNull]];
    }
    
    

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    else
    {
        if (buttonIndex == 0 || buttonIndex == 1)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if(buttonIndex == 0)
            {
                if([UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else if (buttonIndex == 1)
            {
                if([UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypeCamera])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                }
            }
            NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.image",nil];
            [imagePicker setMediaTypes:mediaTypesAllowed];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.wantsFullScreenLayout=TRUE;
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        Group_Picture_Changed = YES;
        UIImage *img = [info valueForKey:UIImagePickerControllerEditedImage];
        imgGroupProfile.image = [img squaredImage];
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    
    
    // [self callThumbnail];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - VIEW ALL MEDIA
-(IBAction)btnViewAllMediaClicked:(id)sender
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,group_id,nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[VIEW_ALL_MEDIA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(viewAllMedia:) withfailureHandler:@selector(FailToviewAllMedia:) withCallBackObject:self];
    [obj startRequest];
}

-(void)viewAllMedia:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    arrmediaBYmonth = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        for (int i = 0; i<[[dictResponse valueForKey:@"media"] count]; i++) {
            NSLog(@"%@",[[[dictResponse valueForKey:@"media"] objectAtIndex:i] valueForKey:@"date_created"]);
            NSLog(@"%@",[[[dictResponse valueForKey:@"media"] objectAtIndex:i] valueForKey:@"image_url_thumb"]);
            
            [arrmediaBYmonth addObject:[Photo photoWithURLString:[[[dictResponse valueForKey:@"media"] objectAtIndex:i] valueForKey:@"image_url_thumb"] date:[self dateFromString:[[[dictResponse valueForKey:@"media"] objectAtIndex:i] valueForKey:@"date_created"]]]];
        }
        
            [self testButtonPressed:arrmediaBYmonth];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }else{
            
            kGRAlert(@"oops! No media file found")
        }
    }
}
-(void)FailToviewAllMedia:(id)sender{
    
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    
}
- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat dateFromString:string];
}

- (void)testButtonPressed:(NSMutableArray *)sender
{
    photoCollectionController = [[REPhotoCollectionController alloc] initWithDatasource:sender];
    //photoCollectionController.title = @"Photos";
    photoCollectionController.thumbnailViewClass = [ThumbnailView class];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoCollectionController];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0-iOS7, 320, 44+iOS7)];
    if(iOS7)
        [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_navbar.png"]]];
    else
        [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_navbar_normal.png"]]];
    [navigationController.navigationBar addSubview:titleView];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 8+iOS7, 50, 29);
    btnBack.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btnback.png"]];
    [btnBack addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btnBack];
    
    [self presentViewController:navigationController animated:NO completion:^{}];
    
    //[self.navigationController pushViewController:navigationController animated:YES];
}

-(void)backBtnPressed:(id)sender{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)btnLeaveGroupClicked:(id)sender
{
    if (arrGroupUsers.count == 1 && [[[[arrGroupUsers objectAtIndex:0] objectForKey:@"user_id"] removeNull] isEqualToString:[[dictGroupSettings objectForKey:@"group_admin_id"] removeNull]])
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_id"]removeNull]],@"group_id",nil];
        
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLeaveGroupOnlyYouURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(LeaveGroupOnlyYouSuccess:) withfailureHandler:@selector(LeaveGroupOnlyYoufailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoader];
        [obj startRequest];
    }
    else
    {
        ChangeAdminViewCtr *obj_ChangeAdminViewCtr = [[ChangeAdminViewCtr alloc]initWithNibName:@"ChangeAdminViewCtr" bundle:nil];
        obj_ChangeAdminViewCtr.ArryUsers = [arrGroupUsers mutableCopy];
        obj_ChangeAdminViewCtr.strGroup_Admin_Id = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_admin_id"] removeNull]];
        obj_ChangeAdminViewCtr.strGroup_Id = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_id"]removeNull]];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj_ChangeAdminViewCtr animated:NO completion:^{}];
    }
}

-(void)LeaveGroupOnlyYouSuccess:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        //VJAY
        BOOL isGroupRemoved=NO;
        for (int i=0; i<[arrJoinedGroups count]; i++)
        {
            if ([[[arrJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:[dictGroupSettings objectForKey:@"group_id"]])
            {
                if (!isGroupRemoved)
                {
                    [[dictGroups objectForKey:@"joined"] removeObjectAtIndex:i];
                    isGroupRemoved=YES;
                    break;
                }
            }
        }
        
        shouldBackToRoot=YES;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
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

-(void)LeaveGroupOnlyYoufailed:(id)sender
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    Group_Picture_Changed = NO;
    arrGroupUsers=[[NSMutableArray alloc]init];
    
    NSLog(@"the group data:%@",dictGroupSettings);
    
    for (NSString *theKey in [dictGroupUsers allKeys])
    {
        [arrGroupUsers addObject:[dictGroupUsers objectForKey:theKey]];
    }
    
    NSLog(@"the users: data:%@",arrGroupUsers);
    
    txtGroupName.text=[[dictGroupSettings objectForKey:@"group_name"] removeNull];
    [imgGroupProfile setImageWithURL:[NSURL URLWithString:[[[dictGroupSettings objectForKey:@"group_pic"] removeNull] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_group"]];
    switchMute.on=([[[dictGroupSettings objectForKey:@"is_mute"] removeNull] isEqualToString:@"no"])?NO:YES;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy, hh:mm a"];
    lblGroupCreationTime.text=[NSString stringWithFormat:@"Created %@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[dictGroupSettings objectForKey:@"group_creation_time"] removeNull] doubleValue]]]];
    lblMemberCount.text = [NSString stringWithFormat:@"Members (%@/%@)",[[dictGroupSettings objectForKey:@"group_member_count"] removeNull],[[dictGroupSettings objectForKey:@"max_group_users"] removeNull]];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 504);
}

-(IBAction)btnSavePressed:(id)sender
{
    NSString *strGroup_Id = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_id"]removeNull]];
    NSString *strGroup_Name = [NSString stringWithFormat:@"%@",[[txtGroupName.text removeNull] removeNull]];
    NSString *stradmin_id = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_admin_id"] removeNull]];
    NSString *stris_mute = ([switchMute isOn])?@"0":@"1";
    
    
    if ([strGroup_Name length] > 0)
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroup_Id,@"group_id",strGroup_Name,@"group_name",stradmin_id,@"admin_id",stris_mute,@"is_mute",nil];
    
        NSDictionary *dictData = Group_Picture_Changed ? [NSDictionary dictionaryWithObjectsAndKeys:UIImagePNGRepresentation([imgGroupProfile.image scaleAndRotateImage]),@"group_picture",nil]:nil;
        
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kUpdateGroupInfoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:dictData withsucessHandler:@selector(Groupupdated:) withfailureHandler:@selector(Groupupdatefailed:) withCallBackObject:self];
        [[MyAppManager sharedManager] showLoader];
        [obj startRequest];
    }
    else
    {
        kGRAlert(@"Group name should not be empty.");
    }
    
//    for (int i=0; i<[arrJoinedGroups count];i++)
//    {
//        if ([[[arrJoinedGroups objectAtIndex:i] objectForKey:@"group_id"] isEqualToString:[dictGroupSettings objectForKey:@"group_id"]])
//        {
//            [[arrJoinedGroups objectAtIndex:i] setObject:[txtGroupName.text removeNull] forKey:@"group_name"];
//        }
//    }
}
-(void)Groupupdated:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        Group_Picture_Changed = NO;
        //VJAY
        
        
        [dictUpdatedGroupSettings removeAllObjects];
        [dictUpdatedGroupSettings addEntriesFromDictionary:[dictResponse objectForKey:@"updated_group_info"]];
        shouldUpdateGroupSettings=YES;
        [dictGroupSettings removeAllObjects];
        [dictGroupSettings addEntriesFromDictionary:dictUpdatedGroupSettings];
        
        BOOL isGroupUpdated=NO;
        for (int i=0; i<[arrJoinedGroups count]; i++)
        {
            if ([[[arrJoinedGroups objectAtIndex:i]objectForKey:@"group_id"] isEqualToString:[dictGroupSettings objectForKey:@"group_id"]])
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
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)Groupupdatefailed:(id)sender
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

- (IBAction)btnDoneClicked:(id)sender
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
    return [arrGroupUsers count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ChatUserCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ChatUserCustomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == [arrGroupUsers count])
    {
        cell.textLabel.text = @"Invite new members";
        cell.detailTextLabel.text = @"";
    }
    else
    {
        cell.textLabel.text=[[[arrGroupUsers objectAtIndex:indexPath.row] objectForKey:@"username"] removeNull];
        cell.detailTextLabel.text=([[[[arrGroupUsers objectAtIndex:indexPath.row] objectForKey:@"user_id"] removeNull] isEqualToString:[[dictGroupSettings objectForKey:@"group_admin_id"] removeNull]])?@"Admin":@"";

    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [arrGroupUsers count])
    {
        InviteToGroupViewCtr *obj=[[InviteToGroupViewCtr alloc]initWithNibName:@"InviteToGroupViewCtr" bundle:nil];
        obj.ArryInvitedUsers = [arrGroupUsers mutableCopy];
        obj.strgroup_remaining_count = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_remaining_count"] removeNull]];
        obj.strgroup_max_count = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"max_group_users"] removeNull]];
        obj.strGroup_Id = [NSString stringWithFormat:@"%@",[[dictGroupSettings objectForKey:@"group_id"]removeNull]];

        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj animated:NO completion:^{}];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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

- (void)viewDidUnload
{
    imgGroupProfile = nil;
    txtGroupName = nil;
    switchMute = nil;
    lblMemberCount = nil;
    imgbgMember = nil;
    tblMember = nil;
    btnLeaveGroup = nil;
    lblGroupCreationTime = nil;
    [super viewDidUnload];
}
@end
