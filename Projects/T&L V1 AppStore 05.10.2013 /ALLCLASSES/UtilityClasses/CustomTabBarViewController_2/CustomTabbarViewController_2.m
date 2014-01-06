//
//  CustomTabbarViewController_2.m
//  T&L
//
//  Created by OpenXcell-Macmini3 on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbarViewController_2.h"

@interface CustomTabbarViewController_2 ()

@end

@implementation CustomTabbarViewController_2

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
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    nextParticipantsQueViewController = [[ParticipantsQueViewController alloc]initWithNibName:@"ParticipantsQueViewController" bundle:nil];
    nextQuestionAssessorViewController = [[QuestionAssessorViewController alloc]initWithNibName:@"QuestionAssessorViewController" bundle:nil];
    
    nav_1 = [[UINavigationController alloc] initWithRootViewController:nextParticipantsQueViewController];
    nav_2 = [[UINavigationController alloc] initWithRootViewController:nextQuestionAssessorViewController];
    nav_3 = [[UINavigationController alloc] initWithRootViewController:nextParticipantsQueViewController];
    
    [nav_1 setNavigationBarHidden:YES];
    [nav_2 setNavigationBarHidden:YES];
    [nav_3 setNavigationBarHidden:YES];    
    
    MainTabBar = [[UITabBarController alloc] init];
	MainTabBar.delegate = self;
	[MainTabBar setViewControllers:[NSArray arrayWithObjects:nav_1,nav_2,nav_3,nil]];
    MainTabBar.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    MainTabBar.tabBar.frame = CGRectMake(0,0,768,55); 
    //MainTabBar.tabBar.tintColor = [UIColor whiteColor];
    
     float version = [[[UIDevice currentDevice] systemVersion] floatValue];     
     if (version >= 5.0)
     {
     MainTabBar.tabBar.backgroundImage=[UIImage imageNamed:@"glow.png"];
     MainTabBar.tabBar.tintColor = [UIColor whiteColor];
     
     }
     else
     {
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glow.png"]];
     [MainTabBar.tabBar insertSubview:imageView atIndex:0];
     }
     
    imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Exit.png"]];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFit];
    [imageView1 setFrame:CGRectMake(438,10,72,37)];
    [MainTabBar.tabBar insertSubview:imageView1 atIndex:1];
    
    
    imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Participant.png"]];
    [imageView2 setFrame:CGRectMake(548,13,97,27)];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    [MainTabBar.tabBar insertSubview:imageView2 atIndex:2];

    
    imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Assessor.png"]];
    [imageView3 setFrame:CGRectMake(642,13,100,28)];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFit];
    [MainTabBar.tabBar insertSubview:imageView2 atIndex:2];

    
    MainTabBar.selectedIndex = 2;
    [imageView1 setImage:[UIImage imageNamed:@"Assessor.png"]];
	[self.view addSubview:MainTabBar.view];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Tabbar delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
    switch(MainTabBar.selectedIndex)
    {
            
        case 1:
            [imageView2 setImage:[UIImage imageNamed:@"Participant1.png"]]; // dark
            [imageView3 setImage:[UIImage imageNamed:@"Assesor1.png"]]; // light
            break;
            
        case 2:
            [imageView2 setImage:[UIImage imageNamed:@"Participant.png"]]; // light
            [imageView3 setImage:[UIImage imageNamed:@"Assessor.png"]]; // dark
            break;
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
	return YES;
}

@end
