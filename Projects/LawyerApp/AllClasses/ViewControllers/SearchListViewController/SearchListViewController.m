//
//  SearchListViewController.m
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchResultViewController.h"
@interface SearchListViewController ()

@end

@implementation SearchListViewController

@synthesize tblView;
@synthesize ArrJsonResponse;
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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

[self.navigationController setNavigationBarHidden:FALSE];
    self.title=@"Lawer's List";
    [super viewWillAppear:animated];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if (indexPat.row==0) {
        
        return 100;
    }else{
        
    return 44;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 6;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil)
    {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row==0) {
            
        
        SearchListCell *cellSearch=[[SearchListCell alloc] initWithNibName:@"SearchListCell" bundle:nil];
        [cell.contentView addSubview:cellSearch.view];
            
        }else{
            
            UILabel *lblCell=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 22)];
            lblCell.font=[UIFont fontWithName:@"Arial" size:14.0];
            lblCell.textColor=[UIColor brownColor];
            lblCell.backgroundColor=[UIColor clearColor];
            lblCell.text=@"Read More...";
            [cell.contentView addSubview:lblCell];
            
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


-(IBAction)btnLawyerPressed:(id)sender{
    
    
    SearchResultViewController *searchResult= [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
    
    [self.navigationController pushViewController:searchResult animated:YES];
    
}


@end
