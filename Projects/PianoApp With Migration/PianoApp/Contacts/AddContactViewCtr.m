//
//  AddContactViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddContactViewCtr.h"
#import "TypeViewCtr.h"
#import "AppDelegate.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
// adjust this following value to account for the height of your toolbar, too
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation AddContactViewCtr
@synthesize strEdit,strPassID;
CGFloat animatedDistance;
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
   /* self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DonePressed)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];*/
    if ([strEdit isEqualToString:@"Edit"]) 
    {
       /* self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelEditPressed)];
        self.navigationItem.title=@"Edit";*/
        NSString *strQuery_Select_Contact =[NSString stringWithFormat:@"SELECT * FROM tbl_addcontacts where id=%d",[strPassID intValue]];
        ArryViewCont = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_addcontacts:strQuery_Select_Contact]];
        appdel.strSelectedType=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Category"]];
    }
    else
    {
        self.navigationItem.title=@"New Contact";
        appdel.strSelectedType=@"Family";
    }
    lblSelect=[[UILabel alloc] init];
    lblTitleSelect=[[UILabel alloc] init];
    tfFname=[[UITextField alloc]init];
    tfLname=[[UITextField alloc]init];
    tfMobile=[[UITextField alloc]init];
    tfHome=[[UITextField alloc]init];
    tfHomePage=[[UITextField alloc]init];
    tfCompany=[[UITextField alloc]init];
    tfPhoneHome=[[UITextField alloc]init];
    tfPhoneWork=[[UITextField alloc]init];
    tfPhoneOther=[[UITextField alloc]init];
    tfWorkEmail=[[UITextField alloc]init];
    tfOtherEmail=[[UITextField alloc]init];
    lblTitle1=[[UILabel alloc]init];
    lblTitle2=[[UILabel alloc]init];
    lblTitle3=[[UILabel alloc]init];
    lblTitle4=[[UILabel alloc]init];
    lblTitle5=[[UILabel alloc]init];
    lblTitle6=[[UILabel alloc]init];
    lblTitle7=[[UILabel alloc]init];
    lblTitle8=[[UILabel alloc]init];
    
    if ([strEdit isEqualToString:@"Edit"]) 
    {
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"] isEqualToString:@""]) 
        {
            tfHome.placeholder=@"email";
        }
        else
        {
            tfHome.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"]];
        }
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"] isEqualToString:@""]) 
        {
            tfHomePage.placeholder=@"url";
        }
        else
        {
            tfHomePage.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"]];
        }
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"] isEqualToString:@""]) 
        {
            tfWorkEmail.placeholder=@"work";
        }
        else
        {
            tfWorkEmail.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"]];
        }
        if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"] isEqualToString:@"(null)"]||[[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"] isEqualToString:@""]) 
        {
            tfOtherEmail.placeholder=@"other";
        }
        else
        {
            tfOtherEmail.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"]];
        }
    }
    [tbl_AddContact reloadData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)CancelEditPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];

    // Add iAd
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdShowSetFrame) name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdHideSetFrame) name:@"iAdHideSetFrame" object:nil];
    
    if (AppDel.isiAdVisible)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_AddContact.frame = CGRectMake(0, 44, 320, 454);
        }
        else
        {
            tbl_AddContact.frame = CGRectMake(0, 44, 320, 366);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_AddContact.frame = CGRectMake(0, 44, 320, 504);
        }
        else
        {
            tbl_AddContact.frame = CGRectMake(0, 44, 320, 416);
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil]; 
    } 
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }   
    [tbl_AddContact reloadData];
}

// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_AddContact.frame = CGRectMake(0, 44, 320, 454);
    }
    else
    {
        tbl_AddContact.frame = CGRectMake(0, 44, 320, 366);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_AddContact.frame = CGRectMake(0, 44, 320, 504);
    }
    else
    {
        tbl_AddContact.frame = CGRectMake(0, 44, 320, 416);
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[locManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidShowNotification 
                                                  object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 4;
    }
    else if (section == 3)
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
    if (section == 2)
    {
        return @"Phone";
    }
    else if (section == 3)
    {
        return @"Email";
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
   // }
        if (indexPath.section == 0)
        {
            lblTitleSelect.frame=CGRectMake(18,15,67,15);
            lblTitleSelect.backgroundColor=[UIColor clearColor];
            lblTitleSelect.textColor=[UIColor orangeColor];
            lblTitleSelect.textAlignment=UITextAlignmentLeft;
            lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
            lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
            lblTitleSelect.text=@"Category";
            [cell.contentView addSubview:lblTitleSelect];
            
            lblSelect.frame=CGRectMake(93,12,190,19);
            lblSelect.backgroundColor=[UIColor clearColor];
            lblSelect.textColor=[UIColor blackColor];
            lblSelect.textAlignment=UITextAlignmentLeft;
            lblSelect.font=[UIFont boldSystemFontOfSize:17.0f];
            lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
            lblSelect.text=[NSString stringWithFormat:@"%@",appdel.strSelectedType];
            [cell.contentView addSubview:lblSelect];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                tfFname.frame=CGRectMake(18, 11, 270, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                        tfFname.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Firstname"]];
                }
                else
                {
                    tfFname.placeholder=@"first";
                }
                tfFname.delegate=self;
                tfFname.backgroundColor=[UIColor clearColor];
                tfFname.textAlignment=UITextAlignmentLeft;
                tfFname.returnKeyType = UIReturnKeyDefault;
                tfFname.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfFname.font=[UIFont systemFontOfSize:17.0f];
                tfFname.keyboardType=UIKeyboardTypeDefault;
                tfFname.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfFname];
            }
            else if (indexPath.row == 1)
            {
                tfLname.frame=CGRectMake(18, 11, 270, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"] isEqualToString:@""]) 
                    {
                        tfLname.placeholder=@"last";
                    }
                    else
                    {
                        tfLname.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"LastName"]];
                    }
                }
                else
                {
                    tfLname.placeholder=@"last";
                }
                tfLname.delegate=self;
                tfLname.backgroundColor=[UIColor clearColor];
                tfLname.textAlignment=UITextAlignmentLeft;
                tfLname.returnKeyType = UIReturnKeyDefault;
                tfLname.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfLname.font=[UIFont systemFontOfSize:17.0f];
                tfLname.keyboardType=UIKeyboardTypeDefault;
                tfLname.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfLname];
            }
            else if (indexPath.row == 2)
            {
                tfCompany.frame=CGRectMake(18, 11, 270, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"] isEqualToString:@""]) 
                    {
                        tfCompany.placeholder=@"company";
                    }
                    else
                    {
                        tfCompany.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Company"]];
                    }
                }
                else
                {
                    tfCompany.placeholder=@"company";
                }
                tfCompany.delegate=self;
                tfCompany.backgroundColor=[UIColor clearColor];
                tfCompany.textAlignment=UITextAlignmentLeft;
                tfCompany.returnKeyType = UIReturnKeyDefault;
                tfCompany.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfCompany.font=[UIFont systemFontOfSize:17.0f];
                tfCompany.keyboardType=UIKeyboardTypeDefault;
                tfCompany.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfCompany];
            }
            
        }
        else if (indexPath.section == 2)
        {
            if (indexPath.row == 0)
            {
                lblTitle1.frame=CGRectMake(18,11,85,21);
                lblTitle1.backgroundColor=[UIColor clearColor];
                lblTitle1.textColor=[UIColor orangeColor];
                lblTitle1.textAlignment=UITextAlignmentRight;
                lblTitle1.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle1.text=@"mobile";
                [cell.contentView addSubview:lblTitle1];
            
                tfMobile.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"] isEqualToString:@""]) 
                    {
                        tfMobile.placeholder=@"phone";
                    }
                    else
                    {
                        tfMobile.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Mobile"]];
                    }
                }
                else
                {
                    tfMobile.placeholder=@"phone";
                }
                tfMobile.delegate=self;
                tfMobile.backgroundColor=[UIColor clearColor];
                tfMobile.textAlignment=UITextAlignmentLeft;
                tfMobile.returnKeyType = UIReturnKeyDefault;
                tfMobile.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfMobile.font=[UIFont systemFontOfSize:17.0f];
                tfMobile.keyboardType=UIKeyboardTypeNumberPad;
                tfMobile.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfMobile];
            }
            else if (indexPath.row == 1)
            {
                lblTitle2.frame=CGRectMake(18,11,85,21);
                lblTitle2.backgroundColor=[UIColor clearColor];
                lblTitle2.textColor=[UIColor orangeColor];
                lblTitle2.textAlignment=UITextAlignmentRight;
                lblTitle2.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle2.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle2.text=@"home";
                [cell.contentView addSubview:lblTitle2];
            
                tfPhoneHome.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"] isEqualToString:@""]) 
                    {
                        tfPhoneHome.placeholder=@"home";
                    }
                    else
                    {
                        tfPhoneHome.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"homephone"]];
                    }
                }
                else
                {
                    tfPhoneHome.placeholder=@"home";
                }
                tfPhoneHome.delegate=self;
                tfPhoneHome.backgroundColor=[UIColor clearColor];
                tfPhoneHome.textAlignment=UITextAlignmentLeft;
                tfPhoneHome.returnKeyType = UIReturnKeyDefault;
                tfPhoneHome.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfPhoneHome.font=[UIFont systemFontOfSize:17.0f];
                tfPhoneHome.keyboardType=UIKeyboardTypeNumberPad;
                tfPhoneHome.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfPhoneHome];
                
            }
            else if (indexPath.row == 2)
            {
                lblTitle3.frame=CGRectMake(18,11,85,21);
                lblTitle3.backgroundColor=[UIColor clearColor];
                lblTitle3.textColor=[UIColor orangeColor];
                lblTitle3.textAlignment=UITextAlignmentRight;
                lblTitle3.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle3.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle3.text=@"work";
                [cell.contentView addSubview:lblTitle3];
                
                tfPhoneWork.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"] isEqualToString:@""]) 
                    {
                        tfPhoneWork.placeholder=@"work";
                    }
                    else
                    {
                        tfPhoneWork.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"workphone"]];
                    }
                }
                else
                {
                    tfPhoneWork.placeholder=@"work";
                }
                tfPhoneWork.delegate=self;
                tfPhoneWork.backgroundColor=[UIColor clearColor];
                tfPhoneWork.textAlignment=UITextAlignmentLeft;
                tfPhoneWork.returnKeyType = UIReturnKeyDefault;
                tfPhoneWork.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfPhoneWork.font=[UIFont systemFontOfSize:17.0f];
                tfPhoneWork.keyboardType=UIKeyboardTypeNumberPad;
                tfPhoneWork.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfPhoneWork];
                
            }
            else if (indexPath.row == 3)
            {
                lblTitle4.frame=CGRectMake(18,11,85,21);
                lblTitle4.backgroundColor=[UIColor clearColor];
                lblTitle4.textColor=[UIColor orangeColor];
                lblTitle4.textAlignment=UITextAlignmentRight;
                lblTitle4.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle4.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle4.text=@"other";
                [cell.contentView addSubview:lblTitle4];
                
                tfPhoneOther.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"] isEqualToString:@"(null)"] || [[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"] isEqualToString:@""]) 
                    {
                        tfPhoneOther.placeholder=@"other";
                    }
                    else
                    {
                        tfPhoneOther.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"otherphone"]];
                    }
                }
                else
                {
                    tfPhoneOther.placeholder=@"other";
                }
                tfPhoneOther.delegate=self;
                tfPhoneOther.backgroundColor=[UIColor clearColor];
                tfPhoneOther.textAlignment=UITextAlignmentLeft;
                tfPhoneOther.returnKeyType = UIReturnKeyDefault;
                tfPhoneOther.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfPhoneOther.font=[UIFont systemFontOfSize:17.0f];
                tfPhoneOther.keyboardType=UIKeyboardTypeNumberPad;
                tfPhoneOther.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfPhoneOther];
                
            }
        }
        else if (indexPath.section == 3)
        {
            if (indexPath.row == 0) 
            {
                lblTitle5.frame=CGRectMake(18,11,85,21);
                lblTitle5.backgroundColor=[UIColor clearColor];
                lblTitle5.textColor=[UIColor orangeColor];
                lblTitle5.textAlignment=UITextAlignmentRight;
                lblTitle5.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle5.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle5.text=@"home";
                [cell.contentView addSubview:lblTitle5];
                
                tfHome.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                   // tfHome.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"Home"]];
                }
                else
                {
                    tfHome.placeholder=@"email";
                }
                tfHome.delegate=self;
                tfHome.backgroundColor=[UIColor clearColor];
                tfHome.textAlignment=UITextAlignmentLeft;
                tfHome.returnKeyType = UIReturnKeyDefault;
                tfHome.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfHome.font=[UIFont systemFontOfSize:17.0f];
                tfHome.keyboardType=UIKeyboardTypeEmailAddress;
                tfHome.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfHome];
            }
            else if (indexPath.row == 1)
            {
                lblTitle6.frame=CGRectMake(18,11,85,21);
                lblTitle6.backgroundColor=[UIColor clearColor];
                lblTitle6.textColor=[UIColor orangeColor];
                lblTitle6.textAlignment=UITextAlignmentRight;
                lblTitle6.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle6.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle6.text=@"work";
                [cell.contentView addSubview:lblTitle6];
                
                tfWorkEmail.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                   // tfWorkEmail.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"workemail"]];
                }
                else
                {
                    tfWorkEmail.placeholder=@"work";
                }
                tfWorkEmail.delegate=self;
                tfWorkEmail.backgroundColor=[UIColor clearColor];
                tfWorkEmail.textAlignment=UITextAlignmentLeft;
                tfWorkEmail.returnKeyType = UIReturnKeyDefault;
                tfWorkEmail.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfWorkEmail.font=[UIFont systemFontOfSize:17.0f];
                tfWorkEmail.keyboardType=UIKeyboardTypeEmailAddress;
                tfWorkEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfWorkEmail];
            }
            else if (indexPath.row == 2)
            {
                lblTitle7.frame=CGRectMake(18,11,85,21);
                lblTitle7.backgroundColor=[UIColor clearColor];
                lblTitle7.textColor=[UIColor orangeColor];
                lblTitle7.textAlignment=UITextAlignmentRight;
                lblTitle7.font=[UIFont boldSystemFontOfSize:17.0f];
                lblTitle7.lineBreakMode = UILineBreakModeTailTruncation;
                lblTitle7.text=@"other";
                [cell.contentView addSubview:lblTitle7];
                
                tfOtherEmail.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                   // tfOtherEmail.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"otheremail"]];
                }
                else
                {
                    tfOtherEmail.placeholder=@"other";
                }
                tfOtherEmail.delegate=self;
                tfOtherEmail.backgroundColor=[UIColor clearColor];
                tfOtherEmail.textAlignment=UITextAlignmentLeft;
                tfOtherEmail.returnKeyType = UIReturnKeyDefault;
                tfOtherEmail.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfOtherEmail.font=[UIFont systemFontOfSize:17.0f];
                tfOtherEmail.keyboardType=UIKeyboardTypeEmailAddress;
                tfOtherEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell.contentView addSubview:tfOtherEmail];
            }
            
        }
        else if (indexPath.section == 4)
        {
            lblTitle8.frame=CGRectMake(15,11,95,21);
            lblTitle8.backgroundColor=[UIColor clearColor];
            lblTitle8.textColor=[UIColor orangeColor];
            lblTitle8.textAlignment=UITextAlignmentRight;
            lblTitle8.font=[UIFont boldSystemFontOfSize:17.0f];
            lblTitle8.lineBreakMode = UILineBreakModeTailTruncation;
            lblTitle8.text=@"home page";
            [cell.contentView addSubview:lblTitle8];
            
            tfHomePage.frame=CGRectMake(116, 11, 173, 31);
            if ([strEdit isEqualToString:@"Edit"]) 
            {
               // tfHomePage.text=[NSString stringWithFormat:@"%@",[[ArryViewCont objectAtIndex:0]valueForKey:@"HomePage"]];
            }
            else
            {
                tfHomePage.placeholder=@"url";
            }
            tfHomePage.delegate=self;
            tfHomePage.backgroundColor=[UIColor clearColor];
            tfHomePage.textAlignment=UITextAlignmentLeft;
            tfHomePage.returnKeyType = UIReturnKeyDefault;
            tfHomePage.autocapitalizationType=UITextAutocapitalizationTypeNone;
            tfHomePage.font=[UIFont systemFontOfSize:17.0f];
            tfHomePage.keyboardType=UIKeyboardTypeURL;
            tfHomePage.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:tfHomePage];
        }
   // }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell.
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        TypeViewCtr *obj_TypeViewCtr=[[TypeViewCtr alloc]initWithNibName:@"TypeViewCtr" bundle:nil];
        obj_TypeViewCtr.strType=@"Contact";
        [self.navigationController pushViewController:obj_TypeViewCtr animated:YES];
        obj_TypeViewCtr=nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==tfMobile || textField==tfPhoneHome || textField==tfPhoneWork || textField==tfPhoneOther)
    {
        doneButton.hidden = NO;
        phoneTagOrNot = FALSE;
    }
    else 
    {
        doneButton.hidden = YES;
        phoneTagOrNot = TRUE;
    }
    
    CGRect textVWRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

