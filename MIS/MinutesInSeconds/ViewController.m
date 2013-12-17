//
//  ViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "ViewController.h"
#import "MeetingCell.h"
#import "CellUpperViewViewController.h"
#import "CreateMeetingViewController.h"
#import "GlobalClass.h"
#import "AppDelegate.h"
#import "RecordNoteViewController.h"
#import "MeetingDetailViewController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "TabBarViewCtr.h"
#import "PopOverViewController.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "CustomUIApplicationClass.h"

@interface ViewController (){
    ZKRevealingTableViewCell *_currentlyRevealedCell;
    NSArray *menus;
}
@property (nonatomic, retain) NSArray *objects;
@end

@implementation ViewController
@synthesize titleView;
@synthesize databaseOBJ;
@synthesize tblView;
@synthesize objects;
@synthesize lblNavigationImage;
@synthesize arrChildOfParantMeeting;
@dynamic currentlyRevealedCell;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    databaseOBJ = [DAL getInstance];
    [databaseOBJ createEditableCopyOfDatabaseIfNeeded];
    [databaseOBJ openCreateDatabase];
    
	// Do any additional setup after loading the view, typically from a nib.
    if ([mutCellArr count]==0) {
        mutCellArr = [[NSMutableArray alloc] init];
    }
    
    self.objects = [NSArray arrayWithObjects:@"bur", @"Vishal Bur", @"Vish Bur", @"None", nil];
    self.tblView.rowHeight=101.0;
    self.navigationItem.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenSearchViewAction:) name:SEARCH_POST_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMeetingBtnClicked:) name:ADD_MEETING_POST_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewWillAppear:) name:RELOAD_MEETING_TABLE_POST_NOTIFICATION object:nil];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(createMeeting:)];
    self.navigationItem.leftBarButtonItem=addButton;
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"eyeNotes.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"eyeNotes.png"];
    
    UIImage *starImage1 = [UIImage imageNamed:@"eyeNotes.png"];
