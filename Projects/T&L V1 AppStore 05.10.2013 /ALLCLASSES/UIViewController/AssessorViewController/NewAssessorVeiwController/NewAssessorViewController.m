//
//  NewAssessorViewController.m
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAssessorViewController.h"
#import "KeypadVC.h"
#import "TabbarController.h"
#import "GlobleClass.h"
#import "AssessmentsVIewController.h"
#import "ViewController.h"
#import "ContexualizationViewController.h"
#import "ThirdPartyStep1ViewController.h"
#import "HelpViewController.h"

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
@implementation NewAssessorViewController
@synthesize LoginType,strPushViewController,strSelectedView;
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
    
    [viewSignUp setContentSize:CGSizeMake(768, 800)];
    if([strSelectedView isEqualToString:@"1"]){
        [viewSignUp setHidden:FALSE];
        [viewSignIn setHidden:TRUE];
        [ivSignInUpStrip setImage:[UIImage imageNamed:@"leftSelected.png"]];
        self.LoginType = @"REGISTER";
    }
    else if([strSelectedView isEqualToString:@"0"]){
        [viewSignUp setHidden:TRUE];
        [viewSignIn setHidden:FALSE];
        [ivSignInUpStrip setImage:[UIImage imageNamed:@"existingAssessorBG.png"]];
        self.LoginType = @"LOGIN";
    }
    
    //------Topbar Image Set
    [ivTopBarSelected setImage:[APPDEL topbarselectedImage:strFTabSelectedID]];
    
    lblUnitName.text = globle_UnitName;
    [lblUnitInfo setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
}

- (void)viewWillAppear:(BOOL)animated {

    
    [super viewWillAppear:animated];
 
    if([navigationStr isEqualToString:@"1"])
    {
        navigationStr = @"0";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
    }
    
}

-(void)viewDissmiss
{

}

