//
//  FindChallengesViewConroller.m
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FindChallengesViewConroller.h"
#import "FrndSugestCustomCell.h"
#import "FindMapListViewController.h"
#import "TagCustomCell.h"
@implementation FindChallengesViewConroller
@synthesize tblFindResult;
@synthesize txtFieldSearch;
@synthesize btnAtUser;
@synthesize btnHash;
@synthesize intTypeOf;
const int HASHTAG=0;
const int ATUSER=1;
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
    //navigation back Button- Arrow
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:btnback ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)viewDidUnload
{
    [self setTxtFieldSearch:nil];
    [self setBtnHash:nil];
    [self setBtnAtUser:nil];
    [self setTblFindResult:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(intTypeOf==HASHTAG)
        return 20;
    else
        return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(intTypeOf==HASHTAG){
        static NSString *CellIdentifier = @"Cell";
        TagCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TagCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //if(isCurrentUser){
                        
        }
        cell.lblTitle.text=@"#FitnesTag";
        [cell.btnAdd setHidden:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"UserCell";
        FrndSugestCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FrndSugestCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.lblUserName.text=@"TopTrainer";
        [cell.btnFollow setHidden:YES];
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    
}

- (IBAction)btnHashPressed:(id)sender {
    intTypeOf=HASHTAG;
    [btnHash setImage:[UIImage imageNamed:@"btnHashSel"] forState:UIControlStateNormal];
    [btnAtUser setImage:[UIImage imageNamed:@"btnAt"] forState:UIControlStateNormal];
    [tblFindResult reloadData];
    
}

- (IBAction)btnAtUserPressed:(id)sender {
    intTypeOf=ATUSER;
    [btnAtUser setImage:[UIImage imageNamed:@"btnAtSel"] forState:UIControlStateNormal];
    [btnHash setImage:[UIImage imageNamed:@"btnHash"] forState:UIControlStateNormal];
  
    [tblFindResult reloadData];

}
- (IBAction)btnMapPressed:(id)sender {
    FindMapListViewController *findMapListVC=[[FindMapListViewController alloc]initWithNibName:@"FindMapListViewController" bundle:nil];
    findMapListVC.title=@"List";
    [self.navigationController pushViewController:findMapListVC animated:YES];
    
}
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

        [textField resignFirstResponder];
     return NO;
} 
@end
