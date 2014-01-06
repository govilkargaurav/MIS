//
//  SignatureViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/10/12.
//
//


#import "SignatureViewController.h"
#import "JBSignatureView.h"
#import "NavigationController.h"
#import "TabbarController.h"
#import "GlobleClass.h"
#import "ViewController.h"
#import "AppDelegate.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation UITextField (custom)
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
@end

@interface SignatureViewController ()
{
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	id<SignatureViewControllerDelegate> delegate_;
}
// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

@end

@implementation SignatureViewController
@synthesize
signaturePanelBackgroundImageView = signaturePanelBackgroundImageView_,
signatureView = signatureView_,
portraitBackgroundImage = portraitBackgroundImage_,
landscapeBackgroundImage = landscapeBackgroundImage_,
delegate = delegate_;

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
   
    
    
    //[[NSUserDefaults standardUserDefaults] setValue:globle_resource_id forKey:@"grID"];
    //[[NSUserDefaults standardUserDefaults] setValue:globle_assessment_task_id forKey:@"gataskID"];
    //[[NSUserDefaults standardUserDefaults] setValue:globle_participant_id forKey:@"gpID"];
    
    if([taskEditMode isEqualToString:@"YES"])
    {
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryResumeInfo objectAtIndex:0]valueForKey:@"AssName"]]];
        
        [tfAssName setText:[[aryResumeInfo objectAtIndex:0]valueForKey:@"AssName"]];
        [tfLocation setText:[[aryResumeInfo objectAtIndex:0]valueForKey:@"AssLocation"]];
        [pickDate setTitle:[[aryResumeInfo objectAtIndex:0]valueForKey:@"AssDate"] forState:UIControlStateNormal];
    }
    else if([taskEditMode isEqualToString:@"NO"])
    {
        NSDateFormatter *RdateFormatter = [[NSDateFormatter alloc] init];
        [RdateFormatter setDateFormat:@"dd-MM-yyyy"];
        [pickDate setTitle:[RdateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]]];
        [tfAssName setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]];
        [tfLocation setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"asscity"]];
        
        
        
    }
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    
    EndTime = [NSDate date];
    NSString *dateString = [format stringFromDate:EndTime];
    EndTime = [format dateFromString:dateString];
    NSLog(@"%@",StartTime);
    NSLog(@"%@",EndTime);
    
    NSTimeInterval interval = [EndTime timeIntervalSinceDate:StartTime];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    int seconds = round(interval - minutes * 60);
    NSString *timeDiff = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes,seconds];
    
    NSLog(@"Date IS %@",timeDiff);

    [tfDuration setText:timeDiff];
    /* -----------------------------------------------------*/
    
        
    lbl1.text = globle_UnitName;
    [lbl2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    
    
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    self.signatureView = [[JBSignatureView alloc] init];
    [self.signatureView setFrame:CGRectMake(0,510,768,400)];
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:self.signatureView];
    
    btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setFrame:CGRectMake(658, 520, 61, 32)];
    [btnClear setImage:[UIImage imageNamed:@"clearbutton.png"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClear];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - button event
-(void)clearSignature
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCleared:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureCleared:signatureImage signatureController:self];
	}
	
	[self.signatureView clearSignature];
}

-(IBAction)btnContinueTapped:(id)sender
{
    /* --------- Code Update Status => Completed into tbl_ResumeTask ------------ */
    NSString *sqlStmt;
    if([taskEditMode isEqualToString:@"YES"])
    {
        sqlStmt = [NSString stringWithFormat:@"update tbl_ResumeTask set Status = 'Completed',PartName = '%@',PartDate = '%@',AssName = '%@',AssLocation = '%@',AssDuration = '%@',AssDate = '%@' where ParticipantID  = '%@' and cast(ResourceID as int) = %@ and cast(AssessmentTaskID as int) = %@",PName,PDate,tfAssName.text,tfLocation.text,tfDuration.text,pickDate.currentTitle,globle_participant_id,globle_resource_id,globle_assessment_task_id];
    }
    else
    {
        sqlStmt = [NSString stringWithFormat:@"update tbl_ResumeTask set Status = 'Completed',PartName = '%@',PartDate = '%@',AssessorID = '%@',AssName = '%@',AssLocation = '%@',AssDuration = '%@',AssDate = '%@' where ParticipantID  = '%@' and cast(ResourceID as int) = %@ and cast(AssessmentTaskID as int) = %@",PName,PDate,[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"],tfAssName.text,tfLocation.text,tfDuration.text,pickDate.currentTitle,globle_participant_id,globle_resource_id,globle_assessment_task_id];
    }
    taskEditMode = @"NONE";
    /* -------------------------------------------------------------------------- */
    
    [DatabaseAccess INSERT_UPDATE_DELETE:sqlStmt];
    
    AsParYsNo = @"YES";
    ParticipatnsContinue = @"NONE";
    tabFocus = @"AsTask";
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.strWhichTabBar = @"FirstSecondTabBar";
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController_ShowAssessment" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)selectDateTapped:(id)sender
{
    datePickerViewNew = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 360, 216)];
    datePickerViewNew.datePickerMode = UIDatePickerModeDateAndTime;
    [datePickerViewNew addTarget:self
                          action:@selector(changeDateInLabel:)
                forControlEvents:UIControlEventValueChanged];
    
    
    UIViewController* popoverContent = [[UIViewController alloc]
                                        init];
    UIView* popoverView = [[UIView alloc]
                           initWithFrame:CGRectMake(0,0, 360, 216)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    
    [popoverView addSubview:datePickerViewNew];
    popoverContent.view = popoverView;
    
    //resize the popover view shown
    //in the current view to the view's size
    popoverContent.contentSizeForViewInPopover =  CGSizeMake(360, 216);
    
    popOverControllerWithPicker = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popOverControllerWithPicker.popoverContentSize = CGSizeMake(360, 216);
    CGSize sizeOfPopover = CGSizeMake(300, 222);
    [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(60,260 , sizeOfPopover.width, sizeOfPopover.height)
                                                 inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)changeDateInLabel:(id)sender{
    
    NSDateFormatter *RdateFormatter = [[NSDateFormatter alloc] init];
    [RdateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSLog(@"%@",[RdateFormatter stringFromDate:datePickerViewNew.date]);
    [pickDate setTitle:[RdateFormatter stringFromDate:datePickerViewNew.date] forState:UIControlStateNormal];
    
}

#pragma mark - signture orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/**
 * Upon rotation, switch out the background image
 * @author Jesse Bunch
 **/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self.signaturePanelBackgroundImageView setImage:self.landscapeBackgroundImage];
	} else {
		[self.signaturePanelBackgroundImageView setImage:self.portraitBackgroundImage];
	}
	
}

/**
 * After rotation, we need to adjust the signature view's frame to fill.
 * @author Jesse Bunch
 **/
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.signatureView setFrame:self.view.bounds];
	[self.signatureView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnExitPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnParticipantPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_22" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnAssessorPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_23" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}


@end
