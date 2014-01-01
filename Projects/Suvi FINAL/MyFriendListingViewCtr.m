//
//  MyFriendListingViewCtr.m
//  Suvi
//
//  Created by Imac 2 on 4/26/13.
//
//

#import "MyFriendListingViewCtr.h"
#import "CustomBadge.h"
#import "common.h"
#import "NSString+Utilities.h"
#import "Global.h"
#import "FriendsProfileVC.h"

@interface MyFriendListingViewCtr ()

@end

@implementation MyFriendListingViewCtr
@synthesize ArryFriends,ArryPendingRequest;

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
    [super viewDidLoad];
    
    [[tbl_friendList layer] setMasksToBounds:YES];
    [[tbl_friendList layer] setBorderColor:[RGBCOLOR(215.0, 215.0, 215.0) CGColor]];
    [[tbl_friendList layer] setBorderWidth:1.0f];
    
    webData=[[NSMutableData alloc]init];
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    [tbl_friendList reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark- TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ArryPendingRequest count] > 0 && [ArryFriends count] > 0)
        return 2;
    else
        return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 28)];
	customView.backgroundColor = [UIColor clearColor];
    if (section == 0 && [ArryPendingRequest count] > 0)
    {
        UIImageView *imgFrndRequest = [[UIImageView alloc]init];
        imgFrndRequest.frame = CGRectMake(0, 0, 310, 28);
        imgFrndRequest.backgroundColor = [UIColor clearColor];
        imgFrndRequest.contentMode = UIViewContentModeCenter;
        imgFrndRequest.image = [UIImage imageNamed:@"frndrequestsection.png"];
        [customView addSubview:imgFrndRequest];
    }
    else
    {
        UIImageView *imgFrndRequest = [[UIImageView alloc]init];
        imgFrndRequest.frame = CGRectMake(0, 0, 310, 28);
        imgFrndRequest.backgroundColor = [UIColor clearColor];
        imgFrndRequest.contentMode = UIViewContentModeCenter;
        imgFrndRequest.image = [UIImage imageNamed:@"myfrindssection.png"];
        [customView addSubview:imgFrndRequest];
    }
	return customView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && [ArryPendingRequest count] > 0)
        return [ArryPendingRequest count];
    else
        return [ArryFriends count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         [[NSBundle mainBundle] loadNibNamed:@"MyFriendCCell" owner:self options:nil];
        cell = obj_myfrndCell;
    }
    NSDictionary *DicfriendsDetail;
    if (indexPath.section == 0 && [ArryPendingRequest count] > 0)
    {
        obj_myfrndCell.imgGreen.hidden = NO;
        
        [obj_myfrndCell.btnWinkorReject addTarget:self action:@selector(btnRejectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [obj_myfrndCell.btnNoteorAccept addTarget:self action:@selector(btnAcceptPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [obj_myfrndCell.btnWinkorReject setImage:[UIImage imageNamed:@"rejectfriend.png"] forState:UIControlStateNormal];
        [obj_myfrndCell.btnNoteorAccept setImage:[UIImage imageNamed:@"acceptfriend.png"] forState:UIControlStateNormal];
        
        DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArryPendingRequest objectAtIndex:indexPath.row]];
    }
    else
    {
        obj_myfrndCell.imgGreen.hidden = YES;
        
        [obj_myfrndCell.btnWinkorReject addTarget:self action:@selector(btnwinkPressed:) forControlEvents:UIControlEventTouchUpInside];
        [obj_myfrndCell.btnNoteorAccept addTarget:self action:@selector(btnpostPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [obj_myfrndCell.btnWinkorReject setImage:[UIImage imageNamed:@"wink.png"] forState:UIControlStateNormal];
        [obj_myfrndCell.btnNoteorAccept setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
        
        DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArryFriends objectAtIndex:indexPath.row]];
    }
    
    obj_myfrndCell.btnNoteorAccept.tag = indexPath.row;
    obj_myfrndCell.btnWinkorReject.tag = indexPath.row;
    
    obj_myfrndCell.lblUsername.text = [[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
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
    obj_myfrndCell.lblNoFriends.text = [[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"hasNoOfFriends"],strFriendAppend] removeNull];
    obj_myfrndCell.lblNoMutualFriends.text = [[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"No_of_mutualFriends"],strMutualFrndAppend] removeNull];
    obj_myfrndCell.lblSchoolName.text = [[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"school"]] removeNull];
    
    NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
    [DddAvtar setValue:[DicfriendsDetail valueForKey:@"image_path"] forKey:@"urlAvtar"];
    [obj_myfrndCell setDict:DddAvtar];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,76.0,310.0,1.0)];
    viewSeparater.backgroundColor=RGBCOLOR(215.0, 215.0, 215.0);
    [cell.contentView addSubview:viewSeparater];
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL SendYesNo;
    NSDictionary *DicfriendsDetail;
    NSString *strFromView;
    if (indexPath.section == 0 && [ArryPendingRequest count] > 0)
    {
        SendYesNo = YES;
        DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArryPendingRequest objectAtIndex:indexPath.row]];
        strFromView = @"FriendRequestView";
    }
    else
    {
        SendYesNo = NO;
        DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArryFriends objectAtIndex:indexPath.row]];
        strFromView = @"FriendView";
    }
    FriendsProfileVC *objFriendsProfileVC = [[FriendsProfileVC alloc]initWithNibName:@"FriendsProfileVC" bundle:nil];
    objFriendsProfileVC.admin_id = [DicfriendsDetail valueForKey:@"admin_id"];
    objFriendsProfileVC.shouldShowOnlyOneFeed = SendYesNo;
    objFriendsProfileVC.strFrom = strFromView;
    [self.navigationController pushViewController:objFriendsProfileVC animated:YES];
    objFriendsProfileVC = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        selectedindex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Would you like to remove this friend?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.tag = 10;
        [alert show];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && [ArryPendingRequest count] > 0)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}
