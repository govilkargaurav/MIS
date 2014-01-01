//
//  EncryptorViewCtr.m
//  PianoApp
//
//  Created by Imac 2 on 5/27/13.
//
//

#import "EncryptorViewCtr.h"
#import "DataExporter.h"
#import "GlobalMethods.h"

@interface EncryptorViewCtr ()

@end

@implementation EncryptorViewCtr

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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoveiAdBannerView" object:nil];
    
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
    
    [GlobalMethods SetInsetToTextField:tfPassword];
    
    ViewText.hidden = NO;
    ViewPicture.hidden = YES;
    btnText.selected = YES;
    btnPicture.selected = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - IBAction Methods
-(IBAction)DonePressedResign:(id)sender
{
    [self ResignAndSave];
}
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnTextPressed:(id)sender
{
    [btnText setTitleColor:RGBCOLOR(255, 125, 0) forState:UIControlStateNormal];
    [btnText setBackgroundColor:RGBCOLOR(51, 51, 51)];
    [btnPicture setTitleColor:RGBCOLOR(179, 179, 179) forState:UIControlStateNormal];
    [btnPicture setBackgroundColor:RGBCOLOR(255, 255, 255)];
    btnText.selected = YES;
    btnPicture.selected = NO;
    ViewText.hidden = NO;
    ViewPicture.hidden = YES;
}
-(IBAction)btnPicturePressed:(id)sender
{
    [btnPicture setTitleColor:RGBCOLOR(255, 125, 0) forState:UIControlStateNormal];
    [btnPicture setBackgroundColor:RGBCOLOR(51, 51, 51)];
    [btnText setTitleColor:RGBCOLOR(179, 179, 179) forState:UIControlStateNormal];
    [btnText setBackgroundColor:RGBCOLOR(255, 255, 255)];
    btnPicture.selected = YES;
    btnText.selected = NO;
    ViewText.hidden = YES;
    ViewPicture.hidden = NO;
}
-(IBAction)btnEncryptAndSendPressed:(id)sender
{
    if ([btnText isSelected])
    {
        NSString *strText = [txtViewEncrypt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![strText isEqualToString:@"Enter text to encrypt..."] && [strText length] != 0)
        {
            [self OpenActionSheetOrPasswordView];
        }
    }
    else if ([btnPicture isSelected])
    {
        if (imgPhotoForEncrypt.image)
        {
            [self OpenActionSheetOrPasswordView];
        }
    }
        
}
-(void)OpenActionSheetOrPasswordView
{
    if (isPasswordInclude)
    {
        [self OpenActionSheet];
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
            [self OpenActionSheet];
        }
    }
    else if ([sender tag] == 102)
    {
        isPasswordInclude = NO;
        [self OpenActionSheet];
    }
}
-(IBAction)btnPianoPassPressed:(id)sender
{
    SelectFromPianoPass *obj_SelectFromPianoPass = [[SelectFromPianoPass alloc]initWithNibName:@"SelectFromPianoPass" bundle:nil];
    obj_SelectFromPianoPass._delegate = self;
    [self presentModalViewController:obj_SelectFromPianoPass animated:YES];
    obj_SelectFromPianoPass = nil;
}
-(IBAction)btnChooseOrTakePhotoPressed:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Choose photo from library",@"Take from camera",@"Cancel",nil];
    popupQuery.tag = 2;
    popupQuery.destructiveButtonIndex = 2;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        lblChoose.hidden = YES;
        imgPhotoForEncrypt.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
}

/*-(UIImage*)ReduceImageSize:(UIImage*)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 640.0/960.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 960.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 960.0;
        }
        else{
            imgRatio = 640.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 640.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}*/

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)ImagePassForEncrypt:(UIImage*)img
{
    lblChoose.hidden = YES;
    imgPhotoForEncrypt.image = img;
}

#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                
                NSMutableDictionary *dictshare=[[NSMutableDictionary alloc]init];
                
                if ([btnText isSelected])
                    [dictshare setObject:txtViewEncrypt.text forKey:@"descPianopass"];
                else
                    [dictshare setObject:@"" forKey:@"descPianopass"];
                
                if ([btnPicture isSelected])
                {
                    UIImage *imgReaizable = [imgPhotoForEncrypt.image imageReduceSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*2,[UIScreen mainScreen].bounds.size.height*2)];
                    [dictshare setObject:imgReaizable forKey:@"imgPianopass"];
                }
                
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
    }
    else if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0 || buttonIndex == 1)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if (buttonIndex == 0)
            {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else
            {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                }
            }
            NSArray *mediaTypesAllowed = [NSArray arrayWithObjects:@"public.image",nil];
            [imagePicker setMediaTypes:mediaTypesAllowed];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.wantsFullScreenLayout=TRUE;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            return;
        }
       
    }
}
#pragma mark - MFMailComposeController delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *strMesssage;
	switch (result)
	{
		case MFMailComposeResultCancelled:
            strMesssage = @"Mail cancelled: you cancelled the operation and no email message was queued";
			break;
		case MFMailComposeResultSaved:
            strMesssage = @"Mail saved: you saved the email message in the Drafts folder";
			break;
		case MFMailComposeResultSent:
            strMesssage = @"Mail send: the email message was sent";
			break;
		case MFMailComposeResultFailed:
            strMesssage = @"Mail failed: the email message was not saved or queued, possibly due to an error";
			break;
		default:
            strMesssage = @"Mail not sent";
			break;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:strMesssage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Self Methods
-(void)ResignAndSave
{
    NSString *strString = [txtViewEncrypt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strString length] == 0)
    {
        txtViewEncrypt.text=@"Enter text to encrypt...";
        txtViewEncrypt.textColor = [UIColor darkGrayColor];
    }
    else if (![txtViewEncrypt.text isEqualToString:@"Enter text to encrypt..."])
    {
    }
    if (isiPhone5)
    {
        txtViewEncrypt.frame=CGRectMake(0, 0, 306, 347);
        toolBar.frame=CGRectMake(0,568, 320, 44);
    }
    else
    {
        txtViewEncrypt.frame=CGRectMake(0, 0, 306, 259);
        toolBar.frame=CGRectMake(0,480, 320, 44);
    }
    [txtViewEncrypt resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    [UIView commitAnimations];
    
}
-(void)OpenActionSheet
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Send Email",@"Cancel",nil];
    popupQuery.tag=1;
    popupQuery.destructiveButtonIndex = 1;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
}

#pragma mark TextView Delegate Methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([txtViewEncrypt.text isEqualToString:@"Enter text to encrypt..."])
    {
        txtViewEncrypt.text=@"";
        txtViewEncrypt.textColor = [UIColor blackColor];
    }
    if (isiPhone5)
    {
        txtViewEncrypt.frame=CGRectMake(0, 0, 306, 148);
        toolBar.frame=CGRectMake(0,292, 320, 44);
    }
    else
    {
        txtViewEncrypt.frame=CGRectMake(0, 0, 306, 60);
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
