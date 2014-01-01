//
//  CommentViewController.m
//  FitTag
//
//  Created by apple on 3/9/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "NSDate+TimeAgo.h"
#import "ProfileViewController.h"
#import "STTweetLabel.h"

@implementation CommentViewController
@synthesize tblComments;
@synthesize txtfieldComment,challengeId;
@synthesize ChallengeOwner;
@synthesize strChaleengeName,objchallenge;
@synthesize isFromFindTags,isTakeChallenge,delegate;

static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    
    createdUser = [self.objchallenge objectForKey:@"userId"];
    
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
    arrAllComments=[[NSMutableArray alloc]init];
    
    mutArrMentionedFriends  = [[NSMutableArray alloc]init];
    mutArrUserNamesMentionInComment = [[NSMutableArray alloc]init];
    
    // Creating custom popover view for mention friends in comments functionality
    
//    if ([UIScreen mainScreen].bounds.size.height == 568.0) {
//        [txtfieldComment setFrame:CGRectMake(12, 446, 229, 36)];
//        [btnDone setFrame:CGRectMake(255, 447, 59, 35)];
//        [imagView setFrame:CGRectMake(6, 447, 241, 38)];
//    }
//    else{
//    
//        [txtfieldComment setFrame:CGRectMake(12, 363, 229, 36)];
//        [btnDone setFrame:CGRectMake(255, 363, 59, 35)];
//        [imagView setFrame:CGRectMake(6, 362, 241, 38)];
//    }
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,120.0,130.0)];
    backImg.userInteractionEnabled = YES;
    backImg.image = [UIImage imageNamed:@"popoverImage.png"];
    
    popOverViewBackground = [[UIView alloc]initWithFrame:CGRectMake(170.0,230.0,120.0,130.0)];
    popOverViewBackground.userInteractionEnabled = YES;
    
    // Table View for show followers for mention suggetion in comment
    tblViewMentionFriends = [[UITableView alloc]initWithFrame:CGRectMake(2.0,2.0,116.0,120.0)];
    tblViewMentionFriends.layer.cornerRadius = 4.0;
    
    [popOverViewBackground addSubview:backImg];
    [backImg addSubview:tblViewMentionFriends];
    [self.view addSubview:popOverViewBackground];
    popOverViewBackground.hidden = YES;
    
    tblViewMentionFriends.delegate = self;
    tblViewMentionFriends.dataSource = self;
    
    // Tracking varible for search followers
    isSearching = NO;
    
    // Appdelegate shared instance
    appdelegateRef = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Mutable array for store search result
    mutArrSearchDisplay = [[NSMutableArray alloc]init];
    
    // Mutable Araay which keep all followers
    mutArrMyFollowers = [[NSMutableArray alloc]init];
    
    // Getting all comment for challenge
    [self getComments];
    
    // Getting all followers for mention in comment functionality
    [self getfollowers];
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;

}
#pragma mark get User followers

-(void)getChallengeHasUsesSameHashTags:(NSArray *)arrayHasTags{
    PFQuery *getChallenge = [PFQuery queryWithClassName:@"Challenge"];
    [getChallenge whereKey:@"challengeHashTags" containedIn:arrayHasTags];
    [getChallenge includeKey:@"userId"];
    [getChallenge findObjectsInBackgroundWithBlock:^(NSArray *arrchallengeUsesSameHashTags,NSError *challengeError) {
        if (!challengeError){
            
        } else {
            DisplayAlertWithTitle(@"FitTag",@"Unable to get Challenge.");
        }
    }];
}

-(void)getfollowers{

    PFQuery *followersQuery1 = [PFQuery queryWithClassName:@"Tbl_follower"];
    [followersQuery1 whereKey:@"CurrentUserId" equalTo:[PFUser currentUser].objectId];
    PFQuery *followersQuery2 = [PFQuery queryWithClassName:@"Tbl_follower"];
    [followersQuery2 whereKey:@"follower_id" equalTo:[PFUser currentUser].objectId];
    NSArray *arrFollow = [[NSArray alloc]initWithObjects:followersQuery1,followersQuery2, nil];
    PFQuery *followersQuery = [PFQuery orQueryWithSubqueries:arrFollow];
    [followersQuery includeKey:@"userId"];
    [followersQuery includeKey:@"followerUser"];
    
    [followersQuery findObjectsInBackgroundWithBlock:^(NSArray *arrFollowers,NSError *followerserror) {
        
        if (!followerserror) {
            mutArrMyFollowers = [arrFollowers copy];
        } else {
            DisplayAlertWithTitle(@"FitTag",@"Unable to get followers");
        }
    }];
}