-(IBAction)btnEditPressed:(id)sender
{
    if (!EditTbl)
    {
        [tbl_friendList setEditing:YES animated:YES];
        EditTbl = YES;
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [tbl_friendList setEditing:NO animated:YES];
        EditTbl = NO;
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex==1)
        {
            [self removeFriendFromList];
        }
    }
    else if(alertView.tag==20)
    {
        if (buttonIndex==0) {
            [self rejectFriendFromList];
        }
    }
}
-(void)removeFriendFromList
{
    [action setString:@"removefriend"];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&iFriendsID=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[[ArryFriends objectAtIndex:selectedindex] objectForKey:@"admin_id"]intValue]]];
    [actionurl setString:removeFriend];
    [self _startSend];
}
-(void)btnpostPressed:(id)sender
{
    SetKeyBoardTag = YES;
    [self AddAutoExpandTextField];
    selectedindex = [sender tag];
    containerView.frame = CGRectMake(-2, self.view.frame.size.height - 38+iOS7ExHeight, 327, 45);
    [tfautoExpandPost becomeFirstResponder];
}
-(void)btnwinkPressed:(id)sender
{
    selectedindex = [sender tag];
    [action setString:@"winked"];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&iFriendsID=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[[ArryFriends objectAtIndex:selectedindex] objectForKey:@"admin_id"]intValue]]];
    [actionurl setString:strWinked];
    [self _startSend];
}
-(void)btnRejectPressed:(id)sender
{
    selectedindex = [sender tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you would like to decline?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    alert.tag = 20;
    [alert show];
}
-(void)btnAcceptPressed:(id)sender
{
    selectedindex = [sender tag];
    [self acceptFriendFromList];
}
-(void)acceptFriendFromList
{
    [action setString:@"acceptfriend"];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDS=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[[ArryPendingRequest objectAtIndex:selectedindex] objectForKey:@"admin_id"]intValue]]];
    [actionurl setString:kAcceptFriendRequestURL];
    [self _startSend];
}
-(void)rejectFriendFromList
{
    [action setString:@"rejectfriend"];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDS=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[[ArryPendingRequest objectAtIndex:selectedindex] objectForKey:@"admin_id"]intValue]]];
    [actionurl setString:kRejectFriendRequestURL];
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[actionparameters stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:actionurl]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        //NSString *temp = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

#pragma mark - NSUrl Delegate
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
#pragma mark - Receive Data

