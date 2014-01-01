//
//  AddNewGroupViewController.m
//  MyU
//
//  Created by Vijay on 7/19/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "AddNewGroupViewController.h"
#import "InvitePeopleCustomCell.h"
#import "ALPickerView.h"
#import "GRAlertView.h"

@interface AddNewGroupViewController () <ALPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UITextField *txtGroupName;
    IBOutlet UITextField *txtUniversity;
    IBOutlet UITextField *txtPeople;
    ALPickerView *pickerView;
    NSMutableArray *arrUniversityNames;
    NSInteger selecteduni;
    IBOutlet UILabel *lblFriendsCount;
    IBOutlet UIImageView *imgBG;
    IBOutlet UIActivityIndicatorView *actIndicator;
    NSMutableArray *arrUsersLocal;
    NSMutableArray *arrUsersSelected;
}

@end

@implementation AddNewGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selecteduni=-1;
    arrUniversityNames=[[NSMutableArray alloc]init];
    [self syncuniversities];
    arrUsersLocal=[[NSMutableArray alloc]init];
    arrUsersSelected=[[NSMutableArray alloc]init];
    if ([arrAppUsers count]==0)
    {
        [self loaduserslist];
    }
    else
    {
        [arrUsersLocal addObjectsFromArray:arrAppUsers];
        [self hideLoader];
    }
    
    if ([arrAppUsers count]==0) {
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people"];
    }
    else{
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people (%d/%d)",[arrUsersSelected count],group_maxinvite];
    }
    
    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,460+iPhone5ExHeight+iOS7, 320.0, 216.0)];
    [self.view addSubview:pickerView];
    pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    pickerView.delegate=self;
    if ([arrUniversityNames count]>0) {
        [pickerView reloadAllComponents];
    }
    [imgBG setImage:[[UIImage imageNamed:@"bg_addgroup.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(200.0, 0.0, 50.0, 0.0) resizingMode:UIImageResizingModeTile]];
}
-(void)showLoader
{
    [actIndicator startAnimating];
}
-(void)hideLoader
{
    [actIndicator stopAnimating];
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
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrAppUsers removeAllObjects];
        [arrAppUsers addObjectsFromArray:[dictResponse objectForKey:@"user_info"]];
        [arrUsersLocal addObjectsFromArray:[dictResponse objectForKey:@"user_info"]];
        
        group_maxinvite=[[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"group_count"]] integerValue];
        
        [tblView reloadData];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if (theTouch.view==self.view) {
        [self hidePicker];
        [txtPeople resignFirstResponder];        
    }
}
-(IBAction)btnUniversityClicked:(id)sender
{
    if ([arrUniversityNames count]>0)
    {
        [txtGroupName resignFirstResponder];
        [txtPeople resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
        [UIView commitAnimations];
    }
    else
    {
        kGRAlert(kUniversityNotLoadedAlert);
    }
}

#pragma mark - UNIVERSITY METHODS
-(void)syncuniversities
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObject:@"" forKey:@"lastsyncedtimestamp"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLoadUniversityURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(universitysynced:) withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)universitysynced:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([dictResponse objectForKey:@"university_list"])
        {
            [arrUniversityNames removeAllObjects];
            [arrUniversityNames addObjectsFromArray:[dictResponse objectForKey:@"university_list"]];
            [pickerView reloadAllComponents];
        }
    }
}

