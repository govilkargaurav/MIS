//
//  ViewNewPassViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewNewPassViewCtr.h"
#import "NewPassWordsViewCtr.h"
#import "AppDelegate.h"

@implementation ViewNewPassViewCtr
@synthesize strID;
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
    
   /* self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditPressed)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];*/
    
   [self GetArray];
    
   /* UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, 320, 44)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment=UITextAlignmentCenter;
    headerLabel.font = [UIFont boldSystemFontOfSize:24];
    headerLabel.text = @"Info";
    [customView addSubview:headerLabel];
    
    btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFav setFrame:CGRectMake(160, 8, 28, 28)];*/
    if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"viewcount"] intValue] == 0)
    {
        [btnFav setImage:[UIImage imageNamed:@"star_silver.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnFav setImage:[UIImage imageNamed:@"star_gold.png"] forState:UIControlStateNormal];
    }
   /* [btnFav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFav addTarget:self action:@selector(btnFavPressed) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnFav];
    self.navigationItem.titleView=customView;*/
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    // Add iAd
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdShowSetFrame) name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdHideSetFrame) name:@"iAdHideSetFrame" object:nil];
    
    if (AppDel.isiAdVisible)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_ViewPass.frame = CGRectMake(0, 44, 320, 454);
        }
        else
        {
            tbl_ViewPass.frame = CGRectMake(0, 44, 320, 366);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_ViewPass.frame = CGRectMake(0, 44, 320, 504);
        }
        else
        {
            tbl_ViewPass.frame = CGRectMake(0, 44, 320, 416);
        }
    }
    [self GetArray];
    [tbl_ViewPass reloadData];
}

// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_ViewPass.frame = CGRectMake(0, 44, 320, 454);
    }
    else
    {
        tbl_ViewPass.frame = CGRectMake(0, 44, 320, 366);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_ViewPass.frame = CGRectMake(0, 44, 320, 504);
    }
    else
    {
        tbl_ViewPass.frame = CGRectMake(0, 44, 320, 416);
    }
}

