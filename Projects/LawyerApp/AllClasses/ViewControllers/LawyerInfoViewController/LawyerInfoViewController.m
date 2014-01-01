//
//  LawyerInfoViewController.m
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "LawyerInfoViewController.h"
#import "JSONParsingAsync.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "UIButton+WebCache.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface LawyerInfoViewController ()

@end

@implementation LawyerInfoViewController
CGFloat animatedDistance;
@synthesize arrLawyerInfo;
@synthesize _scrollView= scrollView;
@synthesize _tableView;
@synthesize arrCountryList;
@synthesize arrLawIdList;
@synthesize strIDCountry;
@synthesize strIDLaw;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        arrCountryList = [[NSMutableArray alloc] init];
        arrLawIdList = [[NSMutableArray alloc] init];
        arrFillTable=[[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(34, 0, 817, 24) style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.backgroundColor=[UIColor grayColor];
        _tableView.clipsToBounds = YES;
        _tableView.layer.cornerRadius = 10;//half of the width
        _tableView.layer.borderColor=[UIColor colorWithRed:91.0/255.0 green:177.0/255.0 blue:39.0/255.0 alpha:0.8].CGColor;
        _tableView.layer.borderWidth=2.0f;
        [_tableView setHidden:YES];
        [scrollView bringSubviewToFront:_tableView];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndexDict = [[NSMutableDictionary alloc] init];
    [self FillContryAndLawCategory];
    [self fillTextField:nil];
    NSLog(@"%@",arrLawyerInfo);
}

-(void)viewDidAppear:(BOOL)animated{
    
    scrollView.contentSize=CGSizeMake(320, 1750);
    if (IS_IPHONE_5) {
        
        [scrollView setContentOffset:CGPointMake(0,-60) animated:YES];
        scrollView.contentInset=UIEdgeInsetsMake(60, 0,0, 0);
        
    }else{
        [scrollView setContentOffset:CGPointMake(0,-150) animated:YES];
        scrollView.contentInset=UIEdgeInsetsMake(150, 0,0, 0);
    }
    /* Date Picker */
    
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
    DatepickerView.datePickerMode = UIDatePickerModeTime;
	[self.view addSubview:DatepickerView];
    
    /***********************************************/
    [scrollView addSubview:_tableView];
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
    [df setDateFormat:@"hh:mm:ss a"];
    NSString *strDate=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:DatepickerView.date]];
    if (globalTxtField==txtFldOfficeStartTime) {
        
        txtFldOfficeStartTime.text=[NSString stringWithFormat:@"%@",strDate];
    }else if (globalTxtField==txtFldOfficeEndTime){
        
        txtFldOfficeEndTime.text=[NSString stringWithFormat:@"%@",strDate];
    }
    
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_tableView setHidden:YES];
    
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    globalTxtField= textField;
    // Below code is used for scroll up View with navigation baar
    
    // Below code is used for scroll up View with navigation baar
    CGRect textVWRect = [self._scrollView convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self._scrollView convertRect:self.view.bounds fromView:self.view];
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
    if (textField==txtFldContryId) {
        _tableView.tag=0;
        _tableView.frame=CGRectMake(28,txtFldContryId.frame.origin.y+25,272,100);
    }
    else if(textField==txtFldLawId)
    {
        _tableView.tag=1;
        _tableView.frame=CGRectMake(28,txtFldLawId.frame.origin.y+25,272,100);
        [_tableView reloadData];
        [_tableView setHidden:NO];
        
    }
    
    
    if (textField==txtFldOfficeEndTime || textField==txtFldOfficeStartTime) {
        [textField resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.80];
        DatetoolBar.frame=CGRectMake(0,296, 320, 44);
        DatepickerView.frame=CGRectMake(0,340, 320, 216);
        [UIView commitAnimations];
    }
    
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==txtFldContryId) {
        
        if ([arrFillTable count]>0) {
            [arrFillTable removeAllObjects];
        }
        NSInteger counter = 0;
        
        for(NSDictionary *s in arrCountryList) {
            
            if ([string isEqualToString:@""]) {
                
                NSString *strCC = [txtFldContryId.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
                
                if (strCC.length==0) {
                    [arrFillTable addObject:s];
                }else
                {
                    NSString *strS = [s valueForKey:@"vCountryName"];
                    NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                    if(r.location != NSNotFound && r.location==0) {
                        [arrFillTable addObject:s];
                    }
                    counter++;
                    
                }
            }else if ([string isEqualToString:@"\n"])
            {
                
            }else{
                NSString *strCC = [textField.text stringByAppendingString:string];
                NSString *strS = [s valueForKey:@"vCountryName"];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {
                    [arrFillTable addObject:s];
                }
                counter++;
                
            }
        }
        
        [_tableView setHidden:NO];
        
    }else if (textField==txtFldLawId){
        
        if (textField.text.length == 0 && range.length == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Just choose category from table." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
            textField.text=@"";
            return NO;
        }
        
        
        [_tableView setHidden:NO];
    }
    
    
    [scrollView bringSubviewToFront:_tableView];
    [_tableView reloadData];
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FillContryAndLawCategory{
    
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"COUNTRY_LIST"]==nil) {
        id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=country&func=countrylist",WEBSERVICE_HEADER]];
        
        NSDictionary *jsonDictionary;
        NSArray *jsonArray;
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            jsonArray = (NSArray *)jsonObject;
        }else if([jsonObject isKindOfClass:[NSDictionary class]]){
            jsonDictionary = (NSDictionary *)jsonObject;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[jsonDictionary objectForKey:@"list"] forKey:@"COUNTRY_LIST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"LAW_ID_LIST"]==nil) {
        
        id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:[NSString stringWithFormat:@"%sc=law_category&func=lawcategorylist",WEBSERVICE_HEADER]];
        
        NSDictionary *jsonDictionary;
        NSArray *jsonArray;
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            jsonArray = (NSArray *)jsonObject;
        }else if([jsonObject isKindOfClass:[NSDictionary class]]){
            jsonDictionary = (NSDictionary *)jsonObject;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[jsonDictionary objectForKey:@"list"] forKey:@"LAW_ID_LIST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    arrCountryList = [[NSUserDefaults standardUserDefaults]valueForKey:@"COUNTRY_LIST"];
    arrLawIdList = [[NSUserDefaults standardUserDefaults]valueForKey:@"LAW_ID_LIST"];
    
    
}
#pragma mark Camara Upload

