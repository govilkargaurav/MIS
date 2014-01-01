//
//  SignUpViewController.m
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "SignUpViewController.h"
#import "LawyerInfoViewController.h"
#import "FTAnimationManager.h"
#import "FTAnimation+UIView.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "GlobalClass.h"
#import "ReceiptCheck.h"
#import "UICustomActionSheet.h"
#import "JSONParsingAsync.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "UIImage+Utilities.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface SignUpViewController ()

@end

@implementation SignUpViewController
CGFloat animatedDistance;
@synthesize scrlView;
@synthesize viewInApp;
@synthesize _products;
@synthesize backView;
@synthesize loadingActivityIndicator;
@synthesize strSubscriptionIdentifire;
@synthesize arrCountryList;
@synthesize arrLawIdList;
@synthesize _tableView;
@synthesize strIDCountry;
@synthesize strIDLaw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        [scrlView bringSubviewToFront:_tableView];
    }
    return self;
}


/* Keep All Fields Disable In starting */

-(void)keepAllFieldsDisable{
    txtFldFirstName.userInteractionEnabled=FALSE;
    txtFldLastName.userInteractionEnabled=FALSE;
    txtFldEmail.userInteractionEnabled=FALSE;
    txtFldPassword.userInteractionEnabled=FALSE;
    txtFldAddress1.userInteractionEnabled=FALSE;
    txtFldAddress2.userInteractionEnabled=FALSE;
    txtFldFirmName.userInteractionEnabled=FALSE;
    txtFldCity.userInteractionEnabled=FALSE;
    txtFldPhNumber.userInteractionEnabled=FALSE;
    txtFldState.userInteractionEnabled=FALSE;
    txtFldPrice.userInteractionEnabled=FALSE;
    txtFldFirmAddress1.userInteractionEnabled=FALSE;
    txtFldFirmAddress2.userInteractionEnabled=FALSE;
    txtFldEducation.userInteractionEnabled=FALSE;
    txtFldContryId.userInteractionEnabled=FALSE;
    txtFldAddmissionInfo.userInteractionEnabled=FALSE;
    txtFldLawId.userInteractionEnabled=FALSE;
    txtFldOfficeStartTime.userInteractionEnabled=FALSE;
    txtFldOfficeEndTime.userInteractionEnabled=FALSE;
    btnFirmImage.userInteractionEnabled=FALSE;
    btnUserImage.userInteractionEnabled=FALSE;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Register Method To hide activity If fail in In-App Purchase and post it from "failedTransaction" */
    selectedIndexDict = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivity) name:HIDE_ACTIVITY object:nil];
    ISRECIEPTVALIDATE = NO;
    backView.alpha = 0.6;
    _products = nil;
    [self FillContryAndLawCategory];
    [self.navigationController setNavigationBarHidden:TRUE];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"Sign up";
}

/* Show View With Animation */

#pragma mark FTAnimation Done
-(void)animationBegin:(id)sender{
    [self.viewInApp popIn:1.0 delegate:self];
    self.viewInApp.alpha=1;
}

-(void)viewDidAppear:(BOOL)animated{
    
    /* scroll View Setup here */
    
    scrlView.contentSize=CGSizeMake(320, 1150);
    if (IS_IPHONE_5) {
        
        [scrlView setContentOffset:CGPointMake(0,-60) animated:YES];
        scrlView.contentInset=UIEdgeInsetsMake(60, 0,0, 0);
        
    }else{
        [scrlView setContentOffset:CGPointMake(0,-150) animated:YES];
        scrlView.contentInset=UIEdgeInsetsMake(150, 0,0, 0);
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
    [scrlView addSubview:_tableView];
}

-(IBAction)upgreadAccount:(id)sender{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Lawyer App" message:@"These features are not available in basic account. You need to upgrade this." delegate:nil cancelButtonTitle:@"UPGRADE" otherButtonTitles:@"NO", nil];
    [alert show];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGRect textVWRect = [self.scrlView convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.scrlView convertRect:self.view.bounds fromView:self.view];
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
        [_tableView reloadData];
       [_tableView setHidden:YES];
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
        DatepickerView.frame=CGRectMake(0,self.view.frame.size.height-216, 320, 216);
        DatetoolBar.frame=CGRectMake(0,DatepickerView.frame.origin.y-44, 320, 44);
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
        
    }else if (txtFldLawId){
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Just choose category from table." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alert show];
            return NO;
         [_tableView reloadData];
        [_tableView setHidden:NO];
    }
    
    [scrlView bringSubviewToFront:_tableView];
    [_tableView reloadData];

    return YES;
}

