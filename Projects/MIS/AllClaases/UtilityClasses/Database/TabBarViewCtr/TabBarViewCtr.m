//
//  TabBarViewCtr.m
//  MyMites
//
//  Created by openxcell technolabs on 7/10/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "TabBarViewCtr.h"
#import "GlobalClass.h"

@implementation TabBarViewCtr
@synthesize MainTabBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationMainTabBar
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
    
    appdel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    firstViewCtRl = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    createMeetingCtRl = [[CreateMeetingViewController alloc] initWithNibName:@"CreateMeetingViewController" bundle:nil];
    settingsViewCtRl = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    
    nav_1 = [[UINavigationController alloc] initWithRootViewController:firstViewCtRl];
    nav_2 = [[UINavigationController alloc] initWithRootViewController:createMeetingCtRl];
    nav_3 = [[UINavigationController alloc] initWithRootViewController:settingsViewCtRl];

    MainTabBar = [[UITabBarController alloc] init];
	MainTabBar.delegate = self;
	[MainTabBar setViewControllers:[NSArray arrayWithObjects:nav_1,nav_2,nav_3,nil]];
	MainTabBar.view.frame=self.view.frame;
    MainTabBar.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
       MainTabBar.tabBar.backgroundImage=[UIImage imageNamed:@"TabBarBG.png"];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabBarBG.png"]];
        [MainTabBar.tabBar insertSubview:imageView atIndex:0];
    }
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"librarySelected.png"]];
    [imageView1 setContentMode:UIViewContentModeScaleToFill];
    [imageView1 setFrame:CGRectMake(0, 0, 107,49)];
    [MainTabBar.tabBar insertSubview:imageView1 atIndex:1];
    
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addMeeting.png"]];
    [imageView2 setFrame:CGRectMake(108,0, 107 , 49)];
    [imageView2 setContentMode:UIViewContentModeScaleToFill];
    [MainTabBar.tabBar insertSubview:imageView2 atIndex:2];
    
    
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsBlack.png"]];
    [imageView3 setFrame:CGRectMake(216, 0, 107 ,49)];
    [imageView3 setContentMode:UIViewContentModeScaleToFill];
    [MainTabBar.tabBar insertSubview:imageView3 atIndex:3];
    
    MainTabBar.selectedIndex = 0;
    [imageView1 setImage:[UIImage imageNamed:@"librarySelected.png"]];
	[self.view addSubview:MainTabBar.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnFirstTab) name:PUSH_TO_0th_INDEX object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSecondTab) name:PUSH_TO_1st_INDEX object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableTabbar:) name:@"DISABLE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnableTabbar:) name:@"ENABLE" object:nil];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)disableTabbar:(id)sender{
      dispatch_async(dispatch_get_main_queue(), ^{
   
          for (UITabBarItem *iteam in MainTabBar.tabBar.items)
          {
              iteam.enabled=NO;
          }
          
          //  MainTabBar.tabBar.userInteractionEnabled= FALSE;
    });
}

-(void)EnableTabbar:(id)sender{
    
    for (UITabBarItem *iteam in MainTabBar.tabBar.items)
    {
        iteam.enabled=YES;
    }

    // MainTabBar.tabBar.userInteractionEnabled= TRUE;
}

-(void)btnFirstTab
{
    MainTabBar.selectedIndex = 0;
    [imageView1 setImage:[UIImage imageNamed:@"librarySelected.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"addMeeting.png"]];
    [imageView3 setImage:[UIImage imageNamed:@"settingsBlack.png"]];
    [self CallPopView];
}
-(void)btnSecondTab
{
   MainTabBar.selectedIndex = 1; 
    [imageView1 setImage:[UIImage imageNamed:@"libraryBlack.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"addmeetingsSelected.png"]];
    [imageView3 setImage:[UIImage imageNamed:@"settingsBlack.png"]];
    [self CallPopView];
}
-(void)CallPopView
{
    UINavigationController *navController=(UINavigationController*)[[MainTabBar viewControllers]objectAtIndex:0];
    if([navController.viewControllers count]>0)
    {
        [navController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - Tabbar delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    @synchronized(self){
    
    if(MainTabBar != viewController) {
     //   NSUInteger count=[[(UINavigationController*)viewController viewControllers] count];
        switch(MainTabBar.selectedIndex)
        {
            case 0:
                [imageView1 setImage:[UIImage imageNamed:@"librarySelected.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"addMeeting.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"settingsBlack.png"]];
                
               // [[NSNotificationCenter defaultCenter]postNotificationName:RELOAD_MEETING_TABLE_POST_NOTIFICATION object:nil];
                break;
                
            case 1:
                [imageView1 setImage:[UIImage imageNamed:@"libraryBlack.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"addmeetingsSelected.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"settingsBlack.png"]];
                break;
                
            case 2:
            {
                [imageView1 setImage:[UIImage imageNamed:@"libraryBlack.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"addMeeting.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"settingsSelected.png"]];
                break;
            }
            
        }
      //  [[[(UINavigationController*)viewController viewControllers]objectAtIndex:(count-1)] viewWillAppear:YES];
        
    }
        }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
