//
//  ContactsViewController.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactCustomCell.h"
#define ZERO_WIDTH_SPACE_STRING @"\u200B"

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    [[ViewSendRequest layer] setMasksToBounds:YES];
    [[ViewSendRequest layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ViewSendRequest layer] setBorderWidth:1.0f];
    
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    webData=[[NSMutableData alloc]init];
    tblview.alpha=0;

    
    arrallcontacts= [[NSMutableArray alloc]init];
    arraddedcontactsfulllist= [[NSMutableArray alloc]init];
    arraddedcontacts= [[NSMutableArray alloc]init];
    [self fetchIphoneContact];
}

#pragma mark - SEARCHBAR
-(IBAction)btnbackclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   
    [arraddedcontacts removeAllObjects];
    
    for (int i=0; i<[arraddedcontactsfulllist count]; i++) {
        NSRange range = [[[arraddedcontactsfulllist objectAtIndex:i] objectForKey:@"fullName"] rangeOfString :searchText options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arraddedcontacts addObject:[arraddedcontactsfulllist objectAtIndex:i]];
        }
    }
    
    [tblview reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchbar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchbar setShowsCancelButton:NO animated:YES];
    [searchbar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [arraddedcontacts removeAllObjects];
    
    for (int i=0; i<[arraddedcontactsfulllist count]; i++) {
        NSRange range = [[[arraddedcontactsfulllist objectAtIndex:i] objectForKey:@"fullName"] rangeOfString :searchbar.text options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound)
        {
            [arraddedcontacts addObject:[arraddedcontactsfulllist objectAtIndex:i]];
        }
    }
    
    [tblview reloadData];
    [searchbar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.text=@"";
    
    [arraddedcontacts removeAllObjects];
    [arraddedcontacts addObjectsFromArray:arraddedcontactsfulllist];
    [tblview reloadData];
    [searchbar resignFirstResponder];
}
*/
-(void)_addContactToAddressBook
{
    char *lastNameString, *firstNameString,*emailString;
	NSMutableArray *arrname =[[NSMutableArray alloc] init];
	NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	// AddressBook
	
	ABAddressBookRef ab = ABAddressBookCreate();
	CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(ab);
	CFIndex nPeople = ABAddressBookGetPersonCount(ab);
    

	for(int i = 0; i < nPeople; i++)
	{	
        [dict removeAllObjects];
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
    
		CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
		CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        ABMutableMultiValueRef multi = ABRecordCopyValue(ref, kABPersonEmailProperty);
        CFStringRef email;
        if (ABMultiValueGetCount(multi) > 0) {
            // collect all emails in array
            for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) 
            {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
                //[personDealingWithEmails addObject:(NSString *)emailRef];
                email=emailRef;
                CFRelease(emailRef);
            }
        }
        else
        {
            email=nil;
        }
        
		CFDataRef imgData;
		if(ABPersonHasImageData(ref))
        {
			imgData = ABPersonCopyImageData(ref);
		}else {
			imgData=nil;
		}
		
		static char* fallback = "";
		int fbLength = strlen(fallback);
		
		int firstNameLength = fbLength;
		bool firstNameFallback = true;
		
        int lastNameLength = fbLength;
		bool lastNameFallback = true;
        
        int emailLength = fbLength;
		bool emailFallback = true;
        
		if (firstName != NULL)
		{
			firstNameLength = (int) CFStringGetLength(firstName);
			firstNameFallback = false;
		}
		if (lastName != NULL)
		{
			lastNameLength = (int) CFStringGetLength(lastName);
			lastNameFallback = false;
		}
        if (email !=  NULL)
		{
			emailLength = (int) CFStringGetLength(email);
			emailFallback = false;
		}
        
        
		if (firstNameLength == 0)
		{
			firstNameLength = fbLength;
			firstNameFallback = true;
		}
		if (lastNameLength == 0)
		{
			lastNameLength = fbLength;
			lastNameFallback = true;
		}
        if (emailLength == 0)
		{
			emailLength = fbLength;
			emailFallback = true;
		}
        
		
		firstNameString = malloc(sizeof(char)*(firstNameLength+1));
		lastNameString = malloc(sizeof(char)*(lastNameLength+1));
        emailString = malloc(sizeof(char)*(emailLength+1));
        
		if (firstNameFallback == true)
		{
			strcpy(firstNameString, fallback);
		}
		else
		{
			CFStringGetCString(firstName, firstNameString, 10*CFStringGetLength(firstName), kCFStringEncodingASCII);
		}
		
		if (lastNameFallback == true)
		{
			strcpy(lastNameString, fallback);
		}
		else
		{
			CFStringGetCString(lastName, lastNameString, 10*CFStringGetLength(lastName), kCFStringEncodingASCII);
		}
		
		if (emailFallback == true)
		{
			strcpy(emailString, fallback);
		}
		else
		{
			CFStringGetCString(email, emailString, 10*CFStringGetLength(email), kCFStringEncodingASCII);
		}
        
		//printf("%d.\t%s %s\n", i, firstNameString, lastNameString);
		NSString *fname= [NSString stringWithFormat:@"%s",firstNameString];
		NSString *lname= [NSString stringWithFormat:@"%s",lastNameString];
        NSString *fullName=[NSString stringWithFormat:@"%@%@%@",fname,([fname length]!=0)?@" ":@"",lname];
		NSString *eMail= [NSString stringWithFormat:@"%s",emailString];
		NSData *myData;
		if (imgData) {
			myData=(__bridge NSData *)imgData;
		}else {
			myData=nil;
		}
        
		
		//fetch Phone num
		ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(ref, kABPersonPhoneProperty);
		NSArray* phoneNumbers = (__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
		CFRelease(phoneNumberProperty);
		
		NSString *PhoneNum = [phoneNumbers objectAtIndex:0];
		
		NSString *originalString = PhoneNum;
		
		NSMutableString *strippedString = [NSMutableString 
										   stringWithCapacity:originalString.length];
		
		NSScanner *scanner = [NSScanner scannerWithString:originalString];
		NSCharacterSet *numbers = [NSCharacterSet 
								   characterSetWithCharactersInString:@"0123456789"];
		
		while ([scanner isAtEnd] == NO) {
			NSString *buffer;
			if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
				[strippedString appendString:buffer];
				
			} else {
				[scanner setScanLocation:([scanner scanLocation] + 1)];
			}
		}
		
		if([fname isEqualToString:@""] && [lname isEqualToString:@""]){
			
		}else{
			
			if (myData) {
				UIImage *img = [UIImage imageWithData:myData];
				
				[dict setObject:img forKey:@"imgData"];			
			}
            
			[dict setValue:fname forKey:@"fname"];
			[dict setValue:lname forKey:@"lname"];
            [dict setValue:fullName forKey:@"fullName"];
            [dict setValue:eMail forKey:@"email"];
			[dict setValue:strippedString forKey:@"phoneNumber"];
			[arrname addObject:[dict copy]];
		}
		
		if (firstName != NULL)
		{
			CFRelease(firstName);
		}
		if (imgData != NULL)
		{
			CFRelease(imgData);
		}
		if (lastName != NULL)
		{
			CFRelease(lastName);
		}
        if (email != NULL)
		{
			CFRelease(email);
		}
		free(firstNameString);
		free(lastNameString);
		free(emailString);
	}
	
	
	for (int i=0; i<[arrname count]; i++) 
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
		[dict setValue:@"0" forKey:@"sel"];
		[arrTemp addObject:dict];
	}
    
    [arrallcontacts addObjectsFromArray:arrname];
    
    for (int j=0; j<[arrallcontacts count]; j++) 
    {
        if([[[arrallcontacts objectAtIndex:j] objectForKey:@"phoneNumber"] length]>0)
        {
            [arraddedcontactsfulllist addObject:[arrallcontacts objectAtIndex:j]];
        }
    }
    
    NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
    NSArray *sorted = [arraddedcontactsfulllist sortedArrayUsingDescriptors:descriptors];
    [arraddedcontactsfulllist removeAllObjects];
    [arraddedcontactsfulllist addObjectsFromArray:sorted];
    [arraddedcontacts addObjectsFromArray:sorted];

    [self SetArrayWithSection];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    tblview.alpha=1;
    [UIView commitAnimations];
    [tblview reloadData];
}
-(void)SetArrayWithSection
{
    NSMutableArray *LatterArray = [[NSMutableArray alloc] init];
    [LatterArray addObject:@"A"];
    [LatterArray addObject:@"B"];
    [LatterArray addObject:@"C"];
    [LatterArray addObject:@"D"];
    [LatterArray addObject:@"E"];
    [LatterArray addObject:@"F"];
    [LatterArray addObject:@"G"];
    [LatterArray addObject:@"H"];
    [LatterArray addObject:@"I"];
    [LatterArray addObject:@"J"];
    [LatterArray addObject:@"K"];
    [LatterArray addObject:@"L"];
    [LatterArray addObject:@"M"];
    [LatterArray addObject:@"N"];
    [LatterArray addObject:@"O"];
    [LatterArray addObject:@"P"];
    [LatterArray addObject:@"Q"];
    [LatterArray addObject:@"R"];
    [LatterArray addObject:@"S"];
    [LatterArray addObject:@"T"];
    [LatterArray addObject:@"U"];
    [LatterArray addObject:@"V"];
    [LatterArray addObject:@"W"];
    [LatterArray addObject:@"X"];
    [LatterArray addObject:@"Y"];
    [LatterArray addObject:@"Z"];
    [LatterArray addObject:@"#"];
    
    valueArray = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [LatterArray count]; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
       
        NSMutableArray *temp = [[NSMutableArray alloc]init];
            for (int j = 0; j < [arraddedcontacts count]; j++){
                NSString *str = [[arraddedcontacts objectAtIndex:j]objectForKey:@"fullName"];
                NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
                NSRange r = [[[str substringToIndex:1]uppercaseString] rangeOfCharacterFromSet:s];
                if ([[LatterArray objectAtIndex:i] isEqualToString:[[str substringToIndex:1]uppercaseString]]) {
                    [temp addObject:[arraddedcontacts objectAtIndex:j]];
                }
                else if (r.location == NSNotFound && [[LatterArray objectAtIndex:i] isEqualToString:@"#"])
                {
                    [temp addObject:[arraddedcontacts objectAtIndex:j]];
                }
            }
        
        if ([temp count]) {
            [dict setObject:[LatterArray objectAtIndex:i] forKey:@"key"];
            [dict setObject:temp forKey:@"value"];
            [array addObject:dict];
        }
    }
    
    if (valueArray.count > 0)
        [valueArray removeAllObjects];
    
    valueArray = array;
    
}
-(void)fetchIphoneContact
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
    {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                [self _addContactToAddressBook];
                //[tblview reloadData];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            [self _addContactToAddressBook];
            //[tblview reloadData];
        }
        else {
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
            DisplayAlertWithTitle(APP_Name,@"To access your contacts from Suvi, please go to Settings>Privacy>Contacts>Suvi>ON");
        }

    }
    else
    {
        [self _addContactToAddressBook];

    }
}
#pragma mark - INVITE
-(IBAction)btnInvite:(id)sender
{
    NSMutableArray *contactarray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",[[arraddedcontacts objectAtIndex:[sender tag]] objectForKey:@"phoneNumber"]], nil];
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    if (picker)
    {
        picker.messageComposeDelegate = self;
        picker.navigationBar.tintColor=[UIColor blackColor];
        picker.recipients=contactarray;
        
        NSString *strfname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_fname"]];
        NSString *strlname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_lname"]];
        NSString *strfullName=[NSString stringWithFormat:@"%@%@%@",strfname,([strfname length]!=0 && [strlname length]!=0)?@" ":@"",strlname];
        
        NSString *strInvitation=[NSString stringWithFormat:@"%@ wants to connect!\nJoin Suvi today.\n Free app: %@",strfullName,kAppStoreURL];
        
        picker.body=strInvitation;
        
        [self presentModalViewController:picker animated:YES];
    }
}
-(void)btnInviteClicked:(id)sender
{
    NSMutableArray *contactarray=[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",[sender currentTitle]], nil];
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    if (picker)
    {
        picker.messageComposeDelegate = self;
        picker.navigationBar.tintColor=[UIColor blackColor];
        picker.recipients=contactarray;
        
        NSString *strfname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_fname"]];
        NSString *strlname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_lname"]];
        NSString *strfullName=[NSString stringWithFormat:@"%@%@%@",strfname,([strfname length]!=0 && [strlname length]!=0)?@" ":@"",strlname];
        
        NSString *strInvitation=[NSString stringWithFormat:@"%@ wants to connect!\nJoin Suvi today.\n Free app: %@",strfullName,kAppStoreURL];
        
        picker.body=strInvitation;
        
        [self presentModalViewController:picker animated:YES];
    }
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([valueArray count]==0)
    {
        return 0;
    }
    else
    {
        return [valueArray count];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[valueArray objectAtIndex:section]objectForKey:@"value"] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[valueArray objectAtIndex:section]objectForKey:@"key"];
    
}
/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return LatterArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [LatterArray indexOfObject:title];
}*/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [valueArray valueForKey:@"key"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[valueArray valueForKey:@"key"] indexOfObject:title];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSMutableDictionary *allInfoDict = [[[valueArray objectAtIndex:indexPath.section] objectForKey:@"value"] objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font  = [UIFont boldSystemFontOfSize:18.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"fullName"]];
    cell.textLabel.textAlignment=UITextAlignmentLeft;
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAdd.frame = CGRectMake(260, 5, 29, 29);
    [btnAdd setTitle:[NSString stringWithFormat:@"%@",[allInfoDict objectForKey:@"phoneNumber"]] forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnInviteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnAdd];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(15.0,39.0,290.0,1.0)];
    viewSeparater.backgroundColor=[UIColor darkGrayColor];
    [cell.contentView addSubview:viewSeparater];
    
    // Configure the cell.
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark - Send Request Through Mail or Phone no
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
-(BOOL)validPhone:(NSString*) phoneString
{
    NSString *regExPattern = @"^[0-9]";
    NSString *strFinalPhone=[phoneString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *strFinalPhone2=[strFinalPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:strFinalPhone2 options:0 range:NSMakeRange(0, [strFinalPhone2 length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(void)sendEmailInvite
{
    [action setString:@"invitefriends"];
    [actionurl setString:kSendInviteViaEmailURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDs=%@&sometext=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[txtInviteId.text removeNull],@"Invite text"]];
    [self _startSend];
}
-(void)sendSMSInvite
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        NSString *strFinalPhone=[txtInviteId.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *strFinalPhone2=[strFinalPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        controller.recipients = [NSArray arrayWithObjects:strFinalPhone2, nil];
        controller.messageComposeDelegate = self;
        
        NSString *strfname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_fname"]];
        NSString *strlname=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"] valueForKey:@"admin_lname"]];
        NSString *strfullName=[NSString stringWithFormat:@"%@%@%@",strfname,([strfname length]!=0 && [strlname length]!=0)?@" ":@"",strlname];
        
        NSString *strInvitation=[NSString stringWithFormat:@"%@ wants to connect!\nJoin Suvi today.\n Free app: %@",strfullName,kAppStoreURL];
        
        controller.body=strInvitation;
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
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            
        }
            break;
            
        case MessageComposeResultSent:
        {
            txtInviteId.text=@"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invitation sent successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Message sending failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Message sending failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *strInviteEmail=[NSString stringWithFormat:@"%@",[textField.text removeNull]];
    if ([strInviteEmail length]==0)
    {
        
    }
    else if([self validEmail:strInviteEmail])
    {
        [self sendEmailInvite];
    }
    else if([self validPhone:strInviteEmail])
    {
        [self sendSMSInvite];
    }
    else
    {
        DisplayAlert(@"Enter valid email-id or phone no.!");
    }
    
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - Webservice Called
-(void)_startSend
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [[AppDelegate sharedInstance]showLoader];
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[actionparameters stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",actionurl]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString
{
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
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
-(void)setData:(NSDictionary*)dictionary
{
    [[AppDelegate sharedInstance]hideLoader];
    
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }
    else
    {
        NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            if([action isEqualToString:@"invitefriends"])
            {
                txtInviteId.text=@"";
                DisplayAlert(@"Friend Invited Successfully!");
            }
        }
        else
        {
            if ([[strMSG removeNull]length]>0)
            {
                DisplayAlertWithTitle(APP_Name, strMSG);
            }
            
            return;
        }
    }
}

#pragma mark - DEFAULT
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

@end
