//
//  FindChallengesViewConroller.m
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FindChallengesViewConroller.h"
#import "FrndSugestCustomCell.h"
#import "FindMapListViewController.h"
#import "TagCustomCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "FindMapViewController.h"
#import "ProfileViewController.h"
#import "TimeLineViewController.h"
#import "TimeLineViewController_copy.h"
@implementation FindChallengesViewConroller
@synthesize searchBar;
@synthesize tblFindResult;
@synthesize txtFieldSearch;
@synthesize btnAtUser;
@synthesize btnHash;
@synthesize intTypeOf;
@synthesize aryTagSearchDisplay;
@synthesize mAryUsers;
@synthesize searchType;
@synthesize aryUserSearchDisplay;
@synthesize imgAtUser,imgHash,imgLocation;
const int HASHTAG=0;
const int ATUSER=1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
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
   // [self setSearchBarSubView];
    
    self.searchType=PDSearchTypeContains;
    mAryUsers = [[NSMutableArray alloc]init];
    [self getTagsData];
 
}
- (void)viewDidUnload{
    [self setTxtFieldSearch:nil];
    [self setBtnHash:nil];
    [self setBtnAtUser:nil];
    [self setTblFindResult:nil];
    [self setSearchBar:nil];
    [self setImgHash:nil];
    [self setImgAtUser:nil];
    [self setImgLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark
#pragma Mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;    //count of section
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(intTypeOf==HASHTAG)
       // return [mutArrAllEventTag count];
        return [self.aryTagSearchDisplay count];
    else
        return [self.aryUserSearchDisplay count];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(intTypeOf==HASHTAG){
        static NSString *CellIdentifier = @"Cell";
        TagCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TagCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //if(isCurrentUser){
                        
        }
        cell.lblTitle.text=[self.aryTagSearchDisplay objectAtIndex:indexPath.row];
        
        cell.lblTitle.font=[UIFont fontWithName:@"DynoRegular" size:18];
        // cell.lblTitle.text=@"FitTag";
        [cell.btnAdd setHidden:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"UserCell";
        FrndSugestCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FrndSugestCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.imgProfileView.layer setBorderWidth:1];
            [cell.imgProfileView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [cell.imgProfileView.layer setCornerRadius:5.0];
            //cell.imgProfileView.layer.masksToBounds = YES;
            cell.imgProfileView.clipsToBounds=YES;

        }
        PFUser *user =[self.aryUserSearchDisplay objectAtIndex:indexPath.row];
        
        cell.lblUserName.text=[user username];
        cell.lblUserName.font=[UIFont fontWithName:@"DynoRegular" size:18];
                PFFile *uesrProfileImage = [user objectForKey:@"userPhoto"];
        [cell.imgProfileView setImageURL:[NSURL URLWithString:[uesrProfileImage url]]];
        [cell.btnFollow setHidden:YES];
        
        return cell;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(intTypeOf==ATUSER){
        
        ProfileViewController *profileVC = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        profileVC.title=@"Profile";
        profileVC.profileUser = [aryUserSearchDisplay objectAtIndex:indexPath.row];
         profileVC.title=[profileVC.profileUser username];
        [self.navigationController pushViewController:profileVC animated:YES];

    }else if(intTypeOf == HASHTAG){
        
        TimeLineViewController_copy *timelineTagVC=[[TimeLineViewController_copy alloc]initWithNibName:@"TimeLineViewController_copy" bundle:nil];
        timelineTagVC.title=[self.aryTagSearchDisplay objectAtIndex:indexPath.row];
        timelineTagVC.strSelectedTag = [self.aryTagSearchDisplay objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:timelineTagVC animated:YES];;
    }
}
#pragma mark
#pragma mark Button Actions
- (IBAction)btnHashPressed:(id)sender {
    [searchBar resignFirstResponder];
    intTypeOf=HASHTAG;
    [imgHash setImage:[UIImage imageNamed:@"btnHashSel"] ];
    [imgAtUser setImage:[UIImage imageNamed:@"btnAt"]];
    [searchBar setText:@""];
    aryTagSearchDisplay=mutArrAllEventTag;
    
    [tblFindResult reloadData];
}
- (IBAction)btnAtUserPressed:(id)sender {
    
    
    if ([aryUserSearchDisplay count]==0) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFQuery *query = [PFUser query];
        
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                PFQuery *queryuser = [PFUser query];
                [queryuser setLimit:count];
                [queryuser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error){
                        mAryUsers  = [objects mutableCopy];
                        aryUserSearchDisplay = [NSArray arrayWithArray:objects];
                        [searchBar resignFirstResponder];
                        intTypeOf=ATUSER;
                        [imgAtUser setImage:[UIImage imageNamed:@"btnAtSel"]];
                        [imgHash setImage:[UIImage imageNamed:@"btnHash"]];
                        [searchBar setText:@""];
                        aryUserSearchDisplay=mAryUsers;
                        [tblFindResult reloadData];
                    }
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                }];
            } else {
                // The request failed
            }
        }];
        
    }else{
  
    [searchBar resignFirstResponder];
    intTypeOf=ATUSER;
    [imgAtUser setImage:[UIImage imageNamed:@"btnAtSel"]];
    [imgHash setImage:[UIImage imageNamed:@"btnHash"]];
    [searchBar setText:@""];
    aryUserSearchDisplay=mAryUsers;
    [tblFindResult reloadData];
    }

}
- (IBAction)btnMapPressed:(id)sender {
    FindMapViewController *findMapVC=[[FindMapViewController alloc]initWithNibName:@"FindMapViewController" bundle:nil];
    findMapVC.title=@"Map";
    [self.navigationController pushViewController:findMapVC animated:YES];
}
-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Searchbar Delegate Method
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
   // [self filterResults:searchString];
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(intTypeOf==HASHTAG){
        if ([searchText length] == 0) 
        {
            [self.searchBar performSelector: @selector(resignFirstResponder) 
                                 withObject: nil 
                                 afterDelay: 0.1];
            aryTagSearchDisplay = mutArrAllEventTag;
        } 
        else 
        {
            NSPredicate *predicate;
            switch (self.searchType) {
                case PDSearchTypeContains:
                    predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
                    break;
                case PDSearchTypeBeginsWith:
                    predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
                    break;
                default:
                    break;
            }
         
            aryTagSearchDisplay = [mutArrAllEventTag filteredArrayUsingPredicate:predicate];
            
        }
    [self.tblFindResult reloadData];
    
    }else{
        if ([searchText length] == 0) 
        {
            [self.searchBar performSelector: @selector(resignFirstResponder) 
                                 withObject: nil 
                                 afterDelay: 0.1];
            aryUserSearchDisplay = mAryUsers;
        } 
        else 
        {
            NSPredicate *predicate;
//            switch (self.searchType) {
//                case PDSearchTypeContains:
//                    predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
//                    break;
//                case PDSearchTypeBeginsWith:
//                    predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
//                    break;
//                default:
//                    break;
//            }
             predicate = [NSPredicate predicateWithFormat: @"username CONTAINS[cd] %@", searchText];
                aryUserSearchDisplay = [mAryUsers filteredArrayUsingPredicate:predicate];
         
            
        }
        
        [self.tblFindResult reloadData];
    }

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1 {
    [searchBar1 setShowsCancelButton:NO animated:NO];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    aryUserSearchDisplay = mAryUsers;
     [self.tblFindResult reloadData];
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [searchBar1 resignFirstResponder];
}
#pragma mark Own Method
-(void)getTagsData{

    @try {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mutArrEventTagResponse = [[NSMutableArray alloc]init];
        mutArrAllEventTag = [[NSMutableArray alloc]init];
        
        PFQuery *query123 = [PFQuery queryWithClassName:@"tblEventTag"];
        [query123 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                PFQuery *postQuery = [PFQuery queryWithClassName:@"tblEventTag"];
                [postQuery includeKey:@"userId"];
                [postQuery addDescendingOrder:@"createdAt"];
                [postQuery setLimit:count];
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
                        
                        
                        aryTagSearchDisplay = [NSArray arrayWithArray:mutArrAllEventTag];
                        [tblFindResult reloadData];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }else{
                    }
                }];
                
            } else {
                // The request failed
            }
        }];

    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
}
-(void)setSearchBarSubView{
    [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    searchBar.layer.borderWidth = 0;
    searchBar.showsCancelButton=NO;
    [searchBar setShowsCancelButton:NO animated:NO];
    UITextField *searchField;
    NSUInteger numViews = [searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [searchBar.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor whiteColor];
        [searchField setBackground: [UIImage imageNamed:@"searchBG.png"] ];
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setTextColor:[UIColor blackColor]];
    }
    
    [searchField setEnablesReturnKeyAutomatically:NO];
    
}
@end
