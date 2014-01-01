//
//  SignUpViewController.m
//  Suvi
//
//  Created by apple on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "TermsOfUseViewController.h"
#import "AutocompletionTableView.h"

@interface SignUpViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation SignUpViewController
@synthesize alltextfield;
@synthesize strsEmail,strsPassword,isProfileCreated,isSignUpFromFB,dictFacebook;
@synthesize autoCompleter = _autoCompleter;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect theRect2=viewprofileupdate.frame;
    theRect2.origin.y+=iOS7ExHeight;
    viewprofileupdate.frame=theRect2;
    
    //strGender = @"Male";
    //[self radioButton:btnMale];
    
    webData = [[NSMutableData alloc]init];
    action=[[NSMutableString alloc]init];
    
    [self.view addSubview:viewprofileupdate];
    viewprofileupdate.alpha=0.0;
    
    isProfileCreated=NO;
    
    viewsignupbox.frame=CGRectMake(0, 0+(iPhone5ExHalfHeight/2.6f)+iOS7ExHeight, 320, 480+iPhone5ExHeight);
    
    btnDropDownMask=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 480+iPhone5ExHeight)];
    [self.view addSubview:btnDropDownMask];
    btnDropDownMask.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.1];
    btnDropDownMask.hidden=YES;
    
    [[AppDelegate sharedInstance] getalllocations];

    txtlocationname.text=[AppDelegate sharedInstance].strPrepopulatedAddress;
    [txtlocationname addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    firstNameField.text=[[dictFacebook objectForKey:@"first_name"] removeNull];
    lastNameField.text=[[dictFacebook objectForKey:@"last_name"] removeNull];
    
    if ([dictFacebook objectForKey:@"gender"])
    {
        BOOL isMale=([[[dictFacebook objectForKey:@"gender"] removeNull] isEqualToString:@"male"])?YES:NO;
        
        [btnMale setTitleColor:(isMale)?RGBCOLOR(71, 162, 134):RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        [btnFemale setTitleColor:(!isMale)?RGBCOLOR(71, 162, 134):RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        strGender =(isMale)?@"Male":@"Female";
    }
    
    if ([dictFacebook objectForKey:@"birthday"])
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        
        NSString *strBday=[[dictFacebook objectForKey:@"birthday"] removeNull];
        
        if ([strBday length]>6)
        {
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            
            NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
            NSDateFormatter *dateFormatter3=[[NSDateFormatter alloc]init];
            
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter3 setDateFormat:@"LLL. MM, yyyy"];
            
            NSDate *theBD = [dateFormatter dateFromString:strBday];
            dateofbirth = [dateFormatter2 stringFromDate:theBD];
            txtBirthDate.text=[dateFormatter3 stringFromDate:theBD];
        }
    }
}


#pragma mark - MALE FEMALE SELECTION
-(IBAction)radioButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btnMale setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    [btnFemale setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(71, 162, 134) forState:UIControlStateNormal];
    strGender = btn.titleLabel.text;
}

#pragma mark - IMAGE UPDATE

