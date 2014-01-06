//
//  ThirdPartyStep2ViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdPartyStep2ViewController.h"
#import "ThirdPartyStep1ViewController.h"
#import "AssessmentsVIewController.h"
#import "JBSignatureView.h"
#import "GlobleClass.h"

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


#pragma mark - *** Private Interface ***

@interface ThirdPartyStep2ViewController() {
@private
	__strong JBSignatureView *signatureView_;
	__strong UIImageView *signaturePanelBackgroundImageView_;
	__strong UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	__strong UIButton *confirmButton_, *cancelButton_;
	id<ThirdPartyStep2ViewControllerDelegate> delegate_;
}

// The view responsible for handling signature sketching
@property(nonatomic,strong) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,strong) UIImageView *signaturePanelBackgroundImageView;
@end


// @implementation UITextField (custom)

// @end

@implementation ThirdPartyStep2ViewController
@synthesize signaturePanelBackgroundImageView = signaturePanelBackgroundImageView_;
@synthesize signatureView = signatureView_;
@synthesize portraitBackgroundImage = portraitBackgroundImage_;
@synthesize landscapeBackgroundImage = landscapeBackgroundImage_;
@synthesize delegate = delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    //------------------------------       Fill Static Values       ----------------------------
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    
    [lblPartName setText:[NSString stringWithFormat:@"Confirmation of completion for %@",[[aryParticipantInfoGlobal objectAtIndex:0]valueForKey:@"part_name"]]];
    
    lbl1.text = globle_UnitName;
    [lbl2 setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    
    //------------------------- assessor information    ------------------------
    aryAssessorInfo = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"select *from tbl_assessor where ass_name = '%@' and ass_pinnumber = '%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"],[[NSUserDefaults standardUserDefaults] valueForKey:@"asspinnumber"]]]];
    
    //-----------------------------------------
    aryThirdPartyInfo = [[NSMutableArray alloc]init];
    
    aryThirdPartyInfo = [DatabaseAccess getthirdpartyresults:[NSString stringWithFormat:@"select *from tbl_ThirdPartyReports where cast(ResourceID as int) = %@",globle_resource_id]];
    
    aryThirdPartyDetail = [[NSMutableArray alloc]init];
    aryThirdPartyDetail = [DatabaseAccess getthirdpartyresults_detail:[NSString stringWithFormat:@"select *from tbl_ThirdPartyDetail where ParticipantID  = '%@' and cast(ResourceID as int) = %@",globle_participant_id,globle_resource_id]];
    
    if([aryThirdPartyDetail count]>0)
    {
        tfName.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"Name"];
        tfPostion.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"Position"];
        tfOrg.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"Organization"];
        tfOffAdd.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"OffAddress"];
        tfCity.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"City"];
        tfState.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"State"];
        tfPostCode.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"PostCode"];
        tfPhone.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"Phone"];
        tfEmail.text = [[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"Email"];
        
    }
    
    [scrView setContentSize:CGSizeMake(768, 700)];
    // Signature View
	self.signatureView = [[JBSignatureView alloc] init];
	[self.signatureView setFrame:CGRectMake(0,540,768,380)];
    [self.signatureView setBackgroundColor:[UIColor whiteColor]];
    //[self.signatureView setMultipleTouchEnabled:YES];
    [self.view addSubview:self.signatureView];
    
    btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setFrame:CGRectMake(658, 550, 61, 32)];
    [btnClear setImage:[UIImage imageNamed:@"clearbutton.png"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClear];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - signtaure view method & orientation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self.signaturePanelBackgroundImageView setImage:self.landscapeBackgroundImage];
	} else {
		[self.signaturePanelBackgroundImageView setImage:self.portraitBackgroundImage];
	}
	
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.signatureView setFrame:self.view.bounds];
	[self.signatureView setNeedsDisplay];
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


-(IBAction)exitbuttontapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnContinueTapped:(id)sender
{
    if([aryThirdPartyDetail count]>0)
    {
        NSString *strQuery = [NSString stringWithFormat:@"update tbl_ThirdPartyDetail set Name='%@',Position = '%@',Organization = '%@',OffAddress = '%@',City = '%@',State = '%@',PostCode = '%@',Phone = '%@',Email = '%@' where cast(TAutoID as int)=%@",tfName.text,tfPostion.text,tfOrg.text,tfOffAdd.text,tfCity.text,tfState.text,tfPostCode.text,tfPhone.text,tfEmail.text,[[aryThirdPartyDetail objectAtIndex:0] valueForKey:@"TAutoID"]];
        [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
    }
    else
    {
        [DatabaseAccess insert_thrdpartydetail:[[aryThirdPartyInfo objectAtIndex:0]valueForKey:@"ReportID"] resourceid:[[aryThirdPartyInfo objectAtIndex:0]valueForKey:@"ResourceID"] name:tfName.text position:tfPostion.text organization:tfOrg.text officeadd:tfOffAdd.text city:tfCity.text state:tfState.text postcode:tfPostCode.text phone:tfPhone.text email:tfEmail.text assid:[[aryAssessorInfo objectAtIndex:0] valueForKey:@"assessorsID"] parid:globle_participant_id];
    }
    
    ThirdPartyStep1ViewController *objThirdPartyStep1ViewController = [[ThirdPartyStep1ViewController alloc]initWithNibName:@"ThirdPartyStep1ViewController" bundle:nil];
    [self.navigationController pushViewController:objThirdPartyStep1ViewController animated:YES];
}


@end
