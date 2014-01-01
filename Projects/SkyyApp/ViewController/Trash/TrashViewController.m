//
//  TrashViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "TrashViewController.h"
#import "SHCToDoItem.h"
#import "SHCTableViewCell.h"
#import "MBProgressHUD.h"
#import "AddMoteViewController.h"
#define originalHeight 125.0f
#define expansionHeight 260.0f
NSMutableArray *arraySubNots;
NSIndexPath *currentIndexPath;
#import "UIViewController+MJPopupViewController.h"
#import "UIView+SubviewHunting.h"

@interface TrashViewController ()

@end

@implementation TrashViewController

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
    arrAllTrash=[[NSMutableArray alloc]init];
    
    arraySubNots=[[NSMutableArray alloc]init];
    subNotsTable=[[UITableView alloc]initWithFrame:CGRectMake(13, 40, 235, 150)];
    [subNotsTable setDataSource:self];
    [subNotsTable setDelegate:self];
    [subNotsTable setEditing:YES animated:YES];
    subNotsTable.layer.borderWidth = 2.5;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [subNotsTable setSeparatorInset:UIEdgeInsetsZero];
    }
    [subNotsTable setSeparatorColor:[UIColor redColor]];
    subNotsTable.layer.borderColor = [[UIColor redColor] CGColor];
    [subNotsTable setBackgroundColor:[UIColor clearColor]];
    subNotsTable.tag=9999;
    
    
    appDelegate.currentRightClass=@"";
   
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(handleSwipeGestureLeftHome)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
     [tblTrash registerClass:[SHCTableViewCell class] forCellReuseIdentifier:@"cell"];
    if ([PFUser currentUser]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self getAllTrashNote];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)handleSwipeGestureLeftHome{
    [self.navigationController popViewControllerAnimated:TRUE];

}
-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = appDelegate.arrTrash.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    }else{
        [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    }
}

-(void)getAllTrashNote{
    
    [appDelegate.arrTrash removeAllObjects];
    PFQuery *queryHome=[PFQuery queryWithClassName:@"TblTrash"];
    [queryHome whereKey:@"ReceiveUser" equalTo:[PFUser currentUser]];
    [queryHome includeKey:@"NoteRef.CreatUser"];
    [queryHome includeKey:@"CreatUser"];
     [queryHome orderByDescending:@"createdAt"];

    [queryHome findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (int i=0; i<[objects count]; i++) {
            PFObject *objHome=[objects objectAtIndex:i];
             PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            arrAllTrash=[objects mutableCopy];
            
            [appDelegate.arrTrash addObject:[SHCToDoItem toDoItemWithText:[objNote objectForKey:@"note"]]];
                       
        }
        [tblTrash reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
    }];
}


