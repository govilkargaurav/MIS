//
//  AddNotesViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNotesViewCtr.h"
#import "DataExporter.h"
#import "GlobalMethods.h"

@implementation AddNotesViewCtr
@synthesize strEdit,strPassID;

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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    
   /* self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ExportPressed)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];*/
    
    if (isiPhone5)
    {
        toolBar.frame=CGRectMake(0,568, 320, 44);
    }
    else
    {
        toolBar.frame=CGRectMake(0,480, 320, 44);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    
    
    note = [[NoteView alloc] init];
    if (isiPhone5)
    {
        note.frame = CGRectMake(32, 84, 288, 469);
    }
    else
    {
        note.frame = CGRectMake(32, 84, 288, 375);
    }
    [self.view addSubview:note];
    note.delegate = self;
    note.text = @"Enter Note Here...";
    
    if ([strEdit isEqualToString:@"Edit"]) 
    {
        NSString *strQuery_Select_Note =[NSString stringWithFormat:@"SELECT * FROM tbl_notes where id=%d",[strPassID intValue]];
        NSMutableArray *Arrynotes = [[NSMutableArray alloc]initWithArray:[DatabaseAccess gettbl_notes:strQuery_Select_Note]];
        
        int days = [self ReturnNoOfDays:[[Arrynotes objectAtIndex:0]valueForKey:@"ndate"]];
        if (days != 0)
        {
            lblDate.text = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"ndate"]];
        }
        else
        {
            lblDate.text = @"Today";
        }
        
        strDate = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"ndate"]];
        
        lblTime.text = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"ntime"]];
        note.text = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"notesdesc"]];
        strCompreNote = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"notesdesc"]];
        
        strEditableStatus = [NSString stringWithFormat:@"%@",[[Arrynotes objectAtIndex:0]valueForKey:@"editable"]];

    
        self.navigationItem.title=note.text;
    }
    else
    {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [timeFormat setDateFormat:@"h:mm a"];

        NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        
        NSDate *now = [[NSDate alloc] init];
    
        strDate = [dateFormatter stringFromDate:now];
        lblDate.text = @"Today";
        lblTime.text = [timeFormat stringFromDate:now];
        self.navigationItem.title=@"New Note";
    }
    
    CGSize lblDateSize = [self text:lblDate.text fontname:[UIFont fontWithName:@"GillSans-Bold" size:14.0]];
    lblDate.frame = CGRectMake(38, 53, lblDateSize.width, 26);
    lblTime.frame = CGRectMake(lblDateSize.width + 5 + 38, 53, 50, 26);
    
    [self.view bringSubviewToFront:toolBar];
    
    if ([strEditableStatus intValue] == 1)
    {
        note.editable = NO;
        btnEditable.hidden = YES;
        lblDate.hidden = YES;
        lblTime.hidden = YES;
        lblLockedSince.hidden = NO;
        lblLockedSince.text = [NSString stringWithFormat:@"Locked Since : %@ - %@",lblDate.text,lblTime.text];
        lblTopGray.backgroundColor = RGBCOLOR(51, 51, 51);
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
        {
            note.editable = YES;
            lblLockedSince.hidden = YES;
            btnEditable.hidden = NO;
        }
        else
        {
            btnEditable.hidden = YES;
        }
    }
    
    [GlobalMethods SetInsetToTextField:tfPassword];

    // Do any additional setup after loading the view from its nib.
}

-(CGSize)text:(NSString*)strTextContent fontname:(UIFont*)fname
{
    CGSize constraintSize;
    constraintSize.width = MAXFLOAT;
    constraintSize.height = 26.0;
    CGSize stringSize1 =[strTextContent sizeWithFont:fname constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
    return stringSize1;
}

-(int)ReturnNoOfDays:(NSString*)strDatePass
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *StartDate=[dateFormatter dateFromString:strDatePass];
    
    
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
    
    return days;
}

