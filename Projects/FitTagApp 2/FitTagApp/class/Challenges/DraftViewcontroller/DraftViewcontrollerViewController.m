//
//  DraftViewcontrollerViewController.m
//  FitTag
//
//  Created by Vinod Jat on 6/5/13.
//
//

#import "DraftViewcontrollerViewController.h"
#import "CreateChlng1ViewController.h"

@interface DraftViewcontrollerViewController ()

@end

@implementation DraftViewcontrollerViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //618236961536576 Test account
    // 192915557527782 live application
    
    
    self.title = @"Draft";
    
    // Back button customization
    UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressedDraft:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // All challenges of drafts
    mutArraDraftsChallenges = [[NSMutableArray alloc]init];
    
    PFQuery *draftQuery = [PFQuery queryWithClassName:@"ChallengeDrafts"];
    [draftQuery whereKey:@"userId" equalTo:[PFUser currentUser]];
    
    [draftQuery findObjectsInBackgroundWithBlock:^(NSArray *mutArrDraft,NSError *draftError){
        if(!draftError){
            // Got the drafted challenges from Parse
            mutArraDraftsChallenges = [mutArrDraft mutableCopy];
            [self.tblViewDrafts reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }else{
            // Some error occure while getting data from parse
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mutArraDraftsChallenges count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellFindBg.png"]];
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[mutArraDraftsChallenges objectAtIndex:indexPath.row] objectForKey:@"challengeName"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"DynoRegular" size:18];
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateChlng1ViewController *createChallengeStepOneVC = [[CreateChlng1ViewController alloc]initWithNibName:@"CreateChlng1ViewController" bundle:nil];
    createChallengeStepOneVC.mutArrDraftChallenge = mutArraDraftsChallenges;
    createChallengeStepOneVC.buttonIndex = indexPath.row;
    [self.navigationController pushViewController:createChallengeStepOneVC animated:YES];
}

#pragma mark Action methods

-(void)btnHeaderbackPressedDraft:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
