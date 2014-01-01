//
//  AppDelegate.m
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.


#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "TimeLineViewController.h"
#import "CommentViewController.h"
#import "ProfileViewController.h"
#import "ChallengeDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ChangeUserNameViewController.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize dataDeviceToken,isTimeline,arrCurrentUserChallegesData,arrUserLikeChallenge;
@synthesize mutArryChallengeStepsData;
@synthesize mutArryChallengeImageData;
@synthesize isLaunchFromPushNotification;
@synthesize mutDictStepsText,richLabelHeight,arrUserFirstChallenge,controllerName;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSDictionary *tmpDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    //if tmpDic is not nil, then your app is launched due to an APNs push, therefore check this NSDictionary for further information
    if (tmpDic != nil) {
        self.isLaunchFromPushNotification = YES;
    }else{
        self.isLaunchFromPushNotification = NO;
    }

    //keep all the index where user add text in the steps creating in order to create challenge
    mutDictStepsText = [[NSMutableDictionary alloc]init];

    
    // Keep default social sharing setting on
    
    [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"twitterShare"];
    [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"facebookShare"];
    [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"contactShare"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // Register for push notifications
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    // challenge steps array for prevent to disappear when user come back (popview)
    mutArryChallengeStepsData  = [[NSMutableArray alloc]init];
    mutArryChallengeImageData  = [[NSMutableArray alloc]init];
    self.arrUserFirstChallenge = [[NSMutableArray alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    self.window.rootViewController = self.navigationController;
    //Navigation Setting
    self.navigationController.navigationBar.translucent = YES;
    
    UINavigationBar* navigationBar = self.navigationController.navigationBar;
    navigationBar.opaque = NO;
    [navigationBar setBarTintColor:[UIColor redColor]];
    
    const CGFloat statusBarHeight = 20;    //  Make this dynamic in your own code...
    
    UIView* underlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, navigationBar.frame.size.width, navigationBar.frame.size.height + statusBarHeight)];
    [underlayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [underlayView setBackgroundColor:[UIColor colorWithRed:255.0f green:0.0f blue:3.0f alpha:1.0f]];
    [underlayView setAlpha:0.6f];
    underlayView.opaque = NO;
    [navigationBar insertSubview:underlayView atIndex:1];
    [navigationBar sendSubviewToBack:underlayView];
    
    
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"DynoBold" size:21] forKey:UITextAttributeFont];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 30, 30)];
    [btnBack setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack ];//]:[UIImage imageNamed:@"headerHome"] style:UIButtonTypeCustom target:self action:@selector(btnHomePressed:)];
    self.navigationController.navigationItem.backBarButtonItem = leftButton;
    
    //********************Rechability*********************//
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // tell the reachability that we DONT want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = NO;
    
    // here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    //********************Connecton with parse database***********************//
    
    //Application keys for live application
    
    
    [Parse setApplicationId:@"jEEmn9WZDBZW7NknC004gjYtuoNtDfwMi85laGl5" clientKey:@"HiraM29g5HWmzaSWPoLOuAk4b9fQPoqii90kcsMI"];
    
    // Make sure this is commented for live application. Test database use only for testing 
    //[Parse setApplicationId:@"tfFLFH6Yn5Y1f2nLkh9xdXlZrSnSiNUr7hHQxuut" clientKey:@"fH7uabN1OG6KXuOsW8g0ObQmUKOfeHYproDEzZ0s"];
    
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET_KEY];
    
    //For UserDefault for Direct Login :
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    bool isLogin = [userdefault valueForKey:@"isLogin"];
   
    if([[PFUser currentUser] isDataAvailable] &&isLogin){
            if([PFUser currentUser] != nil){
           
            }
        
        TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        [self.navigationController pushViewController:timelineViewConroller animated:NO];
    }else{
        
    }
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    [self.window makeKeyAndVisible];
    

    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
    
}

