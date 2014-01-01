//
//  LoginViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
#define FB_PERMISSIONS [NSArray arrayWithObjects:@"user_about_me",@"email",@"user_photos",nil]

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
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBarHidden=YES;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([UIScreen mainScreen].bounds.size.height == 568.0) {
        [imageBaceground setImage:[UIImage imageNamed:@"loginBG-5.png"]];
    }else{
    
        [imageBaceground setImage:[UIImage imageNamed:@"loginBG-4.png"]];
    }
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)btnLoginWithFbPressed:(id)sender{
   [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [PFFacebookUtils logInWithPermissions:FB_PERMISSIONS block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        } else if (user.isNew) {
            if (user) {
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // Store the current user's Facebook ID on the user
                        NSLog(@"%@",[result objectForKey:@"email"]);
                        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                                 forKey:@"fbId"];
                        [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                                 forKey:@"name"];
                        [[PFUser currentUser] saveInBackground];
                        [PFUser currentUser].username = [result objectForKey:@"name"];
                        [PFUser currentUser].email=[result objectForKey:@"email"];
                        [self configurePushNotificationSetting];
                        [self sendNotiFicationToNewJoinUserFriend];
                      
                        HomeViewController *objHomeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        objHomeViewController.title=@"Home";
                        [self.navigationController pushViewController:objHomeViewController animated:TRUE];
                    }
                }];
            }
            
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        } else {
            NSLog(@"User logged in through Facebook!");
            if (user) {
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // Store the current user's Facebook ID on the user
                        
                        NSDictionary *userData = (NSDictionary *)result;
                        
                        
                        NSString *name = userData[@"name"];
                         [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                                 forKey:@"fbId"];
                        [[PFUser currentUser] setObject:name
                                                 forKey:@"name"];
                        [[PFUser currentUser] saveInBackground];
                        [PFUser currentUser].email=[result objectForKey:@"email"];
                        NSLog(@"User signed up and logged in through Facebook!");
                        [self configurePushNotificationSetting];
                        HomeViewController *objHomeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        objHomeViewController.title=@"Home";
                        [self.navigationController pushViewController:objHomeViewController animated:TRUE];
                    }
                }];
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
            
            
        }
    }];
    
    
//    HomeViewController *objHomeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//    objHomeViewController.title=@"Home";
//    [self.navigationController pushViewController:objHomeViewController animated:TRUE];
}

-(void)configurePushNotificationSetting{
    // Save the current loged in user as owner for push notification
    // Push Notification setting for user
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:appDelegate.currentDeviceToken];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"user_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
    [currentInstallation setObject:[PFUser currentUser]  forKey:@"owner"];
    [currentInstallation saveInBackground];
    
  
}
-(IBAction)continueHerebtnPressed:(id)sender{

        HomeViewController *objHomeViewController=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
       objHomeViewController.title=@"Home";
       [self.navigationController pushViewController:objHomeViewController animated:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendNotiFicationToNewJoinUserFriend{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
          
            for (int i=0; i<[friendUsers count]; i++) {
                // Notification for owner of challenge
                
                // Find devices associated with these users
                PFUser *toSendUser=[friendUsers objectAtIndex:i];
                
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:toSendUser];
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                //[push setQuery:pushQuery]; // Set our Installation query
                [push setChannel:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
                
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%@ join Skyy app",[PFUser currentUser].username],
                                      @"alert",
                                      @"Increment", @"badge",
                                      @"default",@"sound",
                                      @"note",@"action",
                                      nil];
                [push setData:data];
                [push sendPushInBackground];
                
            }
            
        
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        }
        else{
            DisplayLocalizedAlert(@"You need to login to send a Note");
            [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        }
    }];
}
@end