-(void)_receiveDidStopWithStatus:(NSString *)statusString
{
    [[AppDelegate sharedInstance]hideLoader];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    if( [statusString isEqual:@"Connection failed"] || statusString == nil)
    {
        //DisplayAlertWithTitle(@"Error", @"Failed to connect with the server!");
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
    if (dictionary ==(id) [NSNull null])
    {
        return;
    }
    
    NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
    if ([strMSG isEqualToString:@""])
    {
        return;
    }
    if ([strMSG isEqualToString:@"SUCCESS"])
    {
        if ([dictionary objectForKey:@"LoggedinUser"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[dictionary objectForKey:@"LoggedinUser"] forKey:@"USER_DETAIL"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        if ([action isEqualToString:@"removefriend"])
        {
            strRefreshForFriendsView = @"RefreshFriendsView";
            [ArryFriends removeObjectAtIndex:selectedindex];
            [tbl_friendList reloadData];
        }
        else if ([action isEqualToString:@"acceptfriend"] || [action isEqualToString:@"rejectfriend"])
        {
            strRefreshForFriendsView = @"RefreshFriendsView";
            if ([action isEqualToString:@"acceptfriend"])
            {
                [ArryFriends addObject:[ArryPendingRequest objectAtIndex:selectedindex]];
                NSSortDescriptor *sortByfullName = [[NSSortDescriptor alloc] initWithKey:@"admin_fullname" ascending:YES];
                NSArray *descriptors = [NSArray arrayWithObject:sortByfullName];
                NSArray *sorted = [ArryFriends sortedArrayUsingDescriptors:descriptors];
                
                if ([ArryFriends count] > 0)
                    [ArryFriends removeAllObjects];
                
                [ArryFriends addObjectsFromArray:sorted];
            }
            [ArryPendingRequest removeObjectAtIndex:selectedindex];
            [tbl_friendList reloadData];
        }
        else if ([action isEqualToString:@"winked"])
        {
            NSString *strWinkedMsg = [NSString stringWithFormat:@"You have winked at %@",[[ArryFriends objectAtIndex:selectedindex] objectForKey:@"admin_fullname"]];
            DisplayAlertWithTitle(@"Winked!", strWinkedMsg);
        }
        else if ([action isEqualToString:@"postonwall"])
        {
            tfautoExpandPost.text = @"";
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
-(void)viewWillDisappear:(BOOL)animated
{
    [txtSearch resignFirstResponder];
}

#pragma mark - Search Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchFriendsAndNavigate:textField.text];
    return YES;
}
-(void)searchFriendsAndNavigate:(NSString*)strSearch
{
    if ([[strSearch removeNull] length]<=1)
    {
        DisplayAlert(@"Please enter two or more characters to search!");
    }
    else
    {
        FriendsSearchViewController *obj=[[FriendsSearchViewController alloc]init];
        obj.strsearchtext=[NSString stringWithFormat:@"%@",[strSearch removeNull]];
        txtSearch.text=@"";
        [self.navigationController pushViewController:obj animated:YES];
    }
}
-(IBAction)btnSearchPressed:(id)sender
{
    [txtSearch resignFirstResponder];
    [self searchFriendsAndNavigate:txtSearch.text];
}

#pragma mark - Add AutoExpand TextField
-(void)AddAutoExpandTextField
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(-2, self.view.frame.size.height+iOS7ExHeight, 323, 45)];
    
	tfautoExpandPost = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 7, 250, 25)];
    tfautoExpandPost.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
	tfautoExpandPost.minNumberOfLines = 1;
	tfautoExpandPost.maxNumberOfLines = 6;
	tfautoExpandPost.returnKeyType = UIReturnKeyGo; //just as an example
	tfautoExpandPost.font = [UIFont systemFontOfSize:15.0f];
	tfautoExpandPost.delegate = self;
//    [tfautoExpandPost setPlaceHolderTextView:@"Write a note..."];
    tfautoExpandPost.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    tfautoExpandPost.backgroundColor = [UIColor clearColor];
    tfautoExpandPost.textColor = [UIColor blackColor];

    [[tfautoExpandPost layer] setMasksToBounds:YES];
    [[tfautoExpandPost layer] setCornerRadius:5.0f];
    [[tfautoExpandPost layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[tfautoExpandPost layer] setBorderWidth:1.0f];
    [[tfautoExpandPost layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[tfautoExpandPost layer] setShadowOffset:CGSizeMake(0, 0)];
    [[tfautoExpandPost layer] setShadowRadius:2.0];
    
    [self.view addSubview:containerView];
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(-2, 2, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tfautoExpandPost.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:tfautoExpandPost];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width -65, 12, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"Post" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [doneBtn setTitleColor:RGBCOLOR(242.0, 108.0, 79.0) forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
-(void)resignTextView
{
    [tfautoExpandPost resignFirstResponder];
    NSString *strPostComment = [tfautoExpandPost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strPostComment length]>0)
    {
        [action setString:@"postonwall"];
        [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDS=%d&vActivityText=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],[[[ArryFriends objectAtIndex:selectedindex] objectForKey:@"admin_id"]intValue],strPostComment]];
        [actionurl setString:strPostonwall];
        [self _startSend];
    }
    containerView.frame = CGRectMake(-2, self.view.frame.size.height+iOS7ExHeight, 327, 45);
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
    if (SetKeyBoardTag)
    {
        containerView.frame = containerFrame;
    }
    SetKeyBoardTag = NO;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
    if (SetKeyBoardTag)
    {
        [containerView removeFromSuperview];
    }
    SetKeyBoardTag = NO;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
