//
//  HomeViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.

#define originalHeight 125.0f
#define expansionHeight 260.0f
#import "HomeViewController.h"
#import "TrashViewController.h"
#import "InboxViewController.h"
#import "SHCToDoItem.h"
#import "SHCTableViewCell.h"
#import "UIViewController+MJPopupViewController.h"
#import "AddMoteViewController.h"
#import "FbFriendsViewController.h"
#import "SubNoteViewController.h"
#import "UIView+SubviewHunting.h"
#import "InfoViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "JSONKit.h"
@interface HomeViewController (){
    UIToolbar *toolBar;
    UIDatePicker *pickerDateTime;
}
@end

@implementation HomeViewController
NSIndexPath *currentIndexPath;
NSMutableArray *arraySubNots;
int intTableSubHeight;
NSIndexPath *currentExpandedIndexpath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    self.canDisplayBannerAds = YES;
    arrHomeNotes=[[NSMutableArray alloc]init];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.currentRightClass=@"Trash";
    appDelegate.currentLeftClass=@"Send note";
    appDelegate._toDoItems = [[NSMutableArray alloc] init];
    tblHome.delegate = self;
    tblHome.dataSource = self;
    arraySubNots=[[NSMutableArray alloc]init];
    pagingCount=5;

    subNotsTable.tag=9999;
    
    if ([PFUser currentUser]) {
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleSwipeGestureToTrash)];
        [self.view addGestureRecognizer:swipeGestureLeft];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(handleSwipeGestureToInbox)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeGestureRight];
        [tblHome registerClass:[SHCTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        
    }

    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addNewNotes) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(0, 0, 22, 22)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"addwhite.png"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"btnPluseHigh.png"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];;

    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 30, 44);
        SINavigationMenuView *menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@""];
        [menu displayMenuInView:self.view];
        
        if ([PFUser currentUser]) {
            menu.items = @[@"Remove Ads", @"How to Use Skyy", @"Privacy Policy",@"Like Skyy on Facebook",@"Delete Profile", @"Logout of Facebook"];
        }else{
            menu.items = @[@"Remove Ads", @"How to Use Skyy", @"Privacy Policy",@"Like Skyy on Facebook",@"Delete Profile", @"Login with Facebook"];
            
        }
        menu.delegate = self;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menu ];
    }
}

#pragma iAd Delegate
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self.view addSubview:banner];
    [self.view layoutIfNeeded];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [banner removeFromSuperview];
    [self.view layoutIfNeeded];
}

#pragma mark Menu Delegate
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    if (index==1) {
        InfoViewController *info=[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
        info.isSetting=TRUE;
        [self.navigationController pushViewController:info animated:TRUE];
    }
    
    if (index==2) {
        ViewController *objViewController=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil                                       ];
        [self.navigationController pushViewController:objViewController animated:TRUE];
    }
    if (index==5) {
        [PFUser logOut];
        LoginViewController *objLoginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:objLoginViewController animated:TRUE];
    }
}
-(void)getAllHomeNote{
    [NSThread detachNewThreadSelector:@selector(selfActivities) toTarget:self withObject:nil];
    PFQuery *queryHome=[PFQuery queryWithClassName:@"TblHome"];
    [queryHome whereKey:@"CreatUser" equalTo:[PFUser currentUser]];
    [queryHome includeKey:@"NoteRef.CreatUser"];
    [queryHome orderByDescending:@"IndexDate"];
    [queryHome setLimit:pagingCount];
    [queryHome findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [appDelegate._toDoItems removeAllObjects];
        for (int i=0; i<[objects count]; i++) {
            PFObject *objHome=[objects objectAtIndex:i];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            PFQuery *querySubnotes=[PFQuery queryWithClassName:@"TblSubNotes"];
            [querySubnotes whereKey:@"ParentNote" equalTo:objNote];
            [querySubnotes includeKey:@"ParentNote"];
            [querySubnotes addDescendingOrder:@"createdAt"];
            [querySubnotes includeKey:@"Sender"];
            NSMutableArray *arrSub=[[querySubnotes findObjects]mutableCopy];
            [objHome setObject:arrSub forKey:@"SubNotes"];
            [appDelegate._toDoItems addObject:[SHCToDoItem toDoItemWithText:[objNote objectForKey:@"note"]]];
            arrHomeNotes=[objects mutableCopy];
        }
        [tblHome reloadData];
        isloding=TRUE;
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    }];
}

