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
    
    appdel=(FsenetAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    nextFirst = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    nextSecond = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    nextThird = [[HowItWorks alloc] initWithNibName:@"HowItWorks" bundle:nil];
    nextFourth = [[MoreView alloc] initWithNibName:@"MoreView" bundle:nil];
    
    
    nav_1 = [[UINavigationController alloc] initWithRootViewController:nextFirst];
    nav_2 = [[UINavigationController alloc] initWithRootViewController:nextSecond];
    nav_3 = [[UINavigationController alloc] initWithRootViewController:nextThird];
    nav_4 = [[UINavigationController alloc] initWithRootViewController:nextFourth];
    
    [nav_1 setNavigationBarHidden:YES];
    [nav_2 setNavigationBarHidden:YES];
    [nav_3 setNavigationBarHidden:YES];
    [nav_4 setNavigationBarHidden:YES];
    
    MainTabBar = [[UITabBarController alloc] init];
	MainTabBar.delegate = self;
	[MainTabBar setViewControllers:[NSArray arrayWithObjects:nav_1,nav_2,nav_3,nav_4,nil]];
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
    
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchiconselected.png"]];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFit];
    [imageView1 setFrame:CGRectMake(19, -10, 47 , 52)];
    [MainTabBar.tabBar insertSubview:imageView1 atIndex:1];
    
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myprofileicon.png"]];
    [imageView2 setFrame:CGRectMake(98,-10, 52 , 52)];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    [MainTabBar.tabBar insertSubview:imageView2 atIndex:2];
    
    
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mysearchicon.png"]];
    [imageView3 setFrame:CGRectMake(170, -10, 65 , 52)];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFit];
    [MainTabBar.tabBar insertSubview:imageView3 atIndex:3];
    
    
    imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moreicon.png"]];
    [imageView4 setFrame:CGRectMake(260, -10, 46 , 52)];
    [imageView4 setContentMode:UIViewContentModeScaleAspectFit];
    [MainTabBar.tabBar insertSubview:imageView4 atIndex:4];
    
    
    MainTabBar.selectedIndex = 0;
    [imageView1 setImage:[UIImage imageNamed:@"searchiconselected.png"]];
	[self.view addSubview:MainTabBar.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnFirstTab) name:@"pushIt0" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSecondTab) name:@"pushIt1" object:nil];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)btnFirstTab
{
    MainTabBar.selectedIndex = 0;
    [imageView1 setImage:[UIImage imageNamed:@"searchiconselected.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"myprofileicon.png"]];
    [imageView3 setImage:[UIImage imageNamed:@"mysearchicon.png"]];
    [imageView4 setImage:[UIImage imageNamed:@"moreicon.png"]];
    [self CallPopView];
}
-(void)btnSecondTab
{
   MainTabBar.selectedIndex = 1; 
    [imageView2 setImage:[UIImage imageNamed:@"myprofileiconselected.png"]];
    [imageView1 setImage:[UIImage imageNamed:@"searchicon.png"]];
    [imageView3 setImage:[UIImage imageNamed:@"mysearchicon.png"]];
    [imageView4 setImage:[UIImage imageNamed:@"moreicon.png"]];
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
    
    if(MainTabBar != viewController) {
     //   NSUInteger count=[[(UINavigationController*)viewController viewControllers] count];
        switch(MainTabBar.selectedIndex)
        {
            case 0:
                [imageView1 setImage:[UIImage imageNamed:@"searchiconselected.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"myprofileicon.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"mysearchicon.png"]];
                [imageView4 setImage:[UIImage imageNamed:@"moreicon.png"]];
                break;
                
            case 1:
                [imageView2 setImage:[UIImage imageNamed:@"myprofileiconselected.png"]];
                [imageView1 setImage:[UIImage imageNamed:@"searchicon.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"mysearchicon.png"]];
                [imageView4 setImage:[UIImage imageNamed:@"moreicon.png"]];
                break;
                
            case 2:
            {
                UINavigationController *navController=(UINavigationController*)[[tabBarController viewControllers]objectAtIndex:2];
                if([navController.viewControllers count]>0)
                {
                    [navController popToRootViewControllerAnimated:YES];
                }
                [imageView3 setImage:[UIImage imageNamed:@"mysearchiconselected.png"]];
                [imageView1 setImage:[UIImage imageNamed:@"searchicon.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"myprofileicon.png"]];
                [imageView4 setImage:[UIImage imageNamed:@"moreicon.png"]];
                break;
            }
            case 3:
                [imageView4 setImage:[UIImage imageNamed:@"moreiconselected.png"]];
                [imageView1 setImage:[UIImage imageNamed:@"searchicon.png"]];
                [imageView2 setImage:[UIImage imageNamed:@"myprofileicon.png"]];
                [imageView3 setImage:[UIImage imageNamed:@"mysearchicon.png"]];
                break;
        }
      //  [[[(UINavigationController*)viewController viewControllers]objectAtIndex:(count-1)] viewWillAppear:YES];
        
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
