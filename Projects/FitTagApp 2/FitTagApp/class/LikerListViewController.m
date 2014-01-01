//
//  LikerListViewController.m
//  FitTag
//
//  Created by apple on 4/12/13.
//
//

#import "LikerListViewController.h"
#import "LikerCustomCell.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface LikerListViewController ()

@end

@implementation LikerListViewController
@synthesize arrLikerList,isFollower,isLike;

-(void)viewDidLoad{
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [arrLikerList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    like=[arrLikerList objectAtIndex:indexPath.row];
    
    if ([[like parseClassName]isEqualToString:@"Tbl_follower"]) {
        
        if (self.isFollower==TRUE) {
            user=[like objectForKey:@"userId"];
        }
        else{
        user=[like objectForKey:@"followerUser"];
        }
    }
    else{
    user=[like objectForKey:@"userId"];
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    LikerCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[LikerCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lblUserName.text=[user username];
    NSLog(@"%@",[user username]);
    [cell.lblUserName setFont:[UIFont fontWithName:@"DynoBold" size:21]];
    
    
    PFFile *uesrProfileImage = [user objectForKey:@"userPhoto"];
    [cell.imgProfileView setImageWithURL:[NSURL URLWithString:[uesrProfileImage url]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    like=[arrLikerList objectAtIndex:indexPath.row];
    if (self.isFollower==TRUE) {
        user=[like objectForKey:@"userId"];
    }
    else{
        user=[like objectForKey:@"followerUser"];
    }
    ProfileViewController *obj=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    obj.profileUser=user;
    obj.title=@"Profile";
    [self.navigationController pushViewController:obj animated:TRUE];
    
    
    }
#pragma mark
#pragma make Button Back
-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
