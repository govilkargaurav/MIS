//
//  RandomUserViewCtr.m
//  Suvi
//
//  Created by Imac 2 on 4/29/13.
//
//

#import "RandomUserViewCtr.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "FriendsProfileVC.h"

@interface RandomUserViewCtr ()

@end

@implementation RandomUserViewCtr
@synthesize ArrayUsersList;
@synthesize strFromView;
@synthesize pageCount,TotalCount;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];

    
    action=[[NSMutableString alloc]init];
    actionurl=[[NSMutableString alloc]init];
    actionparameters=[[NSMutableString alloc]init];
    webData=[[NSMutableData alloc]init];
    
    while ([scl_Users.subviews count] > 0)
    {
        [[[scl_Users subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    lblTitle.text = [NSString stringWithFormat:@"%@",strFromView];
    
    if ([strFromView isEqualToString:@"Suggested Friends"])
    {
        if (IS_DEVICE_iPHONE_5)
        {
            Yaxis = 5;
            Xaxis = 14;
        }
        else
        {
            Yaxis = 7;
            Xaxis = 14;
        }
        [self SetPeopleMayYouKnowInScrollView:1];
    }
    else if ([strFromView isEqualToString:@"Random"])
    {
        if (IS_DEVICE_iPHONE_5)
        {
            YaxisRandom = 5;
            XaxisRandom = 14;
        }
        else
        {
            YaxisRandom = 7;
            XaxisRandom = 14;
        }
        [self SetRandomInScrollView:1];
    }
    
    [[ViewSendRequest layer] setMasksToBounds:YES];
    [[ViewSendRequest layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ViewSendRequest layer] setBorderWidth:1.0f];

}
-(void)SetPeopleMayYouKnowInScrollView:(int)startCount
{
    for (int i = startCount; i <= [ArrayUsersList count]; i++)
    {
        NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArrayUsersList objectAtIndex:i-1]];
        
        NSString *strGender=[NSString stringWithFormat:@"%@",([DicfriendsDetail objectForKey:@"eGender"])?[DicfriendsDetail objectForKey:@"eGender"]:@""];
        BOOL isUserMale=([strGender isEqualToString:@"Male"])?YES:NO;
        
        UIButton *btnUserProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUserProfile.frame = CGRectMake(Xaxis, Yaxis + 4, 84, 84);
        //[btnUserProfile setImageWithURL: placeholderImage:];
        [btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"image_path"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        btnUserProfile.tag= [[DicfriendsDetail objectForKey:@"admin_id"] intValue];
        [btnUserProfile addTarget:self action:@selector(btnUserProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnUserProfile.backgroundColor = [UIColor clearColor];
        btnUserProfile.userInteractionEnabled = YES;
        [scl_Users addSubview:btnUserProfile];
        
        
        UILabel *lblUser=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+87,84,15)];
        lblUser.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
        lblUser.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        lblUser.textAlignment=UITextAlignmentLeft;
        lblUser.backgroundColor=[UIColor clearColor];
        lblUser.textColor = RGBCOLOR(73.0, 72.0, 72.0);
        [scl_Users addSubview:lblUser];
        
        UILabel *lblSharedFrndr=[[UILabel alloc]initWithFrame:CGRectMake(Xaxis,Yaxis+102,84,12)];
        NSString *strAppend;
        if ([[DicfriendsDetail valueForKey:@"No_of_mutualFriends"] intValue] == 1)
        {
            strAppend = @"mutual friend";
        }
        else
        {
            strAppend = @"mutual friends";
        }
        lblSharedFrndr.text=[NSString stringWithFormat:@"%@ %@",[DicfriendsDetail valueForKey:@"No_of_mutualFriends"],strAppend];
        lblSharedFrndr.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        lblSharedFrndr.textAlignment=UITextAlignmentLeft;
        lblSharedFrndr.backgroundColor=[UIColor clearColor];
        lblSharedFrndr.textColor= RGBCOLOR(49.0f, 126.0f, 103.0f);
        [scl_Users addSubview:lblSharedFrndr];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(Xaxis+66, Yaxis - 2, 29, 29);
        btnAdd.tag = [[DicfriendsDetail valueForKey:@"admin_id"] intValue];
        [btnAdd addTarget:self action:@selector(btnSendFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
        
        if ([[DicfriendsDetail objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
            [[DicfriendsDetail objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
        {
            btnAdd.hidden=NO;
        }
        else
        {
            btnAdd.hidden=YES;
        }

        
        [scl_Users addSubview:btnAdd];
        
        if (IS_DEVICE_iPHONE_5)
        {
            if (i % 12 == 0)
            {
                Xaxis = Xaxis + 114;
                Yaxis = 5;
            }
            else if (i % 3 == 0)
            {
                Xaxis = Xaxis - 196;
                Yaxis = Yaxis + 114;
            }
            else
            {
                Xaxis = Xaxis + 98;
            }
        }
        else
        {
            if (i % 9 == 0)
            {
                Xaxis = Xaxis + 114;
                Yaxis = 7;
            }
            else if (i % 3 == 0)
            {
                Xaxis = Xaxis - 196;
                Yaxis = Yaxis + 125;
            }
            else
            {
                Xaxis = Xaxis + 98;
            }
        }
    }
    if (IS_DEVICE_iPHONE_5)
    {
        //
        NSInteger lastpageoffset=[ArrayUsersList count]%12;
        NSInteger pagecounts=[ArrayUsersList count]/12+((lastpageoffset==0)?0:1);
        scl_Users.contentSize=CGSizeMake(310*pagecounts,scl_Users.frame.size.height);
    }
    else
    {
        NSInteger lastpageoffset=[ArrayUsersList count]%9;
        NSInteger pagecounts=[ArrayUsersList count]/9+((lastpageoffset==0)?0:1);
        scl_Users.contentSize=CGSizeMake(310*pagecounts,scl_Users.frame.size.height);
    }
}
-(void)SetRandomInScrollView:(int)startCount
{
    for (int i = startCount; i <= [ArrayUsersList count]; i++)
    {
        NSDictionary *DicfriendsDetail = [[NSDictionary alloc] initWithDictionary:[ArrayUsersList objectAtIndex:i-1]];
        
        NSString *strGender=[NSString stringWithFormat:@"%@",([DicfriendsDetail objectForKey:@"eGender"])?[DicfriendsDetail objectForKey:@"eGender"]:@""];
        BOOL isUserMale=([strGender isEqualToString:@"Male"])?YES:NO;
        
        UIButton *btnUserProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        btnUserProfile.frame = CGRectMake(XaxisRandom, YaxisRandom + 4, 84, 84);
        //[btnUserProfile setImageWithURL:[NSURL URLWithString:] placeholderImage:];
        [btnUserProfile setImageWithURL:[NSURL URLWithString:[[DicfriendsDetail valueForKey:@"vProfilePicName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:(isUserMale)?@"suvimale.png":@"suvifemale.png"]];
        btnUserProfile.tag= [[DicfriendsDetail objectForKey:@"admin_id"] intValue];
        [btnUserProfile addTarget:self action:@selector(btnUserProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnUserProfile.backgroundColor = [UIColor clearColor];
        btnUserProfile.userInteractionEnabled = YES;
        [scl_Users addSubview:btnUserProfile];
        
        UILabel *lblUser=[[UILabel alloc]initWithFrame:CGRectMake(XaxisRandom,YaxisRandom+87,84,15)];
        lblUser.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"admin_fullname"]] removeNull];
        lblUser.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        lblUser.textAlignment=UITextAlignmentLeft;
        lblUser.backgroundColor=[UIColor clearColor];
        lblUser.textColor = RGBCOLOR(73.0, 72.0, 72.0);
        [scl_Users addSubview:lblUser];
        
        UILabel *lblSchool=[[UILabel alloc]initWithFrame:CGRectMake(XaxisRandom,YaxisRandom+102,84,12)];
        lblSchool.text=[[NSString stringWithFormat:@"%@",[DicfriendsDetail valueForKey:@"school"]] removeNull];
        lblSchool.font=[UIFont fontWithName:@"Helvetica" size:10.0];
        lblSchool.textAlignment=UITextAlignmentLeft;
        lblSchool.backgroundColor=[UIColor clearColor];
        lblSchool.textColor= RGBCOLOR(49.0f, 126.0f, 103.0f);
        [scl_Users addSubview:lblSchool];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(XaxisRandom+66, YaxisRandom - 2, 29, 29);
        btnAdd.tag = [[DicfriendsDetail valueForKey:@"admin_id"] intValue];
        [btnAdd addTarget:self action:@selector(btnSendFriendRequest:) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setImage:[UIImage imageNamed:@"btnPlus.png"] forState:UIControlStateNormal];
        
        if ([[DicfriendsDetail objectForKey:@"canSendFrndReq"] isEqualToString:@"YES"] &&
            [[DicfriendsDetail objectForKey:@"isAlreadyFrnd"] isEqualToString:@"NO"])
        {
            btnAdd.hidden=NO;
        }
        else
        {
            btnAdd.hidden=YES;
        }
        
        [scl_Users addSubview:btnAdd];
        
        if (IS_DEVICE_iPHONE_5)
        {
            if (i % 12 == 0)
            {
                XaxisRandom = XaxisRandom + 114;
                YaxisRandom = 5;
            }
            else if (i % 3 == 0)
            {
                XaxisRandom = XaxisRandom - 196;
                YaxisRandom = YaxisRandom + 114;
            }
            else
            {
                XaxisRandom = XaxisRandom + 98;
            }
        }
        else
        {
            if (i % 9 == 0)
            {
                XaxisRandom = XaxisRandom + 114;
                YaxisRandom = 7;
            }
            else if (i % 3 == 0)
            {
                XaxisRandom = XaxisRandom - 196;
                YaxisRandom = YaxisRandom + 125;
            }
            else
            {
                XaxisRandom = XaxisRandom + 98;
            }
        }
    }
    
    if (IS_DEVICE_iPHONE_5)
    {
        NSInteger lastpageoffset=[ArrayUsersList count]%12;
        NSInteger pagecounts=[ArrayUsersList count]/12+((lastpageoffset==0)?0:1);
        scl_Users.contentSize=CGSizeMake(310*pagecounts,371.0+iPhone5ExHeight);
    }
    else
    {
        NSInteger lastpageoffset=[ArrayUsersList count]%9;
        NSInteger pagecounts=[ArrayUsersList count]/9+((lastpageoffset==0)?0:1);
        scl_Users.contentSize=CGSizeMake(310*pagecounts,371.0);
    }
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
            if ([action isEqualToString:@"SendFriendRequest"])
            {
                strRefreshForFriendsView = @"RefreshFriendsView";
                DisplayAlert(@"Friend request sent!");
            }
            else if([action isEqualToString:@"invitefriends"])
            {
                txtInviteId.text=@"";
                DisplayAlert(@"Friend Invited Successfully!");
            }
            else if ([action isEqualToString:@"RandomRefresh"])
            {
                if ([strFromView isEqualToString:@"Suggested Friends"])
                {
                    if ([[dictionary objectForKey:@"CAN_BE_COMMON_FRIEND"] count] > 0)
                    {
                        [ArrayUsersList addObjectsFromArray:[dictionary objectForKey:@"CAN_BE_COMMON_FRIEND"]];
                        [self SetPeopleMayYouKnowInScrollView:LastTotalArrayCount+1];
                        [scl_Users setContentOffset:CGPointMake(scl_Users.contentOffset.x + 310,scl_Users.contentOffset.y)];
                    }
                }
                else if ([strFromView isEqualToString:@"Random"])
                {
                    if ([[dictionary objectForKey:@"RANDOM_USERS"] count] > 0)
                    {
                        [ArrayUsersList addObjectsFromArray:[dictionary objectForKey:@"RANDOM_USERS"]];
                        [self SetRandomInScrollView:LastTotalArrayCount+1];
                        [scl_Users setContentOffset:CGPointMake(scl_Users.contentOffset.x + 310,scl_Users.contentOffset.y)];
                    }
                }
            }
        }
        else if ([strMSG isEqualToString:@"UNSUCCESS"])
        {
            return;
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

#pragma mark - Send Request To Friend
-(void)btnSendFriendRequest:(id)sender
{
    UIButton *btnRequest=(UIButton *)sender;
    btnRequest.hidden=YES;
    
    strFriendID = [NSString stringWithFormat:@"%d",[sender tag]];
    [action setString:@"SendFriendRequest"];
    [actionurl setString:kSendFriendRequestURL];
    [actionparameters setString:[NSString stringWithFormat:@"userID=%@&frndIDs=%@&sometext=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],strFriendID,@""]];
    [self _startSend];
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

#pragma mark - IBAction Methods 
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnUserProfileClicked:(id)sender
{
    FriendsProfileVC *objFriendsProfileVC = [[FriendsProfileVC alloc]initWithNibName:@"FriendsProfileVC" bundle:nil];
    objFriendsProfileVC.admin_id = [NSString stringWithFormat:@"%d",[sender tag]];
    objFriendsProfileVC.shouldShowOnlyOneFeed = YES;
    objFriendsProfileVC.strFrom = @"RandomView";
    [self.navigationController pushViewController:objFriendsProfileVC animated:YES];
    objFriendsProfileVC = nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int scrollWidth = scrollView.contentSize.width;
    int scrollx = scrollView.contentOffset.x;
    if (scrollWidth - scrollx < 310)
    {
        int CountMinus = TotalCount - [ArrayUsersList count];
        if (CountMinus != 0)
        {
            LastTotalArrayCount = [ArrayUsersList count];
            pageCount = pageCount + 1;
            [action setString:@"RandomRefresh"];
            if ([strFromView isEqualToString:@"Suggested Friends"])
            {
                [actionurl setString:strSuggestedUserRefresh];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@&page=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],pageCount]];
            }
            else if ([strFromView isEqualToString:@"Random"])
            {
                [actionurl setString:strRandomUserRefresh];
                [actionparameters setString:[NSString stringWithFormat:@"userID=%@&page=%d",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],pageCount]];
            }
            [self _startSend];
        }
        else
        {
            [self performSelector:@selector(scrollHome) withObject:nil afterDelay:0.1];
        }
    }
}

-(void)scrollHome
{
    [scl_Users setContentOffset:CGPointMake(0,scl_Users.contentOffset.y)];
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