-(void)relodAllPostMethod{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
   [NSThread detachNewThreadSelector:@selector(selfActivities) toTarget:self withObject:nil];
    PFQuery *queryHome=[PFQuery queryWithClassName:@"TblHome"];
    [queryHome whereKey:@"CreatUser" equalTo:[PFUser currentUser]];
    [queryHome includeKey:@"NoteRef.CreatUser"];
    [queryHome orderByDescending:@"IndexDate"];
    [queryHome setLimit:pagingCount];
    [queryHome findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [appDelegate._toDoItems removeAllObjects];
        for (int i=0; i<[objects count]; i++) {
            PFObject *objHome=[objects objectAtIndex:i];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            PFQuery *querySubnotes=[PFQuery queryWithClassName:@"TblSubNotes"];
            [querySubnotes whereKey:@"ParentNote" equalTo:objNote];
            [querySubnotes includeKey:@"ParentNote"];
            [querySubnotes addDescendingOrder:@"createdAt"];
            [querySubnotes includeKey:@"Sender"];
            NSMutableArray *arrSub=[[querySubnotes findObjects]mutableCopy];
            [objHome setObject:arrSub forKey:@"SubNotes"];
            [appDelegate._toDoItems addObject:[SHCToDoItem toDoItemWithText:[objNote objectForKey:@"note"]]];
            arrHomeNotes=[objects mutableCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [tblHome reloadData];
             [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        });
        isloding=TRUE;
        
    }];
});
}


