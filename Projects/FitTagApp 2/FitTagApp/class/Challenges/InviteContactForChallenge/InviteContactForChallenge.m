//
//  InviteContactForChallenge.m
//  FitTag
//
//  Created by Shivam on 3/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InviteContactForChallenge.h"
#import "TimeLineViewController.h"

@implementation InviteContactForChallenge
@synthesize tblViewUsers;
@synthesize mutArraEmailIds,mutArrSelectedUserForInvitation;
@synthesize strChallengeName;

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    appDelegateRefrence = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBarHidden = NO;
    UIButton *btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone addTarget:self action:@selector(donButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setFrame:CGRectMake(0, 0, 50, 30)];
    [btnDone setImage:[UIImage imageNamed:@"btnSmallDone.png"] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50,30)];
    [view addSubview:btnDone];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-11;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    // Back button customization
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    mutArrSelectedUserForInvitation = [[NSMutableArray alloc]init];
}
// Pop viewcontroller for back action
-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidUnload{
    [super viewDidUnload];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Request authorization to Address Book
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self addContactToAddressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addContactToAddressBook];
    }
    else {
        // The user has previously denied access
        DisplayAlertWithTitle(@"FitTag", @"You have denied the app for access contach information. Please change your application setting.")
    }
}
-(void)addContactToAddressBook{
 //   addressBook = ABAddressBookCreate();
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook,
                                                 ^(bool granted, CFErrorRef error){
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
     CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
     NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
     for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSString *firstName =  (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName =  [appDelegateRefrence removeNull:(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty)];
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
            NSMutableDictionary *dictEmailAndName = [[NSMutableDictionary alloc]init];
            if(j > 0){
                // We want only one email id so keep email id of zero index
            }else{
                [dictEmailAndName setObject:email forKey:@"emailid"];
                [dictEmailAndName setObject:[NSString stringWithFormat:@"%@ %@", firstName,lastName ] forKey:@"name"];
                [allEmails addObject:dictEmailAndName];
                
            }
        }
        CFRelease(emails);
    }
    CFRelease(addressBook);
    CFRelease(people);
    self.mutArraEmailIds = [allEmails copy];
    [tblViewUsers reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mutArraEmailIds count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   // cell.backgroundColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.mutArraEmailIds objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([self isUserSelected:[[mutArraEmailIds objectAtIndex:indexPath.row]objectForKey:@"emailid"]]){
        [mutArrSelectedUserForInvitation removeObject:[[mutArraEmailIds objectAtIndex:indexPath.row]objectForKey:@"emailid"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [mutArrSelectedUserForInvitation addObject:[[mutArraEmailIds objectAtIndex:indexPath.row]objectForKey:@"emailid"]];    
    }
}

-(BOOL)isUserSelected:(NSString *)strEmailId{
    for (NSString *srtEmail in mutArrSelectedUserForInvitation){
        if([srtEmail isEqualToString:strEmailId])
            return YES;
        
    }
    return NO;
}
#pragma mark - Done button
-(IBAction)donButtonCliked:(id)sender{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"%@ just challenged you on FitTag",[PFUser currentUser].username]];
        NSArray *toRecipients = mutArrSelectedUserForInvitation;
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = [NSString stringWithFormat:@"%@ just challenged you on FitTag (www.fittagapp.com). Do you accept the challenge? ",[PFUser currentUser].username];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:TRUE completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - MFMailComposeController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	switch (result){
		case MFMailComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
			break;
		case MFMailComposeResultSaved:{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self getFirstChallenge];
            NSArray *array = [self.navigationController viewControllers];
            for(int i=0;i<array.count;i++){
                if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                    [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                    break;
                }
            }
            break;
        }
			break;
		case MFMailComposeResultSent:{
            [self dismissViewControllerAnimated:YES completion:nil];
            [self getFirstChallenge];
            NSArray *array = [self.navigationController viewControllers];
            for(int i=0;i<array.count;i++){
                if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                    [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                    break;
                }
            }
                break;
        }
		case MFMailComposeResultFailed:
            [self dismissViewControllerAnimated:YES completion:nil];
			break;
		default:
			break;
	}
}
-(void)getFirstChallenge
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
    [postQuery whereKey:@"challengeName" equalTo:self.strChallengeName];
    [postQuery addDescendingOrder:@"createdAt"];
    [postQuery includeKey:@"userId"];
    [postQuery whereKeyExists:@"objectId"];
    NSMutableArray *arrFirstChallenge = [[postQuery findObjects] mutableCopy];
    [appDelegateRefrence.arrUserFirstChallenge removeAllObjects];
    appDelegateRefrence.arrUserFirstChallenge=arrFirstChallenge;
}
@end
