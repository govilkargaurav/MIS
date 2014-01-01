



//
//  TredingViewController.m
//  HuntingApp
//
//  Created by Habib Ali on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TredingViewController.h"
#import "SettingsViewController.h"
#import "GalleryViewController.h"

@interface TredingViewController ()
@end

@implementation TredingViewController


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGallery:) name:@"PUSHLIKE" object:nil];
    titleView = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 200, 44)];
    [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(0,0, 200, 44)] autorelease];
    [lbl setFont:[UIFont fontWithName:@"WOODCUT" size:18]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavigationBar"]]];
    [lbl setText:@"OutdoorLoop"];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lbl];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:titleView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:LOGIN_TOKEN])
    {
        [self performSegueWithIdentifier:@"FirstScreen" sender:self];        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleView removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    RELEASE_SAFELY(titleView);
    [super dealloc];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"FirstScreen"])
    {
        FirstViewController *controller = (FirstViewController *)((UINavigationController *)[segue destinationViewController]).topViewController;
        [controller setDelegate:self];
        if ([sender isKindOfClass:[UIButton class]])
        {
            [controller selectGallery:sender];
        }else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"TRADINGVIEW"] isEqualToString:@"TRADINGVIEW"]){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TRADINGVIEW"];
            [controller selectGallery:sender];
        }
    }
    else if ([[segue identifier]isEqualToString:@"GalleryView"])
    {
        NSInteger gallerySelected = ((UIButton *)sender).tag;
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
}

- (void)dismissModalView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [self createAlbums];
    [self.navigationController.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)showGallery:(id)sender
{
    [self performSegueWithIdentifier:@"FirstScreen" sender:sender];
}

- (void)createAlbums
{
    [Utility createAlbum:[Utility userID]];
}

@end
