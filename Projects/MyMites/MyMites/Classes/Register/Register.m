//
//  Register.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Register.h"
#import "AppConstat.h"
#import "BusyAgent.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;


@implementation Register
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
    strLocation=@"";
    
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
    
    
    
    Scl_Regi.contentSize=CGSizeMake(320, 520);
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [self.view addSubview:toolBar];  
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
    
    NSArray *buttons = [NSArray arrayWithObjects: item1, item2, nil];
    [toolBar setItems: buttons animated:NO];
    
    [UIView commitAnimations];
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    ArryOccupation = [[NSMutableArray alloc]init];
    ArryOccuID = [[NSMutableArray alloc]init];
    ArryOccuName = [[NSMutableArray alloc]init];
    responseData = [[NSMutableData alloc] init];
    results=[[NSDictionary alloc]init];
    NSString *strLogin=[NSString stringWithFormat:@"%@webservices/occupationlist.php",APP_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    DisplayNoInternate;
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    results = [responseString JSONValue];
    
    for (int i = 0; i<[[results valueForKey:@"occupation"] count]; i++)
    {
        [ArryOccupation addObject:[[results valueForKey:@"occupation"]objectAtIndex:i]];
    }
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"vOccupation" ascending:YES];
    NSMutableArray *temp = [ArryOccupation mutableCopy];
    [temp sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
    ArryOccupation = temp;
    
    selectionStates = [[NSMutableDictionary alloc] init];
    for (NSString *key in ArryOccupation)
        [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    
    // Init picker and add it to view
    [UIView commitAnimations];
    pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 480, 320,216)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}