-(IBAction)lawyerInfo:(id)sender{
    
    LawyerInfoViewController *lawyerInfo =[[LawyerInfoViewController alloc] initWithNibName:@"LawyerInfoViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:lawyerInfo animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark IN-APP PURCHASE BUYING METHODS
/* In-App Purchase Delegate Methods */

-(IBAction)buyButtonTapped:(id)sender{
    loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Purchasing In Progress"];
    NSLog(@"%@",_products);
    UIButton *buyButton = (UIButton *)[viewInApp viewWithTag:[sender tag]];
    SKProduct *product = _products[buyButton.tag];
    NSLog(@"%@",product.productIdentifier);
    strSubscriptionIdentifire = _products[buyButton.tag];
    [[RageIAPHelper sharedInstance] buyProduct:product];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            backView.alpha = 0.0;
            [[NSUserDefaults standardUserDefaults]setObject:dictRecieptVarification forKey:@"Reciet_Varification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.viewInApp popOut:1.0 delegate:nil];
            [loadingActivityIndicator removeFromSuperview];
            [[NSUserDefaults standardUserDefaults]setObject:productIdentifier forKey:@"productIdentifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self OpenFieldsForSignUpAccordingToSubscription:productIdentifier];
            *stop = YES;
        }
    }];
    
}

-(void)checkReceipt:(NSData *)receipt {
    // save receipt
    NSString *receiptStorageFile = [DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"];
    NSMutableArray *receiptStorage = [[NSMutableArray alloc] initWithContentsOfFile:receiptStorageFile];
    NSLog(@"%@",receiptStorage);
    if(!receiptStorage) {
        receiptStorage = [[NSMutableArray alloc] init];
    }
    [receiptStorage addObject:receipt];
    [receiptStorage writeToFile:receiptStorageFile atomically:YES];
    
    
    [ReceiptCheck validateReceiptWithData:receipt completionHandler:^(BOOL success,NSString *answer){
        
        if(success==YES) {
            ISRECIEPTVALIDATE = YES;
            
        } else {
            
            ISRECIEPTVALIDATE = NO;
            NSLog(@"Receipt not validated! Error: %@",answer);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error" message:@"Cannot validate receipt" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        };
    }];
    
}

#pragma mark AFTER COMPLETION OF IN-APP PURCHASE AND RECEIPT VARIFICATION

-(void)afterComplition{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:@"You can only be able to fill out fields according to your subscription plan. For more info go to \nSETTINGS -> Info" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [loadingActivityIndicator removeFromSuperview];
    [self OpenFieldsForSignUpAccordingToSubscription:strSubscriptionIdentifire];
    backView.alpha= 0.0;
    
    
}
-(void)OpenFieldsForSignUpAccordingToSubscription:(NSString *)strSubscription{
    
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"productIdentifier"]);
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"productIdentifier"] isEqualToString:@"com.lawyer.basic"]) {
        SUBSCRIPTION_ID=1;
        txtFldFirstName.userInteractionEnabled=TRUE;
        txtFldLastName.userInteractionEnabled=TRUE;
        txtFldEmail.userInteractionEnabled=TRUE;
        txtFldPassword.userInteractionEnabled=TRUE;
        txtFldAddress1.userInteractionEnabled=TRUE;
        txtFldAddress2.userInteractionEnabled=TRUE;
        txtFldCity.userInteractionEnabled=TRUE;
        txtFldPhNumber.userInteractionEnabled=TRUE;
        txtFldState.userInteractionEnabled=TRUE;
        txtFldPrice.userInteractionEnabled=FALSE;
        txtFldFirmName.userInteractionEnabled=FALSE;
        txtFldFirmAddress1.userInteractionEnabled=FALSE;
        txtFldFirmAddress2.userInteractionEnabled=FALSE;
        txtFldEducation.userInteractionEnabled=FALSE;
        txtFldContryId.userInteractionEnabled=FALSE;
        txtFldAddmissionInfo.userInteractionEnabled=FALSE;
        txtFldLawId.userInteractionEnabled=FALSE;
        txtFldOfficeStartTime.userInteractionEnabled=FALSE;
        txtFldOfficeEndTime.userInteractionEnabled=FALSE;
        
    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"productIdentifier"] isEqualToString:@"com.lawyer.silver"]){
        SUBSCRIPTION_ID=2;
        txtFldFirstName.userInteractionEnabled=TRUE;
        txtFldLastName.userInteractionEnabled=TRUE;
        txtFldEmail.userInteractionEnabled=TRUE;
        txtFldPassword.userInteractionEnabled=TRUE;
        txtFldAddress1.userInteractionEnabled=TRUE;
        txtFldAddress2.userInteractionEnabled=TRUE;
        txtFldCity.userInteractionEnabled=TRUE;
        txtFldPhNumber.userInteractionEnabled=TRUE;
        txtFldState.userInteractionEnabled=TRUE;
        txtFldFirmName.userInteractionEnabled=TRUE;
        txtFldFirmAddress1.userInteractionEnabled=TRUE;
        txtFldFirmAddress2.userInteractionEnabled=TRUE;
        txtFldPrice.userInteractionEnabled=FALSE;
        txtFldEducation.userInteractionEnabled=FALSE;
        txtFldContryId.userInteractionEnabled=FALSE;
        txtFldAddmissionInfo.userInteractionEnabled=FALSE;
        txtFldLawId.userInteractionEnabled=FALSE;
        txtFldOfficeStartTime.userInteractionEnabled=FALSE;
        txtFldOfficeEndTime.userInteractionEnabled=FALSE;
        btnFirmImage.userInteractionEnabled=TRUE;
        btnUserImage.userInteractionEnabled=TRUE;
        
        
    }else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"productIdentifier"] isEqualToString:@"com.layer.platinum"]){
        SUBSCRIPTION_ID=3;
        txtFldFirstName.userInteractionEnabled=TRUE;
        txtFldLastName.userInteractionEnabled=TRUE;
        txtFldEmail.userInteractionEnabled=TRUE;
        txtFldPassword.userInteractionEnabled=TRUE;
        txtFldAddress1.userInteractionEnabled=TRUE;
        txtFldAddress2.userInteractionEnabled=TRUE;
        txtFldCity.userInteractionEnabled=TRUE;
        txtFldPhNumber.userInteractionEnabled=TRUE;
        txtFldState.userInteractionEnabled=TRUE;
        txtFldFirmName.userInteractionEnabled=TRUE;
        txtFldFirmAddress1.userInteractionEnabled=TRUE;
        txtFldFirmAddress2.userInteractionEnabled=TRUE;
        txtFldPrice.userInteractionEnabled=TRUE;
        txtFldEducation.userInteractionEnabled=TRUE;
        txtFldContryId.userInteractionEnabled=TRUE;
        txtFldAddmissionInfo.userInteractionEnabled=TRUE;
        txtFldLawId.userInteractionEnabled=TRUE;
        txtFldOfficeStartTime.userInteractionEnabled=TRUE;
        txtFldOfficeEndTime.userInteractionEnabled=TRUE;
        btnFirmImage.userInteractionEnabled=TRUE;
        btnUserImage.userInteractionEnabled=TRUE;
        
    }
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
    UIButton *btn = (UIButton *)[scrlView viewWithTag:[sender tag]];
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
            //[image resizeImage:image resizeSize:CGSizeMake(71, 72)]
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
    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
        if (globalTxtField==txtFldContryId) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        
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

