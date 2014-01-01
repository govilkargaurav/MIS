//
//  CreateMeetingViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/30/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CreateMeetingViewController.h"
#import "NavigationSubclass.h"
#import "GlobalClass.h"
#import "AppDelegate.h"
#import "GlobalClass.h"
#import "PMCalendarController.h"
#import "PMCalendar.h"
#import <AddressBook/AddressBook.h>
#import "SIAlertView.h"
#import "FTAnimation+UIView.h"
#import "FTAnimationManager.h"
#import "RecordNoteViewController.h"
#import "EXTScope.h"
#import "CustomUIApplicationClass.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface CreateMeetingViewController ()<PMCalendarControllerDelegate>
@property (nonatomic, strong) PMCalendarController *pmCC;
@end

@implementation CreateMeetingViewController
@synthesize titleView;
@synthesize lblNavigationImage;
@synthesize txtView;
@synthesize pmCC;
@synthesize _dictPeopleInfo;
@synthesize _arrPeopleInfo;
@synthesize arrPeoplePhNumber;
@synthesize databaseOBJ;
@synthesize arrDatabseAttendeesTbl;
@synthesize strIDOfAttendees;
@synthesize strMeetingID;
@synthesize hud;
@synthesize arrOfLastObject;

CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrPeopleInfo = [[NSMutableArray alloc] init];
        _dictPeopleInfo = [[NSMutableDictionary alloc] init];
        arrPeoplePhNumber = [[NSMutableArray alloc] init];
        arrDatabseAttendeesTbl = [[NSMutableArray alloc] init];
        arrOfLastObject = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    hud = [[ATMHud alloc] initWithDelegate:self];
	[self.view addSubview:hud.view];
    
    /* Get all Contact List and save that in Local Database */
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            
            dispatch_async(kBgQueue, ^{
                [self getAllContactsInfowithImageAndEmail:nil];
            });
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        
        dispatch_async(kBgQueue, ^{
            [self getAllContactsInfowithImageAndEmail:nil];
        });
    }
    else {
        // The user has previously denied access
        [AppDelegate showalert:@"You have denied the app for access contach information. Please change your application setting"];
    };
    
  
}

-(IBAction)resign:(id)sender{
    [txtView resignFirstResponder];
    [txtFldTitle resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
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
    DatepickerView.datePickerMode = UIDatePickerModeTime;
    
    datePickerBackGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 580, 320, 216)];
    datePickerBackGroundView.backgroundColor=RGBCOLOR(62, 146, 0);
    [datePickerBackGroundView addSubview:DatepickerView];
	[self.view addSubview:datePickerBackGroundView];
    [self.view addSubview:DatetoolBar];
}
-(void)handleMultiTap:(id)sender{
    
        if(txtView.text.length == 0){
            txtView.textColor = [UIColor lightGrayColor];
            txtView.text = @"Comment";
            [txtView resignFirstResponder];
        }
    if (txtViewLocal) {
        
        [txtView resignFirstResponder];
    }
}

#pragma mark GET CONTACTS INFO
/* This function will return array of dictionary with Full Name, Ph Number, Image , Email */
-(void)getAllContactsInfowithImageAndEmail :(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [hud setAccessoryPosition:ATMHudAccessoryPositionLeft];
        [hud setAlpha:1.0];
        [hud setCaption:@"Setting up view"];
        [hud setActivity:YES];
        [hud show];
    });

    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    NSArray *arrTemp=(__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    arrContact=[[NSMutableArray alloc] init];
    for (int i=0;i<[arrTemp count];i++)
    {
     //   NSMutableDictionary *dicContact=[[NSMutableDictionary alloc] init];
        NSString *name=(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([arrTemp objectAtIndex:i]),kABPersonFirstNameProperty);
        if (!name)
            continue;
        NSString *name2=(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([arrTemp objectAtIndex:i]),kABPersonLastNameProperty);
        name = [name stringByAppendingFormat:@" %@",name2];
        NSString *mobile;

        ABMultiValueRef emails = ABRecordCopyValue((__bridge ABRecordRef)([arrTemp objectAtIndex:i]), kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++)
        {
           mobile= (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
        }
        
        if(!mobile)
            continue;
        
        if (name && mobile)
        {
            UIImage *image = nil;
            ABRecordRef person = CFArrayGetValueAtIndex( (__bridge CFArrayRef)(arrTemp), i );
            if(ABPersonHasImageData(person)){
                image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
            }else{
                image = [UIImage imageNamed:@"icon.png"];
            }
            CGSize newSize = CGSizeMake(50.0, 50.0f);
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
            //[arrContact addObject:dicContact];
            [_arrPeopleInfo addObject:[[KNSelectorItem alloc] initWithDisplayValue:name   selectValue:nil image:newImage ID:i+1 personEmail:mobile]];
          
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hide];
        [hud.view removeFromSuperview];
    });
}