-(IBAction)btnProfileImageClicked:(id)sender
{
    [alltextfield resignFirstResponder];
    
    isselectedimagecover=NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 1;
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)btnCoverImageClicked:(id)sender
{
    [alltextfield resignFirstResponder];
    
    isselectedimagecover=YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallery", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.tag = 1;
	[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (actionSheet.tag)
    {
        case 1:
			switch (buttonIndex){
                case 0:
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        picker.delegate = self;
                        picker.allowsEditing =YES;
                        [self presentModalViewController:picker animated:YES];
                    }
                }
                break;
                    
                case 1:
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    picker.delegate = self;
                    picker.allowsEditing =YES;
                    [self presentModalViewController:picker animated:YES];
                }
                break;
            }
            break;

        case 1001:
            if (buttonIndex == 0)
            {
                txtBirthDate.text =  [self setDateViaPicker:[datepiker date]];
            }
            break;
            
		default:
			break;
	}
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage *resultingImage = (isselectedimagecover)?[info objectForKey:UIImagePickerControllerEditedImage]:[info objectForKey:UIImagePickerControllerEditedImage];
    
    if (isselectedimagecover)
    {
        lblCoverImageTap.alpha=0.0;
        imgviewcover.image=resultingImage;
    }
    else
    {
        imgviewprofilepic.image=[resultingImage squareImage];
        imgviewprofilepic.contentMode=UIViewContentModeScaleAspectFit;
    }
    
    [self performSelector:@selector(_updateImage)];
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - DATEPICKER METHODS
-(IBAction)openDatePiker:(id)sender
{
    [alltextfield resignFirstResponder];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Select Date" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionsheet.tag = 1001;
    datepiker= [[UIDatePicker alloc]init];
    datepiker.datePickerMode=UIDatePickerModeDate;
    [actionsheet addSubview:datepiker];
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionsheet setBounds:CGRectMake(0,0,320, 516)];
    [datepiker setFrame:CGRectMake(0, 160, 320, 216)];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-13];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-22];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [datepiker setMaximumDate:maxDate];
    [datepiker setMinimumDate:minDate];
}
-(NSString *)setDateViaPicker:(NSDate *)datenew
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * selected1 = datenew;
    dateofbirth = [dateFormatter stringFromDate:selected1];
    NSDate * selected = datenew;
    
    [dateFormatter setDateFormat:@"LLL. MM, yyyy"];
	NSString * strDate = [dateFormatter stringFromDate:selected];
    return strDate;
}

#pragma mark - TEXTFIELD METHODS
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    alltextfield=textField;
    
    if (!IS_DEVICE_iPHONE_5)
    {
        if (textField==txtSchool)
        {
            CGRect viewFrame =viewprofileupdate.frame;
            viewFrame.origin.y-=11;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewprofileupdate setFrame:viewFrame];
            [UIView commitAnimations];
        }
    }
    
    if(textField==txtlocationname)
    {
        CGRect viewFrame = viewprofileupdate.frame;
        viewFrame.origin.y -=250.0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [viewprofileupdate setFrame:viewFrame];
        [UIView commitAnimations];
        
        btnDropDownMask.hidden=NO;
        [self.autoCompleter showSuggestionsForString:[txtlocationname.text removeNull]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!IS_DEVICE_iPHONE_5)
    {
        if (textField==txtSchool)
        {
            CGRect viewFrame =viewprofileupdate.frame;
            viewFrame.origin.y +=11;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewprofileupdate setFrame:viewFrame];
            [UIView commitAnimations];
        }
    }
    
    if(textField==txtlocationname)
    {
        CGRect viewFrame = viewprofileupdate.frame;
        viewFrame.origin.y +=250.0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [viewprofileupdate setFrame:viewFrame];
        [UIView commitAnimations];
        
        btnDropDownMask.hidden=YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField*) textField
{
    if (textField==txtlocationname)
    {
        NSMutableDictionary *userdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [userdict setObject:@"" forKey:@"iLocationID"];
        [userdict setObject:@"" forKey:@"vLocationName"];
        [userdict setObject:[txtlocationname.text removeNull] forKey:@"vCustomLocation"];
        [[NSUserDefaults standardUserDefaults]setObject:userdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        self.autoCompleter.hidden=YES;
    }

    [textField resignFirstResponder];
	return TRUE;
}
#pragma mark - AutoCompleteTableViewDelegate
-(AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:txtlocationname inViewController:self withOptions:options];
        _autoCompleter.tag=100;
        //_autoCompleter.delegate=self;
        _autoCompleter.suggestionsDictionary = [AppDelegate sharedInstance].arrlocations;
    }
    return _autoCompleter;
}
- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return [AppDelegate sharedInstance].arrlocations;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
    
    NSString *strLocationName=[NSString stringWithFormat:@"%@",[[self.autoCompleter.suggestionsListed objectAtIndex:index] objectForKey:@"locationname"]];
    NSString *strLocationId=[NSString stringWithFormat:@"%@",[[self.autoCompleter.suggestionsListed objectAtIndex:index] objectForKey:@"locid"]];
    
    NSMutableDictionary *userdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [userdict setObject:strLocationId forKey:@"iLocationID"];
    [userdict setObject:strLocationName forKey:@"vLocationName"];
    [userdict setObject:@"" forKey:@"vCustomLocation"];
    [[NSUserDefaults standardUserDefaults]setObject:userdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.autoCompleter.hidden=YES;
    btnDropDownMask.hidden=YES;
    [txtlocationname resignFirstResponder];
}

