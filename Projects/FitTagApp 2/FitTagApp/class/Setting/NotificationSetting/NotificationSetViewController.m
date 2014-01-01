//
//  NotificationSetViewController.m
//  FitTag
//
//  Created by apple on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NotificationSetViewController.h"

@implementation NotificationSetViewController
@synthesize switchLike;
@synthesize switchMention;
@synthesize switchComment;
@synthesize switchFollow;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting tags for switches
//    for(UIView* view in self.navigationController.navigationBar.subviews)
//    {
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            [view removeFromSuperview];
//        }
//        
//    }
//    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setBackgroundColor:[UIColor blackColor]];
//    
//    UILabel * nav_title = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 25)];
//    nav_title.font = [UIFont fontWithName:@"DynoBold" size:21];
//    nav_title.textColor = [UIColor whiteColor];
//    nav_title.textAlignment=UITextAlignmentCenter;
//    nav_title.adjustsFontSizeToFitWidth = YES;
//    nav_title.text = @"Notification Setting";
//    self.title = @"";
//    nav_title.backgroundColor = [UIColor clearColor];
//    [bar addSubview:nav_title];
    
    lbl1.font = [UIFont fontWithName:@"DynoBold" size:15];
    lbl2.font = [UIFont fontWithName:@"DynoBold" size:15];
    lbl3.font = [UIFont fontWithName:@"DynoBold" size:15];
    lbl4.font = [UIFont fontWithName:@"DynoBold" size:15];
        lbl5.font = [UIFont fontWithName:@"DynoBold" size:12];
    switchLike.tag      = 1;
    switchMention.tag   = 2;
    switchComment.tag   = 3;
    switchFollow.tag    = 4;
    
    if([[[PFUser currentUser] objectForKey:@"likeNotification"] isEqualToString:@"YES"]){
        switchLike.on = YES;
    }else{
        switchLike.on = NO;
    }
    
    if([[[PFUser currentUser] objectForKey:@"mentionNotification"] isEqualToString:@"YES"]){
        switchMention.on = YES;
    }else{
        switchMention.on = NO;
    }
    
    if([[[PFUser currentUser] objectForKey:@"commentNotification"] isEqualToString:@"YES"]){
        switchComment.on = YES;
    }else{
        switchComment.on = NO;
    }
    
    if([[[PFUser currentUser] objectForKey:@"followNotification"] isEqualToString:@"YES"]){
        switchFollow.on = YES;
    }else{
        switchFollow.on = NO;
    }
    
    //navigation back Button- Arrow
    
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
}

-(void)viewDidUnload{
    [self setSwitchLike:nil];
    [self setSwitchMention:nil];
    [self setSwitchComment:nil];
    [self setSwitchFollow:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-button Actions

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Notification setting

-(IBAction)chamgePushNotificationSetting:(id )sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UISwitch *switchNotification = (UISwitch *)sender;
    
    NSString *strOnOff;
    
    if(switchNotification.isOn)
        strOnOff = @"YES";
    else
        strOnOff = @"NO";
    
    switch (switchNotification.tag){
        case 1:
            [self changeNotificarionSettingOnOff:strOnOff fieldName:@"likeNotification"];
            break;
        case 2:
            [self changeNotificarionSettingOnOff:strOnOff fieldName:@"mentionNotification"];
            break;
        case 3:
            [self changeNotificarionSettingOnOff:strOnOff fieldName:@"commentNotification"];
            break;
        case 4:
            [self changeNotificarionSettingOnOff:strOnOff fieldName:@"followNotification"];
            break;
        default:
            break;
    }
}

-(void)changeNotificarionSettingOnOff:(NSString *)strswitchValue fieldName:(NSString *)strFieldName{
    
    [[PFUser currentUser] setObject:strswitchValue forKey:strFieldName];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL done,NSError *error){
        if(!error){
        }else{
        }
    }];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
