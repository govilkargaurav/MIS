//
//  NewParticipentController.m
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewParticipentController.h"
#import "ImportParticipants.h"
#import "AssessmentsVIewController.h"
#import "GlobleClass.h"
#import "NewAssessorViewController.h"
#import "HelpViewController.h"
#import "AlertManger.h"

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

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;



@implementation NewParticipentController

CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //------Topbar Image Set
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    lblUnitName.text = globle_UnitName;
    [lblUnitInfo setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];

    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];

    [scrNewParticipant setContentSize:CGSizeMake(768, 896)];
    /*
    NavViewController *navScreenController  = [[NavViewController alloc] initWithNibName:@"NavView" bundle:nil];
    [self.view addSubview:navScreenController.view];
    [navScreenController setFocusButton:2];
    navScreenController.btn3.enabled=NO;
    */
    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newView) name:@"newView" object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(void)newView
{    
    NewAssessorViewController *controller=[[NewAssessorViewController alloc]initWithNibName:@"NewAssessorViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    //controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:controller animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    

    //NSLog(@"textFieldDidBeginEditing %@",textField);
	// Below code is used for scroll up View with navigation baar
	CGRect textVWRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

#pragma mark - UIButton Events

-(IBAction)helpButtonTapped:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    
    if(![popoverController isPopoverVisible]){
		HelpViewController *objHelpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:objHelpViewController];
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 500.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(90,0,60,39) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	[UIView setAnimationDuration:2.75];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
    self.view.alpha = 1;
	
	[UIView commitAnimations];
}



-(IBAction)goBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)contineoueVeiw:(id)sender
{
    BOOL yn = [self validateEmailWithString:emailField.text];
    
    if ([participantsNameField.text isEqualToString:@""] || [jobTitleField.text isEqualToString:@""] || [companyField.text isEqualToString:@""] || [empIdStuIdField.text isEqualToString:@""] || [addressField.text isEqualToString:@""] || [suburbCityField.text isEqualToString:@""] || [stateField.text isEqualToString:@""] ||[postcodeField.text isEqualToString:@""] || [countryField.text isEqualToString:@""] || [emailField.text isEqualToString:@""] || [phoneNoField.text isEqualToString:@""] || [superviserFiled.text isEqualToString:@""] || yn==FALSE) {
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"All fields are required. Do not left any field empty." cancelButtonTitle:@"Ok"];
        
    }
    else
    {
        BOOL yn = [DatabaseAccess isrecordExistin_tbl_resources:[NSString stringWithFormat:@"select *from tbl_participants where empId_stuNO ='%@'",empIdStuIdField.text]];
        if(yn==NO)
        {
            [DatabaseAccess INSERT_UPDATE_DELETE:[NSString stringWithFormat:@"insert into tbl_participants (part_name,job_title,company,empId_stuNO,address,suburb_city,state,post_date,country,email,ph_no,superviser) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",participantsNameField.text,jobTitleField.text,companyField.text,empIdStuIdField.text,addressField.text,suburbCityField.text,stateField.text,postcodeField.text,countryField.text,emailField.text,phoneNoField.text,superviserFiled.text]];
            
            
            
            NSLog(@"%@",[sender currentTitle]);
            if(aryParticipantInfoGlobal != nil)
            {
                [aryParticipantInfoGlobal removeAllObjects];
                aryParticipantInfoGlobal = nil;
            }
            aryParticipantInfoGlobal = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getAllRecordTbl_Participants:[NSString stringWithFormat:@"Select *from tbl_participants where empId_stuNo = '%@'", empIdStuIdField.text]]];
            NSLog(@"%@",aryParticipantInfoGlobal);
            
            AssessmentsVIewController *controller=[[AssessmentsVIewController alloc] initWithNibName:@"AssessmentsVIewController" bundle:nil];
            globle_participant_id = empIdStuIdField.text;
            globle_ParticipantName = participantsNameField.text;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        else
        {
            UIAlertView *alert_1 = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Employee Id is already exists !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert_1 show];
        }
        
    /*
    dbBean.part_name=participantsNameField.text;
    dbBean.job_title=jobTitleField.text;
    dbBean.company=companyField.text;
    dbBean.empId_stuNo=empIdStuIdField.text;
    dbBean.address=addressField.text;
    dbBean.suburb_city=suburbCityField.text;
    dbBean.state=stateField.text;
    dbBean.post_date=postcodeField.text;
    dbBean.country=countryField.text;
    dbBean.email=emailField.text;
    dbBean.ph_no=phoneNoField.text;
    dbBean.superviser=superviserFiled.text;
        
        if([dt insertintotblparticipants:dbBean])
        {
            [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"Records Added Successfully" cancelButtonTitle:@"Ok" okButtonTitle:nil parentController:self];

            if(aryParticipantInfoGlobal!=nil)
            {
                [aryParticipantInfoGlobal removeAllObjects];
                aryParticipantInfoGlobal = nil;
            }
            aryParticipantInfoGlobal = [[NSMutableArray alloc]initWithArray:[dt getAllRecordTbl_Participants:[NSString stringWithFormat:@"Select *from tbl_participants where cast(empId_stuNo as int) = %@",empIdStuIdField.text]]];
        }
        else
        {
            [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"We found Some error in Data. Please check enterd data and try again." cancelButtonTitle:@"Ok"];    
        }
     */
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex==0) {

        magicStr3=@"1";
        AssessmentsVIewController *controller=[[AssessmentsVIewController alloc] initWithNibName:@"AssessmentsVIewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];

    }
    
    
}


-(IBAction)importContacts:(id)sender{
    
    ImportParticipants *_controller=[[ImportParticipants alloc] initWithNibName:@"ImportParticipants" bundle:nil];
    [self.navigationController pushViewController:_controller animated:YES];
    
}

-(IBAction)btnHomePressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnLearningPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_12" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnAssessmentPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_13" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnResourcePressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}



#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (theTextField  == phoneNoField)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
            else
            {
                return YES;
            }
            
        }
    }
    
    return YES;
}

#pragma mark - Email Address Validation
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