#pragma mark - BUTTON CLICK METHODS

-(IBAction)TermsAndCondi:(id)sender
{
    TermsOfUseViewController *objTermsOfUseViewController = [[TermsOfUseViewController alloc]initWithNibName:@"TermsOfUseViewController" bundle:nil];
    objTermsOfUseViewController.strTitle = @"Terms Of Use";
    objTermsOfUseViewController.strWebURL = kTermsOfUsePageURL;
    [self.navigationController pushViewController:objTermsOfUseViewController animated:YES];
}

-(IBAction)PrivacyPolicy:(id)sender
{
    TermsOfUseViewController *objTermsOfUseViewController = [[TermsOfUseViewController alloc]initWithNibName:@"TermsOfUseViewController" bundle:nil];
    objTermsOfUseViewController.strTitle = @"Privacy Policy";
    objTermsOfUseViewController.strWebURL = kPrivacyPolicy;
    [self.navigationController pushViewController:objTermsOfUseViewController animated:YES];
}

-(IBAction)backButton:(id)sender
{
    [alltextfield resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)DonePressed:(id)sender
{
    if (isProfileCreated)
    {
        [action setString:@"profile_update"];
        [self updateProfile];
    }
    else
    {
        [self signUpForaccount];
    }
}

-(void)signUpForaccount
{
    [alltextfield resignFirstResponder];

    if ([[firstNameField.text removeNull] isEqualToString:@""])
    {
        DisplayAlert(@"Please enter firstname.");
        return;
    }
    else if ([[lastNameField.text removeNull] isEqualToString:@""])
    {
        DisplayAlert(@"Please enter lastname.");
        return;
    }
    else if ([[dateofbirth removeNull] isEqualToString:@""])
    {
        DisplayAlert(@"Please select birthdate.");
        return;
    }
    else if ([[strGender removeNull]length]==0)
    {
        DisplayAlert(@"Please select gender.");
        return;
    }
    
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance]showLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [action setString:@"signup"];
        
        NSString  *urlstring = [NSString stringWithFormat:@"%@&admin_fname=%@&admin_lname=%@&admin_email=%@&admin_pwd=%@&eGender=%@&admin_mobile=%@&dDOB=%@&uname=%@&school=%@&device=%@",strRegistration,[firstNameField.text removeNull],[lastNameField.text removeNull],strsEmail,strsPassword,strGender,@"",[dateofbirth removeNull],@"",@"",[[NSUserDefaults standardUserDefaults] valueForKey:@"Device_Token"]];
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}

-(void)updateProfile
{
    [alltextfield resignFirstResponder];
    
//    if (!IS_DEVICE_iPHONE_5)
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.2];
//        [self.view setFrame:CGRectMake(0, 0, 320, 460)];
//        [UIView commitAnimations];
//    }
    
    NSArray *array=[NSArray arrayWithObjects:firstNameField.text,lastNameField.text,txtBirthDate.text, nil];
    for (int i=0; i<[array count]; i++)
    {
        NSString *getStr=[array objectAtIndex:i];
        getStr=[getStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([getStr isEqualToString:@""] || [getStr length]==0) {
            DisplayAlert(@"Please enter all information");
            return;
        }
    }
    
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance]showLoader];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSString *struserid=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_id"]];
        NSString *strDOB=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"dDOB"]];
        
        NSString  *urlstring = [NSString stringWithFormat:@"%@&admin_fname=%@&admin_lname=%@&admin_email=%@&school=%@&eGender=%@&dDOB=%@&admin_mobile=0&vCustomLocation=%@",strEditProfile,firstNameField.text,lastNameField.text,strsEmail,txtSchool.text,strGender,strDOB,txtlocationname.text];
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@",struserid] stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