#pragma mark PushNotification Methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Keep the device token data for sending to parse when user login
    self.dataDeviceToken = deviceToken;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // Push the controller where user get the comment
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    bool isLogin= [userdefault valueForKey:@"isLogin"];
    
    if([[PFUser currentUser] isDataAvailable] && isLogin){
        if([[userInfo objectForKey:@"action"] isEqualToString:@"like"]){
            self.isLaunchFromPushNotification = YES;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
            [postQuery includeKey:@"userId"];
            [postQuery whereKey:@"objectId" equalTo:[userInfo objectForKey:@"challengeId"]];
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray *arrChallenge, NSError *error){
                
                if(!error){
                    // Getting the challenge information for sending user on comment view
                    if([arrChallenge count] > 0){
                        PFObject *objChallengeInfo = [arrChallenge objectAtIndex:0];
                        // Need to work here
                        
                        ChallengeDetailViewController *challengeDetailVC = [[ChallengeDetailViewController alloc]initWithNibName:@"ChallengeDetailViewController" bundle:nil];
                        challengeDetailVC.objChallengeInfo = objChallengeInfo;
                        [self.navigationController pushViewController:challengeDetailVC animated:YES];
                        
                    }else{
                        DisplayAlertWithTitle(@"FitTag", @"We are unable to get challenge information.We are sending you on Timeline view please check your challenge updates")
                    }
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"We are unable to get challenge information.We are sending you on Timeline view please check your challenge updates")
                }
            }];
            
        }else if([[userInfo objectForKey:@"action"] isEqualToString:@"comment"] || [[userInfo objectForKey:@"action"] isEqualToString:@"mention"]){
            self.isLaunchFromPushNotification = YES;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            CommentViewController *commentVC = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
            commentVC.challengeId = [userInfo objectForKey:@"challengeId"];
            
            PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
            [postQuery includeKey:@"userId"];
            [postQuery whereKey:@"objectId" equalTo:[userInfo objectForKey:@"challengeId"]];
            [postQuery findObjectsInBackgroundWithBlock:^(NSArray *arrChallenge, NSError *error){
                
                if(!error){
                    // Getting the challenge information for sending user on comment view
                    if([arrChallenge count] > 0){
                        PFObject *objChallengeInfo = [arrChallenge objectAtIndex:0];
                        commentVC.challengeId       = [objChallengeInfo objectId];
                        commentVC.ChallengeOwner    = [objChallengeInfo objectForKey:@"userId"];
                        commentVC.strChaleengeName  = [objChallengeInfo objectForKey:@"challengeName"];
                        [self.navigationController pushViewController:commentVC animated:YES];
                    }else{
                        DisplayAlertWithTitle(@"FitTag", @"We are unable to get challenge information.We are sending you on Timeline view please check your challenge updates")
                    }
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"We are unable to get challenge information.We are sending you on Timeline view please check your challenge updates")
                }
            }];
            
        }else if([[userInfo objectForKey:@"action"] isEqualToString:@"follow"]){
            self.isLaunchFromPushNotification = YES;
            [self.navigationController popToRootViewControllerAnimated:NO];
            ProfileViewController *profileVC = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profileVC.profileUser = [PFQuery getUserObjectWithId:[userInfo objectForKey:@"followingUserId"]];
            
            if(profileVC.profileUser != nil){
                
                [self.navigationController pushViewController:profileVC animated:YES];
                
            }else{
                DisplayAlertWithTitle(@"FitTag", @"We are unable to get your following user details.We are sending you on Timeline view please check your following.")
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
    }
}

#pragma mark Twitter login Method