-(IBAction)DonePressedResign:(id)sender
{
    [self ResignAndSave];
}
-(void)SaveNotes
{
    NSString *strNote = [note.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if ([strEdit isEqualToString:@"Edit"]) 
    {
        NSString *strDateSave,*strTimeSave;
        if (![strCompreNote isEqualToString:note.text])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [timeFormat setDateFormat:@"h:mm a"];
            
            NSDate *now = [[NSDate alloc] init];
            
            strDateSave = [dateFormat stringFromDate:now];
            strTimeSave = [timeFormat stringFromDate:now];
        }
        else
        {
            strDateSave = [NSString stringWithFormat:@"%@",strDate];
            strTimeSave = lblTime.text;
        }
        NSString *str_Insert_Notes = [NSString stringWithFormat:@"update tbl_notes Set ndate='%@',ntime='%@',notesdesc='%@' Where id=%d",strDateSave,strTimeSave,strNote,[strPassID intValue]];
        [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_Notes];
    }
    else
    {
        NSString *str_Insert_Notes = [NSString stringWithFormat:@"insert into tbl_notes(ndate,ntime,notesdesc) values('%@','%@','%@')",strDate,lblTime.text,strNote];
        int lastid = [DatabaseAccess InsertUpdateDeleteQuery:str_Insert_Notes];
        strPassID = [NSString stringWithFormat:@"%d",lastid];
        strEdit=@"Edit";
    }
}

