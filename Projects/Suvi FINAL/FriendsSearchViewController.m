//
//  FriendsSearchViewController.m
//  Suvi
//
//  Created by apple on 1/16/13.
//
//

#import "FriendsSearchViewController.h"
#import "ContactCustomCell.h"
#import "AppDelegate.h"

@implementation FriendsSearchViewController

#pragma mark - View lifecycle
@synthesize strsearchtext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
  
    [[tblview layer] setMasksToBounds:YES];
    [[tblview layer] setBorderColor:[RGBCOLOR(215.0, 215.0, 215.0) CGColor]];
    [[tblview layer] setBorderWidth:1.0f];
    
    [[viewtblheader layer] setMasksToBounds:YES];
    [[viewtblheader layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[viewtblheader layer] setBorderWidth:1.0f];
    
    arrsuvifriends=[[NSMutableArray alloc]init];
    
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    webData=[[NSMutableData alloc]init];
    [self _searchFriend];
}

-(IBAction)btnbackclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_searchFriend
{
    [action setString:@"searchfriends"];
    [actionurl setString:kSearchUsersURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&textField=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],strsearchtext]];
    [self _startSend];
}
-(void)btnaddfriendcalled:(id)sender
{
    UIButton *btnRequest=(UIButton *)sender;
    btnRequest.hidden=YES;
    
    [action setString:@"addfriends"];
    [actionurl setString:kSendFriendRequestURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDs=%@&sometext=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[arrsuvifriends objectAtIndex:[sender tag]] objectForKey:@"admin_id"],@"Invite text"]];
    [self _startSend];
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
        if ([strMSG isEqualToString:@""])
        {
            //DisplayAlert(@"Failed to connect with the server!");
            return;
        }
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            if([action isEqualToString:@"searchfriends"])
            {
                if ([[dictionary objectForKey:@"USER_DETAIL"] count] > 0)
                {
                    [arrsuvifriends removeAllObjects];
                    [arrsuvifriends addObjectsFromArray:[dictionary objectForKey:@"USER_DETAIL"]];
                    
                    NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"admin_fname" ascending:YES];
                    NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
                    NSArray *sorted = [arrsuvifriends sortedArrayUsingDescriptors:descriptors];
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
                    lblNoUserFoundMessage.alpha = 1.0;
                }
            }
            else if([action isEqualToString:@"addfriends"])
            {
                DisplayAlert(@"Friend request sent!");
            }
            else if([action isEqualToString:@"invitefriends"])
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
#pragma mark - TABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrsuvifriends count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [[NSBundle mainBundle] loadNibNamed:@"FriendSearchCCell" owner:self options:nil];
        cell = obj_frndsearchCell;
    }
    NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[arrsuvifriends objectAtIndex:indexPath.row]];
    
    obj_frndsearchCell.lblUsername.text = [[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"FULL_NAME"]] removeNull];
    NSString *strFriendAppend,*strMutualFrndAppend;
    if ([[DicfriendsDetail valueForKey:@"hasNoOfFriends"] intValue] == 0 || [[DicfriendsDetail valueForKey:@"hasNoOfFriends"] intValue] == 1)
    {
        strFriendAppend = @"Friend";
    }
    else
    {
        strFriendAppend = @"Friends";
    }
    if ([[DicfriendsDetail valueForKey:@"No_of_mutualFriends"] intValue] == 0 || [[DicfriendsDetail valueForKey:@"No_of_mutualFriends"] intValue] == 1)
    {
        strMutualFrndAppend = @"Mutual friend";
    }
    else
    {
        strMutualFrndAppend = @"Mutual friends";
    }
    obj_frndsearchCell.lblNoFriends.text = [[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"hasNoOfFriends"],strFriendAppend] removeNull];
    obj_frndsearchCell.lblNoMutualFriends.text = [[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"No_of_mutualFriends"],strMutualFrndAppend] removeNull];
    obj_frndsearchCell.lblSchoolName.text = [[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"school"]] removeNull];
    
    
    obj_frndsearchCell.btnAdd.tag = indexPath.row;
    
    if ([[DicfriendsDetail objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
        [[DicfriendsDetail objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
    {
        if ([[DicfriendsDetail valueForKey:@"admin_id"] integerValue]==[[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] integerValue])
        {
            obj_frndsearchCell.btnAdd.hidden = YES;
        }
        else
        {
            obj_frndsearchCell.btnAdd.hidden = NO;
            [obj_frndsearchCell.btnAdd addTarget:self action:@selector(btnaddfriendcalled:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else
    {
         obj_frndsearchCell.btnAdd.hidden = YES;
    }
    
    NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
    [DddAvtar setValue:[DicfriendsDetail valueForKey:@"image_path"] forKey:@"urlAvtar"];
    [obj_frndsearchCell setDict:DddAvtar];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,76.0,310.0,1.0)];
    viewSeparater.backgroundColor=RGBCOLOR(215.0, 215.0, 215.0);
    [cell.contentView addSubview:viewSeparater];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[arrsuvifriends objectAtIndex:indexPath.row] valueForKey:@"admin_id"] integerValue]==[[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] integerValue])
    {
        return;
    }
    
    FriendsProfileVC *objFriendsProfileVC = [[FriendsProfileVC alloc]initWithNibName:@"FriendsProfileVC" bundle:nil];
    objFriendsProfileVC.admin_id = [[[arrsuvifriends objectAtIndex:indexPath.row] valueForKey:@"admin_id"] copy];
    if ([[[arrsuvifriends objectAtIndex:indexPath.row] objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
        [[[arrsuvifriends objectAtIndex:indexPath.row] objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
    {
        objFriendsProfileVC.shouldShowOnlyOneFeed=YES;
        objFriendsProfileVC.strFrom = @"RandomView";
    }
    else
    {
        objFriendsProfileVC.shouldShowOnlyOneFeed = NO;
        objFriendsProfileVC.strFrom = @"FriendView";
    }
    [self.navigationController pushViewController:objFriendsProfileVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
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
