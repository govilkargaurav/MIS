//
//  LeftSideViewController.m
//  MyU
//
//  Created by Vijay on 7/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "LeftSideViewController.h"
#import "SideMenuCell.h"

#import "RightSideViewController.h"
#import "HomeViewController.h"
#import "UniversityViewController.h"
#import "NewsViewController.h"
#import "GroupViewController.h"
#import "RatingsViewController.h"
#import "TellAFriendViewController.h"
#import "AboutUsViewController.h"
#import "TermsViewController.h"
#import "SettingsViewController.h"
#import "PrivacyPolicyViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+Utilities.h"
#import "WSManager.h"
#import "MyAppManager.h"

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)updateProfilePicLeftSide
{
    
    [imgProfilePic setImage:Nil];
    [imgProfilePic setImageWithURL:[NSURL URLWithString:[strUserProfilePic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProfilePicLeftSide) name:@"updateProfilePicLeftSide" object:Nil];
    tblView.backgroundColor=kSIDEBARCOLOR;
    viewHeader.backgroundColor=kSIDEBARCOLOR;
    self.view.backgroundColor = kSIDEBARCOLOR;
    
    imgProfilePic.layer.borderColor=[UIColor whiteColor].CGColor;
    imgProfilePic.layer.borderWidth=2.0;
    imgProfilePic.layer.cornerRadius=3.0;
    imgProfilePic.opaque=YES;
    imgProfilePic.clipsToBounds=YES;
    
    selectedIndex=0;
    
    arrIcons=[[NSArray alloc]initWithObjects:@"icn_home.png",@"icn_uni.png",@"icn_news.png",@"icn_groups.png",@"icn_rating.png",@"icn_tellfriend.png",@"icn_about.png",@"icn_terms.png",@"icn_privacy.png",@"icn_settings.png",@"icn_logout.png",nil];
    arrSections=[[NSArray alloc]initWithObjects:@"Home",@"University",@"News",@"Groups",@"Ratings",@"Tell a friend",@"About us",@"Terms",@"Privacy policy",@"Settings",@"Logout",nil];
    [self refreshtableview];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshtableview];
}

-(void)refreshtableview
{
    /*
     "user_info" =     {
     bio = "";
     birthday = "05-08-2013";
     "can_add_news" = 0;
     department = "";
     email = "vijay@openxcell.info";
     faculty = no;
     gender = Male;
     "graduation_year" = "";
     id = 76;
     major = "";
     name = "Vijay Hirpara";
     "phone_number" = "";
     "profile_picture" = "http://www.openxcellaus.info/myu/admin/files/38d3c3aa3809ad04f510ff8b3bfd933f.png";
     thumbnail = "";
     "university_email" = "";
     "university_name" = "California University";
     username = vijayhirpara;
     };
     */

    if (!isAppInGuestMode) {
        [imgProfilePic setImageWithURL:[NSURL URLWithString:[strUserProfilePic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];
        lblName.text=[[dictUserInfo objectForKey:@"name"] removeNull];
        lblSchool.text=[[dictUserInfo objectForKey:@"universityname"] removeNull];
        lblSubject.text=[[dictUserInfo objectForKey:@"department"] removeNull];
    }
    else
    {
        imgProfilePic.backgroundColor=[UIColor lightTextColor];
        [imgProfilePic setImage:[UIImage imageNamed:@"default_user"]];
        lblName.text=@"Guest";
        lblSubject.text=@"";
        lblSchool.text=[[dictUserInfo objectForKey:@"universityname"] removeNull];
    }
    
    
    [tblView reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[SideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.imgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrIcons objectAtIndex:indexPath.row]]];
    cell.lblView.text=[arrSections objectAtIndex:indexPath.row];
    
    cell.isSelectedBG=(indexPath.row==selectedMenuIndex)?YES:NO;
    viewHeader.backgroundColor=(selectedMenuIndex==-1)?kSIDEBAR_HCOLOR:kSIDEBARCOLOR;
    
    if (isAppInGuestMode) {
        cell.lblUni.text=(indexPath.row==University)?[[dictUserInfo objectForKey:@"abbreviation"] removeNull]:@"";
    }
    else{
        cell.lblUni.text=(indexPath.row==University)?[[dictUserInfo objectForKey:@"uni_list_abbreviation"] removeNull]:@"";
    }
    
    switch (indexPath.row)
    {
        case Home:
        {
            cell.theCellType=CellType_Header;
        }
            break;
            
        case Ratings:
        case PrivacyPolicy:
        case SignOut:
        {
            cell.theCellType=CellType_Footer;
        }
            break;
            
        default:
        {
            cell.theCellType=CellType_Middle;
        }
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case Home:
        {
            return 46.0;
        }
            break;
            
        case Ratings:
        case PrivacyPolicy:
        case SignOut:
        {
            return 45.0;
        }
            break;
            
        default:
        {
            return 41.0;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedMenuIndex=indexPath.row;
    selectedIndex=indexPath.row;
    [tblView reloadData];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    switch (indexPath.row)
    {
        case Home:
        {
            HomeViewController *obj = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
        break;
            
        case University:
        {
            UniversityViewController *obj = [[UniversityViewController alloc] initWithNibName:@"UniversityViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case News:
        {
            NewsViewController *obj = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case Groups:
        {
            GroupViewController *obj = [[GroupViewController alloc] initWithNibName:@"GroupViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case Ratings:
        {
            RatingsViewController *obj = [[RatingsViewController alloc] initWithNibName:@"RatingsViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case TellAFriend:
        {
            TellAFriendViewController *obj = [[TellAFriendViewController alloc] initWithNibName:@"TellAFriendViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case AboutUs:
        {
            AboutUsViewController *obj = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case Terms:
        {
            TermsViewController *obj = [[TermsViewController alloc] initWithNibName:@"TermsViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case PrivacyPolicy:
        {
            PrivacyPolicyViewController *obj = [[PrivacyPolicyViewController alloc] initWithNibName:@"PrivacyPolicyViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case Settings:
        {
            SettingsViewController *obj = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
            nav.navigationBar.hidden=YES;
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        }
            break;
            
        case SignOut:
        {
            [self logout];
        }
            break;
    }
}


-(void)logout
{
    if (isAppInGuestMode)
    {
        [self clearalldata];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"userid",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kSignOutURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(logoutsuccessfully:) withfailureHandler:@selector(logoutfailed:) withCallBackObject:self];
        [obj startRequest];
        [[MyAppManager sharedManager]showLoader];
    }
}
-(void)logoutsuccessfully:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response:%@",dictResponse);
    [self clearalldata];
    
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)clearalldata
{
    [[MyAppManager sharedManager] signOutFromApp];
}

-(void)logoutfailed:(id)sender
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

-(IBAction)btnProfileClicked:(id)sender
{
    selectedMenuIndex=-1;
    [tblView reloadData];
    ProfileViewController *obj = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    obj.isProfileViewMine=YES;
    obj.strTheUserId=[NSString stringWithString:strUserId];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
    nav.navigationBar.hidden=YES;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
