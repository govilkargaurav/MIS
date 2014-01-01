//
//  FirstViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "GalleryViewController.h"
#import "SignUpController.h"
#import "LoginViewController.h"
#import "FindFriendsViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize delegate;
@synthesize firstScreen;







-(void)goodBad{
    
    NSLog(@"Gaurav");
    NSLog(@"Kiran");
    
}

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
	// Do any additional setup after loading the view.
    
    hasShownFirstView = NO;
    infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 13, 18, 18)];
    [infoBtn setImage:[UIImage imageNamed:@"info-ico"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"info-ico"] forState:UIControlStateHighlighted];
    [infoBtn addTarget:self action:@selector(showFirstScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"OutdoorLoop"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:titleView];
    [self.navigationController.navigationBar addSubview:infoBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!hasShownFirstView)
    {
        [self showFirstScreen:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
    [infoBtn removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    RELEASE_SAFELY(titleView);
    RELEASE_SAFELY(infoBtn);
    RELEASE_SAFELY(firstScreen);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectGallery:(id)sender
{
    [self performSegueWithIdentifier:@"GalleryView" sender:sender];
}

- (IBAction)showFirstScreen:(id)sender
{
//    if (firstScreen)
//    {
//        [firstScreen.view removeFromSuperview];
//        RELEASE_SAFELY(firstScreen);
//    }
//    firstScreen = [[FirstScreen alloc]init];
//    [self.view addSubview:firstScreen.view];
    hasShownFirstView = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"GalleryView"])
    {
        NSInteger gallerySelected;
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SEGUELIKE"] isEqualToString:@"SEGUELIKE"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SEGUELIKE"];
             NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"CATEGORY"];
             gallerySelected=[str integerValue];
            
        }else{
            gallerySelected = ((UIButton *)sender).tag;

            
        }
        
        GalleryViewController *controller = (GalleryViewController *)[segue destinationViewController];
        switch (gallerySelected)
        {
            case 1:
            {
                [controller setTitle:@"Big Game"];
            }
                break;
            case 2:
            {
                [controller setTitle:@"Small Game"];
                
            }
                break;
            case 3:
            {
                [controller setTitle:@"Fresh Water"];
                
            }
                break;
            case 4:
            {
                [controller setTitle:@"Salt Water"];
                
            }
                break;
            case 5:
            {
                [controller setTitle:@"Exotic"];
            }
                break;
            case 6:
            {
                [controller setTitle:@"Others"];
            }
                break;
            default:
                break;
        }
        
    }
    else if ([[segue identifier]isEqualToString:@"SignUp"]) 
    {
        SignUpController *controller = [segue destinationViewController];
        [controller setController:self];
    }
    else if ([[segue identifier]isEqualToString:@"Login"])
    {
        LoginViewController *controller = [segue destinationViewController];
        [controller setController:self];
    }
    else if ([[segue identifier]isEqualToString:@"FindFriend"]) {
        FindFriendsViewController *controller = (FindFriendsViewController *)[segue destinationViewController];
        [controller setIsLoggedFirstTime:YES];
    }

}

- (void)dismissMyView:(id)sender
{
    NSString *type = (NSString *)sender;
    if ([type isEqualToString:@"2"])
    {
        if (delegate && [delegate respondsToSelector:@selector(dismissModalView:)])
        {
            [delegate performSelector:@selector(dismissModalView:) withObject:self];
        }
    }
    else{
        
        [self performSegueWithIdentifier:@"FindFriend" sender:self];
        
    }

}

- (void)releaseFirstView
{
  
}

@end