//    UIImage *starImage2 = [UIImage imageNamed:@"eyeMick.png"];
    UIImage *starImage3= [UIImage imageNamed:@"eyemail.png"];
    UIImage *stareImage4=[UIImage imageNamed:@"eyeTrash.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage1
                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:starImage2
//                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage3
                                                    highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:stareImage4
                                                    highlightedContentImage:nil];
    
    menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem3,starMenuItem4,nil];
    
    
    // add search view
    searchView.frame=CGRectMake(0,-searchView.frame.size.height,searchView.frame.size.width, searchView.frame.size.height);
   
    [self.view addSubview:searchView];
    
    //give border
    btnSearch.layer.cornerRadius=5;
    btnSearch.layer.borderColor=[UIColor blackColor].CGColor;
    btnSearch.layer.borderWidth=1;
    
    // set Fount
    btnSearch.titleLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
    btnFrom.titleLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
    btnTo.titleLabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
    txtField.font=[UIFont fontWithName:@"OpenSans-Bold" size:14];
  
    // add date search view
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
       dateSearchView.frame=CGRectMake(-320,0,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
    else
       dateSearchView.frame=CGRectMake(-320,64,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
    
    // give border to button
    for (UIButton *button in  dateSearchView.subviews)
    {
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.layer.cornerRadius=7;
    }
    [self.view addSubview:dateSearchView];
    
    //set textfield place holder text colour
    UIColor *color = [UIColor whiteColor];
    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Name" attributes:@{NSForegroundColorAttributeName: color}];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (arrayOFParantMeeting!=nil) {
        arrayOFParantMeeting = nil;
        [arrayOFParantMeeting removeAllObjects];
    }
    arrayOFParantMeeting = [[NSMutableArray alloc] init];
    arrChildOfParantMeeting= [[NSMutableArray alloc] init];
    arrayOFSUBParantMeeting = [[NSMutableArray alloc] init];
    
    arrayOFParantMeeting = [databaseOBJ lookupAllForSQL:@"select * from CreateMeeting"];
    
    if ([arrayOFParantMeeting count]>0) {
        arrayOFParantMeeting=[[[arrayOFParantMeeting reverseObjectEnumerator] allObjects] mutableCopy];
        
        for (int i=0; i<[arrayOFParantMeeting count];i++) {
            NSLog(@"%@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]);
            
            NSString *query = [NSString stringWithFormat:@"select * from tblSubMeetings where meetingID = %@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]];
            
            arrChildOfParantMeeting = [databaseOBJ lookupAllForSQL:query];
            [arrayOFSUBParantMeeting addObject:arrChildOfParantMeeting];
        }
        NSLog(@"%@",arrayOFSUBParantMeeting);
        [tblView reloadData];
    }
    else{
        [AppDelegate showalert:@"No Records Found"];
    }

    strTitleViewCalling = DRAW_RECT;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENABLE" object:nil];
    titleView = [[NavigationSubclass alloc] initWithFrame:CGRectMake(0, 0, 320, 44) navigationTitleName:@"Minutes In Seconds"];
    [self.navigationController.navigationBar addSubview:titleView];
    
    
    //reset value
    selectedDateButton=nil;
    txtField.text=@"";
    btnFrom.titleLabel.text=@"From Date";
    btnTo.titleLabel.text=@"To Date";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    DatetoolBar=[[UIToolbar alloc] init];
	DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    DatetoolBar.barStyle=UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressedDate)];
    item11.tintColor = [UIColor redColor];
    UIBarButtonItem *item21 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressedDate)];
    item21.tintColor = RGBCOLOR(62, 146, 0);
    UIBarButtonItem *item212 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        
        UIButton *cancel = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
        UIImage *cancelImage = [UIImage imageNamed:@"cancel.png"];
        [cancel setBackgroundImage:cancelImage forState:UIControlStateNormal];
        
        [cancel addTarget:self action:@selector(CanclePressedDate) forControlEvents:UIControlEventTouchUpInside];
        item11= [[UIBarButtonItem alloc] initWithCustomView:cancel];
        
        
        UIButton *okButton= [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
        UIImage *okImage = [UIImage imageNamed:@"ok.png"];
        [okButton  setBackgroundImage:okImage forState:UIControlStateNormal];
        
        [okButton  addTarget:self action:@selector(DonePressedDate) forControlEvents:UIControlEventTouchUpInside];
        item21 = [[UIBarButtonItem alloc] initWithCustomView:okButton ];
        
    }
    
    NSArray *buttons1= [NSArray arrayWithObjects: item11,item212, item21, nil];
    
    [DatetoolBar setItems: buttons1 animated:NO];
    DatepickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
	DatepickerView.backgroundColor=[UIColor whiteColor];
    DatepickerView.datePickerMode = UIDatePickerModeDate;
    
    datePickerBackGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 580, 320, 216)];
    datePickerBackGroundView.backgroundColor=RGBCOLOR(62, 146, 0);
    [datePickerBackGroundView addSubview:DatepickerView];
	[self.view addSubview:datePickerBackGroundView];
    [self.view addSubview:DatetoolBar];
}
#pragma mark-
#pragma mark CREATE MEETING

-(void)createMeeting:(id)sender{

    //appdelegate.tabbarController.selectedIndex=1;
}
#pragma mark - Accessors

- (ZKRevealingTableViewCell *)currentlyRevealedCell
{
	return _currentlyRevealedCell;
}

- (void)setCurrentlyRevealedCell:(ZKRevealingTableViewCell *)currentlyRevealedCell
{
	if (_currentlyRevealedCell == currentlyRevealedCell)
		return;
	
	[_currentlyRevealedCell setRevealing:NO];
	[self willChangeValueForKey:@"currentlyRevealedCell"];
	_currentlyRevealedCell = currentlyRevealedCell;
	[self didChangeValueForKey:@"currentlyRevealedCell"];
}

#pragma mark - ZKRevealingTableViewCellDelegate

- (BOOL)cellShouldReveal:(ZKRevealingTableViewCell *)cell
{
	return YES;
}

- (void)cellDidReveal:(ZKRevealingTableViewCell *)cell
{
	////NSLog(@"Revealed Cell with title: %@", cell.textLabel.text);
	self.currentlyRevealedCell = cell;
}

- (void)cellDidBeginPan:(ZKRevealingTableViewCell *)cell
{
	if (cell != self.currentlyRevealedCell)
		self.currentlyRevealedCell = nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.currentlyRevealedCell = nil;
}