-(void)getComments{
    if (isTakeChallenge==TRUE) {
        PFQuery *postQuery = [PFQuery queryWithClassName:@"tbl_comments_takeChallenge"];
        [postQuery whereKey:@"ChallengeId" equalTo:self.challengeId];
        [postQuery includeKey:@"userId"];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error){
                arrAllComments=[objects mutableCopy];
                [tblComments reloadData];
                if(arrAllComments.count > 0){
                   // NSIndexPath* ipath = [NSIndexPath indexPathForRow: arrAllComments.count-1 inSection: 0];
              //      [tblComments scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                    [self.delegate commentCount:[arrAllComments count]];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
            }
        }];
    }
    else{
        
        PFQuery *postQuery = [PFQuery queryWithClassName:@"tbl_comments"];
        [postQuery whereKey:@"ChallengeId" equalTo:self.challengeId];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                arrAllComments=[objects mutableCopy];
                [tblComments reloadData];
                if(arrAllComments.count>0){
             //       NSIndexPath* ipath = [NSIndexPath indexPathForRow: arrAllComments.count-1 inSection: 0];
                 //   [tblComments scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
            }
        }];
    }
}

- (void)viewDidUnload
{
    [self setTblComments:nil];
    [self setTxtfieldComment:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == tblViewMentionFriends){
        return [mutArrSearchDisplay count];
    }else{
        return [arrAllComments count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(tableView == tblViewMentionFriends)
        return 30.0;
    else{
        PFObject *objComment=[arrAllComments objectAtIndex:indexPath.row];
        NSString *string;
        if ([[arrAllComments objectAtIndex:indexPath.row]isKindOfClass:[NSString class]]) {
            string =[arrAllComments objectAtIndex:indexPath.row];;
        }else{
            string =[objComment objectForKey:@"CommentText"];
        }
        stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        if (stringSize.height < 81) {
            return stringSize.height+45;
        }
        else{
        return stringSize.height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == tblViewMentionFriends){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.text = [[mutArrSearchDisplay objectAtIndex:indexPath.row]objectForKey:@"name"];
        return cell;
    }else{
        
        static NSString *CellIdentifier = @"Cell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell.lblUserName setFont:[UIFont fontWithName:@"DynoBold" size:15]];
        [cell.lblComment setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
        [cell.lblTime setFont:[UIFont fontWithName:@"DynoRegular" size:13]];
        if ([[arrAllComments objectAtIndex:indexPath.row]isKindOfClass:[NSString class]]) {
           // [cell.lblComment setText:[arrAllComments objectAtIndex:indexPath.row]];
            
            NSString *stringComment = [arrAllComments objectAtIndex:indexPath.row];
            CGSize stringSizeComment = [stringComment sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            STTweetLabel *objSTTweetLabel=[self setTweetLabelForLikeUser:[arrAllComments objectAtIndex:indexPath.row] textSize:stringSizeComment];
            [objSTTweetLabel setFrame:CGRectMake(61, 20, 260, stringSizeComment.height)];
            [objSTTweetLabel setText:[arrAllComments objectAtIndex:indexPath.row]];
            //[label setText:@"Hello @vishal  @ravi"];
            [cell.contentView addSubview:objSTTweetLabel];
            
            PFFile *uesrProfileImage = [[PFUser currentUser] objectForKey:@"userPhoto"];
            cell.lblUserName.text=[[PFUser currentUser] username];
            [cell.profileImageView setImageURL:[NSURL URLWithString:[uesrProfileImage url]]];
            
        }
        else{
       
        
        PFObject *objComment = [arrAllComments objectAtIndex:indexPath.row];
        PFUser *user=[objComment objectForKey:@"userId"];
       // cell.lblComment.text=[objComment objectForKey:@"CommentText"];
        PFFile *uesrProfileImage = [user objectForKey:@"userPhoto"];
        cell.lblUserName.text=[user username];
        
        NSString *stringComment = [objComment objectForKey:@"CommentText"];
        CGSize stringSizeComment = [stringComment sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        STTweetLabel *objSTTweetLabel=[self setTweetLabelForLikeUser:[objComment objectForKey:@"CommentText"] textSize:stringSizeComment];
        [objSTTweetLabel setFrame:CGRectMake(61, 20, 260, stringSizeComment.height)];
        [objSTTweetLabel setText:[objComment objectForKey:@"CommentText"]];
        //[label setText:@"Hello @vishal  @ravi"];
        [cell.contentView addSubview:objSTTweetLabel];
        
        NSString *string =[objComment objectForKey:@"CommentText"];
        
        CGSize stringSize2 = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        //Time
        NSDate *CreatedDate=[objComment createdAt];
        cell.lblTime.text=[CreatedDate timeAgo];
        [cell.lblTime setFrame:CGRectMake(170,stringSize2.height+cell.lblTime.height, 146, 16)];
        [cell.profileImageView.layer setBorderWidth:1.0];
        [cell.profileImageView.layer setBackgroundColor:[UIColor grayColor].CGColor];
        [cell.profileImageView.layer setCornerRadius:4.0];
        [cell.profileImageView setImageURL:[NSURL URLWithString:[uesrProfileImage url]]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tblViewMentionFriends){
        NSMutableArray *arrTxtFieldComment = [[txtfieldComment.text componentsSeparatedByString:@"@"] mutableCopy];
        
        [arrTxtFieldComment replaceObjectAtIndex:[arrTxtFieldComment count]-1 withObject:[[mutArrSearchDisplay objectAtIndex:indexPath.row]objectForKey:@"name"]];
        
        txtfieldComment.text = [arrTxtFieldComment componentsJoinedByString:@"@"];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[arrAllComments objectAtIndex:indexPath.row] deleteInBackground];

}
- (NSString *)tagFromSender:(id)sender {
	return ((UIButton *)sender).titleLabel.text;
}
- (void)atSelected:(NSString *)newStr {
   
    newStr = [newStr substringFromIndex:1];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:newStr];
    NSArray *arr=[[NSArray alloc]initWithArray:[query findObjects]];
    if([arr count] > 0){
        PFUser *user=[arr objectAtIndex:0];
        ProfileViewController *obProfile=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        obProfile.title=@"Profile";
        obProfile.profileUser=user;
        [self.navigationController pushViewController:obProfile animated:TRUE];
    }else{
        DisplayAlertWithTitle(@"FitTag", @"There is no user exist")
    }
}

#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self btnSendPressed:nil];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 1.0  *textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    animatedDistance = floor(162.0 * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];

} 
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *strSearchText = [textField.text stringByAppendingFormat:@"%@",string];
    
    if([textField.text length] == 1 && [strSearchText length] == 1){
        isSearching = NO;
        popOverViewBackground.hidden = YES;
        return YES;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength > 120){
        return NO;
    }
    
    if([strSearchText rangeOfString:@"@"].location == NSNotFound){
        // String does not contain @ symbol
        
    }else{
        popOverViewBackground.hidden = YES;
        
        NSRange rangNew = [strSearchText rangeOfString: @"@"];
        
        NSString *strAfterSearchSymbol = [strSearchText substringFromIndex:rangNew.location];
        
        if([strAfterSearchSymbol isEqualToString:@"@"]){
            // We got the first @ in our comment string
        }else{
            if ([mutArrMyFollowers count] > 0){
                isSearching = YES;
                [mutArrSearchDisplay removeAllObjects];
                
                NSArray *arrCommentString = [strAfterSearchSymbol componentsSeparatedByString:@"@"];
                strAfterSearchSymbol = [arrCommentString lastObject];
                
                //for(NSDictionary *strEventTag in mutArrNearByLocationList)
                for(PFObject *userObject in mutArrMyFollowers){
                    
                    NSString *strS;
                    NSString *strTempSearch = [[NSString alloc]initWithString:[userObject objectForKey:@"username"]];
                    
                    if([strTempSearch isEqualToString:[[PFUser currentUser] username]]){
                        strS = [[NSString alloc]initWithString:[userObject objectForKey:@"following_username"]];
                    }else{
                        strS = [[NSString alloc]initWithString:[userObject objectForKey:@"username"]];
                    }
                    
                    NSRange range = [[strS lowercaseString] rangeOfString:[strAfterSearchSymbol lowercaseString]];
                    
                    if(range.location != NSNotFound){
                        if(range.location == 0){
                            
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:strS forKey:@"name"];
                            
                            [mutArrSearchDisplay addObject:dict];
                            
                            if(![mutArrUserNamesMentionInComment containsObject:strS]){
                                [mutArrUserNamesMentionInComment addObject:strS];
                            }
                        }
                    }else{
                        popOverViewBackground.hidden = YES;
                        [tblViewMentionFriends reloadData];
                    }
                    //}
                }
                if([mutArrSearchDisplay count] > 0){
                    popOverViewBackground.hidden = NO;
                    [tblViewMentionFriends reloadData];
                }
            }
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
    isSearching = NO;
    popOverViewBackground.hidden = YES;
    [mutArrSearchDisplay removeAllObjects];
}

// Button send
NSString *commentTest;
- (IBAction)btnSendPressed:(id)sender{
    
    if([[txtfieldComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        [txtfieldComment resignFirstResponder];
        
    }else{
        [arrAllComments insertObject:txtfieldComment.text atIndex:0];
        [txtfieldComment resignFirstResponder];
        commentTest= txtfieldComment.text;
        txtfieldComment.text=@"";
        [tblComments reloadData];
        [self performSelector:@selector(sendComment) withObject:nil afterDelay:1.0];
        
    }
}
-(void)sendComment{

    if (isTakeChallenge==TRUE) {
        PFObject *like = [PFObject objectWithClassName:@"tbl_comments_takeChallenge"];
        
        [like setObject:[PFUser currentUser] forKey:@"userId"];
        [like setObject:self.challengeId forKey:@"ChallengeId"];
        [like setObject:commentTest forKey:@"CommentText"];
        
        txtfieldComment.text = @"";
        //Set ACL permissions for added security
        PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [commentACL setPublicReadAccess:YES];
        [like setACL:commentACL];
        
        [like save];
        [txtfieldComment resignFirstResponder];
        [self getComments];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        popOverViewBackground.hidden = YES;
        [txtfieldComment resignFirstResponder];
        PFObject *like = [PFObject objectWithClassName:@"tbl_comments"];
        [like setObject:[PFUser currentUser] forKey:@"userId"];
        [like setObject:self.challengeId forKey:@"ChallengeId"];
        [like setObject:[createdUser objectId] forKey:@"CreateduserId"];
        PFFile *teaserImage = [objchallenge objectForKey:@"teaserfile"];
        [like setObject:teaserImage forKey:@"teaserfile"];
        // Get the string just after @symbol
        [mutArrMentionedFriends removeAllObjects];
        NSString * aString = txtfieldComment.text;
        NSScanner *scanner = [NSScanner scannerWithString:aString];
        [scanner scanUpToString:@"@" intoString:nil]; // Scan all characters before @
        while(![scanner isAtEnd]){
            NSString *substring = nil;
            [scanner scanString:@"@" intoString:nil]; // Scan the @ character
            if([scanner scanUpToString:@" " intoString:&substring]) {
                // Check wheateher follower arr have the name
                for (PFObject *dict in mutArrMyFollowers) {
                    PFUser *user;
                    if([[dict objectForKey:@"username"] isEqualToString:substring]){
                        user = [dict objectForKey:@"userId"];
                        
                        if([mutArrMentionedFriends containsObject:user]){
                            // User already exist in the array
                        }else{
                            [mutArrMentionedFriends addObject:user];
                        }
                        
                    }else if([[dict objectForKey:@"following_username"] isEqualToString:substring]){
                        user = [dict objectForKey:@"followerUser"];
                        
                        if([mutArrMentionedFriends containsObject:user]){
                            // User already exist in the array
                        }else{
                            [mutArrMentionedFriends addObject:user];
                        }
                    }
                }
            }
            [scanner scanUpToString:@"@" intoString:nil]; // Scan all characters before next @
        }
        
        [like setObject:commentTest forKey:@"CommentText"];
        txtfieldComment.text = @"";
        //Set ACL permissions for added security
        PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [commentACL setPublicReadAccess:YES];
        [like setACL:commentACL];
        
        [like saveInBackgroundWithBlock:^(BOOL Done, NSError *error){
            
            if (Done) {
                // Notification for owner of challenge
                
                // Find devices associated with these users
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:self.ChallengeOwner];
                // Send push notification to query
                
                if(![[self.ChallengeOwner objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                    
                    if([[self.ChallengeOwner objectForKey:@"commentNotification"] isEqualToString:@"YES"]){
                        PFPush *push = [[PFPush alloc] init];
                        //[push setQuery:pushQuery]; // Set our Installation query
                        [push setChannel:[NSString stringWithFormat:@"user_%@",[self.ChallengeOwner objectId]]];
                        
                        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSString stringWithFormat:@"%@ commented on your challenge %@",[PFUser currentUser].username,[appdelegateRef removeNull:self.strChaleengeName ]], @"alert",
                                              @"Increment", @"badge",
                                              @"default",@"sound",
                                              @"comment",@"action",
                                              self.challengeId,@"challengeId",
                                              nil];
                        [push setData:data];
                        [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                            if (!errror) {
                            }else{
                            }
                        }];
                    }
                }
                
                // Notification for friends mentioned in comment
                
                for (int i = 0; i < [mutArrMentionedFriends count] ; i++) {
                    
                    PFUser *receiverUser = [mutArrMentionedFriends objectAtIndex:i];
                    
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"owner" equalTo:receiverUser];
                    
                    // Send push notification to query
                    
                    if(![[receiverUser objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                        
                        if([[receiverUser objectForKey:@"mentionNotification"] isEqualToString:@"YES"]){
                            PFPush *push = [[PFPush alloc] init];
                            //[push setQuery:pushQuery]; // Set our Installation query
                            [push setChannel:[NSString stringWithFormat:@"user_%@",[receiverUser objectId]]];
                            
                            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [NSString stringWithFormat:@"%@ Mention you in Comment.",[PFUser currentUser].username], @"alert",
                                                  @"Increment", @"badge",
                                                  @"default",@"sound",
                                                  @"mention",@"action",
                                                  self.challengeId,@"challengeId",
                                                  nil];
                            [push setData:data];
                            [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                                if (!errror) {
                                }else{
                                }
                            }];
                        }
                    }
                }
                
                [self getComments];
                if (appdelegateRef.isTimeline==TRUE) {
                    NSNotification *notif = [NSNotification notificationWithName:@"comments" object:self];
                    [[NSNotificationCenter defaultCenter] postNotification:notif];
                }else{
                    if(isFromFindTags){
                        NSNotification *notif = [NSNotification notificationWithName:@"commentsTags" object:self];
                        [[NSNotificationCenter defaultCenter] postNotification:notif];
                    }else{
                        NSNotification *notif = [NSNotification notificationWithName:@"commentsProfile" object:self];
                        [[NSNotificationCenter defaultCenter] postNotification:notif];
                    }
                }
            }
        }];
    }

}
#pragma mark- own methods
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    if(appdelegateRef.isLaunchFromPushNotification == YES){
        // Do not update the time line comment section
        appdelegateRef.isLaunchFromPushNotification = NO;
    }else{
        if (appdelegateRef.isTimeline == TRUE) {
            NSNotification *notif = [NSNotification notificationWithName:@"commentbackAction" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
        else{
            if(isFromFindTags){
                NSNotification *notif = [NSNotification notificationWithName:@"commentbackActionTags" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
            }
            else{
                NSNotification *notif = [NSNotification notificationWithName:@"commentbackActionProfile" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(STTweetLabel *)setTweetLabelForLikeUser :(NSString*)text textSize:(CGSize)size{
    
    STTweetLabel* _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0, 0, 195, size.height)];
    [_tweetLabel setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [_tweetLabel setTextColor:[UIColor blackColor]];
    
    STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
        
        switch (actionType) {
            case STLinkActionTypeAccount:
                [self atSelected:link];
                break;
            case STLinkActionTypeHashtag:
                break;
            case STLinkActionTypeWebsite:
                break;
        }
    };
    
    [_tweetLabel setCallbackBlock:callbackBlock];
    
    return _tweetLabel;
}
@end