-(void)resizeScrollView
{
        dispatch_async(dispatch_get_main_queue(), ^{
       
//        scrlView.contentSize = CGSizeMake(320, 500);

        if (!IS_IPHONE_5)
        {
            scrlView.frame = CGRectMake(0,0, 320, 390);
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                scrlView.frame = CGRectMake(0,0,320,480);
            }
        }
        scrlView.contentSize = CGSizeMake(320, 460);
    });
  }
/**/
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /* Set Navigation Bar item */
    lblVoiceNotes.font=[UIFont fontWithName:@"OpenSans-Light" size:16.0];
    strTitleViewCalling= DRAW_RECT_DONT_NEED;
    if (!IS_IPHONE_5)
    {
        scrlView.frame = CGRectMake(0,0, 320, 390);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            scrlView.frame = CGRectMake(0,0,320,480);
        }
    }
    
    scrlView.contentSize = CGSizeMake(320, 460);
    
    /* To add Title View on Navigation Bar */
    CGRect Frame = CGRectMake(0, 0, 320, 44);
    titleView = [[NavigationSubclass alloc] initWithFrame:Frame navigationTitleName:@"Add Meeting"];
    [self.navigationController.navigationBar addSubview:titleView];
    /**************************************************************/
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    /* Add Back button If going from ParantMeeting to add child Meeting */
    
    if([strChildMeeting isEqualToString:@"CHILD"])
    {
        NSLog(@"CHILD MEETING");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DISABLE" object:nil];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50, 44)];
        btn.backgroundColor=[UIColor clearColor];
        [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 16, 25)];
        [backImage setImage:[UIImage imageNamed:@"backBtn.png"]];
        [btn addSubview:backImage];
 
        [titleView addSubview:btn];
    }
    else
    {
        NSLog(@"PARENT MEETING");
    }
    
    if ([strGoinToChooseContactsORnot isEqualToString:@"YES"]) {
        strGoinToChooseContactsORnot= @"NO";
        if (_dictURLwithSpeech!=nil) {
            lblVoiceNotes.text = @"Found one attachment of Voice";
            lblVoiceNotes.font=[UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        }
    }else{
        txtFldAttendees.text=@"";
        txtFldTime.text =@"";
        /* To add Placeholder on UITextView */
        txtView.text = @"Comment";
        txtView.textColor = [UIColor lightGrayColor];
        txtView.layer.borderWidth = 0.0;
        txtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        /**************************************************************/
        txtFldTitle.text=@"";
        btnAddMeeting.imageView.image = [UIImage imageNamed:@"doneAni2.png"];
        txtFldDateTime.text= @"";
        lblVoiceNotes.text=@"Add Voice Notes ?";
    }
    
    if (self.isCreateNewChield)
    {
        txtFldTitle.text = [arrOfLastObject valueForKey:MEETING_TITLE];
        txtView.text = [arrOfLastObject valueForKey:MEETING_COMMENT];
        txtView.textColor=[UIColor blackColor];
        self.isCreateNewChield=NO;
    }
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    txtFldTime.text=[dateFormatter stringFromDate:now];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    txtFldDateTime.text=[df stringFromDate:now];

    [self.navigationItem setHidesBackButton:YES];
}