-(IBAction)SegmentChanged:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            LoginType = @"LOGIN";
            [viewSignUp setHidden:TRUE];
            [viewSignIn setHidden:NO];
            [ivSignInUpStrip setImage:[UIImage imageNamed:@"existingAssessorBG.png"]];
        break;
        
        case 1:
            LoginType = @"REGISTER";
            [viewSignIn setHidden:TRUE];
            [viewSignUp setHidden:NO];
            [ivSignInUpStrip setImage:[UIImage imageNamed:@"leftSelected.png"]];
        break;
             
        default:
        break;
    }
}


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark TextField Delegate

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
    /*
    if(textField.tag ==11)
    {
        if(![textField.text isEqualToString:@""])
        {
            LoginType = @"LOGIN";
            [tfass_name setBackgroundColor:[UIColor lightGrayColor]];
            [tfass_name setEnabled:FALSE];
        }
        else
        {
            [tfass_name setBackgroundColor:[UIColor clearColor]];
            [tfass_name setEnabled:TRUE];
        }
    }
    if(textField.tag==21)
    {
        if(![textField.text isEqualToString:@""])
        {
            LoginType = @"REGISTER";
            [tflogin_name setBackgroundColor:[UIColor lightGrayColor]];
            [tflogin_name setEnabled:FALSE];
        
            [tflogin_pinnumber setBackgroundColor:[UIColor lightGrayColor]];
            [tflogin_pinnumber setEnabled:FALSE];
        }
        else 
        {
            [tflogin_name setBackgroundColor:[UIColor clearColor]];
            [tflogin_name setEnabled:TRUE];
            
            [tflogin_pinnumber setBackgroundColor:[UIColor clearColor]];
            [tflogin_pinnumber setEnabled:TRUE];
        }
    }
    
    */
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
{
    if (theTextField  == tfass_pinnumber || theTextField == tfass_conpinnumber || theTextField == tflogin_pinnumber)
    {
        NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
        if(newLength < 6)
        {
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            for (int i = 0; i < [string length]; i++)
            {
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
        else
        {
            return NO;
        }
    }
    else if(theTextField == tfass_phonenumber)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++)
        {
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

#pragma mark - UIButton Event

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

-(IBAction)popTorootView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

/**************************Added Code****************************/
-(IBAction)continueView:(id)sender
{
    
    
    if([LoginType isEqualToString:@"REGISTER"])
    {
        BOOL yn = [self validateEmailWithString:tfass_email.text];
        if ([tfass_name.text isEqualToString:@""] || [tfass_jobtitle.text isEqualToString:@""] || [tfass_org.text isEqualToString:@""] || [tfass_empid.text isEqualToString:@""] || [tfass_officeadd.text isEqualToString:@""] || [tfass_city.text isEqualToString:@""] || [tfass_state.text isEqualToString:@""] || [tfass_phonenumber.text isEqualToString:@""] || [tfass_postcode.text isEqualToString:@""] || [tfass_email.text isEqualToString:@""] || [tfass_supervisor.text isEqualToString:@""] || [tfass_pinnumber.text isEqualToString:@""] || [tfass_secque.text isEqualToString:@""] || [tfass_answer.text isEqualToString:@""] || yn==FALSE)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"All fields are required. Do not left any register field empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {            
            //-- Insert Assessor Table -----
            [DatabaseAccess insert_tbl_assessor:tfass_name.text ass_jobtitle:tfass_jobtitle.text ass_org:tfass_org.text ass_empid:tfass_empid.text ass_officeadd:tfass_officeadd.text ass_city:tfass_city.text ass_state:tfass_state.text ass_phonenumber:tfass_phonenumber.text asss_postcode:tfass_postcode.text ass_email:tfass_email.text ass_supervisor:tfass_supervisor.text ass_pinnumber:tfass_pinnumber.text ass_secque:tfass_secque.text ass_answer:tfass_answer.text];
            
            //--------------------  NSuserDefault Value -------------------------------
            [[NSUserDefaults standardUserDefaults] setValue:tfass_name.text forKey:@"assname"];
            [[NSUserDefaults standardUserDefaults] setValue:tfass_empid.text forKey:@"assempid"];
            [[NSUserDefaults standardUserDefaults] setValue:tfass_city.text forKey:@"asscity"];
            [[NSUserDefaults standardUserDefaults] setValue:tfass_postcode.text forKey:@"asspostcode"];
            [[NSUserDefaults standardUserDefaults] setValue:tfass_email.text forKey:@"assemail"];
            [[NSUserDefaults standardUserDefaults] setValue:tfass_pinnumber.text forKey:@"asspinnumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]);
            
            
            globle_strAssName =  tfass_name.text;
            globle_strAssLocation = tfass_city.text;
            
            //--- Navigate To Assessor View ----
            //ParticipatnsContinue = @"NO";
            
            [self callPushView];
        }
    }
    else if([LoginType isEqualToString:@"LOGIN"])
    {
        BOOL yn = [self validateEmailWithString:tflogin_name.text];
        if([tflogin_name.text isEqualToString:@""] || [tflogin_pinnumber.text isEqualToString:@""] || yn==FALSE)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"All fields are required. Do not left any login field empty & Enter correct input" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else 
        {
            NSMutableArray *aryC = [[NSMutableArray alloc]initWithArray:[DatabaseAccess get_assessor_information:[NSString stringWithFormat:@"Select *from tbl_assessor where ass_email = '%@' and ass_pinnumber = '%@'",tflogin_name.text,tflogin_pinnumber.text]]];
            if([aryC count]>0)
            {
                //--- Navigate To Assessor View ----
                
                //--------------------  NSuserDefault Value -------------------------------
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"ass_name"] forKey:@"assname"];
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"ass_empid"] forKey:@"assempid"];
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"ass_city"] forKey:@"asscity"];
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"asss_postcode"] forKey:@"asspostcode"];
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"ass_email"] forKey:@"assemail"];
                [[NSUserDefaults standardUserDefaults] setValue:[[aryC objectAtIndex:0] valueForKey:@"ass_pinnumber"] forKey:@"asspinnumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"assname"]);
                
                //ParticipatnsContinue = @"NO";
              
                globle_strAssName =  tfass_name.text;
                
                [self callPushView];
                
            }
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Enter corret login information !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }

        }
    }
    else if([LoginType isEqualToString:@"NONE"])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"T&L" message:@"Please enter login or register information !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"ASSESSORLOGIN"];
    
    //ContexualizationViewController *objController = [[ContexualizationViewController alloc]initWithNibName:@"ContexualizationViewController" bundle:nil];
    //[self.navigationController pushViewController:objController animated:YES];
    
    //ThirdPartyStep1ViewController *thidpartycontroller = [[ThirdPartyStep1ViewController alloc]initWithNibName:@"ThirdPartyStep1ViewController" bundle:nil];
    //[self.navigationController pushViewController:thidpartycontroller animated:YES];
}

-(IBAction)callPushView
{    
    //------------------ Calucuation Time Duration ----------
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy hh:mm:ss a"];
    
    StartTime = [NSDate date];
    NSString *dateString = [format stringFromDate:StartTime];
    StartTime = [format dateFromString:dateString];
    
    NSLog(@"%@",StartTime);
    /* -----------------------------------------------------*/
    
    if([strPushViewController isEqualToString:@"ViewController"])
    {
        //ViewController *x = [[ViewController alloc] init];
        //[app.navigationController pushViewController: x animated:YES];
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.strWhichTabBar = @"SecondTabBar";
        NSNotification *notif = [NSNotification notificationWithName:@"popToViewController_SecondTabbar" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
        
    }
    else
    {
        id temp_V = [[NSClassFromString(strPushViewController) alloc] init];
        [self.navigationController pushViewController:temp_V animated:YES];
    }
}



#pragma mark - Email Address Validation
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