-(void)addNewNotes{
    
    isNewNote=TRUE;
    AddMoteViewController *objAddMoteViewController = [[AddMoteViewController alloc] initWithNibName:@"AddMoteViewController" bundle:nil];
    objAddMoteViewController.delegate=self;
    objAddMoteViewController.isEdit=FALSE;
    [self presentPopupViewController:objAddMoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(void)editNote:(id)sender{
    UIButton *btn=(UIButton *) sender;
    SHCTableViewCell *cell;
    if (SYSTEM_VERSION_GREATER_THAN(@"6.1")) {
        cell=(SHCTableViewCell*)btn.superview.superview.superview;
    }
    else{
        cell=(SHCTableViewCell*)btn.superview.superview;
    }
    PFObject  *objHome=[arrHomeNotes objectAtIndex:[sender tag]];
    objEditNote=[objHome objectForKey:@"NoteRef"];
    AddMoteViewController *objAddMoteViewController = [[AddMoteViewController alloc] initWithNibName:@"AddMoteViewController" bundle:nil];
    objAddMoteViewController.delegate=self;
    objAddMoteViewController.isEdit=TRUE;
    objAddMoteViewController.strEdit=cell._label.text;
    [self presentPopupViewController:objAddMoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}
-(void)editSubNote:(id)sender{
    
    objEditSubNote=[arraySubNots objectAtIndex:[sender tag]];
    SubNoteViewController *objSubNoteViewController = [[SubNoteViewController alloc] initWithNibName:@"SubNoteViewController" bundle:nil];
    objSubNoteViewController.delegate=self;
    objSubNoteViewController.isEditSubNote=TRUE;
    objSubNoteViewController.strSubNote=[objEditSubNote objectForKey:@"SubNote"];
    [self presentPopupViewController:objSubNoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.translucent = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor= [UIColor colorWithRed:245.0/255.0 green:179.0/255.0 blue:51.0/255.0 alpha:1.0];
    }else{

        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:179.0/255.0 blue:51.0/255.0 alpha:1.0]];
    }
    
    self.title=@"Home";
    
    if ([PFUser currentUser]) {
       // [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self getAllHomeNote];
        [tblHome reloadData];
    }
    
}

-(void)handleSwipeGestureToTrash {
    
    TrashViewController *objTrashViewController=[[TrashViewController alloc]initWithNibName:@"TrashViewController" bundle:nil];
    objTrashViewController.title=@"Trash";
    [self.navigationController pushViewController:objTrashViewController animated:TRUE];
}

-(void)handlelongGesture{
    
    
}

-(void)handleSwipeGestureToInbox {
    
    InboxViewController *objInboxViewController=[[InboxViewController alloc]initWithNibName:@"InboxViewController" bundle:nil];
    objInboxViewController.title=@"Inbox";
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:objInboxViewController animated:NO];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = appDelegate._toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - UITableViewDataSource protocol methods
- (NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows;
    if (tableView==subNotsTable) {
        numberOfRows = [arraySubNots count];
    }else{
        numberOfRows = appDelegate._toDoItems.count;
    }
    if ([tableView movingIndexPath] && [[tableView movingIndexPath] section] != [[tableView initialIndexPathForMovingRow] section])
    {
        if (section == [[tableView movingIndexPath] section]) {
            numberOfRows++;
        }
        else if (section == [[tableView initialIndexPathForMovingRow] section]) {
            numberOfRows--;
        }
    }
    return numberOfRows;
}

UILabel *lblSubNote;
UIButton *btnEditSubNote;
-(UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==subNotsTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        }
        if ([tableView indexPathIsMovingIndexPath:indexPath])
        {
            [cell.textLabel setText:@""];
            [cell.detailTextLabel setText:@""];
        }
        else
        {
            if ([tableView movingIndexPath]) {
                indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
            }
            
            PFObject *objSubNote=[arraySubNots objectAtIndex:indexPath.row];
           // cell.textLabel.text=[objSubNote objectForKey:@"SubNote"];
            PFUser *senderUser=[objSubNote objectForKey:@"Sender"];


            UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(34, 7, 120, 24)];
            UILabel *lblUserNameSub = [[UILabel alloc] initWithFrame:CGRectMake(34, 28, 120, 24)];
            lblText.font = CustomfontLight(15);
            lblUserNameSub.font=CustomfontLight(12);
            lblText.textColor = [UIColor darkGrayColor];
            lblUserNameSub.textColor = [UIColor darkGrayColor];
            lblText.text = [objSubNote objectForKey:@"SubNote"];
            lblUserNameSub.text=[senderUser username];
            [cell.contentView addSubview:lblText];
                        [cell.contentView addSubview:lblUserNameSub];
           if ([[senderUser objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
                btnEditSubNote=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, 16, 16)];
                [btnEditSubNote setBackgroundImage:[UIImage imageNamed:@"editGray.png"] forState:UIControlStateNormal];
                [btnEditSubNote setBackgroundImage:[UIImage imageNamed:@"editOreang.png"] forState:UIControlStateHighlighted];
                [btnEditSubNote addTarget:self action:@selector(editSubNote:) forControlEvents:UIControlEventTouchUpInside];
                [btnEditSubNote setBackgroundColor:[UIColor clearColor]];
                [btnEditSubNote setTag:indexPath.row];
                [cell addSubview:btnEditSubNote];
                [cell.contentView bringSubviewToFront:btnEditSubNote];
            }
        }
        return cell;
        
    }
    else
    {
        
        static NSString *CellIdentifier = @"Cell";
        SHCTableViewCell *cell = [tblHome dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SHCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        if ([tableView indexPathIsMovingIndexPath:indexPath])
        {
            [cell.textLabel setText:@""];
            [cell.detailTextLabel setText:@""];
        }
        else
        {
            if ([tableView movingIndexPath]) {
                indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
            }
            
            
            int index = [indexPath row];
            SHCToDoItem *item = appDelegate._toDoItems[index];
            cell.delegate = self;
            cell.todoItem = item;
            [currentIndexPath isEqual:indexPath] ? [cell expandActionView] : [cell collapseActionViews];
            UITapGestureRecognizer *tapRecg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            tapRecg.delegate = self;
            tapRecg.numberOfTapsRequired = 1;
            tapRecg.numberOfTouchesRequired = 1;
            [cell.doubleTapView addGestureRecognizer:tapRecg];
            UITapGestureRecognizer *doubleTapRecg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
            doubleTapRecg.delegate = self;
            doubleTapRecg.numberOfTapsRequired = 2;
            doubleTapRecg.numberOfTouchesRequired = 1;
            [cell.doubleTapView addGestureRecognizer:doubleTapRecg];
            [tapRecg requireGestureRecognizerToFail:doubleTapRecg];
            cell.doubleTapView.tag=indexPath.row;
            
            UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 259, 100)];
            sbView=[[UIView alloc]initWithFrame:CGRectMake(13, 35, 235, 55)];
            sbView.tag=5656;
            sbView.layer.borderWidth=1.0;
            sbView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            lblUserName=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 160, 30)];
            lblUserName.textColor=[UIColor darkGrayColor];
            [lblUserName setBackgroundColor:[UIColor clearColor]];
            lblUserName.font=CustomfontLight(18);
            [sbView addSubview:lblUserName];
            
            userProfileImage=[[EGOImageView alloc]initWithFrame:CGRectMake(178, 58, 50,50)];
            userProfileImage.layer.cornerRadius=userProfileImage.frame.size.width/2.0;
            userProfileImage.tag=8888;
            userProfileImage.clipsToBounds=YES;
            userProfileImage.layer.borderWidth=2.0;
            userProfileImage.layer.borderColor=[[UIColor grayColor] CGColor];
            [detailView addSubview:sbView];
            [detailView addSubview:userProfileImage];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 259, 44)];
            [imageView setImage:[UIImage imageNamed:@"yellowborder.png"]];
            [imageView setBackgroundColor:[UIColor clearColor]];
            cell.backgroundColor = [UIColor clearColor];
            [detailView addSubview:imageView];
            
            UIButton *btnEditNote=[[UIButton alloc]initWithFrame:CGRectMake(235, 10, 16,16)];
            [btnEditNote setBackgroundImage:[UIImage imageNamed:@"editGray.png"] forState:UIControlStateNormal];
            [btnEditNote setBackgroundImage:[UIImage imageNamed:@"editOreang.png"] forState:UIControlStateHighlighted];
            [btnEditNote addTarget:self action:@selector(editNote:) forControlEvents:UIControlEventTouchUpInside];
            [btnEditNote setTag:indexPath.row];
            [cell.doubleTapView addSubview:btnEditNote];
            [cell.contentView addSubview:detailView];
            PFObject *objHome=[arrHomeNotes objectAtIndex:indexPath.row];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            PFUser *inBoxUser=[objNote objectForKey:@"CreatUser"];;
            lblUserName.text=[inBoxUser objectForKey:@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [inBoxUser objectForKey:@"fbId"]]];
            [userProfileImage setImageURL:pictureURL];
            

            
        }
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [arraySubNots objectAtIndex:sourceRow];
    [arraySubNots removeObjectAtIndex:sourceRow];
    [arraySubNots insertObject:object atIndex:destRow];
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)moveTableView:(FMMoveTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

    if (tableView==subNotsTable) {
        NSArray *movie = [[arraySubNots objectAtIndex:[fromIndexPath section]] objectAtIndex:[fromIndexPath row]];
        [[arraySubNots objectAtIndex:[fromIndexPath section]] removeObjectAtIndex:[fromIndexPath row]];
        [[arraySubNots objectAtIndex:[toIndexPath section]] insertObject:movie atIndex:[toIndexPath row]];
        
    }else{
        
        PFObject  *objHomeFrom=[arrHomeNotes objectAtIndex:[fromIndexPath row]];
        PFObject  *objHomeTo=[arrHomeNotes objectAtIndex:[toIndexPath row]];
        NSDate *DateTo = [objHomeTo objectForKey:@"IndexDate"];
        NSTimeInterval secondsInFive = 0;
        
        if ([fromIndexPath row]>[toIndexPath row]) {
            secondsInFive = 5;
        }else{
            secondsInFive = -5;
        }
        
        NSDate *dateUpdated = [DateTo dateByAddingTimeInterval:secondsInFive];
        
        PFObject  *objHomeToCheckUpper;
        if ([toIndexPath row]!=0) {
              if ([fromIndexPath row]>[toIndexPath row]) {
                  objHomeToCheckUpper=[arrHomeNotes objectAtIndex:[toIndexPath row]-1];
              }
        }
        NSDate *DateToCheckUpper = [objHomeToCheckUpper objectForKey:@"IndexDate"];
        NSComparisonResult result;
        result = [DateToCheckUpper compare:dateUpdated]; // comparing two dates
        if(result==NSOrderedSame){
            if ([fromIndexPath row]>[toIndexPath row]) {
                secondsInFive = -2;
                NSLog(@"Neeche se upar +");
            }else{
                secondsInFive = 2;
                NSLog(@"Upar se neeche --");
            }
            dateUpdated = [dateUpdated dateByAddingTimeInterval:secondsInFive];
        }
        
        PFQuery *queryFrom = [PFQuery queryWithClassName:@"TblHome"];
        [queryFrom whereKey:@"objectId" equalTo:objHomeFrom.objectId];
        [queryFrom getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
            if (!error) {
                // Found UserStats
                [userStats setObject:dateUpdated forKey:@"IndexDate"];
                // Save
                [userStats save];
                
          } else {
                // Did not find any UserStats for the current user
                NSLog(@"Error: %@", error);
                
            }
        }];
        NSArray *movie = [appDelegate._toDoItems objectAtIndex:[fromIndexPath row]];
        [appDelegate._toDoItems removeObjectAtIndex:[fromIndexPath row]];
        [appDelegate._toDoItems insertObject:movie atIndex:[toIndexPath row]];
    }
}

- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	return proposedDestinationIndexPath;
}


#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView==subNotsTable) {
        return 50;
    }else{
        //return [currentIndexPath isEqual:indexPath]? expansionHeight : originalHeight;
 
        if([currentIndexPath isEqual:indexPath]){
            PFObject  *objHome=[arrHomeNotes objectAtIndex:indexPath.row];
            if ([[objHome objectForKey:@"SubNotes"] count]==1) {
                 return expansionHeight-100;
            }
            else if ([[objHome objectForKey:@"SubNotes"] count]==2) {
                return expansionHeight-50;
            }
            else {
                return expansionHeight;
            }
            
            
           
        }else{
            return originalHeight;
        }
    }

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (tableView==subNotsTable) {
    //        UIView* reorderControl = [cell huntedSubviewWithClassName:@"UITableViewCellReorderControl"];
    //        for(UIImageView* cellGrip in reorderControl.subviews)
    //        {
    //            if([cellGrip isKindOfClass:[UIImageView class]])
    //                [cellGrip setImage:nil];
    //        }
    //    }
    
}

-(void)toDoItemDeleted:(id)todoItem {
    // use the UITableView to animate the removal of this row
    
    SHCToDoItem *shToDo=(SHCToDoItem *)todoItem;
    int index = [appDelegate._toDoItems indexOfObject:todoItem];
    [tblHome beginUpdates];
    if (shToDo.completed==YES) {
        [appDelegate._toDoItems removeObject:todoItem];
        [tblHome deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [tblHome endUpdates];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self performSelector:@selector(saveMoveNoteToDatabase:) withObject:[NSNumber numberWithInt:index] afterDelay:0.5];
    }else{
        isNewNote=FALSE;
        [self FaceBookFriends:shToDo.text];
        forwordNoteIndex=index;
        [appDelegate._toDoItems removeObject:todoItem];
        [tblHome deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [appDelegate._toDoItems insertObject:todoItem atIndex:index];
        [tblHome insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [tblHome endUpdates];
        [tblHome reloadData];
    }
}

-(void)saveMoveNoteToDatabase :(NSNumber *)index{
    
    PFObject *objHome=[arrHomeNotes objectAtIndex:[index intValue]];
    PFObject *objNote=[objHome objectForKey:@"NoteRef"];
    PFObject *objTrash=[PFObject objectWithClassName:@"TblTrash"];
    [objTrash setObject:objNote forKey:@"NoteRef"];
    [objTrash setObject:@"isHome" forKey:@"fromCome"];
    [objTrash setObject:[objHome objectForKey:@"CreatUser"] forKey:@"CreatUser"];
    [objTrash setObject:[objHome objectForKey:@"CreatUser"] forKey:@"ReceiveUser"];
    [objTrash save];
    [objHome delete];
    [self getAllHomeNote];
}

#pragma mark Delegate Custom
-(void)swipwToSaveNote :(NSString *)note{
    
    if ([note isEqualToString:@""]) {
        DisplayLocalizedAlert(@"Please write something to send your note")
    }else{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        
        if ([PFUser currentUser]) {
            [self performSelector:@selector(FaceBookFriends:) withObject:note afterDelay:1.0];
        }else{
            DisplayLocalizedAlert(@"Please login to create a new note & send it to your FB friends");
        }
        
    }
}
-(void)swipwToEditNote :(NSString *)note{
    PFQuery *query = [PFQuery queryWithClassName:@"TblNote"];
    [query getObjectInBackgroundWithId:[objEditNote objectId] block:^(PFObject *gameScore, NSError *error) {
        [gameScore setObject:note forKey:@"note"];
        [gameScore save];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        [self getAllHomeNote];
    }];
}
-(void)cancelSendNote{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];

}
-(void)sendNote :(NSMutableArray *)arrSelectedFriends{
    
       if (isNewNote==TRUE) {
        PFObject *objNote=[PFObject objectWithClassName:@"TblNote"];
        [objNote setObject:strNote forKey:@"note"];
        [objNote setObject:[PFUser currentUser] forKey:@"CreatUser"];
        [objNote save];
        PFQuery *query=[PFQuery queryWithClassName:@"TblNote"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"CreatUser"];
        [query setLimit:1];
        [query setSkip:0];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *objNote=[objects objectAtIndex:0];
            [self saveNoteToHome:arrSelectedFriends objNote:objNote];

        }];
    }

    else{
        
        [self forwardNote:arrSelectedFriends];
        
    }
    
    
}
-(void)saveNoteToHome :(NSMutableArray *)array objNote:(PFObject *)objNote{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    [MBProgressHUD showHUDAddedTo:self.view.window animated:TRUE];
    for (int i=0; i<[array count]; i++) {
        PFUser *toSendUser=[array objectAtIndex:i];
        PFObject *objInbox=[PFObject objectWithClassName:@"TblInbox"];
        [objInbox setObject:objNote forKey:@"NoteRef"];
        [objInbox setObject:toSendUser forKey:@"ReceiveUser"];
        [objInbox setObject:[NSDate date] forKey:@"IndexDate"];
        [objInbox setObject:[PFUser currentUser] forKey:@"SendUser"];
        [objInbox save];

        // Notification for owner of challenge
        
        // Find devices associated with these users
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"owner" equalTo:toSendUser];
        
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        //[push setQuery:pushQuery]; // Set our Installation query
        [push setChannel:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ send you %@",[PFUser currentUser].username,[objNote objectForKey:@"note"]], @"alert",
                              @"Increment", @"badge",
                              @"default",@"sound",
                              @"note",@"action",
                              nil];
         [self getNotification:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
            if (!errror) {
            }else{
            }
        }];
    }
    PFObject *objHome=[PFObject objectWithClassName:@"TblHome"];
    [objHome setObject:objNote forKey:@"NoteRef"];
    [objHome setObject:[PFUser currentUser] forKey:@"CreatUser"];
    [objHome setObject:[NSDate date] forKey:@"IndexDate"];
    [objHome save];
    [self getAllHomeNote];
    [MBProgressHUD hideHUDForView:self.view.window animated:TRUE];

    
}
-(void)swipeToRightToSaveOnlyHome :(NSString *)note{
    if ([note isEqualToString:@""]) {
        DisplayLocalizedAlert(@"Please write something to send your note")
    }
    else if (![PFUser currentUser]) {
        DisplayLocalizedAlert(@"Please login to create a new note & send it to your FB friends");
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }
    else{
        PFObject *objNote=[PFObject objectWithClassName:@"TblNote"];
        [objNote setObject:note forKey:@"note"];
        [objNote setObject:[PFUser currentUser] forKey:@"CreatUser"];
        [objNote save];
        PFQuery *query=[PFQuery queryWithClassName:@"TblNote"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"CreatUser"];
        [query setLimit:1];
        [query setSkip:0];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *objHome=[PFObject objectWithClassName:@"TblHome"];
            [objHome setObject:objNote forKey:@"NoteRef"];
            [objHome setObject:[PFUser currentUser] forKey:@"CreatUser"];
            [objHome setObject:[NSDate date] forKey:@"IndexDate"];
            [objHome save];
            [self getNotification:[NSString stringWithFormat:@"user_%@",[PFUser currentUser].objectId]];
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            [self getAllHomeNote];
        }];
    }
}