-(void)backButtonPressed:(id)sender{
    strChildMeeting=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
    [txtView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/*Save Meeting In Database with Animations*/
#pragma mark SAVE MEETINGS IN DATABASE

-(void)startRotate:(UIButton *)button
{
    [UIView animateWithDuration:1.5 animations:^{
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
        fullRotation.duration = 0.3f;
        fullRotation.repeatCount = MAXFLOAT;
        [button.layer addAnimation:fullRotation forKey:@"360"];
        //[button setFrame:CGRectMake(139, 376, 0, 0)];
        [btnAddMeeting popOut:0.8 delegate:nil startSelector:nil stopSelector:nil];
        [self performSelector:@selector(popoutAdd) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(stopRotate:) withObject:button afterDelay:1.0];
    }];
}
-(void)stopRotate :(UIButton *)btn
{
    [btn.layer removeAnimationForKey:@"360"];
}
-(void)popoutAdd
{
    [scrlView addSubview:btnAddMeeting];
    [btnAddMeeting setFrame:CGRectMake(BtnbackGroundOfDone.frame.origin.x+6, BtnbackGroundOfDone.frame.origin.y+6, 61, 61)];
    btnAddMeeting.hidden= TRUE;
    btnAddMeeting.imageView.image = [UIImage imageNamed:@"doneAni3.png"];
    [btnAddMeeting popIn:0.5 delegate:nil];
    [self performSelector:@selector(RecordsAdded) withObject:nil afterDelay:1.0];
}

-(void)RecordsAdded{
    [AppDelegate showalert:@"Records Added Successfully"];
    if ([strChildMeeting isEqualToString:@"CHILD"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_TO_0th_INDEX object:nil];
    }
}

-(IBAction)RecordTab:(id)sender{
    
    NSMutableDictionary *_dictCreateMeeting = [NSMutableDictionary new];
    [_dictCreateMeeting setValue:txtFldTitle.text forKey:MEETING_TITLE];
    [_dictCreateMeeting setValue:txtFldDateTime.text forKey:MEETING_DATE_TIME];
    [_dictCreateMeeting setValue:[CustomUIApplicationClass   getUTCFormateDate:txtFldDateTime.text] forKey:MEETING_DATE_TIMESTAMP];
    [_dictCreateMeeting setValue:txtView.text forKey:MEETING_COMMENT];
    [_dictCreateMeeting setValue:dataOfSelectedImages forKey:MEETING_ATTENDEES_ID];
    [_dictCreateMeeting setValue:txtFldTime.text forKey:MEETINGS_TIME];
    NSLog(@"%@",_dictURLwithSpeech);
    [_dictCreateMeeting setValue:[_dictURLwithSpeech valueForKey:AUDIO_URL] forKey:AUDIO_URL];
    [_dictCreateMeeting setValue:[_dictURLwithSpeech valueForKey:SPEECH_TO_TEXT] forKey:SPEECH_TO_TEXT];

    [mutCellArr addObject:@"1"];
    if ([strChildMeeting isEqualToString:@"CHILD"]) {
        [_dictCreateMeeting setValue:strMeetingID forKey:MEETING_ID];
        
        if ([[_dictCreateMeeting valueForKey:MEETING_TITLE] isEqualToString:@""] || [[_dictCreateMeeting valueForKey:MEETING_DATE_TIME] isEqualToString:@""] || [[_dictCreateMeeting valueForKey:MEETING_COMMENT] isEqualToString:@""] || [_dictCreateMeeting valueForKey:MEETING_ATTENDEES_ID]==nil || ([[_dictCreateMeeting valueForKey:AUDIO_URL]  length]==0) || ([[_dictCreateMeeting valueForKey:SPEECH_TO_TEXT] length]==0)) {
            [AppDelegate showalert:@"Fields Should not be Empty"];
        }else{
            strGlobalParantID = [_dictCreateMeeting valueForKey:MEETING_ID];
            [DAL lookupChangeForSQLDictionary:_dictCreateMeeting insertOrUpdate:@"insert" ClauseAndCondition:nil TableName:TBL_SUB_MEETINGS];
            [self startRotate:btnAddMeeting];
            strChildMeeting=@"";
        }
    }else{
        
        if ([[_dictCreateMeeting valueForKey:MEETING_TITLE] isEqualToString:@""] || [[_dictCreateMeeting valueForKey:MEETING_DATE_TIME] isEqualToString:@""] || [[_dictCreateMeeting valueForKey:MEETING_COMMENT] isEqualToString:@""] || [_dictCreateMeeting valueForKey:MEETING_ATTENDEES_ID]==nil || ([[_dictCreateMeeting valueForKey:AUDIO_URL]  length]==0) || ([[_dictCreateMeeting valueForKey:SPEECH_TO_TEXT] length]==0)) {
            [AppDelegate showalert:@"Fields Should not be Empty"];
        }else{
            [DAL lookupChangeForSQLDictionary:_dictCreateMeeting insertOrUpdate:@"insert" ClauseAndCondition:nil TableName:TBL_CREATE_MEETING];
            [self startRotate:btnAddMeeting];
        }
    }
}
/*Successfully Saved Recoed In Database*/
#pragma mark - TextView Delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [self CanclePressedDate];
    if ([txtView.text isEqualToString:@"Comment"]) {
        txtView.text = @"";
    }
    txtView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(txtView.text.length == 0){
        txtView.textColor = [UIColor lightGrayColor];
        txtView.text = @"Comment";
        [txtView resignFirstResponder];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    txtViewLocal = textView;
    CGRect textVWRect = [self.view convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    if ([touch view]==scrlView) {
//        if(txtView.text.length == 0){
//            txtView.textColor = [UIColor lightGrayColor];
//            txtView.text = @"Comment";
//            [txtView resignFirstResponder];
//        }
//        [txtView resignFirstResponder];
//    }
//}
/**/
#pragma mark Calendar with New Design

- (IBAction)showCalendar:(id)sender
{
    [txtFldTitle resignFirstResponder];
    
    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    if ([sender tag] == 10)
    {
        isPopover = NO;
        self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"apple calendar"];
        // limit apple calendar to 2 months before and 2 months after current date
        //        self.pmCC.allowedPeriod = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:-2]
        //                                                        endDate:[[NSDate date] dateByAddingMonths:2]];
    }
    else
    {
        self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    }
    
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = NO;
    
    if ([sender tag] == 10)
    {
        [self.pmCC presentCalendarFromRect:CGRectZero
                                    inView:[sender superview]
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                 isPopover:isPopover
                                  animated:YES];
    }
    else
    {
        [self.pmCC presentCalendarFromView:sender
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                 isPopover:isPopover
                                  animated:YES];
    }
    self.pmCC.allowedPeriod = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingMonths:0]
                                                    endDate:[[NSDate date] dateByAddingMonths:2]];
    self.pmCC.period = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
    [self calendarController:pmCC didChangePeriod:pmCC.period];
}
#pragma mark PMCalendarControllerDelegate methods
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    //    periodLabel.text = [NSString stringWithFormat:@"%@ - %@"
    //                        , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
    //                        , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyyy"]];
    NSLog(@"%@",[newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]);
    txtFldDateTime.text = [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"];
    [self performSelector:@selector(resizeScrollView) withObject:nil afterDelay:.3];

    
    // hack for hide calander view on date selection
    if ([self.pmCC  isCalendarVisible])
    {
        if (isCalanderPopOver)
        {
            [self.pmCC dismissCalendarAnimated:NO];
            isCalanderPopOver=NO;
        }
        else
            isCalanderPopOver=YES;
    }
}
/**/

#pragma mark - KNMultiItemSelectorDelegate

-(void)selector:(KNMultiItemSelector *)selector didSelectItem:(KNSelectorItem *)selectedItem {
    // This is optional, in case you want to do something as soon as user selects an item
    NSLog(@"Selected %d", selectedItem.ID);
}
-(void)selector:(KNMultiItemSelector *)selector didDeselectItem:(KNSelectorItem *)selectedItem {
    // This is optional, in case you want to revert something you have done earlier
    NSLog(@"Removed %@", selectedItem.selectValue);
}

-(void)selector:(KNMultiItemSelector *)selector didFinishSelectionWithItems:(NSArray *)selectedItems {
    // Do whatever you want with the selected items
    NSString * text = @"";
    NSString *primaryID = @"";
    NSMutableArray *arrImagesSelected = [[NSMutableArray alloc] init];
    
    for (KNSelectorItem * i in selectedItems)
    {
        NSMutableDictionary *dictImagesSelection = [[NSMutableDictionary alloc] init];
        text = [text stringByAppendingFormat:@"%@,", i.displayValue];
        primaryID = [primaryID stringByAppendingFormat:@"%d,",i.ID];
        [dictImagesSelection setValue:i.image forKey:SELECTED_USER_IMAGE];
        [dictImagesSelection setValue:i.displayValue forKey:SELECTED_USER_NAME];
        if (i.emailID==nil) {
            [dictImagesSelection setValue:i.selectValue forKey:SELECTED_USER_PHONE_NUMBER];
        }
        else
        { //
            [dictImagesSelection setValue:i.emailID forKey:SELECTED_USER_EMAIL_ID];
        }
        
        [arrImagesSelected addObject:dictImagesSelection];
    }
    
    //NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data]
    dataOfSelectedImages = [NSKeyedArchiver archivedDataWithRootObject:arrImagesSelected];
    strIDOfAttendees = primaryID;
    txtFldAttendees.text = text;
    // You should dismiss modal controller here, it doesn't do that by itself
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)indexButtonDidTouch:(id)sender {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self openContacts];
    });
    
}

