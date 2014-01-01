//
//  EditProfileViewController.m
//  MyMites
//
//  Created by apple on 9/17/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "EditProfileViewController.h"
#import "SBJSON.h"
#import "AppConstat.h"
#import "BusyAgent.h"
#import "ImageViewURL.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation EditProfileViewController

@synthesize statuses;
@synthesize requestMain;

CGFloat animatedDistance;

@synthesize dictEditProfile;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dictEditProfile=DValue;

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
    strLocation=@"";
    // Do any additional setup after loading the view from its nib.
    
    //Date Picker
    
    DatetoolBar=[[UIToolbar alloc] init];
	DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    DatetoolBar.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview:DatetoolBar];
	
	UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressedDate)];
    
	UIBarButtonItem *item21 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressedDate)];
    
	NSArray *buttons1 = [NSArray arrayWithObjects: item11, item21, nil];
    [DatetoolBar setItems: buttons1 animated:NO];
    
	
	DatepickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 580, 320, 216)];
	DatepickerView.backgroundColor=[UIColor grayColor];
    DatepickerView.datePickerMode = UIDatePickerModeDate;
	[self.view addSubview:DatepickerView];
    //-------
    
    scl_Profile.frame = CGRectMake(0, 94, 320, 360);
    scl_Profile.contentSize = CGSizeMake(320, 490);
    
    firstNamefield.text = [NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vFirst"]];
    lastNameField.text = [NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vLast"]];
    NSString *strBCoveringArea = [self removeNull:[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vLocation"]]];
    if ([strBCoveringArea length] != 0)
    {
        strBCoveringArea = [[dictEditProfile valueForKey:@"vLocation"] componentsJoinedByString:@","];
    }
    locationField.text=[NSString stringWithFormat:@"%@",strBCoveringArea];
    emailIdField.text = [NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vEmail"]];
    birthDate.text = [NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"dDOB"]];
    
        
    addressOneField.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vAddress1"]];
    addressTwoField.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vAddress2"]];
    cityField.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vCity"]];
    stateField.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vState"]];
    countryField.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vCountry"]];
    ZIPfield.text=[NSString stringWithFormat:@"%@",[dictEditProfile valueForKey:@"vZip"]];
    
    ImageViewURL *x=[[ImageViewURL alloc] init];
    x.imgV=imgProfile;
	x.strUrl=[NSURL URLWithString:[dictEditProfile valueForKey:@"vImage"]];
}

#pragma mark - Remove NULL

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Self And Selector Methods

-(void)CanclePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    DatepickerView.frame=CGRectMake(0,580, 320, 216);
    [UIView commitAnimations];
}
-(void)DonePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,580, 320, 44);
    DatepickerView.frame=CGRectMake(0,580, 320, 216);
    [UIView commitAnimations];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
    
    
    birthDate.text=[NSString stringWithFormat:@"%@",strDate];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    strDOB = [NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(IBAction)btnDateOfBirthPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,144, 320, 44);
    DatepickerView.frame=CGRectMake(0,188, 320, 216);
    [UIView commitAnimations];
}
-(IBAction)editProfile:(id)sender{
    
    [self performSelectorInBackground:@selector(activityRunning) withObject:self];
    SBJSON *parser = [[SBJSON alloc] init];
    requestMain = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@webservices/update_profile.php?iUserID=%@&vFirst=%@&vLast=%@&vEmail=%@&dDOB=%@&eGender=%@&tAboutMe=%@&vAddress1=%@&vAddress2=%@&vCity=%@&vState=%@&vCountry=%@&vZip=%@&vLocation=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],firstNamefield.text,lastNameField.text,emailIdField.text,strDOB,@"", @"", addressOneField.text,addressTwoField.text,cityField.text,stateField.text,countryField.text,ZIPfield.text,locationField.text]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:requestMain returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    statuses = [parser objectWithString:json_string error:nil];
    
    if ([[statuses valueForKey:@"msg"] isEqualToString:@"Updated Successfully"])
    {
        DisplayAlertWithTitle(APP_Name,@"Done!!!");
    }
    else
    {
       DisplayAlertWithTitle(APP_Name,@"Please !!!");
    }
    
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    

}

-(void)activityRunning{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

-(IBAction)btnAddLocationPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter location here" message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.tag=1;
    tfAdd = [[UITextField alloc] initWithFrame:CGRectMake(12, 43, 260, 27)];
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 0);
    [alert setTransform:myTransform];
    tfAdd.delegate=self;
    tfAdd.keyboardType=UIKeyboardTypeDefault;
    tfAdd.borderStyle=UITextBorderStyleBezel;
    tfAdd.font=[UIFont systemFontOfSize:14.0f];
    [tfAdd becomeFirstResponder];
    [tfAdd setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:tfAdd];
    [alert show];
}

-(IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
        }
        else
        {
            strLocation=[strLocation stringByAppendingString:tfAdd.text];
            strLocation=[strLocation stringByAppendingString:@","];
            int l = [strLocation length];
            NSString *strImg = [NSString stringWithFormat:@"%@",[[strLocation substringFromIndex:l-1] substringToIndex:1]];
            NSString *strFinal;
            if ([strImg isEqualToString:@","])
            {
                strFinal = [strLocation substringToIndex:[strLocation length] - 1];
            }
            locationField.text=[NSString stringWithFormat:@"%@",strFinal];
            tfAdd.text=@"";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