//txtFldLawId.text=[[arrFillTable valueForKey:@"vAreaName"] objectAtIndex:indexPath.row];
//strIDLaw= [[arrFillTable valueForKey:@"iAreaID"] objectAtIndex:indexPath.row];


#pragma mark Registration Button Clicked
-(IBAction)registrationBtnClicked:(id)sender{

    BOOL IS_EMAIL_VALID = [txtFldEmail.text validateEmail];
    if (IS_EMAIL_VALID==YES) {
        if (![txtFldFirstName.text isEqualToString:@""] || ![txtFldPassword.text isEqualToString:@""]) {
            loadingActivityIndicator = [DejalBezelActivityView activityViewForView:self.view withLabel:@"Signing Up"];
            NSString *strSubscriptionId = [NSString stringWithFormat:@"%d",SUBSCRIPTION_ID];
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
            [request1 setPostValue:strSubscriptionId forKey:@"iPackageID"];
            if(imgUser.image!=nil)
            {
                [request1 setData:UIImagePNGRepresentation(btnUserImage.imageView.image) withFileName:@"image.png" andContentType:@"image/png" forKey:@"vProfilePic"];
            }
            if(imgFirm.image!=nil)
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
    NSLog(@"%@",[request1 responseString]);
    NSLog(@"Response is %@",[[request1 responseString] JSONValue]);
    self.navigationController.view.userInteractionEnabled=YES;
    dictionaryJSON=(NSDictionary*)[[request1 responseString] JSONValue];
    if([[dictionaryJSON valueForKey:@"message"]caseInsensitiveCompare:@"SUCCESS"]==NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Registered Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark HIDE ACTIVITY INDICATOR
-(void)hideActivity{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [loadingActivityIndicator removeFromSuperview];
    DisplayAlert(@"Please Try Agin After Some Time");
}

#pragma mark BackBtn

-(IBAction)backBtnPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
