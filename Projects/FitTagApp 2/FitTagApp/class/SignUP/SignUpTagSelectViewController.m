//
//  SignUpTagSelectViewController.m
//  FitTagApp
//
//  Created by apple on 2/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SignUpTagSelectViewController.h"
#import "GCPlaceholderTextView.h"
#import "SignUp3FindFriendViewController.h"
#import "TagCustomCell.h"
//;
@implementation SignUpTagSelectViewController
@synthesize txtViewTags;
@synthesize tblTags;

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
    
//    for(UIView* view in self.navigationController.navigationBar.subviews)
//    {
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            [view removeFromSuperview];
//        }
//        
//    }
//    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setBackgroundColor:[UIColor blackColor]];
//    
//    UILabel * nav_title = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 25)];
//    nav_title.font = [UIFont fontWithName:@"DynoBold" size:21];
//    nav_title.textColor = [UIColor whiteColor];
//    nav_title.textAlignment=UITextAlignmentCenter;
//    nav_title.adjustsFontSizeToFitWidth = YES;
//    nav_title.text = @"Step 3";
//    self.title = @"";
//    nav_title.backgroundColor = [UIColor clearColor];
//    [bar addSubview:nav_title];
    
    // Do any additional setup after loading the view from its nib.
    [self.txtViewTags setPlaceholderColor:[UIColor lightGrayColor]];
    [self.txtViewTags setPlaceholder:@"Choose Tags that describe the workouts you like. This will help us find you users to follow!"];
    [txtViewTags setFont:[UIFont fontWithName:@"DynoRegular" size:12]];

    //navigation back Button- Arrow
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
    
    UIButton *btnBarNext=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBarNext addTarget:self action:@selector(btnNextPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnBarNext setFrame:CGRectMake(0, 0, 52, 30)];
    [btnBarNext setImage:[UIImage imageNamed:@"btnSmallnext"] forState:UIControlStateNormal];
    [btnBarNext setImage: [UIImage imageNamed:@"btnSmallnextSel"] forState:UIControlStateHighlighted];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 52,30)];
    [view addSubview:btnBarNext];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-11;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];

    mutArrEventTagResponse = [[NSMutableArray alloc]init];
    
    mutArrAllEventTag = [[NSMutableArray alloc]init];
    
    [self showHUD];
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"tblEventTag"];
    [postQuery includeKey:@"userId"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            mutArrEventTagResponse = [objects mutableCopy];
            //Save results and update the table
            for(int i = 0; i < [mutArrEventTagResponse count];i++){ 
                PFObject *pfAllTags = [mutArrEventTagResponse objectAtIndex:i];
                
                NSArray *arrTagTitle = [[pfAllTags objectForKey:@"tagTitle"] componentsSeparatedByString:@" "]; 
                // Keep the uniqe value in the tag array
                for (int j = 0; j < [arrTagTitle count]; j++){
                    if([mutArrAllEventTag containsObject:[[arrTagTitle objectAtIndex:j]lowercaseString]]){
                        // Do not add the string if already exist    
                    }else{
                        if([[[arrTagTitle objectAtIndex:j]lowercaseString] length]>0)
                            [mutArrAllEventTag addObject:[[arrTagTitle objectAtIndex:j]lowercaseString]];
                    }
                }
            }
            [self hideHUD];
            [tblTags reloadData];
        }else{
            [self hideHUD];
        }
    }];

}

