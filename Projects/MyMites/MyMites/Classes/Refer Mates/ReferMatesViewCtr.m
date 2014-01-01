//
//  ReferMatesViewCtr.m
//  MyMites
//
//  Created by apple on 11/24/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import "ReferMatesViewCtr.h"
#import "AppConstat.h"
#import "JSON.h"
#import "BusyAgent.h"

@implementation ReferMatesViewCtr
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
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
}
-(IBAction)btnInvitePressed:(id)sender
{
    [tfName resignFirstResponder];
    [tfEmail resignFirstResponder];
    
    NSString *strName = [tfName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strEmail = [tfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([strName length] == 0 || [strEmail length] == 0)
    {
        DisplayAlertWithTitle(APP_Name, @"Both fields are required");
    }
    else
    {
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        responseData = [[NSMutableData alloc] init];
        NSString *strpass = [NSString stringWithFormat:@"%@webservices/invite_friend.php?user_id=%@&mate_name=%@&mate_email=%@",APP_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],tfName.text,tfEmail.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strpass]];
        ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
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
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *DicRes = [responseString JSONValue];
    NSString *strMsg = [DicRes valueForKey:@"msg"];
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO]; 
    
    if ([strMsg isEqualToString:@"unable to send request"])
    {
        DisplayAlertWithTitle(APP_Name, @"It seems  that you have already sent a mate request to this id ! or the email address is wrongly entered , please check.");
    }
    else if ([strMsg isEqualToString:@"request sent"])
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:APP_Name message:@"Refer a mate request sent. Would you like to refer more mates?" delegate:self cancelButtonTitle:@"Back to Menu" otherButtonTitles:@"Yes",nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        DisplayAlertWithTitle(APP_Name, strMsg);
    }
}

#pragma mark - AlertView Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];  
        }
        else
        {
            tfName.text = @"";
            tfEmail.text = @"";
        }
    }
}

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    // occuPationTableView.hidden=YES;
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