-(IBAction)btnDoneClicked:(id)sender
{
    if ([[txtGroupName.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter group name.");
    }
    else if ([[txtUniversity.text removeNull] length]==0)
    {
        kGRAlert(@"Please enter select university.");
    }
    else
    {
        NSString *strInviteIds=[arrUsersSelected componentsJoinedByString:@","];
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",[txtGroupName.text removeNull],@"group_name",[[[arrUniversityNames objectAtIndex:selecteduni] objectForKey:@"universityid"] removeNull],@"uni_id",strInviteIds,@"userid_list",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kAddGroupURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(groupcreated:) withfailureHandler:@selector(groupcreatefailed:) withCallBackObject:self];
        [[MyAppManager sharedManager]showLoader];
        [obj startRequest];
    }
}
-(void)groupcreated:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        /* Create Group in XMPP using roster and conference */
            
        /*************************************************/
        
        [[dictGroups objectForKey:@"joined"] addObject:[[dictResponse objectForKey:@"group_info"] objectAtIndex:0]];
        NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        NSMutableArray *arrSorted=[[NSMutableArray   alloc]initWithArray:[[dictGroups objectForKey:@"joined"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:ascendingSort]]];
        [dictGroups setObject:arrSorted forKey:@"joined"];

        NSLog(@"%@",[[[dictResponse objectForKey:@"group_info"] objectAtIndex:0] valueForKey:@"group_id"]);
        [self createGroup:[[[dictResponse objectForKey:@"group_info"] objectAtIndex:0] valueForKey:@"group_id"]];
        
        
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
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)groupcreatefailed:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
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
    return [arrUsersLocal count];
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
    
    cell.imgMainBG.image=[UIImage imageNamed:[NSString stringWithFormat:@"cellbgaddgroup_%d.png",((indexPath.row%2==0)?0:1)]];
    cell.lblName.text=[[arrUsersLocal objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.btnInvite.tag=indexPath.row;
    [cell.btnInvite addTarget:self action:@selector(btnInviteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strUserInviteId=[NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:indexPath.row]  objectForKey:@"id"]];
    [cell.btnInvite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btninvite%@.png",([arrUsersSelected containsObject:strUserInviteId])?@"db":@""]] forState:UIControlStateNormal];
    
    return cell;
}
-(void)btnInviteClicked:(id)sender
{
    NSString *strUserInviteId=[NSString stringWithFormat:@"%@",[[arrUsersLocal objectAtIndex:[(UIButton *)sender tag]]  objectForKey:@"id"]];
    if(![arrUsersSelected containsObject:strUserInviteId])
    {
        if (group_maxinvite>[arrUsersSelected count]) {
            [arrUsersSelected addObject:strUserInviteId];
        }
        else if(group_maxinvite==0)
        {
            
        }
        else
        {
            NSString *strMSG=[NSString stringWithFormat:@"You can invite maximum %d users.",group_maxinvite];
            kGRAlert(strMSG);
        }
    }
    else
    {
        [arrUsersSelected removeObject:strUserInviteId];
    }
    
    InvitePeopleCustomCell *cell=(InvitePeopleCustomCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(UIButton *)sender tag] inSection:0]];
    [cell.btnInvite setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btninvite%@.png",([arrUsersSelected containsObject:strUserInviteId])?@"db":@""]] forState:UIControlStateNormal];
    
    if ([arrAppUsers count]==0) {
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people"];
    }
    else{
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people (%d/%d)",[arrUsersSelected count],group_maxinvite];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)searchUsersLocally
{
    [arrUsersLocal removeAllObjects];
    
    if ([[txtPeople.text removeNull] length]==0)
    {
        [arrUsersLocal addObjectsFromArray:arrAppUsers];
        [tblView reloadData];
        return;
    }
    
    for (int i=0; i<[arrAppUsers count]; i++)
    {
        NSRange range =[[NSString stringWithFormat:@"%@",[[arrAppUsers objectAtIndex:i] objectForKey:@"name"]] rangeOfString:[txtPeople.text removeNull] options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arrUsersLocal addObject:[arrAppUsers objectAtIndex:i]];
        }
    }
    
    if ([arrAppUsers count]==0) {
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people"];
    }
    else{
        lblFriendsCount.text=[NSString stringWithFormat:@"Invite people (%d/%d)",[arrUsersSelected count],group_maxinvite];
    }
    
    [tblView reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(searchUsersLocally) withObject:nil afterDelay:0.0];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    tblView.frame=CGRectMake(11.0,173.0+iOS7,299.0,71.0+iPhone5ExHeight);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    tblView.frame=CGRectMake(11.0,173.0+iOS7,299.0,229.0+iPhone5ExHeight);
    [UIView commitAnimations];
}
#pragma mark - PICKERVIEW
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
	return [arrUniversityNames count];
}
- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
	return [[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
	return ((row==selecteduni)?YES:NO);
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
- (void)pickerView:(ALPickerView *)pickerViews didCheckRow:(NSInteger)row
{
    selecteduni=row;
    txtUniversity.text=[[[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"] removeNull];
    [self hidePicker];
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{

}
-(void)hidePicker
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
    [UIView commitAnimations];
}
//ttps://itunes.apple.com/in/app/usb-disk/id370531520?mt=8
#pragma mark - DEFAULT
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

#pragma mark xmpp GroupChat 
/*Here we will create a group and Join it's users into it*/
- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)createGroup:(NSString*)groupName{
    xmppRoomStorage = [XMPPRoomHybridStorage sharedInstance];
    groupName = [groupName stringByAppendingFormat:@"%@",GROUP_CHAT_DOMAIN];
    XMPPJID *roomRealJid = [XMPPJID jidWithString:groupName];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomRealJid dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    [xmppRoom activate: [[self appDelegate] xmppStream]];
    [xmppRoom fetchConfigurationForm];
    [xmppRoom addDelegate:[self appDelegate] delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:strUserId history:nil password:@"iphone1"];
    [self performSelector:@selector(ConfigureNewRoom:) withObject:xmppRoom afterDelay:3];
}

- (void)ConfigureNewRoom:(XMPPRoom *)room{
    [room configureRoomUsingOptions:nil];
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"Join");
}

@end
