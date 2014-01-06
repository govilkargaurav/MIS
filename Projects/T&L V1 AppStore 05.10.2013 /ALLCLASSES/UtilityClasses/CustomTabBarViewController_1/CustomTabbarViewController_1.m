//
//  CustomTabbarViewController_1.m
//  T&L
//
//  Created by OpenXcell-Macmini3 on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbarViewController_1.h"
#import "GlobleClass.h"

@interface CustomTabbarViewController_1 ()

@end

@implementation CustomTabbarViewController_1

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToBackButton) name:@"BackButtonPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToViewController) name:@"popToViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToViewController_SecondTabbar) name:@"popToViewController_SecondTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToViewController_ShowAssessment) name:@"popToViewController_ShowAssessment" object:nil];
    
    
    
    if([appDel.strWhichTabBar isEqualToString:@"FirstTabBar"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_12) name:@"SetTabBar_12" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_13) name:@"SetTabBar_13" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_14) name:@"SetTabBar_14" object:nil];
        
        

       
        
        //nextViewController = [[TLISCViewController alloc]initWithNibName:@"TLISCViewController" bundle:nil];
        nextLearningViewController = [[LearningViewController alloc]initWithNibName:@"LearningViewController" bundle:nil];
        nextNParticipantViewController = [[NParticipantViewController alloc] initWithNibName:@"NParticipantViewController" bundle:nil];
        nextResourceListViewController = [[ReourceListViewController alloc]initWithNibName:@"ReourceListViewController" bundle:nil];
        nextAssessmentViewController = [[NAssessmentViewController alloc]initWithNibName:@"NAssessmentViewController" bundle:nil];
        
        //nav_1 = [[UINavigationController alloc] initWithRootViewController:nextViewController];
        nav_2 = [[UINavigationController alloc] initWithRootViewController:nextLearningViewController];
        nav_3 = [[UINavigationController alloc] initWithRootViewController:nextNParticipantViewController];
        nav_4 = [[UINavigationController alloc] initWithRootViewController:nextResourceListViewController];
        nav_5 = [[UINavigationController alloc] initWithRootViewController:nextAssessmentViewController];
        
        //[nav_1 setNavigationBarHidden:YES];
        [nav_2 setNavigationBarHidden:YES];
        [nav_3 setNavigationBarHidden:YES];
        [nav_4 setNavigationBarHidden:YES];
        [nav_5 setNavigationBarHidden:YES];
        
        [self.view setFrame:CGRectMake(0, 0, 768, 970)];
        MainTabBar = [[UITabBarController alloc] init];
        MainTabBar.delegate = self;
        [MainTabBar setViewControllers:[NSArray arrayWithObjects:nav_4,nav_3,nav_5,nav_2,nil]];
        MainTabBar.tabBar.frame = CGRectMake(0,0,768,55); 
        MainTabBar.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
        
        /*
         if([strID isEqualToString:@"1"])
         returnImage = [UIImage imageNamed:@"resourceSelected.png"];
         else if([strID isEqualToString:@"2"])
         returnImage = [UIImage imageNamed:@"assessmentSelected.png"];
         else if([strID isEqualToString:@"3"])
         returnImage = [UIImage imageNamed:@"learningSelected.png"];
        */

        if([tabFocus isEqualToString:@"Assessment"])
        {
            MainTabBar.selectedIndex = 2;
            tabFocus = @"";
            strFTabSelectedID = @"2";
        }
        else if([tabFocus isEqualToString:@"AsTask"])
        {
            MainTabBar.selectedIndex = 2;
            tabFocus = @"";
            strFTabSelectedID = @"2";
        }
        else if([tabFocus isEqualToString:@"NPart"])
        {
            MainTabBar.selectedIndex = 1;
            tabFocus = @"";
            strFTabSelectedID = @"2";
        }
        else if([tabFocus isEqualToString:@"Learning"])
        {
            MainTabBar.selectedIndex = 3;
            strFTabSelectedID = @"3";
        }
        else{
            MainTabBar.selectedIndex = 0;
            strFTabSelectedID = @"1";
        }
        
        //[iv_1 setImage:[UIImage imageNamed:@"HOME.png"]];
        [self.view addSubview:MainTabBar.view];
        //[self hideTabBar:MainTabBar];
        [MainTabBar.tabBar setHidden:YES];

        
    }
    else if([appDel.strWhichTabBar isEqualToString:@"SecondTabBar"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_21) name:@"SetTabBar_21" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_22) name:@"SetTabBar_22" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSetTabBar_23) name:@"SetTabBar_23" object:nil];
        
        nextViewController = [[TLISCViewController alloc]initWithNibName:@"TLISCViewController" bundle:nil];
        nextParticipantsQueViewController = [[ParticipantsQueViewController alloc]initWithNibName:@"ParticipantsQueViewController" bundle:nil];
        nextQuestionAssessorViewController = [[QuestionAssessorViewController alloc]initWithNibName:@"QuestionAssessorViewController" bundle:nil];
        
        nav_1 = [[UINavigationController alloc] initWithRootViewController:nextViewController];
        nav_2 = [[UINavigationController alloc] initWithRootViewController:nextParticipantsQueViewController];
        nav_3 = [[UINavigationController alloc] initWithRootViewController:nextQuestionAssessorViewController];
        
        [nav_1 setNavigationBarHidden:YES];
        [nav_2 setNavigationBarHidden:YES];
        [nav_3 setNavigationBarHidden:YES];    
        
        
        [self.view setFrame:CGRectMake(0, 0, 768, 970)];
        MainTabBar = [[UITabBarController alloc] init];
        MainTabBar.delegate = self;
        [MainTabBar setViewControllers:[NSArray arrayWithObjects:nav_1,nav_2,nav_3,nil]];
        MainTabBar.tabBar.frame = CGRectMake(0,0,768,55); 
        
        /*
        //MainTabBar.tabBar.tintColor = [UIColor whiteColor];
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];     
        if (version >= 5.0)
        {
             MainTabBar.tabBar.backgroundImage=[UIImage imageNamed:@"glow copy.png"];
            
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"glow copy.png"]]];
            [MainTabBar.tabBar insertSubview:imageView atIndex:0];
        }
         
        
        imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Exit.png"]];
        [imageView1 setContentMode:UIViewContentModeScaleAspectFit];
        [imageView1 setFrame:CGRectMake(438,5,66,37)];
        [MainTabBar.tabBar insertSubview:imageView1 atIndex:1];
        
        
        imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Participant.png"]];
        [imageView2 setFrame:CGRectMake(548,10,97,27)];
        [imageView2 setContentMode:UIViewContentModeScaleAspectFit];
        [MainTabBar.tabBar insertSubview:imageView2 atIndex:2];
        
        
        imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Assessor.png"]];
        [imageView3 setFrame:CGRectMake(642,10,100,25)];
        [imageView3 setContentMode:UIViewContentModeScaleAspectFit];
        [MainTabBar.tabBar insertSubview:imageView3 atIndex:3];
        
        */
        
        MainTabBar.selectedIndex = 2;
        //[imageView1 setImage:[UIImage imageNamed:@"Exit.png"]];
        [self.view addSubview:MainTabBar.view];
        [MainTabBar.tabBar setHidden:YES];
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if(MainTabBar!=viewController){
//        
//        MainTabBar = viewController;
//        NSUInteger count=[[(UINavigationController*)viewController viewControllers] count];
//        
//        [[[(UINavigationController*)viewController viewControllers]
//          objectAtIndex:(count-1)] viewWillDisappear:YES];
//        
//    }
}

-(void)popToViewController
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstTabBar";
    [MainTabBar.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popToViewController_SecondTabbar
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"SecondTabBar";
    [MainTabBar.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popToViewController_ShowAssessment{
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstSecondTabBar";
    [MainTabBar.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btnSetTabBar_12 // Learning
{
    strFTabSelectedID = @"3";
    MainTabBar.selectedIndex = 3;
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_12" object:nil];
}
-(void)btnSetTabBar_13 // Assessment
{
    strFTabSelectedID = @"2";
    MainTabBar.selectedIndex = 1;
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_13" object:nil];
}
-(void)btnSetTabBar_14 // All Resources
{
    strFTabSelectedID = @"1";
    MainTabBar.selectedIndex = 0;
    
    if([globle_SectorName isEqualToString:@"Default"])
        globle_SectorName = @"allresources";
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_14" object:nil];
}

-(void)btnSetTabBar_21
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstTabBar";
    [MainTabBar.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSetTabBar_22
{
    MainTabBar.selectedIndex = 1;
    // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_12" object:nil];
}
-(void)btnSetTabBar_23
{
    MainTabBar.selectedIndex = 2;
    // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SetTabBar_13" object:nil];
}
-(void)popToBackButton
{
    [MainTabBar.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
