//
//  InboxViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.

#import "InboxViewController.h"
#import "SHCToDoItem.h"
#import "SHCTableViewCell.h"
#import "MBProgressHUD.h"
#import "FbFriendsViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SubNoteViewController.h"
#import "UIView+SubviewHunting.h"

#define originalHeight 125.0f
#define expansionHeight 260.0f
NSMutableArray *arraySubNots;
NSIndexPath *currentIndexPath;
@interface InboxViewController ()

@end

@implementation InboxViewController
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
    self.navigationItem.hidesBackButton=YES;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.currentRightClass=@"Trash";
    appDelegate.currentLeftClass=@"";
    arrCurrentInbox=[[NSArray alloc]init];
    arraySubNots=[[NSMutableArray alloc]init];
    subNotsTable=[[FMMoveTableView alloc]initWithFrame:CGRectMake(13, 40, 235, 150)];
    [subNotsTable setDataSource:self];
    [subNotsTable setDelegate:self];
    [subNotsTable setEditing:YES animated:YES];
    subNotsTable.layer.borderWidth = 2.5;
    subNotsTable.layer.borderColor = [[UIColor colorWithRed:60.0/255 green:187.0/255 blue:255.0/255 alpha:1.0] CGColor];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [subNotsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    subNotsTable.separatorColor=[UIColor colorWithRed:60.0/255 green:187.0/255 blue:255.0/255 alpha:1.0];
    [subNotsTable setBackgroundColor:[UIColor clearColor]];
    subNotsTable.tag=9999;

    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleSwipeGestureToHome)];
    
    [self.view addGestureRecognizer:swipeGestureLeft];

    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [tblInbox registerClass:[SHCTableViewCell class] forCellReuseIdentifier:@"cell"];
    if ([PFUser currentUser]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self getAllInboxNote];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:243.0/255.0 alpha:1.0];
    }else{
     //   self.navigationController.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:243.0/255.0 alpha:1.0];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:243.0/255.0 alpha:1.0]];
    }
    
    
//    // Get the views.
//    UIView * fromView = self.view;
//    UIView * toView = self.view;
//    
//    // Get the size of the view area.
//    CGRect viewSize = fromView.frame;
//    
//    // Add the toView to the fromView
//    [fromView.superview addSubview:toView];
//    
//    // Position it off screen.
//    toView.frame = CGRectMake( 320 , viewSize.origin.y, 320, viewSize.size.height);
//    
//    [UIView animateWithDuration:0.4 animations:
//     ^{
//         // Animate the views on and off the screen. This will appear to slide.
//         fromView.frame =CGRectMake( -320 , viewSize.origin.y, 320, viewSize.size.height);
//         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
//     }
//                     completion:^(BOOL finished)
//     {
//         if (finished)
//         {
//             // Remove the old view from its parent.
//            // [fromView removeFromSuperview];
//             
//             //I use it to have navigationnBar and TabBar at the same time
//             //self.tabBarController.selectedIndex = indexPath.row+1;
//         }
//     }];
    
}

