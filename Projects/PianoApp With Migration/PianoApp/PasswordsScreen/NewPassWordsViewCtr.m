//
//  NewPassWordsViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewPassWordsViewCtr.h"
#import "TypeViewCtr.h"
#import "AppDelegate.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation NewPassWordsViewCtr
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
        
        NSString *strQuery_Select_Password =[NSString stringWithFormat:@"SELECT * FROM tbl_newpasswords where id=%d",[strPassID intValue]];
        ArryViewPass = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_newpasswords:strQuery_Select_Password]];
        appdel.strSelectedType=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"type"]];
    }
    else
    {
        self.navigationItem.title=@"New Password";
        appdel.strSelectedType=@"Social Networking";
    }
   lblSelect=[[UILabel alloc] init];
    lblTitleSelect=[[UILabel alloc] init];
    tfTitle=[[UITextField alloc]init];
    tfUsrname=[[UITextField alloc]init];
    tfPass=[[UITextField alloc]init];
    tfUrl=[[UITextField alloc]init];
    tfHint=[[UITextField alloc]init];
    tfUrl.text = @"http://";
    // Do any additional setup after loading the view from its nib.
}
/*-(void)CancelEditPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    
    // Add iAd
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdShowSetFrame) name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdHideSetFrame) name:@"iAdHideSetFrame" object:nil];
    
    if (AppDel.isiAdVisible)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_newPass.frame = CGRectMake(0, 44, 320, 454);
        }
        else
        {
            tbl_newPass.frame = CGRectMake(0, 44, 320, 366);
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
        if (isiPhone5)
        {
            tbl_newPass.frame = CGRectMake(0, 44, 320, 504);
        }
        else
        {
            tbl_newPass.frame = CGRectMake(0, 44, 320, 416);
        }
    }
    [tbl_newPass reloadData];
}

// Set Frame OF view according to iAd show/hide
-(void)iAdShowSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_newPass.frame = CGRectMake(0, 44, 320, 454);
    }
    else
    {
        tbl_newPass.frame = CGRectMake(0, 44, 320, 366);
    }
}
-(void)iAdHideSetFrame
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    if (isiPhone5)
    {
        tbl_newPass.frame = CGRectMake(0, 44, 320, 504);
    }
    else
    {
        tbl_newPass.frame = CGRectMake(0, 44, 320, 416);
    }
}

-(void)DonePressed
{
    if ([tfTitle.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please enter title"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([tfUsrname.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please enter username"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else if ([tfPass.text length] == 0 && [tfHint.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please enter password or hint"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *encryptedData;
        if ([tfPass.text length] > 0)
        {
            NSString *password = @"p4ssw0rd";
            
            // Encrypting
            encryptedData = [AESCrypt encrypt:tfPass.text password:password];
        }
        NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        NSString *timestamp=[dateFormatter stringFromDate:[NSDate date]];
        
        tfTitle.text = [tfTitle.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        tfHint.text = [tfHint.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *strQuery_Password;
        if ([strEdit isEqualToString:@"Edit"])
        {
             strQuery_Password = [NSString stringWithFormat:@"update tbl_newpasswords Set type='%@',title='%@',username='%@',password='%@',url='%@',timedateadd='%@',hint='%@' Where id=%d",appdel.strSelectedType,tfTitle.text,tfUsrname.text,encryptedData,tfUrl.text,timestamp,tfHint.text,[strPassID intValue]];
        }
        else
        {
            strQuery_Password =[NSString stringWithFormat:@"insert into tbl_newpasswords(type,title,username,password,url,timedateadd,favstatus,hint) values('%@','%@','%@','%@','%@','%@',%d,'%@')",appdel.strSelectedType,tfTitle.text,tfUsrname.text,encryptedData,tfUrl.text,timestamp,0,tfHint.text];
        }
        [DatabaseAccess InsertUpdateDeleteQuery:strQuery_Password];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 4;
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      
        
        if (indexPath.section == 1)
        {
            UILabel *lblTitle=[[UILabel alloc] init];
            lblTitle.frame=CGRectMake(18,11,85,21);
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.textColor=[UIColor orangeColor];
            lblTitle.textAlignment=UITextAlignmentRight;
            lblTitle.font=[UIFont boldSystemFontOfSize:17.0f];
            lblTitle.lineBreakMode = UILineBreakModeTailTruncation;
            if (indexPath.row == 0)
            {
                lblTitle.text=@"title";
            }
            else if (indexPath.row == 1)
            {
                lblTitle.text=@"username";
            }
            else if (indexPath.row == 2)
            {
                lblTitle.text=@"password";
            }
            else
            {
                lblTitle.text=@"notes";
            }
            [cell addSubview:lblTitle];
            
            if (indexPath.row == 0)
            {
                tfTitle.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    tfTitle.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"title"]];
                }
                else
                {
                    tfTitle.placeholder=@"example type";
                }
                tfTitle.delegate=self;
                tfTitle.backgroundColor=[UIColor clearColor];
                tfTitle.textAlignment=UITextAlignmentLeft;
                tfTitle.returnKeyType = UIReturnKeyDefault;
                tfTitle.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfTitle.font=[UIFont systemFontOfSize:17.0f];
                tfTitle.keyboardType=UIKeyboardTypeDefault;
                tfTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:tfTitle];
            }
            else if (indexPath.row == 1)
            {
                tfUsrname.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    tfUsrname.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"username"]];
                }
                else
                {
                    tfUsrname.placeholder=@"john.appleseed99";
                }
                tfUsrname.delegate=self;
                tfUsrname.backgroundColor=[UIColor clearColor];
                tfUsrname.textAlignment=UITextAlignmentLeft;
                tfUsrname.returnKeyType = UIReturnKeyDefault;
                tfUsrname.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfUsrname.font=[UIFont systemFontOfSize:17.0f];
                tfUsrname.keyboardType=UIKeyboardTypeDefault;
                tfUsrname.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:tfUsrname];
            }
            else if (indexPath.row == 2)
            {
                tfPass.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] isEqualToString:@""]) 
                    {
                        tfPass.placeholder=@"password";
                    }
                    else
                    {
                        NSString *password = @"p4ssw0rd";
                        NSString *message1 = [AESCrypt decrypt:[[ArryViewPass objectAtIndex:0]valueForKey:@"password"] password:password];
                        tfPass.text=[NSString stringWithFormat:@"%@",message1];
                    }
                }
                else
                {
                    tfPass.placeholder=@"password";
                }
                tfPass.delegate=self;
                tfPass.backgroundColor=[UIColor clearColor];
                tfPass.textAlignment=UITextAlignmentLeft;
                tfPass.returnKeyType = UIReturnKeyDefault;
                tfPass.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfPass.font=[UIFont systemFontOfSize:17.0f];
                tfPass.keyboardType=UIKeyboardTypeDefault;
                tfPass.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:tfPass];
            }
            else
            {
                tfHint.frame=CGRectMake(116, 11, 173, 31);
                if ([strEdit isEqualToString:@"Edit"]) 
                {
                    if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"] isEqualToString:@""]) 
                    {
                        tfHint.placeholder=@"notes";
                    }
                    else
                    {
                        tfHint.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"hint"]];
                    }
                }
                else
                {
                    tfHint.placeholder=@"notes";
                }
                tfHint.delegate=self;
                tfHint.backgroundColor=[UIColor clearColor];
                tfHint.textAlignment=UITextAlignmentLeft;
                tfHint.returnKeyType = UIReturnKeyDefault;
                tfHint.autocapitalizationType=UITextAutocapitalizationTypeNone;
                tfHint.font=[UIFont systemFontOfSize:17.0f];
                tfHint.keyboardType=UIKeyboardTypeDefault;
                tfHint.clearButtonMode = UITextFieldViewModeWhileEditing;
                [cell addSubview:tfHint];
            }
            
        }
        else if (indexPath.section == 2)
        {
            UILabel *lblTitle1=[[UILabel alloc] init];
            lblTitle1.frame=CGRectMake(18,11,85,21);
            lblTitle1.backgroundColor=[UIColor clearColor];
            lblTitle1.textColor=[UIColor orangeColor];
            lblTitle1.textAlignment=UITextAlignmentRight;
            lblTitle1.font=[UIFont boldSystemFontOfSize:17.0f];
            lblTitle1.lineBreakMode = UILineBreakModeTailTruncation;
            lblTitle1.text=@"url";
            [cell addSubview:lblTitle1];
            
            tfUrl.frame=CGRectMake(116, 11, 173, 31);
            if ([strEdit isEqualToString:@"Edit"]) 
            {
                if ([[[ArryViewPass objectAtIndex:0]valueForKey:@"url"] isEqualToString:@"(null)"] || [[[ArryViewPass objectAtIndex:0]valueForKey:@"url"] isEqualToString:@""]) 
                {
                    tfUrl.placeholder=@"www.example.com";
                }
                else
                {
                    tfUrl.text=[NSString stringWithFormat:@"%@",[[ArryViewPass objectAtIndex:0]valueForKey:@"url"]];
                }
            }
            else
            {
                tfUrl.placeholder=@"www.example.com";
            }
            tfUrl.delegate=self;
            tfUrl.backgroundColor=[UIColor clearColor];
            tfUrl.textAlignment=UITextAlignmentLeft;
            tfUrl.returnKeyType = UIReturnKeyDefault;
            tfUrl.autocapitalizationType=UITextAutocapitalizationTypeNone;
            tfUrl.font=[UIFont systemFontOfSize:17.0f];
            tfUrl.keyboardType=UIKeyboardTypeURL;
            tfUrl.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:tfUrl];
        }
    }
    if (indexPath.section == 0)
    {
        lblTitleSelect.frame=CGRectMake(18,15,67,15);
        lblTitleSelect.backgroundColor=[UIColor clearColor];
        lblTitleSelect.textColor=[UIColor orangeColor];
        lblTitleSelect.textAlignment=UITextAlignmentLeft;
        lblTitleSelect.font=[UIFont boldSystemFontOfSize:14.0f];
        lblTitleSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblTitleSelect.text=@"type";
        [cell addSubview:lblTitleSelect];
        
        lblSelect.frame=CGRectMake(93,12,190,19);
        lblSelect.backgroundColor=[UIColor clearColor];
        lblSelect.textColor=[UIColor blackColor];
        lblSelect.textAlignment=UITextAlignmentLeft;
        lblSelect.font=[UIFont boldSystemFontOfSize:17.0f];
        lblSelect.lineBreakMode = UILineBreakModeTailTruncation;
        lblSelect.text=[NSString stringWithFormat:@"%@",appdel.strSelectedType];
        [cell addSubview:lblSelect];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell.
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        TypeViewCtr *obj_TypeViewCtr=[[TypeViewCtr alloc]initWithNibName:@"TypeViewCtr" bundle:nil];
        obj_TypeViewCtr.strType=@"Password";
        [self.navigationController pushViewController:obj_TypeViewCtr animated:YES];
        obj_TypeViewCtr=nil;
    }
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidBeginEditing %@",textField);
    // Below code is used for scroll up View with navigation baar
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdShowSetFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iAdHideSetFrame" object:nil];
}

#pragma mark - IBAction Methods
-(IBAction)btnDoneSavePressed:(id)sender
{
    [self DonePressed];
}
-(IBAction)btnBackPressed:(id)sender
{
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
