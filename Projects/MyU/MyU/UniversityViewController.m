//
//  UniversityViewController.m
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "UniversityViewController.h"
#import "WSManager.h"
#import "DBManager.h"
#import "NSString+Utilities.h"
#import "UIImageView+WebCache.h"
#import "MyAppManager.h"
#import "UniversityCell.h"
#import "CustomBadge.h"

@interface UniversityViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIButton *btnChat;
    NSMutableArray *arrUniversityNames;
    NSMutableString *strSubscribedUniList;
}
@end

@implementation UniversityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!isAppInGuestMode)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFromRightNavigationCnTlR:) name:FIRE_NOTI_FROM_RIGHT_SIDE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClosesearchFromRightNavigationCnTlR:) name:CLOSE_NOTI_FROM_RIGHT_SIDE object:nil];
    }
   
    arrUniversityNames=[[NSMutableArray alloc]init];
    strSubscribedUniList=[[NSMutableString alloc]initWithString:strSubscribedUni];
    
    [tblView reloadData];
    
    [self syncuniversities];
    
    NSLog(@"view did loadd...");

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

#pragma mark - WS METHODS
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
            [tblView reloadData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MyAppManager sharedManager] updatenotificationbadge];
    [[NSNotificationCenter defaultCenter] removeObserver:kNotifyUpdateNotificationBadge];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatenotificationbadge) name:kNotifyUpdateNotificationBadge object:nil];
    [self updatenotificationbadge];
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


-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disappered...");
    
    if (![strSubscribedUni isEqualToString:strSubscribedUniList])
    {
        [dictNews removeAllObjects];
        [arrNews removeAllObjects];
    }
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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)btnFriendsSectionClicked:(id)sender
{
    if (isAppInGuestMode) {
        [self alertIfGuestMode];
        return;
    }
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUniversityNames count];
}
//"id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
//"universityname" VARCHAR)
//"universityid" VARCHAR)
//abbreviation = " UM";
//address = USA;
//"uni_picture"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UniversityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UniversityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.lblUniName.text=[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"universityname"] removeNull];
    cell.lblUniAddress.text=[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"address"] removeNull];
    
    if ([[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"uni_picture"] removeNull] length]>0)
    {
        cell.imgUniPic.tag=107.0;
        [cell.imgUniPic setContentMode:UIViewContentModeCenter];

        [cell.imgUniPic setImageWithURL:[NSURL URLWithString:[[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"uni_picture"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_uni"]];
    }
    else
    {
        [cell.imgUniPic setImage:[UIImage imageNamed:@"default_uni"]];
        [cell.imgUniPic setContentMode:UIViewContentModeCenter];
    }   
    
    NSString *strUniId=[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"universityid"] removeNull];
    BOOL isSubscribed=([strSubscribedUni isEqualToString:strUniId])?YES:NO;
    
    cell.imgMainBG.image=[UIImage imageNamed:[NSString stringWithFormat:@"uni_%d_%@sel.png",(indexPath.row%2),(isSubscribed)?@"":@"un"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isAppInGuestMode) {
        NSString *strUniId=[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"universityid"] removeNull];
        [strSubscribedUni setString:strUniId];
        [tblView reloadData];
        
        [dictUserInfo removeAllObjects];
        [dictUserInfo addEntriesFromDictionary:[arrUniversityNames objectAtIndex:indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"uni_info"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        NSString *strUniId=[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"universityid"] removeNull];
        [strSubscribedUni setString:strUniId];
        [tblView reloadData];
        
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strSubscribedUni,@"uni_list", nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSubscribeUniURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
        [obj startRequest];
        
        [dictUserInfo setObject:[[[arrUniversityNames objectAtIndex:indexPath.row] objectForKey:@"abbreviation"] removeNull] forKey:@"uni_list_abbreviation"];
        [dictUserInfo setObject:strSubscribedUni forKey:@"uni_list"];
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"user_info"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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

@end