-(IBAction)addUserImageButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)[scrollView viewWithTag:[sender tag]];
    BUTTONTAGIMGUSERCOMPANY = btn.tag;
    UICustomActionSheet *sheet = [[UICustomActionSheet alloc] initWithTitle:@"Take picture" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library",@"Cancel", nil];
    
    [sheet setColor:RGBCOLOR(0, 0, 0) forButtonAtIndex:0];
    [sheet setColor:RGBCOLOR(0, 0, 0) forButtonAtIndex:1];
    [sheet setColor:RGBCOLOR(255, 0, 0) forButtonAtIndex:2];
    
    [sheet setPressedColor:[UIColor blueColor] forButtonAtIndex:0];
    [sheet setPressedColor:[UIColor blueColor] forButtonAtIndex:1];
    [sheet setPressedColor:[UIColor blueColor] forButtonAtIndex:2];
    
    [sheet setPressedTextColor:RGBCOLOR(250, 200, 200) forButtonAtIndex:0];
    [sheet setPressedTextColor:RGBCOLOR(200, 250, 200) forButtonAtIndex:1];
    [sheet setPressedTextColor:RGBCOLOR(200, 250, 200) forButtonAtIndex:2];
    
    [sheet setFont:[UIFont systemFontOfSize:20] forButtonAtIndex:0];
    [sheet setFont:[UIFont systemFontOfSize:20] forButtonAtIndex:1];
    [sheet setFont:[UIFont systemFontOfSize:20] forButtonAtIndex:2];
    
    for (int i=0; i < 3; i++)
    {
        [sheet setTextColor:[UIColor whiteColor] forButtonAtIndex:i];
    }
    [sheet showFromRect:[sender frame] inView:self.view animated:YES];
}

#pragma -mark ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
    else if(buttonIndex==1)
    {
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
        imagePicker.delegate=self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self presentModalViewController:imagePicker animated:YES];
        }
    }
}