-(void)GetArray
{
    NSString *strQuery_Select_Password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords where id=%d",[strID intValue]];
   ArryViewPass = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_Password]]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else
    {
        return 1;
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) 
    {
        return [NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"title"]];
    }
    return nil;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        if (indexPath.section == 1)
        {
            UILabel *lblTitle=[[UILabel alloc] init];
            lblTitle.frame=CGRectMake(18,11,70,21);
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.textColor=[UIColor orangeColor];
            lblTitle.textAlignment=UITextAlignmentRight;
            lblTitle.font=[UIFont boldSystemFontOfSize:14.0f];
            lblTitle.lineBreakMode = UILineBreakModeTailTruncation;
            if (indexPath.row == 0)
            {
                lblTitle.text=@"username";
            }
            else if (indexPath.row == 1)
            {
                lblTitle.text=@"password";
            }
            else
            {
                lblTitle.text=@"notes";
            }
            [cell addSubview:lblTitle];
            
            UILabel *lblSelect=[[UILabel alloc] init];
            lblSelect.frame=CGRectMake(100,12,200,19);
            lblSelect.backgroundColor=[UIColor clearColor];
            lblSelect.textAlignment=UITextAlignmentLeft;
            lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
            lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
            if (indexPath.row == 0)
            {
                lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"username"]];
            }
            else if (indexPath.row == 1)
            {
                if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] isEqualToString:@""]) 
                {
                    lblSelect.text=@"password";
                    lblSelect.textColor=[UIColor lightGrayColor];
                }
                else
                {
                    NSString *password = @"p4ssw0rd";
                    // Decrypting
                    NSString *message1 = [AESCrypt decrypt:[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] password:password];
                    lblSelect.text=[NSString stringWithFormat:@"%@",message1];
                }
            }
            else
            {
                if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"] isEqualToString:@""]) 
                {
                    lblSelect.text=@"notes";
                    lblSelect.textColor=[UIColor lightGrayColor];
                }
                else
                {
                    lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"]];
                }
            }
            [cell addSubview:lblSelect];
            
        }
        else if (indexPath.section == 2)
        {
            UILabel *lblTitle1=[[UILabel alloc] init];
            lblTitle1.frame=CGRectMake(18,11,70,21);
            lblTitle1.backgroundColor=[UIColor clearColor];
            lblTitle1.textAlignment=UITextAlignmentRight;
            lblTitle1.textColor=[UIColor orangeColor];
            lblTitle1.font=[UIFont boldSystemFontOfSize:14.0f];
            lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
            lblTitle1.text=@"url";
            [cell addSubview:lblTitle1];
            
            UILabel *lblSelect=[[UILabel alloc] init];
            lblSelect.frame=CGRectMake(100,12,200,19);
            lblSelect.backgroundColor=[UIColor clearColor];
            lblSelect.textAlignment=UITextAlignmentLeft;
            lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
            lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
            if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"url"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"url"] isEqualToString:@""]) 
            {
                lblSelect.text=@"www.example.com";
                lblSelect.textColor=[UIColor lightGrayColor];
            }
            else
            {
                lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"url"]];
            }
            [cell addSubview:lblSelect];
            
        }
        else if (indexPath.section == 3)
        {
            UILabel *lblTitleSelect=[[UILabel alloc] init];
            lblTitleSelect.frame=CGRectMake(0,11,320,21);
            lblTitleSelect.backgroundColor=[UIColor clearColor];
            lblTitleSelect.textColor=[UIColor orangeColor];
            lblTitleSelect.textAlignment=UITextAlignmentCenter;
            lblTitleSelect.font=[UIFont fontWithName:@"GillSans" size:14.0];
            lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
            NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"MMM dd, yyyy"];
            NSDate *StartDate=[dateFormatter dateFromString:[[ArryViewPass objectAtIndex:0]valueForKey:@"timedateadd"]];
            NSDate *Date2 = [NSDate date];
            NSString *str2=[dateFormatter stringFromDate:Date2];
            NSDate *EndDate=[dateFormatter dateFromString:str2];
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            unsigned int unitFlags = NSDayCalendarUnit;
            NSDateComponents *components = [gregorian components:unitFlags
                                                        fromDate:EndDate
                                                          toDate:StartDate options:0];
            int days = [components day];
            if (days == 0)
            {
                lblTitleSelect.text=@"Password Last Changed: Today"; 
            }
            else if (days == 1)
            {
                lblTitleSelect.text=@"Password Last Changed: Yesterday";
            }
            else
            {
                lblTitleSelect.text=[NSString stringWithFormat:@"Password Last Changed: %@",[[ArryViewPass objectAtIndex:0]valueForKey:@"timedateadd"]];
            }
            [cell addSubview:lblTitleSelect];
        }
    if (indexPath.section == 0)
    {
        UILabel *lblTitleSelect=[[UILabel alloc] init];
        lblTitleSelect.frame=CGRectMake(18,15,70,15);
        lblTitleSelect.backgroundColor=[UIColor clearColor];
        lblTitleSelect.textColor=[UIColor orangeColor];
        lblTitleSelect.textAlignment=UITextAlignmentRight;
        lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitleSelect.text=@"type";
        [cell addSubview:lblTitleSelect];
        
        UILabel *lblSelect=[[UILabel alloc] init];
        lblSelect.frame=CGRectMake(100,12,200,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:16.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblSelect.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"type"]];
        [cell addSubview:lblSelect];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell.
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[[ArryViewPass objectAtIndex:0]valueForKey:@"url"]]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[ArryViewPass objectAtIndex:0]valueForKey:@"url"]]];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:APP_NAME  message:@"Url is not proper" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[ArryViewPass objectAtIndex:0]valueForKey:@"url"]]];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}

#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnEditPressed:(id)sender
{
    NewPassWordsViewCtr *obj_NewPassWordsViewCtr=[[NewPassWordsViewCtr alloc]initWithNibName:@"NewPassWordsViewCtr" bundle:nil];
    obj_NewPassWordsViewCtr.strEdit=@"Edit";
    obj_NewPassWordsViewCtr.strPassID=[NSString stringWithFormat:@"%@",strID];
    [self.navigationController pushViewController:obj_NewPassWordsViewCtr animated:YES];
    obj_NewPassWordsViewCtr=nil;
}
-(IBAction)btnFavPressed:(id)sender
{
    int TotalCount ;
    if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"viewcount"] intValue] == 0)
    {
        TotalCount = 1;
        [btnFav setImage:[UIImage imageNamed:@"star_gold.png"] forState:UIControlStateNormal];
    }
    else
    {
        TotalCount = 0;
        [btnFav setImage:[UIImage imageNamed:@"star_silver.png"] forState:UIControlStateNormal];
    }
    NSString *strQuery_Update_Password = [NSString stringWithFormat:@"update tbl_newpasswords Set favstatus=%d Where id=%d",TotalCount,[strID intValue]];
    [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Update_Password];
    [self GetArray];
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
