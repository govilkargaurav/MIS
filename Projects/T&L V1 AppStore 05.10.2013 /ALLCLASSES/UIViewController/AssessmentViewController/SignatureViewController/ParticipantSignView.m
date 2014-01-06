//
//  ParticipantSignView.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/10/12.
//
//

#import "ParticipantSignView.h"
#import "JBSignatureView.h"
#import "GlobleClass.h"
#import "JBSignatureView.h"
#import "NavigationController.h"
#import "TabbarController.h"
#import "KeypadVC.h"
#import "GlobleClass.h"
#import "SignatureViewController.h"
#import "DatabaseAccess.h"

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

@interface ParticipantSignView ()
{
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	id<ParticipantSignViewControllerDelegate> delegate_;
}
// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

@end


@implementation ParticipantSignView
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
    
    
    
    if([taskEditMode isEqualToString:@"YES"])
    {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"grID"]);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"gataskID"]);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"gpID"]);
        
        aryResumeInfo = [[NSMutableArray alloc]init];
        aryResumeInfo = [DatabaseAccess get_All_ResumeTaskInfo:[NSString stringWithFormat:@"select *from tbl_ResumeTask where ResourceID = %@ and AssessmentTaskID = %@ and ParticipantID = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"grID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"gataskID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"gpID"]]];
        NSLog(@"%@",aryResumeInfo);
        
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryResumeInfo objectAtIndex:0]valueForKey:@"NSParticipantName"]]];
        
        [tfAssName setText:[[aryResumeInfo objectAtIndex:0]valueForKey:@"NSParticipantName"]];
        
        [pickDate setTitle:[[aryResumeInfo objectAtIndex:0]valueForKey:@"PartDate"] forState:UIControlStateNormal];
    }
    else if([taskEditMode isEqualToString:@"NO"])
    {
        NSDateFormatter *RdateFormatter = [[NSDateFormatter alloc] init];
        [RdateFormatter setDateFormat:@"dd-MM-yyyy"];
        [pickDate setTitle:[RdateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryParticipantInfoGlobal objectAtIndex:0]valueForKey:@"part_name"]]];
        
        [tfAssName setText:[[aryParticipantInfoGlobal objectAtIndex:0]valueForKey:@"part_name"]];
    }
    
    
    strPushView = NO;
    
    lbl1.text = globle_UnitName;
    [lbl2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
        
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    
   
    
    self.signatureView = [[JBSignatureView alloc] init];
    [self.signatureView setFrame:CGRectMake(0,400,768,400)];
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:self.signatureView];
    
    btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setFrame:CGRectMake(658, 410, 61, 32)];
    [btnClear setImage:[UIImage imageNamed:@"clearbutton.png"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClear];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(strPushView)
    {
        strPushView = NO;
        SignatureViewController *objSignatureViewController = [[SignatureViewController alloc]initWithNibName:@"SignatureViewController" bundle:nil];
        [self.navigationController pushViewController:objSignatureViewController animated:YES];
        //QuestionAssessorViewController *QAview=[[QuestionAssessorViewController alloc] initWithNibName:@"QuestionAssessorViewController" bundle:nil];
        //[self.navigationController pushViewController:QAview animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PName = tfAssName.text;
    PDate = pickDate.currentTitle;
    
    strPushView = YES;
    [self dismissModalViewControllerAnimated:YES];
    ParticipatnsContinue = @"YES";
    
    //[[TabbarController sharedInstance]showQAview];
    
    
    KeypadVC *controller=[[KeypadVC alloc] initWithNibName:@"KeypadVC" bundle:nil];
    //navigationString=@"1";
    [self.navigationController pushViewController:controller animated:NO];
    //[self presentModalViewController:controller animated:YES];
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
    [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(60,130 , sizeOfPopover.width, sizeOfPopover.height)
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


#pragma mark - button event
-(IBAction)exitbuttontapped:(id)sender
{
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString:@"AssessmentsVIewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
}

-(IBAction)btnExitPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_21" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnParticipantPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_22" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
-(IBAction)btnAssessorPressed:(id)sender
{
    KeypadVC *objKeypadVC = [[KeypadVC alloc]initWithNibName:@"" bundle:nil];
    [self.navigationController pushViewController:objKeypadVC animated:YES];
    //NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_23" object:self];
    //[[NSNotificationCenter defaultCenter] postNotification:notif];
}


@end
