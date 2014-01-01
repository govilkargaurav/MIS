//
//  SettingViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/6/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "SettingViewController.h"
#import "InfoViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrSettings=[[NSMutableArray alloc]init];
    
    
    [arrSettings addObject:@"Remove Ads"];
    [arrSettings addObject:@"How to use Skyy"];
    [arrSettings addObject:@"Privacy Policy"];
    [arrSettings addObject:@"Delete Profile"];
    [arrSettings addObject:@"Like Skyy on Facebook"];
    if ([PFUser currentUser]) {
         [arrSettings addObject:@"Logout of Facebook"];
    }else{
    
      [arrSettings addObject:@"Login with Facebook"];
    }
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:[arrSettings objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        InfoViewController *info=[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil
                                ];
        info.isSetting=TRUE;
        [self.navigationController pushViewController:info animated:TRUE];
    }
    
    if (indexPath.row==2) {
        ViewController *objViewController=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil
                                  ];
        [self.navigationController pushViewController:objViewController animated:TRUE];
    }
    if (indexPath.row==6) {
        [PFUser logOut];
        LoginViewController *objLoginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:objLoginViewController animated:TRUE];
    }
}

@end