-(void)getAllInboxNote{
    
    [appDelegate.arrInbox removeAllObjects];
    PFQuery *queryInbox=[PFQuery queryWithClassName:@"TblInbox"];
    [queryInbox whereKey:@"ReceiveUser" equalTo:[PFUser currentUser]];
    [queryInbox includeKey:@"SendUser"];
    [queryInbox includeKey:@"ReceiveUser"];
    [queryInbox includeKey:@"NoteRef"];
    [queryInbox orderByDescending:@"IndexDate"];

    [queryInbox findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (int i=0; i<[objects count]; i++) {
            arrCurrentInbox=objects;
            PFObject *objHome=[objects objectAtIndex:i];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            [appDelegate.arrInbox addObject:[SHCToDoItem toDoItemWithText:[objNote objectForKey:@"note"]]];
        }
        [tblInbox reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
        
    }];
}
-(void)handleSwipeGestureToHome{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer
     addAnimation:transition forKey:kCATransition];
    //Animation Reverse
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = appDelegate.arrInbox.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(FMMoveTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSInteger numberOfRows;
    if (tableView==subNotsTable) {
        numberOfRows = [arraySubNots count];
    }else{
        numberOfRows = appDelegate.arrInbox.count;
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

-(UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==subNotsTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
        PFUser *senderUser=[objSubNote objectForKey:@"Sender"];
        cell.textLabel.font=CustomfontLight(15);
        cell.textLabel.textColor=[UIColor darkGrayColor];
        cell.textLabel.text=[objSubNote objectForKey:@"SubNote"];
        
        cell.detailTextLabel.font=CustomfontLight(12);
        cell.detailTextLabel.textColor=[UIColor darkGrayColor];
       cell.detailTextLabel.text=[senderUser username];
        
        if ([[senderUser objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
            UIButton *btnEditSubNote=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, 16, 16)];
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
    }else{
        //    NSString *ident = @"cell";
        //    // re-use or create a cell
        //    SHCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
        
        static NSString *CellIdentifier = @"Cell";
        SHCTableViewCell *cell = [tblInbox dequeueReusableCellWithIdentifier:CellIdentifier];
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
        
        // find the to-do item for this index
        int index = [indexPath row];
        SHCToDoItem *item = appDelegate.arrInbox[index];
        // set the text
        cell.delegate = self;
        cell.todoItem = item;
        
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
        sbView.layer.borderWidth=1.0;
        sbView.tag=5656;
        sbView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        lblUserName=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 160, 30)];
        lblUserName.textColor=[UIColor darkGrayColor];
        [lblUserName setBackgroundColor:[UIColor clearColor]];
        lblUserName.font=CustomfontSemibold(18);
        [sbView addSubview:lblUserName];
        
        userProfileImage=[[EGOImageView alloc]initWithFrame:CGRectMake(178, 58, 50,50)];
        userProfileImage.layer.cornerRadius=userProfileImage.frame.size.width/2.0;
        userProfileImage.clipsToBounds=YES;
        userProfileImage.tag=8888;
        
        userProfileImage.layer.borderWidth=2.0;
        userProfileImage.layer.borderColor=[[UIColor grayColor] CGColor];
        [detailView addSubview:sbView];
        [detailView addSubview:userProfileImage];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 259, 44)];
        [imageView setImage:[UIImage imageNamed:@"blueborder.png"]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        cell.backgroundColor = [UIColor clearColor];
        [detailView addSubview:imageView];
        [cell.contentView addSubview:detailView];
            
        PFObject *objInbox=[arrCurrentInbox objectAtIndex:indexPath.row];
        PFUser *inBoxUser=[objInbox objectForKey:@"SendUser"];
        lblUserName.text=[inBoxUser objectForKey:@"name"];
            lblUserName.font = CustomfontLight(18);
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [inBoxUser objectForKey:@"fbId"]]];
        [userProfileImage setImageURL:pictureURL];
        }
        return cell;
    }
}

#pragma mark - UITableViewDataDelegate protocol methods


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
        
        PFObject  *objHomeFrom=[arrCurrentInbox objectAtIndex:[fromIndexPath row]];
        PFObject  *objHomeTo=[arrCurrentInbox objectAtIndex:[toIndexPath row]];
        NSDate *DateTo = [objHomeTo objectForKey:@"IndexDate"];
        NSTimeInterval secondsInFive = 0;
        
        if ([fromIndexPath row]>[toIndexPath row]) {
            secondsInFive = 5;
            NSLog(@"Neeche se upar +");
        }else{
            secondsInFive = -5;
            NSLog(@"Upar se neeche --");
        }
        
        NSDate *dateUpdated = [DateTo dateByAddingTimeInterval:secondsInFive];
        
        PFObject  *objHomeToCheckUpper;
        if ([toIndexPath row]!=0) {
            if ([fromIndexPath row]>[toIndexPath row]) {
                objHomeToCheckUpper=[arrCurrentInbox objectAtIndex:[toIndexPath row]-1];
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
        
        PFQuery *queryFrom = [PFQuery queryWithClassName:@"TblInbox"];
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
        NSArray *movie = [appDelegate.arrInbox objectAtIndex:[fromIndexPath row]];
        [appDelegate.arrInbox removeObjectAtIndex:[fromIndexPath row]];
        [appDelegate.arrInbox insertObject:movie atIndex:[toIndexPath row]];
    }
}


- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	//	Uncomment these lines to enable moving a row just within it's current section
	//	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
	//		proposedDestinationIndexPath = sourceIndexPath;
	//	}
	
	return proposedDestinationIndexPath;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==subNotsTable) {
        return 50;
    }else{
        return [currentIndexPath isEqual:indexPath]? expansionHeight : originalHeight;
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
-(void)toDoItemDeleted:(id)todoItem {
    // use the UITableView to animate the removal of this row
    
    int index = [appDelegate.arrInbox indexOfObject:todoItem];
    SHCToDoItem *shToDo=(SHCToDoItem *)todoItem;
    if (shToDo.completed==YES) {
        [appDelegate.arrInbox removeObject:todoItem];
        
        [tblInbox deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                        withRowAnimation:UITableViewRowAnimationFade];
        [tblInbox endUpdates];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self performSelector:@selector(moveNoteToInbox:) withObject:[NSNumber numberWithInt:index] afterDelay:0.5];
        
    }else{
        
        [self FaceBookFriends:shToDo.text];
        [appDelegate.arrInbox removeObject:todoItem];
        [tblInbox deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [appDelegate.arrInbox insertObject:todoItem atIndex:index];
        [tblInbox insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [tblInbox endUpdates];
        [tblInbox reloadData];
    }
}


-(void)moveNoteToInbox :(NSNumber *)index{

    PFObject *objInbox=[arrCurrentInbox objectAtIndex:[index intValue]];
    PFObject *objNote=[objInbox objectForKey:@"NoteRef"];
    PFObject *objTrash=[PFObject objectWithClassName:@"TblTrash"];
    [objTrash setObject:objNote forKey:@"NoteRef"];
    [objTrash setObject:@"isInbox" forKey:@"fromCome"];
    [objTrash setObject:[objInbox objectForKey:@"SendUser"] forKey:@"CreatUser"];
    [objTrash setObject:[objInbox objectForKey:@"ReceiveUser"] forKey:@"ReceiveUser"];
    [objTrash save];
    [objInbox delete];
    [self getAllInboxNote];
}

-(void)FaceBookFriends :(NSString *)note{
    
    FbFriendsViewController *objFbFriendsViewController=[[FbFriendsViewController alloc]initWithNibName:@"FbFriendsViewController" bundle:nil];
    objFbFriendsViewController.delegate=self;
    strNote=note;
    [self presentPopupViewController:objFbFriendsViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}

-(void)sendNote :(NSMutableArray *)arrSelectedFriends{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    for (int i=0; i<[arrSelectedFriends count]; i++) {
        PFUser *toSendUser=[arrSelectedFriends objectAtIndex:i];
        PFObject *objInbox=[PFObject objectWithClassName:@"TblInbox"];
        [objInbox setObject:strNote forKey:@"note"];
        [objInbox setObject:toSendUser forKey:@"ReceiveUser"];
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
                              [NSString stringWithFormat:@"%@ send you %@",[PFUser currentUser].username,strNote], @"alert",
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
    
    PFObject *objHome=[PFObject objectWithClassName:@"TblHome"];
    [objHome setObject:strNote forKey:@"note"];
    [objHome setObject:[PFUser currentUser] forKey:@"CreatUser"];
    [objHome save];
    //[self getAllHomeNote];
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
}


-(void)singleTap :(UIGestureRecognizer *)gesture{
    SHCTableViewCell *cell=(SHCTableViewCell*) gesture.view.superview;
    NSIndexPath *indexPath;
    if (SYSTEM_VERSION_GREATER_THAN(@"6.1")) {
        CGPoint center= cell.center;
        CGPoint rootViewPoint = [cell.superview convertPoint:center toView:tblInbox];
        indexPath = [tblInbox indexPathForRowAtPoint:rootViewPoint];
    }
    else{
        indexPath = [tblInbox indexPathForCell:cell];
    }


    if (tblInbox) {
        if([indexPath isEqual:currentIndexPath])
        {
            UITableViewCell *cell=[tblInbox cellForRowAtIndexPath:currentIndexPath];
            
            UIView *subview =[cell.contentView viewWithTag:9999];
            if (subview) {
                [subview removeFromSuperview];
                [arraySubNots removeAllObjects];
                [subNotsTable reloadData];
            }
        }
        currentIndexPath = [currentIndexPath isEqual:indexPath] ? nil : indexPath;
        // [tblInbox reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tblInbox reloadData];
        if ([currentIndexPath isEqual:indexPath])
        {
            [NSThread detachNewThreadSelector:@selector(selfActivities) toTarget:self withObject:nil];
            
            UITableViewCell *cell=[tblInbox cellForRowAtIndexPath:currentIndexPath];
            UIView *view=[cell viewWithTag:5656];
            [view setFrame:CGRectMake(13, 190, 235, 55)];
            EGOImageView *egoIView=(EGOImageView *)[cell viewWithTag:8888];
            [egoIView setFrame:CGRectMake(178, 207, 50,50)];
            
            [cell.contentView addSubview:subNotsTable];
            [cell.contentView sendSubviewToBack:subNotsTable];
            PFObject  *objHome=[arrCurrentInbox objectAtIndex:gesture.view.tag];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            PFQuery *querySubnotes=[PFQuery queryWithClassName:@"TblSubNotes"];
            [querySubnotes whereKey:@"ParentNote" equalTo:objNote];
            [querySubnotes includeKey:@"ParentNote"];
            [querySubnotes includeKey:@"Sender"];
            [querySubnotes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                arraySubNots=[objects mutableCopy];
                [subNotsTable reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
            }];
        }
    }

}
-(void)DoubleTap:(UIGestureRecognizer *)gesture{
    if (tblInbox) {
        
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
          [MBProgressHUD showHUDAddedTo:self.view.window animated:TRUE];
        PFObject *objSubNotes=[PFObject objectWithClassName:@"TblSubNotes"];
        [objSubNotes setObject:subNote forKey:@"SubNote"];
        [objSubNotes setObject:[PFUser currentUser] forKey:@"Sender"];
        PFObject  *objHome=[arrCurrentInbox objectAtIndex:index];
        PFUser *createrUser=[objHome objectForKey:@"SendUser"];
        [objSubNotes setObject:createrUser forKey:@"Receiver"];
        PFObject *objNote=[objHome objectForKey:@"NoteRef"];
        [objSubNotes setObject:objNote forKey:@"ParentNote"];
        [objSubNotes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:TRUE];
                
                PFUser *toSendUser=[objNote objectForKey:@"CreatUser"];
                
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:toSendUser];
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                //[push setQuery:pushQuery]; // Set our Installation query
                [push setChannel:[NSString stringWithFormat:@"user_%@",[toSendUser objectId]]];
                
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%@ send you %@",[PFUser currentUser].username,subNote], @"alert",
                                      @"Increment", @"badge",
                                      @"default",@"sound",
                                      @"Subnote",@"action",
                                      nil];
                [push setData:data];
                [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                    if (!errror) {
                    }else{
                    }
                }];

                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:TRUE];
            }
        }];
    }
    
    
}
-(void)editSubNote:(id)sender{
    
    objEditSubNote=[arraySubNots objectAtIndex:[sender tag]];
    SubNoteViewController *objSubNoteViewController = [[SubNoteViewController alloc] initWithNibName:@"SubNoteViewController" bundle:nil];
    objSubNoteViewController.delegate=self;
    objSubNoteViewController.isEditSubNote=TRUE;
    objSubNoteViewController.strSubNote=[objEditSubNote objectForKey:@"SubNote"];
    [self presentPopupViewController:objSubNoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];

}

-(void)sendEditSubnote :(NSString *)subNote selectIndex:(NSInteger )index
{
    PFQuery *query = [PFQuery queryWithClassName:@"TblSubNotes"];
    [query getObjectInBackgroundWithId:[objEditSubNote objectId] block:^(PFObject *gameScore, NSError *error) {
        [gameScore setObject:subNote forKey:@"SubNote"];
        [gameScore save];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        // [self getAllHomeNote];
        
    }];
}

-(void)cancelSubNote{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