#pragma mark-
#pragma mark UITableViewControllerDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [NSMutableArray new];
    if ([arrayOFSUBParantMeeting count]>0) {
        
        arr = [arrayOFSUBParantMeeting objectAtIndex:indexPath.row];
    }
    
    if ([arr count]==0) {
        
        return 101;
    }else if ([arr count]==1){
        
        return 169;
    }else {
        return 236;
    }
    //    if (indexPath.row==0) {
    //
    //        return 169;
    //    }else{
    
    return 101;
    //    }
    //
    //    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrayOFParantMeeting count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ZKRevealingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
    //	if (!cell) {
    cell = [[ZKRevealingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.delegate       = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeetingCell *meetingCell = [[MeetingCell alloc] initWithNibName:@"MeetingCell" bundle:nil indexpath:indexPath.row];
    CellUpperViewViewController *upperView;
    
    NSDictionary *dictMeetingInfo = [arrayOFParantMeeting objectAtIndex:indexPath.row];
    NSArray *arrOfChilds = [arrayOFSUBParantMeeting objectAtIndex:indexPath.row];
    
    if ([arrOfChilds count]!=0)
    {
        if ([arrOfChilds count]<2)
        {
             upperView = [[CellUpperViewViewController alloc] initWithNibName:@"CellMulti" bundle:nil forSigleOrMulti:2 indexPthRow:indexPath.row _dictMeetingInfo:dictMeetingInfo arrayOfSubMeetings:arrOfChilds];
        }
        else
        {
             upperView = [[CellUpperViewViewController alloc] initWithNibName:@"CellTriplet" bundle:nil forSigleOrMulti:2 indexPthRow:indexPath.row _dictMeetingInfo:dictMeetingInfo arrayOfSubMeetings:arrOfChilds];
        }
        
        cell.direction      =ZKRevealingTableViewCellDirectionNone;
        cell.shouldBounce   = NO;
        AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"eyeBig.png"]
                                                           highlightedImage:[UIImage imageNamed:@"eyeBig.png"]
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
        
        AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(0, 0, 100, 100) startItem:startItem optionMenus:menus];
        menu.delegate = self;
        menu.rotateAngle = 3*M_PI/2;
        menu.menuWholeAngle =  -M_PI/2;
        menu.farRadius = 60.0f;
        menu.endRadius = 60.0f;
        menu.nearRadius = 50.0f;
        menu.animationDuration = 0.5f;
        menu.tag = indexPath.row+5000;
        menu.startPoint = CGPointMake(290.0,25.0);
        
        [upperView.view addSubview:menu];
        [cell.contentView addSubview:upperView.view];
        /*Here We can get click of Time Button TO perform ANimation and to show Information
         UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(82,118,31,31)];
         btn.backgroundColor = [UIColor redColor];
         btn.tag= indexPath.row+1000;
         [btn addTarget:self action:@selector(showAnimationBtn:) forControlEvents:UIControlEventTouchUpInside];
         [upperView.view addSubview:btn];
         */
        
    }else{
        upperView = [[CellUpperViewViewController alloc] initWithNibName:@"CellUpperViewViewController" bundle:nil forSigleOrMulti:1 indexPthRow:indexPath.row _dictMeetingInfo:dictMeetingInfo arrayOfSubMeetings:nil];
        cell.direction      =ZKRevealingTableViewCellDirectionRight;
        cell.shouldBounce   = YES;
        [cell.contentView addSubview:upperView.view];
        [cell addSubview:meetingCell.view];
        [cell sendSubviewToBack:meetingCell.view];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictMeetingInfo = [arrayOFParantMeeting objectAtIndex:indexPath.row];
    NSMutableArray *arrOfChilds = [NSMutableArray new];
    arrOfChilds = [arrayOFSUBParantMeeting objectAtIndex:indexPath.row];
    [arrOfChilds insertObject:dictMeetingInfo atIndex:0];
    MeetingDetailViewController *detailView = [[MeetingDetailViewController alloc] initWithNibName:@"MeetingDetailViewController" bundle:nil];
    detailView.arrOfMeetings = arrOfChilds;
    [self.navigationController pushViewController:detailView animated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DISABLE" object:nil];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	if (row % 2 == 0) {
		cell.backgroundColor = [UIColor whiteColor];
	} else {
		cell.backgroundColor = [UIColor colorWithRed:0.892 green:0.893 blue:0.892 alpha:1.0];
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma BUTTON  ACTION
-(IBAction)addSecondryMeetingInParent:(id)sender{
    
    NSLog(@"%d",[sender tag]);
    CreateMeetingViewController *createMeetingCtRl = [[CreateMeetingViewController alloc] initWithNibName:@"CreateMeetingViewController" bundle:nil];
    strChildMeeting=@"CHILD";
    createMeetingCtRl.isCreateNewChield=YES;
    NSDictionary *dictMeetingInfo = [arrayOFParantMeeting objectAtIndex:[sender tag]-1000];
    NSMutableArray *arrOfChilds = [NSMutableArray new];
    arrOfChilds = [arrayOFSUBParantMeeting objectAtIndex:[sender tag]-1000];
    [arrOfChilds insertObject:dictMeetingInfo atIndex:0];
    createMeetingCtRl.arrOfLastObject = [arrOfChilds objectAtIndex:0];
    NSLog(@"%@",[arrOfChilds objectAtIndex:0]);
    createMeetingCtRl.arrOfLastObject = [arrOfChilds objectAtIndex:0];
    _dictURLwithSpeech=nil;
    createMeetingCtRl.strMeetingID = [[arrayOFParantMeeting objectAtIndex:[sender tag]-1000] valueForKey:MEETING_ID];
    [self.navigationController pushViewController:createMeetingCtRl animated:YES];
 }
-(IBAction)SendmailButtonAction:(id)sender
{
    // Email Subject
    NSString *emailTitle =[[arrayOFParantMeeting objectAtIndex:[sender tag]-3000]  valueForKey:MEETING_TITLE];
    // Email Content
    NSString *messageBody=[NSString stringWithFormat:@"Meeting speechText:- %@",[[arrayOFParantMeeting objectAtIndex:[sender tag]-3000]  valueForKey:SPEECH_TO_TEXT]];
    
    // To address
    NSData *data = [[arrayOFParantMeeting objectAtIndex:[sender tag]-3000] valueForKey:MEETING_ATTENDEES_ID];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *toRecipents = [[NSMutableArray alloc] init];
    for (int i=0; i<[array count]; i++)
    {
        NSDictionary *dict = [array objectAtIndex:i];
        [toRecipents   addObject:[dict valueForKey:SELECTED_USER_EMAIL_ID]];
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    NSURL *audioURL = [NSURL URLWithString:[[arrayOFParantMeeting objectAtIndex:[sender tag]-3000] valueForKey:AUDIO_URL]];
    NSData *file=[NSData dataWithContentsOfURL:audioURL];
    
    if (file!=nil)
    {
        [mc addAttachmentData:file mimeType:@"Meeting Audi" fileName:@"Audio.mp3"];
    }
    
    mc.mailComposeDelegate=self;
    [self.navigationController presentViewController:mc animated:YES completion:nil];
}
-(IBAction)RecordingViewController:(id)sender
{
    RecordNoteViewController *recordCotnroller= [[RecordNoteViewController alloc] initWithNibName:@"RecordNoteViewController" bundle:nil];
    NSDictionary *dictMeetingInfo = [arrayOFParantMeeting objectAtIndex:[sender tag]-2000];
    NSMutableArray *arrOfChilds = [NSMutableArray new];
    arrOfChilds = [arrayOFSUBParantMeeting objectAtIndex:[sender tag]-2000];
    [arrOfChilds insertObject:dictMeetingInfo atIndex:0];
    recordCotnroller.arrOfLastObject = arrOfChilds;
    strISRecordSoundChild = @"YES";
    [self.navigationController pushViewController:recordCotnroller animated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DISABLE" object:nil];
}
-(IBAction)DeleteMainMeeting:(id)sender
{
    NSDictionary *meetingInfo=[arrayOFParantMeeting objectAtIndex:[sender tag]-2000];
    
    [databaseOBJ lookupAllForSQL:[NSString stringWithFormat:@"Delete from CreateMeeting where meetingID=%@",[meetingInfo valueForKey:MEETING_ID]]];
    
    [self viewWillAppear:NO];
    [tblView reloadData];
}
-(IBAction)DeleteButtonAction:(UIButton *)sender forEvent:(UIEvent*)event
{
    NSLog(@"Sender Teg  =====>> %d",sender.tag);
   }
#pragma -mark popOver Delegate
// to dis miss view Controlle
- (void)cancelButtonClicked:(PopOverViewController * )secondDetailViewController
{
    [self viewWillAppear:NO];
     
    [self dismissPopupViewControllerWithanimationType:1];
}
#pragma -mark mail Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)SearchByDateButtonAction:(id)sender
{
    if (dateSearchView.frame.origin.x<0)
    {
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                             dateSearchView.frame=CGRectMake(0,0,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                             else
                             dateSearchView.frame=CGRectMake(0,64,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                             
                         }
                         completion:^(BOOL finished){
                              tblView.userInteractionEnabled=NO;
                         }];
        
        [self OpenSearchViewAction:nil];
    }
    else
    {
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                                   dateSearchView.frame=CGRectMake(-320,0,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                             else
                                 dateSearchView.frame=CGRectMake(-320,64,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
- (IBAction)SearchButtonAction:(id)sender
{
     [self SearchByDateButtonAction:Nil];
    
    if ([btnFrom.titleLabel.text isEqualToString:@"From Date"] || [btnTo.titleLabel.text isEqualToString:@"To Date"])
    {
        [AppDelegate showalert:@"Please Select date"];
        return;
    }
    //select * from CreateMeeting where datetime between "17-10-2013" and "25-10-2013"
    
    NSString *query=[NSString stringWithFormat:@"select * from CreateMeeting where datetimeStamp between \'%@\' and \'%@\'",[CustomUIApplicationClass getUTCFormateDate:btnFrom.titleLabel.text],[CustomUIApplicationClass getUTCFormateDate:btnTo.titleLabel.text]];

    NSMutableArray *meetingList= [databaseOBJ lookupAllForSQL:query];
    
    if ([meetingList count]>0) {
        
        arrayOFParantMeeting = [[NSMutableArray alloc] init];
        arrChildOfParantMeeting= [[NSMutableArray alloc] init];
        arrayOFSUBParantMeeting = [[NSMutableArray alloc] init];
        
        arrayOFParantMeeting=[[[meetingList reverseObjectEnumerator] allObjects] mutableCopy];
        
        for (int i=0; i<[arrayOFParantMeeting count];i++) {
            NSLog(@"%@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]);
            
            NSString *query = [NSString stringWithFormat:@"select * from tblSubMeetings where meetingID = %@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]];
            
            arrChildOfParantMeeting = [databaseOBJ lookupAllForSQL:query];
            [arrayOFSUBParantMeeting addObject:arrChildOfParantMeeting];
        }
        NSLog(@"%@",arrayOFSUBParantMeeting);
        [tblView reloadData];
    }else{
        
        [AppDelegate showalert:@"No Records Found"];
    }
}
-(void)OpenSearchViewAction:(id)sender
{
    if (searchView.frame.origin.y<0)
    {
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                                searchView.frame=CGRectMake(0,0,searchView.frame.size.width,searchView.frame.size.height);
                            else
                             searchView.frame=CGRectMake(0,64,searchView.frame.size.width,searchView.frame.size.height);
                                            }
                         completion:^(BOOL finished){
                          
                         }];
        tblView.userInteractionEnabled=NO;
    }
    else
    {
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             searchView.frame=CGRectMake(0,-searchView.frame.size.height,searchView.frame.size.width,searchView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                            
                         }];
        [txtField resignFirstResponder];
        tblView.userInteractionEnabled=YES;
    }
}
#pragma -mark  UITEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Search indata base by name which user enter
    
    NSString *query=[NSString stringWithFormat:@"SELECT * FROM CreateMeeting    WHERE meetingTitle like '%%%@%%'",txtField.text];
    
    NSMutableArray *meetingList= [databaseOBJ lookupAllForSQL:query];
    
    if ([meetingList count]>0) {
        
        arrayOFParantMeeting = [[NSMutableArray alloc] init];
        arrChildOfParantMeeting= [[NSMutableArray alloc] init];
        arrayOFSUBParantMeeting = [[NSMutableArray alloc] init];
        
        arrayOFParantMeeting=[[[meetingList reverseObjectEnumerator] allObjects] mutableCopy];
        
        for (int i=0; i<[arrayOFParantMeeting count];i++) {
            NSLog(@"%@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]);
            
            NSString *query = [NSString stringWithFormat:@"select * from tblSubMeetings where meetingID = %@",[[arrayOFParantMeeting objectAtIndex:i] valueForKey:MEETING_ID]];
            
            arrChildOfParantMeeting = [databaseOBJ lookupAllForSQL:query];
            [arrayOFSUBParantMeeting addObject:arrChildOfParantMeeting];
        }
        NSLog(@"%@",arrayOFSUBParantMeeting);
        [tblView reloadData];
    }else{
        
        [AppDelegate showalert:@"No Records Found"];
    }
    
    [txtField resignFirstResponder];
    [self OpenSearchViewAction:nil];
    return YES;
}
#pragma -mark UITOUCH DELEGATE
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touch_point = [touch locationInView:tblView];
    
    if ([tblView pointInside:touch_point withEvent:event])
    {
        NSLog(@"point inside tblView");
        
        tblView.userInteractionEnabled=YES;
        [txtField resignFirstResponder];
        
        if (dateSearchView.frame.origin.x>=0)
        {
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                                 dateSearchView.frame=CGRectMake(-320,0,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                             else
                                 dateSearchView.frame=CGRectMake(-320,64,dateSearchView.frame.size.width,dateSearchView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
        }
        if (searchView.frame.origin.y>=0)
        {
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             searchView.frame=CGRectMake(0,-searchView.frame.size.height,searchView.frame.size.width,searchView.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }];
        }
    }
}
#pragma -mark DATE PICKERVIEW METHOD
-(void)openDatePicker
{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.80];

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            if (IS_IPHONE_5)
                DatetoolBar.frame = CGRectMake(0,219+60,320,44);
            else
                DatetoolBar.frame = CGRectMake(0,219+44,320,44);
            datePickerBackGroundView.frame=CGRectMake(0,260+44, 320, 216);
        }
        else
        {
            DatetoolBar.frame=CGRectMake(0,219, 320, 44);
            datePickerBackGroundView.frame=CGRectMake(0,260, 320, 216);
        }
        [UIView commitAnimations];
}
-(void)CanclePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    datePickerBackGroundView.frame=CGRectMake(0,580, 320, 216);
    [UIView commitAnimations];
}
-(void)DonePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    datePickerBackGroundView.frame=CGRectMake(0,580, 320, 216);
    [UIView commitAnimations];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
    
    [selectedDateButton setTitle:strDate forState:UIControlStateNormal];
}
-(void)AddMeetingBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_TO_1st_INDEX object:nil];
}
#pragma -mark UIBUTTON  ACTION
- (IBAction)TodateAction:(UIButton*)sender
{
    selectedDateButton=sender;
    [self openDatePicker];
}
- (IBAction)FromDateAction:(UIButton *)sender
{
    selectedDateButton=sender;
    [self openDatePicker];
}


-(void)showAnimationBtn:(id)sender
{
    UIImageView *imgeView = (UIImageView *)[tblView viewWithTag:[sender tag]];
    ////NSLog(@"%@",imgeView);
    [UIView animateWithDuration:3.0
                     animations:^{
                     }
                     completion:^(BOOL finished){
                         [UIView transitionWithView:imgeView
                                           duration:2
                                            options:UIViewAnimationOptionTransitionFlipFromTop
                                         animations:^{
                                         }
                                         completion:nil];
                     }];
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    if (idx==0) {
        CreateMeetingViewController *createMeetingCtRl = [[CreateMeetingViewController alloc] initWithNibName:@"CreateMeetingViewController" bundle:nil];
        strChildMeeting=@"CHILD";
        createMeetingCtRl.isCreateNewChield=YES;
        createMeetingCtRl.strMeetingID = [[arrayOFParantMeeting objectAtIndex:[menu tag]-5000] valueForKey:MEETING_ID];
        createMeetingCtRl.arrOfLastObject=[arrayOFParantMeeting objectAtIndex:[menu tag]-5000];
        [self.navigationController pushViewController:createMeetingCtRl animated:YES];
        _dictURLwithSpeech=nil;
//    }else if (idx==1){
//        
//        RecordNoteViewController *recordCotnroller= [[RecordNoteViewController alloc] initWithNibName:@"RecordNoteViewController" bundle:nil];
//        NSDictionary *dictMeetingInfo = [arrayOFParantMeeting objectAtIndex:[menu tag]-5000];
//        NSMutableArray *arrOfChilds = [NSMutableArray new];
//        arrOfChilds = [arrayOFSUBParantMeeting objectAtIndex:[menu tag]-5000];
//        [arrOfChilds insertObject:dictMeetingInfo atIndex:0];
//        recordCotnroller.arrOfLastObject = arrOfChilds;
//        strISRecordSoundChild = @"YES";
//        [self.navigationController pushViewController:recordCotnroller animated:YES];
        
    }
    else if  (idx==1)
    {
        /*    First get Main meeting  */
        
        //email title
        NSString *emailTitle =[[arrayOFParantMeeting objectAtIndex:[menu tag]-5000] valueForKey:MEETING_TITLE];
        
        NSMutableArray *titleList=[NSMutableArray new];
        [titleList addObject:emailTitle];
        
        // Email Content
        NSString *messageBody=[NSString stringWithFormat:@"%@ speechText:- %@",emailTitle,[[arrayOFParantMeeting objectAtIndex:[menu tag]-5000]  valueForKey:SPEECH_TO_TEXT]];
        
        // To address
        NSData *data = [[arrayOFParantMeeting objectAtIndex:[menu tag]-5000] valueForKey:MEETING_ATTENDEES_ID];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *toRecipents = [[NSMutableArray alloc] init];
        // add email of attendees in array
        for (NSDictionary *attendiees in array)
        {
            [toRecipents addObject:[attendiees valueForKey:SELECTED_USER_EMAIL_ID]];
        }
        
        // attchments
        NSMutableArray *fileList=[NSMutableArray new];
        
        NSURL *audioURL = [NSURL URLWithString:[[arrayOFParantMeeting objectAtIndex:[menu tag]-5000] valueForKey:AUDIO_URL]];
        NSData *file=[NSData dataWithContentsOfURL:audioURL];
        
        if (file!=nil)
        {
            [fileList addObject:file];
        }
        
        /*   Get Sub Meeting  */
        
        for (NSDictionary *submeeting in  [arrayOFSUBParantMeeting objectAtIndex:[menu tag]-5000])
        {
            // meeting titel
            emailTitle=[emailTitle stringByAppendingString:[NSString stringWithFormat:@", %@",[submeeting valueForKey:MEETING_TITLE]]];
            [titleList addObject:[submeeting valueForKey:MEETING_TITLE]];
            
            
            // message body
            messageBody=[NSString stringWithFormat:@"%@  \n \n %@ speechText:- %@",messageBody,[submeeting valueForKey:MEETING_TITLE],[submeeting valueForKey:SPEECH_TO_TEXT]];
            
            // To address
            NSData *data = [submeeting valueForKey:MEETING_ATTENDEES_ID];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            // add email of attendees in array
            for (NSDictionary *attendiees in array)
            {
                NSString *email=[attendiees valueForKey:SELECTED_USER_EMAIL_ID];
                
                if (![toRecipents containsObject:email])
                {
                    [toRecipents addObject:email];
                }
            }
            
            // get attechments list
            
            NSURL *audioURL = [NSURL URLWithString:[submeeting valueForKey:AUDIO_URL]];
            NSData *file=[NSData dataWithContentsOfURL:audioURL];
           if (file!=nil)
            {
                  [fileList addObject:file];
            }
        }
       
        /* Mail this whole meetings  */
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
      
         int i=0;
        for (NSData *attechment in fileList)
        {
            [mc addAttachmentData:attechment mimeType:@"Meeting Audi" fileName:[NSString stringWithFormat:@"%@.mp3",[titleList objectAtIndex:i]]];
            i=i+1;
        }
        
        mc.mailComposeDelegate=self;
        [self.navigationController presentViewController:mc animated:YES completion:nil];
        
    }
    else
    {
        NSArray *DeleteChildList=[arrayOFSUBParantMeeting objectAtIndex:[menu tag]-5000];
        
        if (DeleteChildList.count==1)
        {
            //DELETE  FROM tblSubMeetings Where submeetingID=5
            NSString *query = [NSString stringWithFormat:@"DELETE from tblSubMeetings where submeetingID= %@",[[DeleteChildList objectAtIndex:0] valueForKey:SUBMEETING_ID]];
            
            arrChildOfParantMeeting = [databaseOBJ lookupAllForSQL:query];
            [self viewWillAppear:NO];
        }
        else
        {
            PopOverViewController *popUpView=[[PopOverViewController alloc] initWithNibName:@"PopOverViewController" bundle:nil];
            popUpView.popOverType=@"Delete SubMeeting";
            
            CGFloat popUpViewHeight=40*(DeleteChildList.count+1);
            popUpView.view.frame=CGRectMake(10,self.view.frame.size.height-popUpViewHeight/2,300,popUpViewHeight);
            popUpView.subMeentingList=(NSMutableArray *)DeleteChildList;
            popUpView.delegate = self;
            [self presentPopupViewController:popUpView animationType:0];
        }
    }
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu
{
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu
{
}
@end
