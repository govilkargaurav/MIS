//
//  SettingViewController.m
//  PropertyInspector
//
//  Created by Shivam on 10/23/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangePasswordControllernew.h"
#import "BusyAgent.h"
#import "AlertManger.h"
#import "AboutViewController.h"

@implementation SettingViewController

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
    // Do any additional setup after loading the view from its nib.
    SettingTableView.delegate=self;
    SettingTableView.dataSource=self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LOGout{
    
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"LoginViewController"])
            break;
    }
    
    [[self navigationController] popToViewController:view animated:YES];
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}

-(void)LogOutButtonClicked
{
    [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"Are you sure want to Logout?" cancelButtonTitle:@"OK" okButtonTitle:@"Cancel" parentController:self];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {
        
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        
        [self performSelector:@selector(LOGout) withObject:nil afterDelay:1.0];
    }
    
    
}

-(void)ChangePassWordButtonClicked
{
    ChangePasswordControllernew *controller=[[ChangePasswordControllernew alloc] initWithNibName:@"ChangePasswordControllernew" bundle:nil];
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark--Table VIEW methods...
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithFrame:CGRectZero ];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *communityButton=[UIButton buttonWithType:UIButtonTypeCustom];
    communityButton.frame=CGRectMake(0, cell.frame.origin.y+10, 250,50);
    [communityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if(indexPath.row==0)
    {
    [communityButton setTitle:@"LOGOUT"  forState:UIControlStateNormal];
    [communityButton addTarget:self action:@selector(LogOutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(indexPath.row==1)
    {
        
        [communityButton setTitle:@"CHANGE PASSWORD"  forState:UIControlStateNormal];
        [communityButton addTarget:self action:@selector(ChangePassWordButtonClicked) forControlEvents:UIControlEventTouchUpInside];  
    }else if(indexPath.row==2)
    {
        
        [communityButton setTitle:@"ABOUT"  forState:UIControlStateNormal];
        [communityButton addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    }
                
        [cell.contentView addSubview:communityButton];
          
    return cell;
}



-(void)about:(id)sender{
    
    AboutViewController *aboutView=[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    //self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:aboutView animated:YES];
    
}


@end