-(void)openContacts{
    [txtView resignFirstResponder];
    // dismiss datePicker
    [self CanclePressedDate];
    strGoinToChooseContactsORnot = @"YES";
    NSArray * sortedItems = [_arrPeopleInfo sortedArrayUsingSelector:@selector(compareByDisplayValue:)];
    NSArray *currentItems = [_arrPeopleInfo mutableCopy];
    KNMultiItemSelector * selector = [[KNMultiItemSelector alloc] initWithItems:sortedItems preselectedItems:currentItems title:@" Select Contacts" placeholderText:nil delegate:self];
    selector.useTableIndex = YES;
    [self presentModalHelper:selector];
}

-(IBAction)openRecordTab:(id)sender
{
    RecordNoteViewController *ctrl = [RecordNoteViewController new];
    strGoinToChooseContactsORnot = @"YES";
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)presentModalHelper:(UIViewController*)controller {

    dispatch_async(dispatch_get_main_queue(),^{
        UINavigationController * uinav = [[UINavigationController alloc] initWithRootViewController:controller];
        uinav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            uinav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:uinav animated:YES completion:nil];
    });
}

-(void)selectorDidCancelSelection {
    // You should dismiss modal controller here, it doesn't do that by itself
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SAVE DATA INTO DATABASE
/* Save Attendees into Database */

-(void)saveAttendeesTodatabase: completion completion:(void (^)(void))completionBlock{
    
//    @synchronized (self){
//    dispatch_async(dispatch_get_main_queue(), ^{
        
//    });
   
        databaseOBJ = [DAL getInstance];
        strTblName = TBL_ATTENDEES;
        for (int idx=0;idx<[arrDatabseAttendeesTbl count] ; idx++) {
            NSDictionary *obj = [arrDatabseAttendeesTbl objectAtIndex:idx];
            NSString *str= [NSString stringWithFormat:@"%d",idx+1];
            if (![databaseOBJ isRecordExistInCountyInfo:str]) {
                [DAL lookupChangeForSQLDictionary:obj insertOrUpdate:@"insert" ClauseAndCondition:nil TableName:TBL_ATTENDEES];
//                CGFloat p = (CGFloat)idx/(CGFloat)[arrDatabseAttendeesTbl count];
//                dispatch_async(dispatch_get_main_queue(),^{
//                    [hud setProgress:p];
//                });
            }
        }
    completionBlock();
    
//    }
    
}

/* Date Picker Methods*/

#pragma mark - Self And Selector Methods

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
    [df setDateFormat:@"hh:mm a"];
    NSString *strDate=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
    txtFldTime.text = strDate;
}

-(IBAction)selectDate:(id)sender{
    
    
    // close phone pad
    // close calander
    [txtFldTitle resignFirstResponder];
    [txtView resignFirstResponder];
    [pmCC dismissCalendarAnimated:YES];
    
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
- (IBAction)SetTitleAction:(id)sender
{
    [txtFldTitle becomeFirstResponder];
}

- (IBAction)CommentAction:(id)sender
{
    [self CanclePressedDate];
    [txtView becomeFirstResponder];
}
@end
