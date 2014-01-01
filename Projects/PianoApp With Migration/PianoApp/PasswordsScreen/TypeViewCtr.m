//
//  TypeViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeViewCtr.h"
#import "AddTypeViewCtr.h"

@implementation TypeViewCtr
@synthesize strSelected,strType;

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
        
    appdel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self CallType];
    strSelected=[NSString stringWithFormat:@"%@",appdel.strSelectedType];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    [self CallType];
}
-(void)CallType
{
    if ([strType isEqualToString:@"Password"]) 
    {
        lblTitle.text = @"Select Type";
        ArryType = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_type:@"SELECT * FROM tbl_typePass"]];
    }
    else
    {
        lblTitle.text = @"Select Category";
        ArryType = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_type:@"SELECT * FROM tbl_typeContact"]];
    }
    [tbl_type reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) 
    {
        return [ArryType count];    
    }
    else
    {
        return 1;
    }
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   // if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    if (indexPath.section == 0) 
    {
            UILabel *lblTitle1=[[UILabel alloc] init];
            lblTitle1.frame=CGRectMake(18,11,270,21);
            lblTitle1.backgroundColor=[UIColor clearColor];
            lblTitle1.textAlignment=UITextAlignmentLeft;
            lblTitle1.font=[UIFont boldSystemFontOfSize:17.0f];
            lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
            lblTitle1.text=[[ArryType objectAtIndex:indexPath.row] valueForKey:@"type"];
            [cell addSubview:lblTitle1];
        
        if ([[[ArryType objectAtIndex:indexPath.row]valueForKey:@"type"] isEqualToString:strSelected])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        UILabel *lblTitle1=[[UILabel alloc] init];
        lblTitle1.frame=CGRectMake(18,11,270,21);
        lblTitle1.backgroundColor=[UIColor clearColor];
        lblTitle1.textAlignment=UITextAlignmentLeft;
        lblTitle1.font=[UIFont boldSystemFontOfSize:17.0f];
        lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitle1.text=@"Custom";
        [cell addSubview:lblTitle1];
    }
     //   }
    
    // Configure the cell.
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        strSelected = [NSString stringWithFormat:@"%@",[[ArryType objectAtIndex:indexPath.row] valueForKey:@"type"]];
        [tbl_type reloadData];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        AddTypeViewCtr *obj_AddTypeViewCtr=[[AddTypeViewCtr alloc]initWithNibName:@"AddTypeViewCtr" bundle:nil];
        if ([strType isEqualToString:@"Password"]) 
        {
            obj_AddTypeViewCtr.strSet=@"Password";
        }
        else
        {
             obj_AddTypeViewCtr.strSet=@"Contact";
        }
        [self.navigationController pushViewController:obj_AddTypeViewCtr animated:YES];
        obj_AddTypeViewCtr=nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveiAdBannerView" object:nil];
}
#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDonePressed:(id)sender
{
    appdel.strSelectedType = [NSString stringWithFormat:@"%@",strSelected];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
