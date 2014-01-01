//
//  Proffession.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Proffession.h"
#import "AppConstat.h"
#import "BusyAgent.h"
#import "JSON.h"
#import "GlobalClass.h"

#pragma mark - KeyBoard Methods
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation Proffession

//@synthesize tableData;
//@synthesize occuPationTableView;

CGFloat animatedDistance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        results =[[NSDictionary alloc]init];
        results = DValue;
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
    
    CALayer *l=[txtDesc layer];
    l.borderWidth=2;
    l.borderColor=[[UIColor clearColor] CGColor];
    l.backgroundColor=[[UIColor whiteColor] CGColor];
    l.cornerRadius=5;
    [l setMasksToBounds:YES];
    
    // Toolbar for Texview Return start
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    toolBar.barStyle=UIBarStyleBlackTranslucent;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
	[self.view addSubview:toolBar];  
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressedResign)];
	NSArray *buttons = [NSArray arrayWithObjects:  item2, nil];
    [toolBar setItems: buttons animated:NO];
    [UIView commitAnimations];
    // Toolbar for Texview Return end

    // Toolbar for ALPickerView Return start
    toolBar1=[[UIToolbar alloc] init];
    toolBar1.frame=CGRectMake(0,480, 320, 44);
    toolBar1.barStyle=UIBarStyleBlackTranslucent;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [self.view addSubview:toolBar1];  
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    
    UIBarButtonItem *item22 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
    NSArray *buttons1 = [NSArray arrayWithObjects: item11, item22, nil];
    [toolBar1 setItems: buttons1 animated:NO];
    [UIView commitAnimations];
    // Toolbar for ALPickerView Return end
    
    ArryOccuID = [[NSMutableArray alloc]init];
    ArryOccuName = [[NSMutableArray alloc]init];

    occupationField.text=[NSString stringWithFormat:@"%@",[results valueForKey:@"vOccupation"]];
    strOccupationID = [NSString stringWithFormat:@"%@",[results valueForKey:@"iOccupationID"]];
    tfBussName.text = [NSString stringWithFormat:@"%@",[results valueForKey:@"vBusiness"]];
    tfBussCategory.text = [NSString stringWithFormat:@"%@",[results valueForKey:@"vBusinessCategory"]];
    txtDesc.text = [NSString stringWithFormat:@"%@",[results valueForKey:@"bDescription"]];
    
    // Init picker and add it to view
    [UIView commitAnimations];
    pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 480, 320,216)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    responseData = [[NSMutableData alloc] init];
    ArryOccupation = [[NSMutableArray alloc]init];
    resultsOcc=[[NSDictionary alloc]init];
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
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    resultsOcc = [responseString JSONValue];

    for (int i = 0; i<[[resultsOcc valueForKey:@"occupation"] count]; i++)
    {
        [ArryOccupation addObject:[[resultsOcc valueForKey:@"occupation"]objectAtIndex:i]];
    }
    
    selectionStates = [[NSMutableDictionary alloc] init];
    for (NSString *key in ArryOccupation)
    {
        [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - ToolBarMethods
-(void)CanclePressed
{
    [self CallPickerHide];
}
-(void)DonePressed
{
    [self CallPickerHide];
    if ([ArryOccuID count] == 0)
    {
        occupationField.text = [NSString stringWithFormat:@"%@",[results valueForKey:@"vOccupation"]];
        strOccupationID = [NSString stringWithFormat:@"%@",[results valueForKey:@"iOccupationID"]];
    }
    else if ([ArryOccuID count] == 1)
    {
        occupationField.text = [NSString stringWithFormat:@"%@",[ArryOccuName objectAtIndex:0]];
        strOccupationID = [NSString stringWithFormat:@"%@",[ArryOccuID objectAtIndex:0]];
    }
    else
    {
        NSString *strFinal = [ArryOccuName componentsJoinedByString:@","];
        occupationField.text = [NSString stringWithFormat:@"%@",strFinal];
        NSString *strFinalID = [ArryOccuID componentsJoinedByString:@","];
        strOccupationID = [NSString stringWithFormat:@"%@",strFinalID];
    }
}
-(void)CallPickerHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar1.frame=CGRectMake(0,480, 320, 44);   
    pickerView.frame=CGRectMake(0,480, 320, 216);   
    [UIView commitAnimations];
}
-(IBAction)btnOccupationPressed:(id)sender
{
    [self CallPickerShow];
}
-(void)CallPickerShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar1.frame=CGRectMake(0,152, 320, 44);   
    pickerView.frame=CGRectMake(0,196, 320, 216);   
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}

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

#pragma mark - Dealloc

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)NextClicked:(id)sender
{
    ProffessionPage2 *objProffessionPage2 = [[ProffessionPage2 alloc]initWithNibName:@"ProffessionPage2" bundle:nil andD:results];
    objProffessionPage2.tfBussName=tfBussName.text;
    objProffessionPage2.tfBussCategory=tfBussCategory.text;
    objProffessionPage2.occupationField=strOccupationID;
    objProffessionPage2.txtDesc=txtDesc.text;
    [self.navigationController pushViewController:objProffessionPage2 animated:YES];
    objProffessionPage2 = nil;

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
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    toolBar.frame=CGRectMake(0,380, 320, 44);   
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}



-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    toolBar.frame=CGRectMake(0,480, 320, 44);
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}
-(void)DonePressedResign
{
    [txtDesc resignFirstResponder];
}

#pragma mark - Extra Methods
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
