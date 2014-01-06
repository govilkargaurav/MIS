//
//  TPParticipantSignViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/3/12.
//
//

#import "TPParticipantSignViewController.h"
#import "JBSignatureView.h"
#import "TPAssessorSignViewController.h"
#import "GlobleClass.h"

@interface TPParticipantSignViewController ()
{
    @private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	id<TPParticipantSignViewControllerDelegate> delegate_;
}

// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;

@end

@implementation TPParticipantSignViewController
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
    
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    [lblPartName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryParticipantInfoGlobal objectAtIndex:0]valueForKey:@"part_name"]]];
    
    lbl1.text = globle_UnitName;
    [lbl2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    
    self.signatureView = [[JBSignatureView alloc] init];
    [self.signatureView setFrame:CGRectMake(0,200,768,400)];
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:self.signatureView];
    
    btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setFrame:CGRectMake(658, 210, 61, 32)];
    [btnClear setImage:[UIImage imageNamed:@"clearbutton.png"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClear];
    // Do any additional setup after loading the view from its nib.
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



@end