-(void)ResignAndSave
{
    NSString *strString = [note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] == 0)
    {
        note.text=@"Enter Note Here...";
    }
    else if (![note.text isEqualToString:@"Enter Note Here..."])
    {
        [self SaveNotes];
    }
    if (isiPhone5)
    {
        note.frame=CGRectMake(32, 84, 288, 469);
        toolBar.frame=CGRectMake(0,568, 320, 44);
    }
    else
    {
        note.frame=CGRectMake(32, 84, 288, 375);
        toolBar.frame=CGRectMake(0,480, 320, 44);
    }
    [note resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    [UIView commitAnimations];

}
#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [btnExport setImage:[UIImage imageNamed:@"ExportWhite.png"] forState:UIControlStateNormal];

    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0) 
        {
            [self SendEmail];
        }   
        else if (buttonIndex == 1)
        {
            [self SendMessage];
        }
        else
            return;
    }
    else if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [self EncryptandSend];
        }
        else if (buttonIndex == 1)
        {
            [self SendEmail];
        }
        else if (buttonIndex == 2)
        {
            [self SendMessage];
        }
        else
            return;
    }
    else if (actionSheet.tag == 3)
    {
        if (buttonIndex == 0)
        {
            [btnEditable setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [btnEditable setImage:[UIImage imageNamed:@"Editable_selected.png"] forState:UIControlStateNormal];
            note.editable = NO;
            NSString *str_Update_Editable_Status_Notes = [NSString stringWithFormat:@"update tbl_notes Set editable='1' Where id=%d",[strPassID intValue]];
            [DatabaseAccess InsertUpdateDeleteQuery:str_Update_Editable_Status_Notes];
            
            btnEditable.userInteractionEnabled = NO;
        }
        else
        {
            [btnEditable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnEditable setImage:[UIImage imageNamed:@"Editable.png"] forState:UIControlStateNormal];
            return;
        }
    }
}
-(void)SendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"%@  %@",strDate,lblTime.text]];
        NSString *emailBody =[NSString stringWithFormat:@"%@",note.text];
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet or add E-mail account from setting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)SendMessage
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = [NSString stringWithFormat:@"%@",note.text];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the sms composer"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
-(void)EncryptandSend
{
    NSString *strString = [note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] != 0 && ![strString isEqualToString:@"Enter Note Here..."])
    {
        [self OpenActionSheetOrPasswordView];
    }
}
-(void)OpenActionSheetOrPasswordView
{
    if (isPasswordInclude)
    {
        [self OpenEmailWithEncryptionText];
    }
    else
    {
        [self.view addSubview:ViewPass];
        [self.view bringSubviewToFront:ViewPass];
        
        if (isiPhone5)
            ViewPass.frame = CGRectMake(50, 160, 220, 227);
        else
            ViewPass.frame = CGRectMake(50, 116, 220, 227);
    }
}
-(IBAction)btnSkipOrGoPressed:(id)sender
{
    [ViewPass removeFromSuperview];
    
    if ([sender tag] == 101)
    {
        NSRange whiteSpaceRange = [tfPassword.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([tfPassword.text length] == 0)
        {
            UIAlertView *alrtMessage = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"Password should not be empty." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alrtMessage show];
        }
        else if (whiteSpaceRange.location != NSNotFound)
        {
            UIAlertView *alrtMessage = [[UIAlertView alloc]initWithTitle:APP_NAME message:@"You can not put space in password." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alrtMessage show];
        }
        else
        {
            isPasswordInclude = YES;
            [self OpenEmailWithEncryptionText];
        }
    }
    else if ([sender tag] == 102)
    {
        isPasswordInclude = NO;
        [self OpenEmailWithEncryptionText];
    }
}
-(void)OpenEmailWithEncryptionText
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"%@  %@",strDate,lblTime.text]];
        NSMutableDictionary *dictshare=[[NSMutableDictionary alloc]init];
       
        [dictshare setObject:note.text forKey:@"descPianopass"];
        
        if (isPasswordInclude)
         [dictshare setObject:tfPassword.text forKey:@"pwdPianopass"];
         else
         [dictshare setObject:@"" forKey:@"pwdPianopass"];
        
        
        NSData *datashare =[NSData dataWithContentsOfFile:[DataExporter saveDataFromDictionary:dictshare]];
        [mailer addAttachmentData:datashare mimeType:@"application/pianopass" fileName:@"EncryptedData.pianopass"];
        [self presentModalViewController:mailer animated:YES];
        
        isPasswordInclude = NO;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet or add E-mail account from setting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	switch (result)
	{
		case MessageComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
	
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [note setNeedsDisplay];
    //note.contentOffset=note1.contentOffset;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{	
    if ([note.text isEqualToString:@"Enter Note Here..."])
    {
        note.text=@"";
    }
    if (isiPhone5)
    {
        note.frame=CGRectMake(32, 84, 288, 210);
        toolBar.frame=CGRectMake(0,292, 320, 44);
    }
    else
    {
        note.frame=CGRectMake(32, 84, 288, 122);
        toolBar.frame=CGRectMake(0,204, 320, 44);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    [UIView commitAnimations];
	return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) 
    {
        
        //[textView resignFirstResponder];
		//return NO;
    }
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSString *strString = [note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] != 0 && ![strString isEqualToString:@"Enter Note Here..."])
    {
        [self SaveNotes];
    }

}
#pragma mark - IBAction Method
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnExportPressed:(id)sender
{
    [self ResignAndSave];
    
    NSString *strString = [note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] == 0 || [note.text isEqualToString:@"Enter Note Here..."])
    {
        return;
    }
    
    [btnExport setImage:[UIImage imageNamed:@"ExportOrange.png"] forState:UIControlStateNormal];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Encrypt and Send",@"Send Email",@"Send Message",@"Cancel",nil];
        popupQuery.tag = 2;
        popupQuery.destructiveButtonIndex = 2;
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupQuery showInView:self.view];
    }
    else
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Send Email",@"Send Message",@"Cancel",nil];
        popupQuery.tag = 1;
        popupQuery.destructiveButtonIndex = 2;
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupQuery showInView:self.view];
    }
}
-(IBAction)btnEditablePressed:(id)sender
{
    NSString *strString = [note.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] == 0 || [note.text isEqualToString:@"Enter Note Here..."])
    {
        return;
    }
    
    [btnEditable setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnEditable setImage:[UIImage imageNamed:@"Editable_selected.png"] forState:UIControlStateNormal];
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Would you like to edit this note and make it uneditable?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Lock",@"Cancel",nil];
    popupQuery.tag = 3;
    popupQuery.destructiveButtonIndex = 1;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
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
