//
//  SettingsViewController.m
//  MyU
//
//  Created by Vijay on 7/19/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UIAlertViewDelegate>
{
    IBOutlet UISwitch *switchNotification;
    IBOutlet UISwitch *switchGroupUpdates;
    IBOutlet UISwitch *switchMessageUpdates;
    IBOutlet UILabel *lblConnected;
    IBOutlet UILabel *lblVersion;
    IBOutlet UIView *viewSettings;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [switchGroupUpdates setOn:(([[dictUserInfo objectForKey:@"group_notification"] integerValue])?YES:NO)];
    [switchMessageUpdates setOn:(([[dictUserInfo objectForKey:@"private_message_notification"] integerValue])?YES:NO)];
    [switchNotification setOn:(([[dictUserInfo objectForKey:@"general_notification"] integerValue])?YES:NO)];
    
    if (isAppInGuestMode)
    {
        [switchGroupUpdates setOn:NO];
        [switchMessageUpdates setOn:NO];
        [switchNotification setOn:NO];
        btn1.hidden=NO;
        btn2.hidden=NO;
        btn3.hidden=NO;
    }
    else
    {
        btn1.hidden=YES;
        btn2.hidden=YES;
        btn3.hidden=YES;
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


-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(checkConnectedToNetwork) withObject:nil afterDelay:0.1];
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)switchTouched:(id)sender
{
    if (isAppInGuestMode)
    {
        [switchGroupUpdates setOn:NO];
        [switchMessageUpdates setOn:NO];
        [switchNotification setOn:NO];
        [self alertIfGuestMode];
        return;
    }
}

-(IBAction)notificationChanged:(id)sender
{
    if (isAppInGuestMode)
    {
        [switchGroupUpdates setOn:NO];
        [switchMessageUpdates setOn:NO];
        [switchNotification setOn:NO];
        [self alertIfGuestMode];
        return;
        //        viewSettings.frame=CGRectMake(0,-118.0, 320.0, 282.0);
    }
    
    NSLog(@"The user Info:%@",dictUserInfo);
    //&=1&notifications=0&group_messages=0&private_messages=0
    
    NSString *strNotification=[NSString stringWithFormat:@"%d",(switchNotification.isOn)?1:0];
    NSString *strGroupUpdate=[NSString stringWithFormat:@"%d",(switchGroupUpdates.isOn)?1:0];
    NSString *strMessageUpdate=[NSString stringWithFormat:@"%d",(switchMessageUpdates.isOn)?1:0];
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"user_id",strNotification,@"notifications",strGroupUpdate,@"group_messages",strMessageUpdate,@"private_messages",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kUpdateSettingsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(settingsupdated:) withfailureHandler:@selector(settingsupdatefailed:) withCallBackObject:self];
    //[[MyAppManager sharedManager] showLoader];
    [obj startRequest];
}
-(void)settingsupdated:(id)sender
{
    //[[MyAppManager sharedManager] hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    NSLog(@"The Response is %@",dictResponse);
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSString *strNotification=[NSString stringWithFormat:@"%d",(switchNotification.isOn)?1:0];
        NSString *strGroupUpdate=[NSString stringWithFormat:@"%d",(switchGroupUpdates.isOn)?1:0];
        NSString *strMessageUpdate=[NSString stringWithFormat:@"%d",(switchMessageUpdates.isOn)?1:0];
        
        [dictUserInfo setObject:strNotification forKey:@"general_notification"];
        [dictUserInfo setObject:strGroupUpdate forKey:@"group_notification"];
        [dictUserInfo setObject:strMessageUpdate forKey:@"private_message_notification"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"user_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
-(void)settingsupdatefailed:(id)sender
{
    //[[MyAppManager sharedManager] hideLoader];

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}


-(void)checkConnectedToNetwork
{
    NSURLRequest *requestNetCheck = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:requestNetCheck returningResponse:nil error:nil];
    lblConnected.text=([returnData length]>0)?@"Connected":@"Not Connected";
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

@end