#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==subNotsTable) {
        return [arraySubNots count];
    }else{
        return appDelegate.arrTrash.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==subNotsTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        PFObject *objSubNote=[arraySubNots objectAtIndex:indexPath.row];
        cell.textLabel.text=[objSubNote objectForKey:@"SubNote"];
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
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        SHCTableViewCell *cell = [tblTrash dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SHCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }

    int index = [indexPath row];
    SHCToDoItem *item = appDelegate.arrTrash[index];
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
         userProfileImage.tag=8888;
        userProfileImage.layer.cornerRadius=userProfileImage.frame.size.width/2.0;
        userProfileImage.clipsToBounds=YES;
        userProfileImage.layer.borderWidth=2.0;
        userProfileImage.layer.borderColor=[[UIColor grayColor] CGColor];
        [detailView addSubview:sbView];
        [detailView addSubview:userProfileImage];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 259, 44)];
        [imageView setImage:[UIImage imageNamed:@"redborder.png"]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        cell.backgroundColor = [UIColor clearColor];
        [detailView addSubview:imageView];
        
        UIButton *btnEditNote=[[UIButton alloc]initWithFrame:CGRectMake(230, 10, 16, 16)];
        [btnEditNote setBackgroundImage:[UIImage imageNamed:@"editGray.png"] forState:UIControlStateNormal];
        [btnEditNote setBackgroundImage:[UIImage imageNamed:@"editOreang.png"] forState:UIControlStateHighlighted];
        [btnEditNote addTarget:self action:@selector(editNote:) forControlEvents:UIControlEventTouchUpInside];
        [btnEditNote setTag:indexPath.row];
        [cell.contentView addSubview:detailView];
        PFObject *objHome=[arrAllTrash objectAtIndex:indexPath.row];
        // appDelegate.currentLeftClass=@"Home";
        PFObject *objNote=[objHome objectForKey:@"NoteRef"];
        PFUser *inBoxUser=[objNote objectForKey:@"CreatUser"];;
       if ([[inBoxUser objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
              [cell.doubleTapView addSubview:btnEditNote];
        }
        if ([[objHome objectForKey:@"fromCome"]isEqualToString:@"isHome"]) {
            cell._crossLabel.text=@"Home";
        }
        else{
            cell._crossLabel.text=@"Inbox";
        }
        lblUserName.text=[inBoxUser objectForKey:@"name"];
        lblUserName.font =CustomfontLight(18);
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [inBoxUser objectForKey:@"fbId"]]];
        [userProfileImage setImageURL:pictureURL];
        return cell;
        
    }
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==subNotsTable) {
        return 50;
    }else{
        return [currentIndexPath isEqual:indexPath]? expansionHeight : originalHeight;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tblTrash) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 259, 44)];
        [imageView setImage:[UIImage imageNamed:@"redborder.png"]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:imageView];
    }
    if (tableView==subNotsTable) {
        UIView* reorderControl = [cell huntedSubviewWithClassName:@"UITableViewCellReorderControl"];
        for(UIImageView* cellGrip in reorderControl.subviews)
        {
            if([cellGrip isKindOfClass:[UIImageView class]])
                [cellGrip setImage:nil];
        }
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
-(void)toDoItemDeleted:(id)todoItem {
    // use the UITableView to animate the removal of this row
    
    int index = [appDelegate.arrTrash indexOfObject:todoItem];
    [tblTrash beginUpdates];
     // [appDelegate._toDoItems addObject:todoItem];

    SHCToDoItem *shToDo=(SHCToDoItem *)todoItem;

    if (shToDo.completed==NO) {
         [appDelegate.arrTrash removeObject:todoItem];
         [tblTrash deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                        withRowAnimation:UITableViewRowAnimationFade];
        [tblTrash endUpdates];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [self performSelector:@selector(saveMoveNoteToHomeAndInbok:) withObject:[NSNumber numberWithInt:index] afterDelay:0.5];
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        [appDelegate.arrTrash removeObject:todoItem];
       
        [tblTrash deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                        withRowAnimation:UITableViewRowAnimationFade];
        [tblTrash endUpdates];
      [self performSelector:@selector(deleteParmentNote:) withObject:[NSNumber numberWithInt:index] afterDelay:0.5];
    
    }
    
}
-(void)saveMoveNoteToHomeAndInbok :(NSNumber *)index{
    PFObject *objTrash=[arrAllTrash objectAtIndex:[index intValue]];
    
    if ([[objTrash objectForKey:@"fromCome"]isEqualToString:@"isHome"]) {
        PFObject *objNote=[objTrash objectForKey:@"NoteRef"];
        PFObject *objHome=[PFObject objectWithClassName:@"TblHome"];
        [objHome setObject:objNote forKey:@"NoteRef"];
        [objHome setObject:[objTrash objectForKey:@"CreatUser"] forKey:@"CreatUser"];
        [objHome save];
        [objTrash delete];
    }
    else if ([[objTrash objectForKey:@"fromCome"]isEqualToString:@"isInbox"]) {
        
        PFObject *objInbox=[PFObject objectWithClassName:@"TblInbox"];
        PFObject *objNote=[objTrash objectForKey:@"NoteRef"];
        [objInbox setObject:objNote forKey:@"NoteRef"];
        [objInbox setObject:[objTrash objectForKey:@"ReceiveUser"] forKey:@"ReceiveUser"];
        [objInbox setObject:[objTrash objectForKey:@"CreatUser"] forKey:@"SendUser"];
        [objInbox save];
        [objTrash delete];
        
    }
  [self getAllTrashNote];
}
-(void)deleteParmentNote :(NSNumber *)index{

    PFObject *objTrash=[arrAllTrash objectAtIndex:[index intValue]];
    [objTrash delete];
    [self getAllTrashNote];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)singleTap :(UIGestureRecognizer *)gesture{
    
    SHCTableViewCell *cell=(SHCTableViewCell*) gesture.view.superview;
    NSIndexPath *indexPath;
    if (SYSTEM_VERSION_GREATER_THAN(@"6.1")) {
        CGPoint center= cell.center;
        CGPoint rootViewPoint = [cell.superview convertPoint:center toView:tblTrash];
        indexPath = [tblTrash indexPathForRowAtPoint:rootViewPoint];
    }
    else{
        indexPath = [tblTrash indexPathForCell:cell];
    }

    if (tblTrash) {
        if([indexPath isEqual:currentIndexPath])
        {
            UITableViewCell *cell=[tblTrash cellForRowAtIndexPath:currentIndexPath];
            
            UIView *subview =[cell.contentView viewWithTag:9999];
            if (subview) {
                [subview removeFromSuperview];
                [arraySubNots removeAllObjects];
                [subNotsTable reloadData];
            }
        }
        currentIndexPath = [currentIndexPath isEqual:indexPath] ? nil : indexPath;
          [tblTrash reloadData];
        if ([currentIndexPath isEqual:indexPath])
        {
            UITableViewCell *cell=[tblTrash cellForRowAtIndexPath:currentIndexPath];
         
            UIView *view=[cell viewWithTag:5656];
            [view setFrame:CGRectMake(13, 190, 235, 55)];
            EGOImageView *egoIView=(EGOImageView *)[cell viewWithTag:8888];
            [egoIView setFrame:CGRectMake(178, 207, 50,50)];
            [cell.contentView addSubview:subNotsTable];
            [cell.contentView sendSubviewToBack:subNotsTable];
            PFObject  *objHome=[arrAllTrash objectAtIndex:gesture.view.tag];
            PFObject *objNote=[objHome objectForKey:@"NoteRef"];
            PFQuery *querySubnotes=[PFQuery queryWithClassName:@"TblSubNotes"];
            [querySubnotes whereKey:@"ParentNote" equalTo:objNote];
            [querySubnotes includeKey:@"ParentNote"];
            [querySubnotes includeKey:@"Sender"];
            [querySubnotes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                arraySubNots=[objects mutableCopy];
                [subNotsTable reloadData];
            }];
            
        }
        
    }
}
-(void)DoubleTap:(UIGestureRecognizer *)gesture{
    if (tblTrash) {
        
        SubNoteViewController *objSubNoteViewController = [[SubNoteViewController alloc] initWithNibName:@"SubNoteViewController" bundle:nil];
        objSubNoteViewController.delegate=self;
        objSubNoteViewController.index=gesture.view.tag;
        [self presentPopupViewController:objSubNoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
        
        
    }
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
    PFObject  *objHome=[arrAllTrash objectAtIndex:[sender tag]];
    objEditNote=[objHome objectForKey:@"NoteRef"];
    AddMoteViewController *objAddMoteViewController = [[AddMoteViewController alloc] initWithNibName:@"AddMoteViewController" bundle:nil];
    objAddMoteViewController.delegate=self;
    objAddMoteViewController.isEdit=TRUE;
    objAddMoteViewController.strEdit=cell._label.text;
    [self presentPopupViewController:objAddMoteViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)swipwToEditNote :(NSString *)note{
    PFQuery *query = [PFQuery queryWithClassName:@"TblNote"];
    [query getObjectInBackgroundWithId:[objEditNote objectId] block:^(PFObject *gameScore, NSError *error) {
        [gameScore setObject:note forKey:@"note"];
        [gameScore save];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        [self getAllTrashNote];
        
    }];
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
        PFObject  *objHome=[arrAllTrash objectAtIndex:index];
        PFUser *createrUser=[objHome objectForKey:@"CreatUser"];
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
-(void)cancelSendNote{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(void)cancelSubNote{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}
@end