-(void)LoginTwitterUser{
    
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error){
        if(user){
            //Save the Flag in UserDefault for Direct Login
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:@"1" forKey:@"isLogin"];
            [userdefault synchronize];
            [self configurePushNotificationSetting];
            if(user.isNew){
                [self getAllUserName];
                
                __block NSMutableDictionary *twitterUserDict = [[NSMutableDictionary alloc] init];
                NSString *strRequestUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@&user_id=%@&include_entities=false",[PFTwitterUtils twitter].screenName,[[PFTwitterUtils twitter] userId]];
                NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strRequestUrl]];
                [[PFTwitterUtils twitter] signRequest:postRequest];
                [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error)
                 {
                     if (!error){
                         NSError *error1;
                         twitterUserDict = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:&error1];
                         
                         //===================
                         
                         
                         [PFUser currentUser].username = [[PFTwitterUtils twitter].screenName lowercaseString];
                         [[PFUser currentUser]saveEventually];
                         
                         NSData *imgData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[twitterUserDict objectForKey:@"profile_image_url"]]];
                         
                         // Uplaod the image on server
                         
                         PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imgData];
                         
                         // Save PFFile
                         
                         [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                             
                             if (!error){
                                 
                                 PFUser *user = [PFUser currentUser];
                                 
                                 [user setObject:imageFile forKey:@"userPhoto"];
                                 
                                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     
                                     if (!error) {
                                         
                                         [MBProgressHUD hideHUDForView:self.window animated:YES];
                                     }
                                     else{
                                         [MBProgressHUD hideHUDForView:self.window animated:YES];
                                         
                                         DisplayAlertWithTitle(@"Fitage",@"There is some problem occure. please try again")
                                     }
                                 }];
                             }
                         }];
                     }
                 }];
            }else{
                
                [MBProgressHUD hideHUDForView:self.window animated:YES];
                TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
                [self.navigationController pushViewController:timelineViewConroller animated:YES];
            }
            
        }
        else{
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            // Error occure while login fro Twitter
        }
    }];
}
-(void)getAllUserName{
    PFQuery * query=[PFUser query];
    [query whereKey:@"username" equalTo:[[PFTwitterUtils twitter].screenName lowercaseString]];
    
    NSArray *objects=[[NSArray alloc]initWithArray:[query findObjects]];
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    if ([objects count]>0) {
        ChangeUserNameViewController *obj=[[ChangeUserNameViewController alloc]initWithNibName:@"ChangeUserNameViewController" bundle:nil];
        obj.delegate=self;
        [self.navigationController presentPopupViewController:obj animationType:MJPopupViewAnimationSlideBottomBottom];
    }
    else{
        

        
        TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        
        [self.navigationController pushViewController:timelineViewConroller animated:YES];
    }
    
}
-(void)userName :(NSString *)strUserName{
    
    PFQuery * query=[PFUser query];
    [query whereKey:@"username" equalTo:strUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]==0) {
            PFUser *user=[PFUser currentUser];
            [user setObject:strUserName forKey:@"username"];
            [user save];
            
            
            TimeLineViewController *timelineViewConroller=[[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            [self.navigationController pushViewController:timelineViewConroller animated:YES];
            [self.navigationController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        }
        else{
            
            DisplayLocalizedAlert(@"This username is already taken");
        }
        
    }];
    
    
    
}
#pragma mark Remove NULL

-(NSString *)removeNull:(NSString *)str{
    
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str){
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

#pragma mark Push notification setting

-(void)configurePushNotificationSetting{
    // Save the current loged in user as owner for push notification
    // Push Notification setting for user
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:self.dataDeviceToken];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"user_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
    [currentInstallation setObject:[PFUser currentUser]  forKey:@"owner"];
    [currentInstallation saveInBackground];
    
    // Save default user setting in user table
    [[PFUser currentUser] setObject:@"YES" forKey:@"likeNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"mentionNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"commentNotification"];
    [[PFUser currentUser] setObject:@"YES" forKey:@"followNotification"];
    [[PFUser currentUser] saveInBackground];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachableViaWWAN] || [reach isReachableViaWiFi] || [reach isReachable])
    {
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"FitTag" message:@"please check internet connection." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
        [alert show];
    }
}
@end