#pragma -mark imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if(image)
    {
        if (BUTTONTAGIMGUSERCOMPANY==10) {
            
            btnUserImage.clipsToBounds = YES;
            btnUserImage.layer.cornerRadius = 20;//half of the width
            btnUserImage.layer.borderColor=[UIColor colorWithRed:91.0/255.0 green:177.0/255.0 blue:39.0/255.0 alpha:0.8].CGColor;
            btnUserImage.layer.borderWidth=3.0f;
            [btnUserImage setImage:image forState:UIControlStateNormal];
            
        }else{
            
            btnFirmImage.clipsToBounds = YES;
            btnFirmImage.layer.cornerRadius = 20;//half of the width
            btnFirmImage.layer.borderColor=[UIColor colorWithRed:24.0/255.0 green:86.0/255.0 blue:138.0/255.0 alpha:0.8].CGColor;
            btnFirmImage.layer.borderWidth=3.0f;
            [btnFirmImage setImage:image forState:UIControlStateNormal];
            
        }
        
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag==0) {
        return [arrFillTable count];
        
    }else if (tableView.tag==1){
        
        return [arrLawIdList count];
    }
    
    return 0;
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
        
        cell.textLabel.text=[[arrFillTable valueForKey:@"vCountryName"] objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView.tag==1){
        
        cell.textLabel.text=[[arrLawIdList valueForKey:@"vAreaName"] objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if ([[selectedIndexDict valueForKey:[NSString stringWithFormat:@"%d", indexPath.row]] boolValue]==YES) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        
        txtFldContryId.text=[[arrFillTable valueForKey:@"vCountryName"] objectAtIndex:indexPath.row];
        strIDCountry =[[arrFillTable valueForKey:@"iCountryID"] objectAtIndex:indexPath.row];
    }else if (tableView.tag==1) {
        
        if ([[selectedIndexDict valueForKey:[NSString stringWithFormat:@"%d", indexPath.row]] boolValue]) {
            
            [selectedIndexDict setValue:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
            txtFldLawId.text = [txtFldLawId.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",[[arrLawIdList valueForKey:@"vAreaName"] objectAtIndex:indexPath.row]] withString:@""];
            
        }else{
            
            [selectedIndexDict setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
            txtFldLawId.text= [txtFldLawId.text stringByAppendingFormat:@"%@,",[[arrLawIdList valueForKey:@"vAreaName"] objectAtIndex:indexPath.row]];
        }
        [_tableView reloadData];
    }
}



-(void)fillTextField:(id)sender{
    
    txtFldFirstName.text=[arrLawyerInfo valueForKey:@"vFirstName"];
    txtFldLastName.text= [arrLawyerInfo valueForKey:@"vLastName"];
    txtFldEmail.text=[arrLawyerInfo valueForKey:@"vEmail"];
    txtFldAddress1.text=[arrLawyerInfo valueForKey:@"vAddress1"];
    txtFldAddress2.text=[arrLawyerInfo valueForKey:@"vAddress2"];
    txtFldFirmName.text=[arrLawyerInfo valueForKey:@"vFirmName"];
    txtFldCity.text=[arrLawyerInfo valueForKey:@"vCity"];
    txtFldPhNumber.text=[arrLawyerInfo valueForKey:@"vPhone"];
    txtFldState.text=[arrLawyerInfo valueForKey:@"vState"];
    txtFldPrice.text=[arrLawyerInfo valueForKey:@"vPrice"];
    txtFldFirmAddress1.text=[arrLawyerInfo valueForKey:@"vFirmAddress1"];
    txtFldFirmAddress2.text=[arrLawyerInfo valueForKey:@"vFirmAddress2"];
    txtFldEducation.text=[arrLawyerInfo valueForKey:@"vEducation"];
    txtFldContryId.text=[arrLawyerInfo valueForKey:@"country_name"];
    txtFldAddmissionInfo.text=[arrLawyerInfo valueForKey:@"tAdmissionInfo"];
    txtFldLawId.text=[arrLawyerInfo valueForKey:@"area_of_law"];
    txtFldOfficeStartTime.text=[arrLawyerInfo valueForKey:@"dOfficeStartTime"];
    txtFldOfficeEndTime.text=[arrLawyerInfo valueForKey:@"dOfficeEndTime"];
    txtFldWebSite.text = [arrLawyerInfo valueForKey:@"vWebsite"];
    txtFldAboutFirm.text =[arrLawyerInfo valueForKey:@"tAboutFirm"];
    txtFldServingCity.text = [arrLawyerInfo valueForKey:@"vFirmCity"];
    if ([arrLawyerInfo valueForKey:@"vFirmLogo"]) {
        btnUserImage.clipsToBounds = YES;
        btnUserImage.layer.cornerRadius = 20;//half of the width
        btnUserImage.layer.borderColor=[UIColor colorWithRed:91.0/255.0 green:177.0/255.0 blue:39.0/255.0 alpha:0.8].CGColor;
        btnUserImage.layer.borderWidth=3.0f;
        [btnUserImage setImageWithURL:[arrLawyerInfo valueForKey:@"vFirmLogo"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sync.png"]];
       
    }
    
    if ([arrLawyerInfo valueForKey:@"vProfilePic"]) {
        btnFirmImage.clipsToBounds = YES;
        btnFirmImage.layer.cornerRadius = 20;//half of the width
        btnFirmImage.layer.borderColor=[UIColor colorWithRed:24.0/255.0 green:86.0/255.0 blue:138.0/255.0 alpha:0.8].CGColor;
        btnFirmImage.layer.borderWidth=3.0f;
        [btnFirmImage setImageWithURL:[arrLawyerInfo valueForKey:@"vProfilePic"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"sync.png"]];
    }
}



#pragma mark Registration Button Clicked


-(IBAction)registrationBtnClicked:(id)sender{
    
    BOOL IS_EMAIL_VALID = [txtFldEmail.text validateEmail];
    if (IS_EMAIL_VALID==YES) {
        if (![txtFldFirstName.text isEqualToString:@""] || ![txtFldPassword.text isEqualToString:@""]) {
            loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing Up"];
            NSString *urlString=[NSString stringWithFormat:@"%sc=user&func=adduser",WEBSERVICE_HEADER];
            NSURL *url=[NSURL URLWithString:urlString];
            ASIFormDataRequest *request1=[ASIFormDataRequest requestWithURL:url];
            [request1 setPostValue:txtFldFirstName.text forKey:@"vFirstName"];
            [request1 setPostValue:txtFldLastName.text forKey:@"vLastName"];
            [request1 setPostValue:txtFldPassword.text forKey:@"vPassword"];
            [request1 setPostValue:txtFldAddress1.text forKey:@"vAddress1"];
            [request1 setPostValue:txtFldEmail.text forKey:@"vEmail"];
            [request1 setPostValue:txtFldPhNumber.text forKey:@"vPhone"];
            [request1 setPostValue:txtFldAddress2.text forKey:@"vAddress2"];
            [request1 setPostValue:txtFldFirmName.text forKey:@"vFirmName"];
            [request1 setPostValue:txtFldCity.text forKey:@"vCity"];
            [request1 setPostValue:txtFldState.text forKey:@"vState"];
            [request1 setPostValue:txtFldPrice.text forKey:@"vPrice"];
            [request1 setPostValue:txtFldWebSite.text forKey:@"vWebsite"];
            [request1 setPostValue:txtFldServingCity.text forKey:@"vFirmCity"];
            [request1 setPostValue:txtFldAboutFirm.text forKey:@"tAboutFirm"];
            [request1 setPostValue:txtFldFirmAddress1.text forKey:@"vFirmAddress1"];
            [request1 setPostValue:txtFldFirmAddress2.text forKey:@"vFirmAddress2"];
            [request1 setPostValue:txtFldEducation.text forKey:@"vEducation"];
            [request1 setPostValue:strIDCountry forKey:@"iCountryID"];
            [request1 setPostValue:txtFldAddmissionInfo.text forKey:@"tAdmissionInfo"];
            [request1 setPostValue:strIDLaw forKey:@"iLawID"];
            [request1 setPostValue:txtFldOfficeStartTime.text forKey:@"dOfficeStartTime"];
            [request1 setPostValue:txtFldOfficeEndTime.text forKey:@"dOfficeEndTime"];
            if(btnUserImage.imageView.image!=nil)
            {
                [request1 setData:UIImagePNGRepresentation(btnUserImage.imageView.image) withFileName:@"image.png" andContentType:@"image/png" forKey:@"vProfilePic"];
            }
            if(btnFirmImage.imageView.image!=nil)
            {
                [request1 setData:UIImagePNGRepresentation(btnFirmImage.imageView.image) withFileName:@"image.png" andContentType:@"image/png" forKey:@"vFirmLogo"];
            }
            
            [request1 setDelegate:self];
            [request1 startAsynchronous];
            
        }else{
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Username Or Password can not be blank" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
            
        }
    }else{
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:APP_NAME message:@"Please enter correct Email Id" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma -mark ASIHTTP delegats
-(void)requestFinished:(ASIHTTPRequest *)request1
{
    //[self.view hideToastActivity];
    NSLog(@"Response is %@",[[request1 responseString] JSONValue]);
    self.navigationController.view.userInteractionEnabled=YES;
    dictionaryJSON=(NSDictionary*)[[request1 responseString] JSONValue];
    if([[dictionaryJSON valueForKey:@"msg"]caseInsensitiveCompare:@"SUCCESS"]==NSOrderedSame)
    {
        NSLog(@"%@",dictionaryJSON);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Registered Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
    [loadingActivityIndicator removeFromSuperview];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Registration failes.Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    self.navigationController.view.userInteractionEnabled=YES;
    [loadingActivityIndicator removeFromSuperview];
}


#pragma mark BackBtn

-(IBAction)backBtnPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
