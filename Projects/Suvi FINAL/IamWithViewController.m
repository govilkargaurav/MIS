//
//  IamWithViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IamWithViewController.h"
#import "IamWithContactsCustomCell.h"
#define ZERO_WIDTH_SPACE_STRING @"\u200B"
#import <AddressBookUI/AddressBookUI.h>

@implementation IamWithViewController
@synthesize arrsuvifriends,arraddressbookcontacts;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];

    arrallcontacts= [[NSMutableArray alloc]init];
    arraddedcontactsfulllist= [[NSMutableArray alloc]init];
    arrremainingcontactsfullist= [[NSMutableArray alloc]init];
    webData=[[NSMutableData alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
	
	_toRecipients = [[NSMutableArray alloc] init];
	_toField = [[JSTokenField alloc] initWithFrame:CGRectMake(0, 0, 320,31)];
    _toField.textField.keyboardAppearance=UIKeyboardAppearanceAlert;
    scrollContact=[[UIScrollView alloc]init];
    scrollContact.frame=CGRectMake(0, 0, 320,31);
    scrollContact.contentSize=CGSizeMake(320, 31);
	[[_toField label] setText:@"I'm with:"];
    [_toField setBackgroundColor:[UIColor clearColor]];
	[_toField setDelegate:self];
	[scrollContact addSubview:_toField];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, _toField.bounds.size.height-1, _toField.bounds.size.width, 1)];
    [separator1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_toField addSubview:separator1];
    [separator1 setBackgroundColor:[UIColor lightGrayColor]];
    tblview.tableHeaderView=scrollContact;
    
    if ([arrsuvifriends count]==0)
    {
        tblview.alpha=0;
        [self fetchIphoneContact];
    }
    else
    {
        for (int i=0; i<[arrsuvifriends count]; i++) {
            if ([[arrsuvifriends objectAtIndex:i] objectForKey:@"isselected"]) 
            {
                if ([[[arrsuvifriends objectAtIndex:i] objectForKey:@"isselected"] intValue]==1) 
                {
                    NSMutableString *recipient = [NSMutableString string];	
                    NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
                    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
                    NSString *rawStr =[NSString stringWithFormat:@"%@",[[arrsuvifriends objectAtIndex:i] objectForKey:@"FULL_NAME"]];
                    NSString *rawStrEx =[NSString stringWithFormat:@"%d",(i+1000)];
                    
                    for (int i = 0; i < [rawStr length]; i++)
                    {
                        if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
                        {
                            [recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
                        }
                    }
                    
                    if ([rawStr length])
                    {
                        [_toField addTokenWithTitle:rawStr representedObject:rawStrEx];
                    }
                }
            }
        }
        
        for (int i=0; i<[arraddressbookcontacts count]; i++) {
            if ([[arraddressbookcontacts objectAtIndex:i] objectForKey:@"isselected"])
            {
                if ([[[arraddressbookcontacts objectAtIndex:i] objectForKey:@"isselected"] intValue]==1) 
                {                    
                    NSMutableString *recipient = [NSMutableString string];	
                    NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
                    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
                    NSString *rawStr =[NSString stringWithFormat:@"%@",[[arraddressbookcontacts objectAtIndex:i] objectForKey:@"FULL_NAME"]];
                    NSString *rawStrEx =[NSString stringWithFormat:@"%d",(i+5000)];
                    
                    for (int i = 0; i < [rawStr length]; i++)
                    {
                        if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
                        {
                            [recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
                        }
                    }
                    
                    if ([rawStr length])
                    {
                        [_toField addTokenWithTitle:rawStr representedObject:rawStrEx];
                    }
                }
            }
        }
    }
    
    
    [tblview reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnDoneClicked:(id)sender
{
    NSDictionary *tempdict=[NSDictionary dictionaryWithObjectsAndKeys:arrsuvifriends,@"friendsarray",arraddressbookcontacts,@"contactsarray",nil];

    NSInteger selectedfriends=0;
      
    for (int i=0; i<[arrsuvifriends count]; i++) 
    {
        if ([[arrsuvifriends objectAtIndex:i] objectForKey:@"isselected"]) {
            if ([[[arrsuvifriends objectAtIndex:i] objectForKey:@"isselected"] intValue]==1) 
            {
                selectedfriends++;
            }
        }
    }
    
    for (int i=0; i<[arraddressbookcontacts count]; i++) {
        if ([[arraddressbookcontacts objectAtIndex:i] objectForKey:@"isselected"])
        {
            if ([[[arraddressbookcontacts objectAtIndex:i] objectForKey:@"isselected"] intValue]==1) 
            {
                selectedfriends++;
            }
        }
    }

    if (selectedfriends<=0)
    {
        DisplayAlertWithTitle(APP_Name, @"Please Select Contact");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IAmWith" object:nil userInfo:tempdict];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchIphoneContact
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
    {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                [self _addContactToAddressBook];
                [tblview reloadData];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            [self _addContactToAddressBook];
            [tblview reloadData];
        }
        else
        {
            [self performSelector:@selector(_startSend) withObject:nil afterDelay:0.0000001];
            DisplayAlertWithTitle(APP_Name, @"You can change your privacy setting in settings app");
        }
    }
    else
    {
        [self _addContactToAddressBook];
    }
}
-(void)_addContactToAddressBook
{
    char *lastNameString, *firstNameString,*emailString;
	NSMutableArray *arrname =[[NSMutableArray alloc] init];
	NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
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
            for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) 
            {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
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
        
		printf("%d.\t%s %s\n", i, firstNameString, lastNameString);
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
		
		if([fname isEqualToString:@""] && [lname isEqualToString:@""])
        {
			
		}
        else
        {
			if (myData) {
				UIImage *img = [UIImage imageWithData:myData];
				
				[dict setObject:img forKey:@"imgData"];			
			}
            
			[dict setValue:fname forKey:@"fname"];
			[dict setValue:lname forKey:@"lname"];
            [dict setValue:fullName forKey:@"FULL_NAME"];
            [dict setValue:eMail forKey:@"email"];
			[dict setValue:strippedString forKey:@"phoneNumber"];
            [dict setValue:@"0" forKey:@"isselected"];
			[arrname addObject:[dict mutableCopy]];
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
    
    NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"FULL_NAME" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
    [arrremainingcontactsfullist addObjectsFromArray:arrallcontacts];
    NSArray *sorted2 = [arrremainingcontactsfullist sortedArrayUsingDescriptors:descriptors];
    [arrremainingcontactsfullist removeAllObjects];
    [arrremainingcontactsfullist addObjectsFromArray:sorted2];
    [arraddressbookcontacts removeAllObjects];
    [arraddressbookcontacts addObjectsFromArray:sorted2];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    tblview.alpha=1;
    [UIView commitAnimations];
    [tblview reloadData]; 
    
    [self performSelector:@selector(_startSend) withObject:nil afterDelay:0.0000001];
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
        [[AppDelegate sharedInstance] showLoaderWithtext:@"Loading Contacts..." andDetailText:@"Please Wait"];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",getFriendList]]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    [self _stopReceiveWithStatus:@"Connection failed"];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [self _stopReceiveWithStatus:strData];
}
-(void)_stopReceiveWithStatus:(NSString *)statusString{    
    [self _receiveDidStopWithStatus:statusString];
}
-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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
-(void)setData:(NSMutableDictionary*)dictionary
{
    [[AppDelegate sharedInstance]hideLoader];
    
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }
    
    
    NSString *strMSG =[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"MESSAGE"]] ;
    if ([strMSG isEqualToString:@"SUCCESS"]) 
    {
        NSMutableArray *temparray=[[NSMutableArray alloc]init];
        [temparray addObjectsFromArray:[dictionary objectForKey:@"FRIENDS_DETAILS"]];
        
        for (int i=0; i<[temparray count]; i++)
        {
            NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
            [tempdict addEntriesFromDictionary:[temparray objectAtIndex:i]];
            [arraddedcontactsfulllist addObject:tempdict];
        }
        
        NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"FULL_NAME" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
        NSArray *sorted = [arraddedcontactsfulllist sortedArrayUsingDescriptors:descriptors];
        [arraddedcontactsfulllist removeAllObjects];
        [arraddedcontactsfulllist addObjectsFromArray:sorted];
        [arrsuvifriends removeAllObjects];
        [arrsuvifriends addObjectsFromArray:sorted];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        tblview.alpha=1;
        [UIView commitAnimations];
        [tblview reloadData]; 
    }
    else
    {
        DisplayAlertWithTitle(APP_Name, strMSG);
        return;
    }
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (([arrsuvifriends count]==0) && ([arraddressbookcontacts count]==0)){
        return 0;
    }
    else if (([arrsuvifriends count]==0) || ([arraddressbookcontacts count]==0))
    {
        return 1;
    }
    else
    {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isSuviFriendSection = ((section==0) && ([arrsuvifriends count]>0))?YES:NO;
    return (isSuviFriendSection)?[arrsuvifriends count]:[arraddressbookcontacts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    IamWithContactsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[IamWithContactsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    BOOL isSuviFriendSection = ((indexPath.section==0) && ([arrsuvifriends count]>0))?YES:NO;
    
    cell.lblcontactname.text=[NSString stringWithFormat:@"%@",[[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"]];
    
    if (isSuviFriendSection)
    {
        NSString *strimageurl=[NSString stringWithFormat:@"%@",[[arrsuvifriends objectAtIndex:indexPath.row] objectForKey:@"image_path"]];
        [cell.imgview setImageWithURL:[NSURL URLWithString:[strimageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    }
    else
    {
        cell.imgview.image=([[arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"imgData"])?[[arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"imgData"]:[UIImage imageNamed:@"profileUser.png"];
    }
    
    if ([[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"isselected"])
    {
        if ([[[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"isselected"] intValue]==0)
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,43.0,320.0,1.0)];
    viewSeparater.backgroundColor=[UIColor darkGrayColor];
    [cell.contentView addSubview:viewSeparater];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lblheader=[[UILabel alloc]init];
    lblheader.frame=CGRectMake(0, 0, 320,22);
    lblheader.textColor=[UIColor whiteColor];
    lblheader.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"greytransbg.png"]];
    
    BOOL isSuviFriendSection = ((section==0) && ([arrsuvifriends count]>0))?YES:NO;
    lblheader.text=[NSString stringWithFormat:@"  %@",(isSuviFriendSection)?@"Friends":@"Contacts"];
    return lblheader;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isSelected=NO;
    BOOL isSuviFriendSection=((indexPath.section==0) && ([arrsuvifriends count]>0))?YES:NO;
    
    if (![[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"isselected"])
    {
        [[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] setObject:@"0" forKey:@"isselected"];
    }
    
    isSelected=([[[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"isselected"] intValue]==0)?NO:YES;
    
    [[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] setObject:(isSelected)?@"0":@"1" forKey:@"isselected"];
    
    if (isSelected)
    {
        NSString *rawStr =[NSString stringWithFormat:@"%@",[[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"]];
        NSString *rawStrEx =[NSString stringWithFormat:@"%d",(indexPath.row+(isSuviFriendSection)?1000:5000)];
        if ([rawStr length])
        {
            [_toField removeTokenWithRepresentedObject:rawStrEx];
        }
    }
    else
    {
        NSMutableString *recipient = [NSMutableString string];
        NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
        [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        NSString *rawStr =[NSString stringWithFormat:@"%@",[[(isSuviFriendSection)?arrsuvifriends:arraddressbookcontacts objectAtIndex:indexPath.row] objectForKey:@"FULL_NAME"]];
        NSString *rawStrEx =[NSString stringWithFormat:@"%d",(indexPath.row+(isSuviFriendSection)?1000:5000)];
        
        for (int i = 0; i < [rawStr length]; i++)
        {
            if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
            {
                [recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
            }
        }
        
        if ([rawStr length])
        {
            [_toField addTokenWithTitle:rawStr representedObject:rawStrEx];
        }
    }

     [self maintainscroll];
     [tblview reloadData];
     [_toField.textField resignFirstResponder];
     [tblview reloadData];
}

#pragma mark - JSTokenField
- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
    BOOL istagfound=NO;
    int tagindex;
    
    for (int i=0; i<[_toRecipients count]; i++)
    {
        NSString *strTemp=[NSString stringWithFormat:@"%@",[_toRecipients objectAtIndex:i]];
        if ([strTemp intValue]==[[NSString stringWithFormat:@"%@",obj] intValue]) {
            istagfound=YES;
            tagindex=i;
        }
    }
    
    if (!istagfound) {
        [_toRecipients addObject:[NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@",obj] intValue]]];
    }
    
    [tblview reloadData];
    [_toField.textField resignFirstResponder];
}
- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
}
-(void)tokenField:(JSTokenField *)tokenField didRemoveToken:(NSString *)title representedObject:(id)obj
{
    BOOL istagfound=NO;
    int tagindex;
    NSInteger tableremoveindex;
    
    for (int i=0; i<[_toRecipients count]; i++)
    {
        NSString *strTemp=[NSString stringWithFormat:@"%@",[_toRecipients objectAtIndex:i]];
        if ([strTemp intValue]==[[NSString stringWithFormat:@"%@",obj] intValue]) {
            istagfound=YES;
            tagindex=i;
            tableremoveindex=[strTemp integerValue];
        }
    }
    
    if (istagfound)
    {
        [_toRecipients removeObjectAtIndex:tagindex];
        
        if (tableremoveindex>=5000) {
            [[arraddressbookcontacts objectAtIndex:(tableremoveindex-5000)] setObject:@"0" forKey:@"isselected"];
        }
        else
        {
            [[arrsuvifriends objectAtIndex:(tableremoveindex-1000)] setObject:@"0" forKey:@"isselected"];
        }
    }
    
    [tblview reloadData];
    [_toField.textField resignFirstResponder];
}
- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField
{
    tokenField.textField.text=@"";
    NSMutableString *recipient = [NSMutableString string];
	NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[recipient appendFormat:@"%@%@",ZERO_WIDTH_SPACE_STRING,[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:recipient];
	}
    
    [self maintainscroll];
    
    [tblview reloadData];
    [tokenField.textField resignFirstResponder];
    
    return NO;
}
- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
    [self maintainscroll];
    tblview.tableHeaderView=scrollContact;
}
-(void)maintainscroll
{
    if (_toField.frame.size.height>31)
    {
        scrollContact.frame=CGRectMake(0, 0, 320,62);
        scrollContact.contentSize=CGSizeMake(320,_toField.frame.size.height);
        scrollContact.contentOffset=CGPointMake(0,scrollContact.contentSize.height-scrollContact.frame.size.height);
    }
    else{
        scrollContact.frame=CGRectMake(0, 0, 320,31);
        scrollContact.contentSize=CGSizeMake(320, 31);
    }
}

#pragma mark -
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