-(void)CanclePressed
{
    [self CallPickerHide];
}
-(void)DonePressed
{
    [self CallPickerHide];
    if ([ArryOccuID count] == 0)
    {
        tfOccupation.text=@"";
        tfOccupation.placeholder=@"Select Occupation";
    }
    else if ([ArryOccuID count] == 1)
    {
        tfOccupation.text=[NSString stringWithFormat:@"%@",[ArryOccuName objectAtIndex:0]];
    }
    else
    {
        tfOccupation.text=@"Multiple selected,Click to see";
    }
}
-(void)CallPickerHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,480, 320, 44);   
    pickerView.frame=CGRectMake(0,480, 320, 216);   
    [UIView commitAnimations];
}
#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView 
{
    return [ArryOccupation count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row 
{
    return [[ArryOccupation objectAtIndex:row] valueForKey:@"vOccupation"];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row 
{
    return [[selectionStates objectForKey:[ArryOccupation objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    // Check whether all rows are checked or only one
    if (row == -1)
    {
        for (id key in [selectionStates allKeys])
            [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
        ArryOccuName = [[NSMutableArray alloc] initWithArray:[ArryOccupation valueForKey:@"vOccupation"]];
        ArryOccuID = [[NSMutableArray alloc] initWithArray:[ArryOccupation valueForKey:@"iOccupationID"]];
    }
    else
    {
        [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[ArryOccupation objectAtIndex:row]];
        [ArryOccuID addObject:[[ArryOccupation objectAtIndex:row]valueForKey:@"iOccupationID"]];
        [ArryOccuName addObject:[[ArryOccupation objectAtIndex:row]valueForKey:@"vOccupation"]];
    }
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    // Check whether all rows are unchecked or only one
        if (row == -1)
        {
            if ([ArryOccuID count]>0 && ArryOccuID!=nil) 
            {
                ArryOccuID=nil;
                ArryOccuName=nil;
                [ArryOccuID removeAllObjects];
                [ArryOccuName removeAllObjects];
                ArryOccuID = [[NSMutableArray alloc]init];
                ArryOccuName = [[NSMutableArray alloc]init];
            }
            for (id key in [selectionStates allKeys])
                [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
        }
        else
        {
            [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[ArryOccupation objectAtIndex:row]];
            [ArryOccuID removeObject:[[ArryOccupation objectAtIndex:row]valueForKey:@"iOccupationID"]];
            [ArryOccuName removeObject:[[ArryOccupation objectAtIndex:row]valueForKey:@"vOccupation"]];
        }
}
-(IBAction)btnOccupationPressed:(id)sender
{
    [self CallPickerShow];
}
-(void)CallPickerShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,204, 320, 44);   
    pickerView.frame=CGRectMake(0,248, 320, 216);   
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}
-(IBAction)btnDateOfBirthPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,204, 320, 44);
    DatepickerView.frame=CGRectMake(0,248, 320, 216);
    [UIView commitAnimations];
}
-(void)CanclePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,480, 320, 44);
    DatepickerView.frame=CGRectMake(0,480, 320, 216);
    [UIView commitAnimations];
}
-(void)DonePressedDate
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    DatetoolBar.frame=CGRectMake(0,480, 320, 44);
    DatepickerView.frame=CGRectMake(0,480, 320, 216);
    [UIView commitAnimations];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
    
    
    tfDob.text=[NSString stringWithFormat:@"%@",strDate];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    strDOB = [NSString stringWithFormat:@"%@",
              [df stringFromDate:DatepickerView.date]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



#pragma mark - IBAction Method
-(IBAction)CancelCliked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)RegisterCliked:(id)sender
{
    if ([tfEmail.text length] == 0 || [tfPassWord.text length] == 0 || [tfCPassWord.text length] == 0 || [tfFName.text length] == 0 || [tfLName.text length] == 0 || [tfCity.text length] == 0 || [tfState.text length] == 0 || [tfCountry.text length] == 0 || [tfLocation.text length] == 0 || [ArryOccuID count] == 0 || [tfDob.text length] == 0)
    {
        DisplayAlertWithTitle(APP_Name, @"All fields are required. Do not left any field empty.");
    }
    else if (![tfPassWord.text isEqualToString:tfCPassWord.text])
    {
        DisplayAlertWithTitle(APP_Name, @"Password not match.");
    }
    else
    {
        NSString *email = tfEmail.text;
        NSString *emailRegEx =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *regExPredicate =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
        
        
        if(!myStringMatchesRegEx)
        {
            DisplayAlertWithTitle(APP_Name, @"The email address you have provided is invalid, please provide a valid email address.");
        }
        else
        {
            FsenetAppDelegate *appdel = (FsenetAppDelegate *)[[UIApplication sharedApplication]delegate];
            if( ![appdel checkConnection] ) 
            {
                [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
                DisplayNoInternate;
            }
            else
            {
                [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
                [self performSelectorInBackground:@selector(callRegister) withObject:nil];
            }  
        }

    }

}
-(void)callRegister
{
    @autoreleasepool 
    {
        NSString *strFinal = [ArryOccuID componentsJoinedByString:@","];
        NSString *strurl=[NSString stringWithFormat:@"%@webservices/register.php?vFirst=%@&vLast=%@&vEmail=%@&vPassword=%@&iOccupationID=%@&vCity=%@&vState=%@&vCountry=%@&vLocation=%@&dDOB=%@",APP_URL,tfFName.text,tfLName.text,tfEmail.text,tfPassWord.text,strFinal,tfCity.text,tfState.text,tfCountry.text,tfLocation.text,strDOB];
        NSURL *myurl= [NSURL URLWithString:strurl];
        NSString *strres = [[NSString alloc] initWithContentsOfURL:myurl encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = [strres JSONValue];
        NSString *strMsg = [NSString stringWithFormat:@"%@",[dic valueForKey:@"msg"]];
        if ([[dic valueForKey:@"msg"] isEqualToString:@"Registered successfully"])
        {
            NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
            [Info setValue:@"LoginValue" forKey:@"Login"];
            [Info setValue:[dic valueForKey:@"iUserID"] forKey:@"iUserID"];
            [Info setValue:[dic valueForKey:@"vEmail"] forKey:@"vEmail"];
            [Info setValue:@"Normal" forKey:@"Type"];
            [Info synchronize];
            [self performSelectorOnMainThread:@selector(Navigate1) withObject:nil waitUntilDone:YES];
        }
        else
        {
            DisplayAlertWithTitle(APP_Name, strMsg);
            [self performSelectorOnMainThread:@selector(Navigate2) withObject:nil waitUntilDone:YES];
        }
        
    }
}
-(void)Navigate1
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)Navigate2
{
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}
-(IBAction)btnAddPressed:(id)sender
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
            tfLocation.text=[NSString stringWithFormat:@"%@",strFinal];
            tfAdd.text=@"";

        }   
    }
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
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
#pragma mark - Extra Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