#pragma mark - Add Keyboard
- (void)addButtonToKeyboard 
{    
    // create custom button
    
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    
    doneButton.adjustsImageWhenHighlighted = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) 
    {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
    } 
    else
    {              
        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    }
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
    
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    UIView* keyboard;
    
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // keyboard found, add the button
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                
                [keyboard addSubview:doneButton];
            
        } else {
            
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                
                [keyboard addSubview:doneButton];
            
        }
        if (phoneTagOrNot == TRUE) {
            doneButton.hidden = TRUE;
        }
    }
} 

- (void)doneButton:(id)sender
{
    [tfMobile resignFirstResponder];
    [tfPhoneHome resignFirstResponder];
    [tfPhoneWork resignFirstResponder];
    [tfPhoneOther resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)note 
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
        [self addButtonToKeyboard];
    }
}

- (void)keyboardDidShow:(NSNotification *)note 
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) 
    {
        [self addButtonToKeyboard];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}
#pragma mark - IBaction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDonePressed:(id)sender
{
    if ([tfFname.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please enter firstname"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *strQuery_Contact;
        if ([strEdit isEqualToString:@"Edit"])
        {
            strQuery_Contact=[NSString stringWithFormat:@"update tbl_addcontacts Set Firstname='%@',LastName='%@',Mobile='%@',Home='%@',HomePage='%@',Category='%@',Company='%@',homephone='%@',workphone='%@',otherphone='%@',workemail='%@',otheremail='%@' Where id=%d",tfFname.text,tfLname.text,tfMobile.text,tfHome.text,tfHomePage.text,appdel.strSelectedType,tfCompany.text,tfPhoneHome.text,tfPhoneWork.text,tfPhoneOther.text,tfWorkEmail.text,tfOtherEmail.text,[[[ArryViewCont objectAtIndex:0]valueForKey:@"viewcount"]intValue]];
        }
        else
        {
            strQuery_Contact = [NSString stringWithFormat:@"insert into tbl_addcontacts(Firstname,LastName,Mobile,Home,HomePage,Category,Company,homephone,workphone,otherphone,workemail,otheremail,favstatus) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d)",tfFname.text,tfLname.text,tfMobile.text,tfHome.text,tfHomePage.text,appdel.strSelectedType,tfCompany.text,tfPhoneHome.text,tfPhoneWork.text,tfPhoneOther.text,tfWorkEmail.text,tfOtherEmail.text,0];
        }
        [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Contact];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