-(void)forwardNote :(NSMutableArray *)arrFriends{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    for (int i=0; i<[arrFriends count]; i++) {
        PFUser *toSendUser=[arrFriends objectAtIndex:i];
        PFObject *objInbox=[PFObject objectWithClassName:@"TblInbox"];
        PFObject  *objHome=[arrHomeNotes objectAtIndex:forwordNoteIndex];
        PFObject *objNote=[objHome objectForKey:@"NoteRef"];
        [objInbox setObject:objNote forKey:@"NoteRef"];
        [objInbox setObject:toSendUser forKey:@"ReceiveUser"];
        [objInbox setObject:[NSDate date] forKey:@"IndexDate"];
        [objInbox setObject:[PFUser currentUser] forKey:@"SendUser"];
        [objInbox save];
        
        // Notification for owner of challenge
        // Find devices associated with these users
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"owner" equalTo:toSendUser];
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        //[push setQuery:pushQuery]; // Set our Installation query
        [push setChannel:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ send you %@",[PFUser currentUser].username,[objNote objectForKey:@"note"]],@"alert",
                              @"Increment", @"badge",
                              @"default",@"sound",
                              @"note",@"action",
                              nil];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
            if (!errror) {
            }else{
            }
        }];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}

-(void)FaceBookFriends :(NSString *)note{
    
    FbFriendsViewController *objFbFriendsViewController=[[FbFriendsViewController alloc]initWithNibName:@"FbFriendsViewController" bundle:nil];
    objFbFriendsViewController.delegate=self;
    strNote=note;
    [self presentPopupViewController:objFbFriendsViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(void)singleTap :(UIGestureRecognizer *)gesture{
     PFObject  *objHome=[arrHomeNotes objectAtIndex:gesture.view.tag];
    if ([[objHome objectForKey:@"SubNotes"] count]>0){
    SHCTableViewCell *cell=(SHCTableViewCell*) gesture.view.superview;
    
    NSIndexPath *indexPath;
    if (SYSTEM_VERSION_GREATER_THAN(@"6.1")) {
        CGPoint center= cell.center;
        CGPoint rootViewPoint = [cell.superview convertPoint:center toView:tblHome];
        indexPath = [tblHome indexPathForRowAtPoint:rootViewPoint];
              currentExpandedIndexpath=indexPath;
    }
    else{
        indexPath = [tblHome indexPathForCell:cell];
        currentExpandedIndexpath=indexPath;
    }
    if (tblHome) {
        if([indexPath isEqual:currentIndexPath])
        {
            UITableViewCell *cell=[tblHome cellForRowAtIndexPath:currentIndexPath];
            
            UIView *subview =[cell.contentView viewWithTag:9999];
            if (subview) {
                [subview removeFromSuperview];
                [arraySubNots removeAllObjects];
                [subNotsTable reloadData];
            }
        }
        currentIndexPath = [currentIndexPath isEqual:indexPath] ? nil : indexPath;
        
        if ([[objHome objectForKey:@"SubNotes"] count]==1) {
            subNotsTable=[[FMMoveTableView alloc]initWithFrame:CGRectMake(13, 40, 235, 50)];
        }
        
        else if ([[objHome objectForKey:@"SubNotes"] count]==2) {
           subNotsTable=[[FMMoveTableView alloc]initWithFrame:CGRectMake(13, 40, 235, 100)];
        }
        else{
             subNotsTable=[[FMMoveTableView alloc]initWithFrame:CGRectMake(13, 40, 235, 150)];
        }
        
        [tblHome reloadData];
        if ([currentIndexPath isEqual:indexPath])
        {
         //   [NSThread detachNewThreadSelector:@selector(selfActivities) toTarget:self withObject:nil];
            UITableViewCell *cell=[tblHome cellForRowAtIndexPath:currentIndexPath];
            UIView *view=[cell viewWithTag:5656];
            EGOImageView *egoIView=(EGOImageView *)[cell viewWithTag:8888];
          
            
            if ([[objHome objectForKey:@"SubNotes"] count]==1) {
                 [view setFrame:CGRectMake(13, 90, 235, 55)];
                  [egoIView setFrame:CGRectMake(178, 107, 50,50)];
            }
            else if ([[objHome objectForKey:@"SubNotes"] count]==2) {
                 [view setFrame:CGRectMake(13, 140, 235, 55)];
                  [egoIView setFrame:CGRectMake(178, 157, 50,50)];
            }
            else{
                 [view setFrame:CGRectMake(13, 190, 235, 55)];
                  [egoIView setFrame:CGRectMake(178, 207, 50,50)];
            }
            
           
          
 
           
            [subNotsTable setDataSource:self];
            [subNotsTable setDelegate:self];
            subNotsTable.layer.borderWidth = 2.5;
            subNotsTable.layer.borderColor = [[UIColor colorWithRed:243.0/255 green:175.0/255 blue:40.0/255 alpha:1.0] CGColor];
            subNotsTable.separatorColor=[UIColor colorWithRed:243.0/255 green:175.0/255 blue:40.0/255 alpha:1.0];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                [subNotsTable setSeparatorInset:UIEdgeInsetsZero];
            }
            [subNotsTable setBackgroundColor:[UIColor clearColor]]; 
            [cell.contentView addSubview:subNotsTable];
            [cell.contentView sendSubviewToBack:subNotsTable];
           
            arraySubNots=[objHome objectForKey:@"SubNotes"];
            [subNotsTable reloadData];
           
        }
    }
}
}
-(void)DoubleTap:(UIGestureRecognizer *)gesture{
    if (tblHome) {
        SubNoteViewController *objSubNoteViewController = [[SubNoteViewController alloc] initWithNibName:@"SubNoteViewController" bundle:nil];
        objSubNoteViewController.delegate=self;
        objSubNoteViewController.index=gesture.view.tag;
        [self presentPopupViewController:objSubNoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    }
}
-(void)selfActivities{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

}
-(void)sendSubnote :(NSString *)subNote selectIndex:(NSInteger )index{
    if ([subNote isEqualToString:@""]) {
        DisplayLocalizedAlert(@"Please write somthing before send subnote");
    
    }
    else{
        //Added
              //
        [MBProgressHUD showHUDAddedTo:self.view.window animated:TRUE];
        PFObject *objSubNotes=[PFObject objectWithClassName:@"TblSubNotes"];
        [objSubNotes setObject:subNote forKey:@"SubNote"];
        [objSubNotes setObject:[PFUser currentUser] forKey:@"Sender"];
        PFObject  *objHome=[arrHomeNotes objectAtIndex:index];
        PFUser *createrUser=[objHome objectForKey:@"CreatUser"];
        [objSubNotes setObject:createrUser forKey:@"Receiver"];
        PFObject *objNote=[objHome objectForKey:@"NoteRef"];
        [objSubNotes setObject:objNote forKey:@"ParentNote"];
        [objSubNotes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:TRUE];
                [self getAllHomeNote];
                [subNotsTable reloadData];
                PFUser *toSendUser=[objNote objectForKey:@"CreatUser"];
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:toSendUser];
                PFPush *push = [[PFPush alloc] init];
                [push setChannel:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ send you %@",[PFUser currentUser].username,subNote],@"alert",@"Increment",@"badge",@"default",@"sound",@"Subnote",@"action",nil];
                [push setData:data];
                [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                    if (!errror) {
                    }else{
                    }
                }];
                //[self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:TRUE];
            }
        }];
        
    }
}