- (void)viewDidUnload
{
    [self setTxtViewTags:nil];
    [self setTblTags:nil];
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
    
    return [mutArrAllEventTag count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TagCustomCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TagCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.lblTitle.text = [mutArrAllEventTag objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.btnAdd addTarget:self action:@selector(AddTagsForUser:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAdd.tag = indexPath.row;
    
    [cell.lblTitle setFont:[UIFont fontWithName:@"DynoRegular" size:17]];
    [cell.btnAdd.titleLabel setFont:[UIFont fontWithName:@"DynoRegular" size:17]];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 58;
    
    
}

-(IBAction)btnNextPressed:(id)sender{
    if([[txtViewTags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]){
        DisplayAlertWithTitle(@"FitTag",@"Please enter tags")
    }else{
        [self setUserTags];
        
    }

}
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextViewDelegate 

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([txtViewTags.text length] == 0){
        txtViewTags.text = @"#";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([txtViewTags.text length] !=0 ){
        if([[txtViewTags.text substringFromIndex:[txtViewTags.text length]-1] isEqualToString:@"#"]){
            txtViewTags.text = [txtViewTags.text substringToIndex:[txtViewTags.text length]-1];
        }
    
    }
    
 

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(newLength < 160){
        
        if ([text isEqualToString:@"\n"]){
            [textView resignFirstResponder];
            return NO;
        }else{
            
            if([text isEqualToString:@" "]){
                NSString *strLastCharactor = [txtViewTags.text substringFromIndex:[txtViewTags.text length]-1];
                
                if([strLastCharactor isEqualToString:@"#"]){
                    DisplayAlertWithTitle(@"FitTag",@"Please enter tag before hitting space");
                    return NO;
                }else{
                    txtViewTags.text = [NSString stringWithFormat:@"%@ #",[txtViewTags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    
                    [txtViewTags.text substringToIndex:[txtViewTags.text length]-1];
                    return NO;
                }
            }
        }

    }else{
        [textView resignFirstResponder];
    }

    return YES;
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
// replacementText:(NSString *)text
//{
//    
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        // Return FALSE so that the final '\n' character doesn't get added
//        return NO;
//    }
//    // For any other character return TRUE so that the text gets added to the view
//    return YES;
//}

#pragma Mark HUD Methods

-(void)showHUD{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading...";
}

-(void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma Mark AddUserTag

-(void)setUserTags{
    
    // Set determinate mode
    [self showHUD];
    PFObject *activitie = [PFObject objectWithClassName:@"tblEventTag"];
    [activitie setObject:[PFUser currentUser] forKey:@"userId"];
    [activitie setObject:[txtViewTags text] forKey:@"tagTitle"];
    
    //Set ACL permissions for added security
    PFACL *activitieACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [activitieACL setPublicReadAccess:YES];
    [activitie setACL:activitieACL];
    [activitie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            //[self hideHUD];
            
            mutArrSuggestedFriends = [[NSMutableArray alloc]init];
            NSMutableArray *mutArrUniqueNameTemp = [[NSMutableArray alloc]init];
            
            for(int i = 0; i < [mutArrEventTagResponse count];i++){ 
                PFObject *pfAllTags = [mutArrEventTagResponse objectAtIndex:i];
                
                NSArray *arrTagTitle = [[pfAllTags objectForKey:@"tagTitle"] componentsSeparatedByString:@"#"];
                
                PFUser *pfSugestedUserAllInfoFromDB = [pfAllTags objectForKey:@"userId"];
                
                if(pfSugestedUserAllInfoFromDB != nil){
                    NSArray *arrUserTags = [txtViewTags.text componentsSeparatedByString:@"#"];
                    
                    // Keep the uniqe value in the tag array
                    for (int j = 0; j < [arrUserTags count]; j++){
                        
                        for(int k = 0; k < [arrTagTitle count];k++){
                            
                            if([[[arrUserTags objectAtIndex:j] lowercaseString] isEqualToString:[[arrTagTitle objectAtIndex:k]lowercaseString]]){
                                
                                if([mutArrUniqueNameTemp containsObject:[[pfSugestedUserAllInfoFromDB objectForKey:@"username"]lowercaseString]]){
                                    // Do not add the User if already exist
                                }else{
                                    NSMutableDictionary *dictSuggestedUserInfo = [[NSMutableDictionary alloc]init];
                                    // Get the user name
                                    [dictSuggestedUserInfo setObject:[[pfSugestedUserAllInfoFromDB objectForKey:@"username"]lowercaseString] forKey:@"name"];
                                    [mutArrUniqueNameTemp addObject:[[pfSugestedUserAllInfoFromDB objectForKey:@"username"]lowercaseString]];
                                    [dictSuggestedUserInfo setObject:[pfSugestedUserAllInfoFromDB objectId] forKey:@"objectIdForUser"];
                                    [dictSuggestedUserInfo setObject:@"No" forKey:@"isFollow"];
                                    [dictSuggestedUserInfo setObject:pfSugestedUserAllInfoFromDB forKey:@"followUser"];
                                    
                                    // Get the image URL
                                    PFFile *pfUserImageURL = [pfSugestedUserAllInfoFromDB objectForKey:@"userPhoto"];
                                    
                                    if([pfUserImageURL url]!=nil ){
                                        [dictSuggestedUserInfo setObject:[pfUserImageURL url] forKey:@"ImageURL"];
                                    }
                                    [mutArrSuggestedFriends addObject:dictSuggestedUserInfo];
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            [self hideHUD];
            
            SignUp3FindFriendViewController *signupFindFrndVC=[[SignUp3FindFriendViewController alloc]initWithNibName:@"SignUp3FindFriendViewController" bundle:nil];
            signupFindFrndVC.arrSugestedFriends = mutArrSuggestedFriends;
            signupFindFrndVC.title = @"Step 4";
            [self.navigationController pushViewController:signupFindFrndVC animated:YES];

        }else{
            [self hideHUD];
        }
    }];
}

-(void)AddTagsForUser:(id)sender{
    UIButton *btnAddTag = (UIButton *)sender;
    
    // Check if your alredy entered the same tag before
    if([txtViewTags.text rangeOfString:[mutArrAllEventTag objectAtIndex:btnAddTag.tag]].location == NSNotFound){
        
        if([txtViewTags.text length] < 1){
            txtViewTags.text = [NSString stringWithFormat:@"%@ ",[mutArrAllEventTag objectAtIndex:btnAddTag.tag]];
        }else{
            txtViewTags.text = [NSString stringWithFormat:@"%@ %@",txtViewTags.text,[mutArrAllEventTag objectAtIndex:btnAddTag.tag]];
        }
    }else{
        DisplayAlertWithTitle(@"FitTag", @"You have already selected this #Tag");
    }
    
}
@end
