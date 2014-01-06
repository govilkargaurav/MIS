//
//  TPAssessorSignViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/3/12.
//
//

#import "TPAssessorSignViewController.h"
#import "JBSignatureView.h"
#import "GlobleClass.h"
@interface TPAssessorSignViewController ()
{
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	id<TPAssessorSignViewControllerDelegate> delegate_;
}
// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

@end

@implementation TPAssessorSignViewController
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
    
    aryTInfos = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_ResumeFTask:[NSString stringWithFormat:@"SELECT *FROM TBL_RESUMEFTASK WHERE cast(ResourceID as int) = %@ and ParticipantID = '%@' and Status = 'TParty'",globle_resource_id,globle_participant_id]]];
    if([aryTInfos count]>0)
    {
        [pickDate setTitle:[[aryTInfos objectAtIndex:0] valueForKey:@"AssDate"] forState:UIControlStateNormal];
        [tfAssName setText:[[aryTInfos objectAtIndex:0] valueForKey:@"AssName"]];
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryTInfos objectAtIndex:0] valueForKey:@"AssName"]]];
    }
    else
    {
        NSDateFormatter *RdateFormatter = [[NSDateFormatter alloc] init];
        [RdateFormatter setDateFormat:@"yyyy-MM-dd"];
        [pickDate setTitle:[RdateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
        [tfAssName setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]];
        [lblAssName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]]];
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
    TPAssessorSignViewController *objTPAssessorSignViewController = [[TPAssessorSignViewController alloc]initWithNibName:@"TPAssessorSignViewController" bundle:nil];
    [self.navigationController pushViewController:objTPAssessorSignViewController animated:YES];
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
    [RdateFormatter setDateFormat:@"yyyy-MM-dd"];
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
    /*----------------- Check ThirdParty Info in Database -----------------------*/
    

    if([aryTInfos count]>0) // Record Exits, So Update Info
    {
        NSString *strQuery = [NSString stringWithFormat:@"Update tbl_ResumeFTask set ResourceID = '%@',ParticipantID = '%@',Status = 'TParty', PartName = '%@', AssName = '%@', AssDate = '%@' where AutoID = %@",globle_resource_id,globle_participant_id,[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"part_name"], tfAssName.text,pickDate.currentTitle,[[aryTInfos objectAtIndex:0] valueForKey:@"AutoID"]];
        [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
    }
    else                    // Record doesn't Exits, So Insert Info
    {
        NSString *strQuery = [NSString stringWithFormat:@"Insert into tbl_ResumeFTask (ResourceId,ParticipantID,AssessorID,Status,PartName,AssName,AssDate) values('%@','%@','%@','%@','%@','%@','%@')",globle_resource_id,globle_participant_id,[[NSUserDefaults standardUserDefaults] valueForKey:@"assempid"],@"TParty",[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"part_name"],tfAssName.text,pickDate.currentTitle];
        [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
    }
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString:@"AssessmentsVIewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
}

@end
