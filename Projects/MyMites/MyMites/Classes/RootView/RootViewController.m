//
//  RootViewController.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AppConstat.h"
#import "GlobalClass.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 180;

@implementation RootViewController
CGFloat animatedDistance;
@synthesize gettableDataStr;
@synthesize gettableDatastrArr;
@synthesize tableData;

#pragma mark - View Did Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"TermsAndConditions"]isEqualToString:@"Read"])
    {
        
        
        AgreementView *objAgreementView= [[AgreementView alloc]initWithNibName:@"AgreementView" bundle:nil];
        [self presentModalViewController:objAgreementView animated:YES];
        
    }
    else 
    {
        //[self ShowTabBar];
    }
    
    appDel = (FsenetAppDelegate *)[[UIApplication sharedApplication]delegate];
        
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
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    ArryOccupation = [[NSMutableArray alloc]init];
    ArryLocation = [[NSMutableArray alloc]init];

    responseData = [[NSMutableData alloc] init];
    results=[[NSDictionary alloc]init];
    NSString *strLogin=[NSString stringWithFormat:@"%@webservices/occupationlist.php",APP_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strLogin]];
    ConnectionRequest=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"TermsAndConditions"]isEqualToString:@"Read"])
    {
        
        if (tableData!=nil) {
            tableData=nil;
            [tableData removeAllObjects];
        }
        tableData=[[NSMutableArray alloc] init];
        
        
        if (occupationDict!=nil) {
            
            occupationDict=nil;
            [occupationDict removeAllObjects];
        }
        occupationDict=[[NSMutableArray alloc] init];

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
    results = [responseString JSONValue];
    
    for (int i = 0; i<[[results valueForKey:@"occupation"] count]; i++)
    {
        [ArryOccupation addObject:[[results valueForKey:@"occupation"]objectAtIndex:i]];
    }
    
    occupationDict=[ArryOccupation copy];
    
    NSString *strurl3=[NSString stringWithFormat:@"%@webservices/locationlist.php",APP_URL];
    NSURL *myurl3= [NSURL URLWithString:strurl3];
    NSString *strres3 = [[NSString alloc] initWithContentsOfURL:myurl3 encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dicLoc = [[NSDictionary alloc]init];
    dicLoc = [strres3 JSONValue];
    for (int i = 0; i< [[dicLoc valueForKey:@"location"] count]; i++) 
    {
        [ArryLocation addObject:[[dicLoc valueForKey:@"location"]objectAtIndex:i]];
    }
    
    NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"vOccupation" ascending:YES];
    NSMutableArray *temp = [ArryOccupation mutableCopy];
    [temp sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
    ArryOccupation = temp;

    
    NSSortDescriptor *locationSorter = [[NSSortDescriptor alloc] initWithKey:@"vlocation" ascending:YES];
    NSMutableArray *tempLocation = [ArryLocation mutableCopy];
    [tempLocation sortUsingDescriptors:[NSArray arrayWithObject:locationSorter]];
    ArryLocation = tempLocation;
    
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}

-(void)CanclePressed
{
    [self CallPickerHide];
}
-(void)DonePressed
{
    [self CallPickerHide];
    if (settag == 1)
    {
        tfSFor.text = [NSString stringWithFormat:@"%@",[[ArryOccupation objectAtIndex:catID] valueForKey:@"vOccupation"]];
        strOccuId = [NSString stringWithFormat:@"%@",[[ArryOccupation objectAtIndex:catID] valueForKey:@"iOccupationID"]];
    }
    else if (settag == 2)
    {
        tfSLocation.text = [NSString stringWithFormat:@"%@",[ArryLocation  objectAtIndex:catID]];
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if (settag == 1)
    {
        return [ArryOccupation count];
    }
    else if (settag == 2)
    {
        return [ArryLocation count];
    }
    else 
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (settag == 1)
    {
        return [[ArryOccupation objectAtIndex:row] valueForKey:@"vOccupation"];
    }
    else if (settag == 2)
    {
        return [ArryLocation  objectAtIndex:row] ;
    }
    else 
    {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
    catID=row;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Search Clicked
-(IBAction)SearchClicked:(id)sender
{
    [objectTextField resignFirstResponder];
    [tfSFor resignFirstResponder];
    [tfSLocation resignFirstResponder];
    if ([tfSFor.text isEqualToString:@""] || [tfSLocation.text isEqualToString:@""])
    {
        DisplayAlertWithTitle(APP_Name, @"For Search Data none of the above field should empty!!!");
    } 
    else
    {
        SearchResult *objSearchResult = [[SearchResult alloc]initWithNibName:@"SearchResult" bundle:nil];
        objSearchResult.strTitle = @"Related Search";
        objSearchResult.strLoc = [NSString stringWithFormat:@"%@",tfSLocation.text];
        objSearchResult.strOccu = [NSString stringWithFormat:@"%@",tfSFor.text];
        [self.navigationController pushViewController:objSearchResult animated:YES];
        tfSLocation.text = @"";
        tfSFor.text = @"";
    }
}
-(IBAction)btnOccupationPressed:(id)sender
{
    settag = [sender tag];
     [self CallPickerShow];
}
-(IBAction)btnLocationPressed:(id)sender
{
    settag = [sender tag];
    [self CallPickerShow];
}
-(void)CallPickerShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,160, 320, 44);   
    pickerView.frame=CGRectMake(0,204, 320, 216);   
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    objectTextField=textField;
    occuPationTableView.hidden=YES;
    [objectTextField resignFirstResponder];
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
    
     if (textField==tfSFor) {
         occuPationTableView.tag=0;
         occuPationTableView.frame=CGRectMake(34,289,258,100);
     }
    else
    {
        occuPationTableView.tag=1;
        occuPationTableView.frame=CGRectMake(34,334,258,90);

    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==tfSFor) {
        
    

    if ([tableData count]>0) {
        [tableData removeAllObjects];
    }
    NSInteger counter = 0;    
    
    for(NSDictionary *s in ArryOccupation) {
        
        if ([string isEqualToString:@""]) {
            
            NSString *strCC = [tfSFor.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
            
            if (strCC.length==0) {
                
                [tableData addObject:s];  
                
            }else
            {
                NSString *strS = [s valueForKey:@"vOccupation"];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {  
                    [tableData addObject:s];
                }        
                counter++;        
                
            }
      }else if ([string isEqualToString:@"\n"])
        {
            
        }else{
            NSString *strCC = [textField.text stringByAppendingString:string];
            NSString *strS = [s valueForKey:@"vOccupation"];
            NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
            if(r.location != NSNotFound && r.location==0) {            
                [tableData addObject:s];  
            }        
            counter++;        
            
        }        
    }

        

       
    occuPationTableView.hidden=NO;
    [occuPationTableView reloadData];
        
        
    } else 
        
      if(textField==tfSLocation){
        
        if ([tableData count]>0) {
            
            [tableData removeAllObjects];
        }
        NSInteger counter = 0;    
        
          
        for(NSDictionary *s in ArryLocation) {
            
            if ([string isEqualToString:@""]) {
                
                NSString *strCC = [tfSLocation.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
                
                if (strCC.length==0) {
                    
                    [tableData addObject:s];  
                    
                }else
                {
                    NSString *strS = [s valueForKey:@"vlocation"];
                    NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                    if(r.location != NSNotFound && r.location==0) {            
                        [tableData addObject:s];
                    }        
                    counter++;        
                    
                }
            }else if ([string isEqualToString:@"\n"])
            {
                
            }else{
                NSString *strCC = [textField.text stringByAppendingString:string];
                NSString *strS = [s valueForKey:@"vlocation"];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {            
                    [tableData addObject:s];  
                }        
                counter++;        
                
            }        
        }
        
        

              
           occuPationTableView.hidden=NO;
           [occuPationTableView reloadData];

        
        
        
    }
      
    
    
    return YES;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==tfSFor) {
    occuPationTableView.hidden=YES;

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    }else 
        if (textField==tfSLocation) {

            occuPationTableView.hidden=YES;
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y += animatedDistance;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
            [self.view setFrame:viewFrame];
            [UIView commitAnimations];
            
            
        }
}



#pragma mark TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier =@"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell)
    {
        cell = nil;
    }
    
    if(cell ==nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView.tag==0) {
        
    cell.textLabel.text=[[tableData valueForKey:@"vOccupation"] objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView.tag==1){
        
        cell.textLabel.text=[[tableData valueForKey:@"vlocation"] objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView.tag==0) {
        
    tfSFor.text=[[tableData valueForKey:@"vOccupation"] objectAtIndex:indexPath.row];
        
    }else 
        if (tableView.tag==1) {
            
            tfSLocation.text=[[tableData valueForKey:@"vlocation"] objectAtIndex:indexPath.row];
            
        }
    occuPationTableView.hidden=YES;

    
}


#pragma mark - Dealloc

#pragma mark - Extra Methods
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}


@end
