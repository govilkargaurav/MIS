//
//  ContactUsViewCtr.m
//  MyMites
//
//  Created by Mac-i7 on 1/31/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import "ContactUsViewCtr.h"
#import "AppConstat.h"
#import "BusyAgent.h"
#import "JSON.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

@interface ContactUsViewCtr ()

@end

@implementation ContactUsViewCtr

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
    
    CALayer *l=[txtMsg layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor clearColor] CGColor];
    l.backgroundColor=[[UIColor whiteColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
    
    ArraySubject = [[NSMutableArray alloc] initWithObjects:@"Media Enquiries",@"Technical Question",@"General Question",@"Contact for New Account",@"Request Credentials", nil];
    
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
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.frame=CGRectMake(0, 480, 320, 216);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    pickerView.backgroundColor=[UIColor grayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnContactUsPressed:(id)sender
{
    [self keyboardDissmiss];
    NSString *strMsg = [txtMsg.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tfName.text length] == 0 || [tfSubject.text length] == 0 || [tfEmail.text length] == 0 || [strMsg length] == 0 )
    {
        DisplayAlertWithTitle(APP_Name, @"Name,Subject,Email and Message fields are required");
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
            [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
            responseData = [[NSMutableData alloc] init];
            results = [[NSMutableDictionary alloc] init];
            NSString *strContactUS= [[NSString stringWithFormat:@"%@webservices/contectemail.php?name=%@&subject=%@&email=%@&phone_number=%@&message=%@",APP_URL,tfName.text,tfSubject.text,tfEmail.text,tfPhoneno.text,strMsg] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strContactUS]];
            ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        }
    }
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
    
    if ([[results valueForKey:@"msg"] isEqualToString:@"sent"])
    {
        DisplayAlertWithTitle(APP_Name, @"Message sent successfully");
        tfName.text = @"";
        tfSubject.text = @"";
        tfEmail.text = @"";
        tfPhoneno.text = @"";
        txtMsg.text = @"";
	}
	else
	{
        DisplayAlertWithTitle(APP_Name,[results valueForKey:@"msg"]);
    }
}
-(IBAction)btnSubjectPressed:(id)sender
{
    [self keyboardDissmiss];
    [self CallPickerShow];
}
-(IBAction)btnResignPressed:(id)sender
{
    [self keyboardDissmiss];
}

-(void)CanclePressed
{
    [self CallPickerHide];
}
-(void)DonePressed
{
    [self CallPickerHide];
    tfSubject.text = [NSString stringWithFormat:@"%@",[ArraySubject objectAtIndex:catID]];    
}
-(void)CallPickerHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    pickerView.frame=CGRectMake(0,480, 320, 216);
    [UIView commitAnimations];
}
-(void)CallPickerShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,140, 320, 44);
    pickerView.frame=CGRectMake(0,184, 320, 216);
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}
-(void)keyboardDissmiss
{
    [tfName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfPhoneno resignFirstResponder];
    [txtMsg resignFirstResponder];
}
#pragma mark ALPickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ArraySubject count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ArraySubject objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    catID=row;
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
#pragma mark - TextView Delegate Methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    CGRect textVWRect = [self.view.window convertRect:textView.bounds fromView:textView];
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
    viewFrame.origin.y -= animatedDistance ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
   // toolBar.frame=CGRectMake(0,402, 320, 44);
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    //toolBar.frame=CGRectMake(0,480, 320, 44);
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
-(IBAction)DonePressedResign:(id)sender
{
    [txtMsg resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
