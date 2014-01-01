//
//  ProffessionPage2.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProffessionPage2.h"
#import "JSON.h"
#import "AppConstat.h"
#import "BusyAgent.h"

#pragma mark - KeyBoard Methods
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation ProffessionPage2
CGFloat animatedDistance;

@synthesize tfBussName;
@synthesize tfBussCategory;
@synthesize occupationField;
@synthesize txtDesc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		d = dVal;
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
    
    tfEmail.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vWorkEmail"]];
    tfExp.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vExperience"]];
    tfWebSite.text = [NSString stringWithFormat:@"%@",[d valueForKey:@"vWebsite"]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Dealloc

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)SaveClicked:(id)sender
{
    [self performSelectorInBackground:@selector(activityRunning) withObject:self];
    NSString *strdataCP=[NSString stringWithFormat:@"iUserID=%@&vBusiness=%@&vBusinessCategory=%@&bDescription=%@&vExperience=%@&vWorkEmail=%@&vWebsite=%@&iOccupationID=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],tfBussName,tfBussCategory,txtDesc,tfExp.text,tfEmail.text,tfWebSite.text,occupationField];
    NSString *urlStringCPData = [NSString stringWithFormat:@"%@webservices/update_profession.php",APP_URL];
    NSString *postLength = [NSString stringWithFormat:@"%d", [strdataCP length]];
    NSMutableURLRequest *requestCPData = [[NSMutableURLRequest alloc] init];
    
    [requestCPData setURL:[NSURL URLWithString:urlStringCPData]];
    [requestCPData setHTTPMethod:@"POST"];
    [requestCPData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestCPData setHTTPBody:[strdataCP dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *responseDataCP = [NSURLConnection sendSynchronousRequest:requestCPData returningResponse:nil error:nil];  
    NSString *responseStringCP = [[NSString alloc] initWithData:responseDataCP encoding: NSUTF8StringEncoding];
    NSDictionary *resultsupload =[responseStringCP JSONValue];
    if ([[resultsupload valueForKey:@"msg"] isEqualToString:@"Updated Successfully"]) {
        
        DisplayAlertWithTitle(APP_Name,@"Done!!!");
        
    }else
    {
        DisplayAlertWithTitle(APP_Name,@"Please !!!");
    }
    
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}
-(void)activityRunning
{    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