-(void)_updateImage
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance]showLoader];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSData *imgData;
        NSString  *urlstring;
        [action setString:@"image_update"];
        
        if (isselectedimagecover)
        {
            imgData = UIImagePNGRepresentation(imgviewcover.image);
            imgviewcover.image=[imgviewcover.image cropCenterToSize:imgviewcover.frame.size];
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kCoverImageUpdateURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        else
        {
            imgData = UIImagePNGRepresentation(imgviewprofilepic.image);
            urlstring= [NSString stringWithFormat:@"%@&userID=%@",kProfileImageUpdateFirstTimeURL,[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        }
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.png\"\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imgData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}

-(void)updateschoolinprofile
{
    [action setString:@"school_update"];
    [self updateProfile];
}
-(IBAction)btnJoiningBackClicked:(id)sender
{
    [alltextfield resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    viewprofileupdate.alpha=0.0;
    [UIView commitAnimations];
}
-(IBAction)btnJoiningNextClicked:(id)sender
{
    [action setString:@"school_update"];
    [self updateProfile];
}

#pragma mark - WS METHODS
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString
{    
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [[AppDelegate sharedInstance]hideLoader];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        return;
    }
    else
    {
        NSError *error;
        NSData *storesData = [statusString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONReadingMutableLeaves error:&error];
        [self setData:dict];
    }
}
-(void)openloginviewcontroller
{
    [[NSUserDefaults standardUserDefaults]setValue:@"SignUPFirstTime" forKey:@"SignUP"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)setData:(NSMutableDictionary*)dictionary
{
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }

    NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]];
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    if ([strMSG isEqualToString:@"DATA NOT FOUND."])
    {
        if([action isEqualToString:@"school_update"])
        {
            [self openloginviewcontroller];
        }
        else if([action isEqualToString:@"profile_update"])
        {
            isProfileCreated=YES;
            
            if ((imgviewprofilepic.image==nil) || (imgviewprofilepic.image==[UIImage imageNamed:@"femaleIcon.png"]) || (imgviewprofilepic.image==[UIImage imageNamed:@"maleIcon.png"]) )
            {
                if ([strGender isEqualToString:@"Female"])
                {
                    imgviewprofilepic.image=[UIImage imageNamed:@"femaleIcon.png"];
                }
                else{
                    imgviewprofilepic.image=[UIImage imageNamed:@"maleIcon.png"];
                }
            }
            
            imgviewprofilepic.contentMode=UIViewContentModeScaleAspectFit;
            
            if (imgviewcover.image==nil)
            {
                lblCoverImageTap.alpha=0.0;
            }
            
            viewprofileupdate.alpha=1.0;
        }
    }
    else if ([strMSG isEqualToString:@"SUCCESS"])
    {
        NSMutableDictionary *tempdict =[[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"USER_DETAIL"]];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:tempdict forKey:@"USER_DETAIL"];
        [defaults synchronize];
        
        if ([action isEqualToString:@"signup"] || [action isEqualToString:@"profile_update"])
        {
            isProfileCreated=YES;
            
            if ((imgviewprofilepic.image==nil) || (imgviewprofilepic.image==[UIImage imageNamed:@"femaleIcon.png"]) || (imgviewprofilepic.image==[UIImage imageNamed:@"maleIcon.png"]) )
            {
                if ([strGender isEqualToString:@"Female"])
                {
                    imgviewprofilepic.image=[UIImage imageNamed:@"femaleIcon.png"];
                }
                else{
                    imgviewprofilepic.image=[UIImage imageNamed:@"maleIcon.png"];
                }
            }
            
            imgviewprofilepic.contentMode=UIViewContentModeScaleAspectFit;
            lblCoverImageTap.alpha=1.0;
            viewprofileupdate.alpha=1.0;
        }
        else if([action isEqualToString:@"image_update"])
        {
            
        }
        else if([action isEqualToString:@"school_update"])
        {
            [self openloginviewcontroller];
        }
    }
    else
    {
        DisplayAlert(strMSG);
        return;
    }
}

-(BOOL)validEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if (regExMatches == 0)
    {
        return NO;
    } 
    else
    {
        return YES;
    }
}

#pragma mark - DEFAULT Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

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
    [super didReceiveMemoryWarning];
}

@end