-(void)sendEditSubnote :(NSString *)subNote selectIndex:(NSInteger )index
{
    PFQuery *query = [PFQuery queryWithClassName:@"TblSubNotes"];
    [query getObjectInBackgroundWithId:[objEditSubNote objectId] block:^(PFObject *gameScore, NSError *error) {
        [gameScore setObject:subNote forKey:@"SubNote"];
        [gameScore save];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }];
}
-(void)cancelSubNote{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
    
}
#pragma mark
#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float scrollOffset = scrollView.contentOffset.y;
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;

    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        isloding=FALSE;
    }

    
    if (isloding==TRUE) {
            if (([scrollView contentOffset].y + scrollView.frame.size.height) >= [scrollView contentSize].height){
                isloding=FALSE;
                pagingCount=pagingCount+5;
                [self relodAllPostMethod];
            }
        }
}

#pragma mark Notification Testing

- (void)getNotification:(NSString *)strUserID{
    @try {
        NSString *strURL=[NSString stringWithFormat:@"https://api.parse.com/1/push"];
        NSURL *url = [NSURL URLWithString:strURL];
        NSMutableURLRequest* reqeust = [NSMutableURLRequest requestWithURL:url];
        [reqeust setValue:@"ftFfLnarcXfL6k1LMiTRdJAbNT8BoYyAnkkUJwbP" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [reqeust setValue:@"fY4yPbmeyxrgrOtpVe2P3AH4NLsD3Ua7xQMnLwnM" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [reqeust setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
        // Create url connection and fire request
        [reqeust setHTTPMethod:@"POST"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

        //Arry Channel
        NSMutableArray *aryChannel=[[NSMutableArray alloc] initWithObjects: nil];
        [aryChannel addObject:strUserID];
        [aryChannel addObject:[NSString stringWithFormat:@"user_%@",[[PFUser currentUser] objectId]]];
        [dic setObject:aryChannel forKey:@"channels"];
        //Push_time
        
        NSDate *testDate=[[NSDate alloc]init];
        NSTimeInterval timeintervalox=[testDate timeIntervalSince1970];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
        NSDate *date = [dateFormatter dateFromString:strDateTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSString *str = [dateFormatter stringFromDate:date];
        [dic setObject:str forKey:@"push_time"];
        NSMutableDictionary *dicData=[[NSMutableDictionary alloc]init];
        [dicData setObject:strNote forKey:@"alert"];
        [dic setObject:dicData forKey:@"data"];
        NSData *data=[dic JSONData];
        reqeust.HTTPBody = data;
        NSURLResponse* response;
        NSError* error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:reqeust  returningResponse:&response error:&error];
        NSString* StrResult = [[NSString alloc] initWithData:result
                                                  encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    [_responseData appendData:data];
    NSString *responseString= [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    NSDictionary *dic = [responseString objectFromJSONString];
    
       
    
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
