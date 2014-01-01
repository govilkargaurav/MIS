//
//  PropertYDescription.m
//  PropertyInspector
//
//  Created by apple on 10/26/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "PropertYDescription.h"
#import "GetTrusteesListModel.h"
#import "DAL.h"
#import "BusyAgent.h"
#import "DatabaseBean.h"
#import "LoginModel.h"
#import "SendMaxBid.h"
#import "BusyAgent.h"
#import "ThreadManager.h"
#import "UpdaePropertyModel.h"
#import "AlertManger.h"
#import "LossViewController.h"

@interface PropertYDescription ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    DAL *dt;
    
    UIToolbar *toolBar;
    UIPickerView *pickerView;
    DatabaseBean *dbBean;
    int cID;
}
@property(nonatomic,strong)NSString *bidStatus;
@property(nonatomic,strong)NSMutableArray *bidArray;
@property(nonatomic,strong)NSMutableDictionary *arrayOfDescription;
@end

@implementation PropertYDescription
@synthesize arrayOfDescription;
@synthesize propertyID;
@synthesize AddressLable;
@synthesize cityState;
@synthesize legalDescription;
@synthesize borrowerLastNameFirstName;
@synthesize fileNo;
@synthesize auctionDate;
@synthesize openingBid;
@synthesize trusteeNo;
@synthesize bidArray;
@synthesize bidStatus;


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
    // Do any additional setup after loading the view from its nib.
    
    if (arrayOfDescription!=nil) {
        arrayOfDescription=nil;
        [arrayOfDescription removeAllObjects];
    }
    arrayOfDescription=[[NSMutableDictionary alloc] init];
    
    if (bidArray!=nil) {
        bidArray=nil;
        [bidArray removeAllObjects];
    }
    bidArray=[[NSMutableArray alloc] init];
    
    dbBean=[[DatabaseBean alloc] init];
    
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,520, 320, 44);
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
    pickerView.frame=CGRectMake(0, 520, 320, 216);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView commitAnimations];
    pickerView.backgroundColor=[UIColor grayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    bidArray=[[NSMutableArray alloc]initWithObjects:@"MISSED",@"POSTPONED",@"CANCELLED",@"OPEN BID HIGH", nil];
    
    dt=[DAL getInstance];
    
    arrayOfDescription=[dt getAllSubCategorybyId:propertyID:GET_RECORDS_PROPERTY_ID];

    
    
    //maxBid.hidden=YES;
    lossButton.hidden=YES;
    wonButton.hidden=YES;
    noBidButton.hidden=NO;
    bidButton.hidden=NO;
    
    criedBy.text=[arrayOfDescription valueForKey:@"CRIER"];
    trusteeNo.text=[arrayOfDescription valueForKey:@"AUCTION_NUMBER"];
    AddressLable.text=[arrayOfDescription valueForKey:@"ADDRESS"];
    cityState.text=[NSString stringWithFormat:@"%@,%@",[arrayOfDescription valueForKey:@"CITY"],[arrayOfDescription valueForKey:@"STATE"]];
    legalDescription.text=[NSString stringWithFormat:@"%@",[arrayOfDescription valueForKey:@"LEGAL_DESCRIPTION"]];
    borrowerLastNameFirstName.text=[NSString stringWithFormat:@"%@",[arrayOfDescription valueForKey:@"BROOWER_NAME"]];
    auctionDate.text=[arrayOfDescription valueForKey:@"AUCTION_DATE_TIME"];
    openingBid.text=[arrayOfDescription valueForKey:@"OPENING_BID"];
    wonPrice.text =[arrayOfDescription valueForKey:@"WON_PRIZE"];
    loanDate.text=[arrayOfDescription valueForKey:@"LOANDATE"];
    loanAmount.text=[arrayOfDescription valueForKey:@"LOANAMOUNT"];
    
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@",[arrayOfDescription valueForKey:@"TRUSTEE_NAME"]];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@",[arrayOfDescription valueForKey:@"TRUSTEE_NAME"]];
    
}


-(IBAction)Bid:(id)sender{
    
    noBidButton.hidden=YES;
    bidButton.hidden=YES;
    //maxBid.hidden=NO;
    lossButton.hidden=NO;
    wonButton.hidden=NO;
}


-(IBAction)Loss:(id)sender{
    
    LossViewController *controller=[[LossViewController alloc] initWithNibName:@"LossViewController" bundle:nil];
    controller.propertyID=propertyID;
    controller.auctionID=[arrayOfDescription valueForKey:@"AUCTION_ID"];
    controller.wonPrise=wonPrice.text;
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(IBAction)bid:(id)sender{
    
    
    
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
    
    return [bidArray count];
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [bidArray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    cID=row;

}

-(void)CanclePressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerView.frame=CGRectMake(0,520, 320, 216);
    [UIView commitAnimations];
    
}

-(void)DonePressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerView.frame=CGRectMake(0,520, 320, 216);
    [UIView commitAnimations];
    
    
    bidStatus=[bidArray objectAtIndex:cID];
    
    //https://206.246.135.196/AH4RMAuction/updateQualifiedProperty.aspx?sessionId=%@&pid=1&bidStatus=LOST&settleStatus=&lostPrice=90000
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&auctionId=%@&borrower=%@&openingBid=%@&trustee=%@&crier=%@&bidStatus=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propertyID,[arrayOfDescription valueForKey:@"AUCTION_ID"],[arrayOfDescription valueForKey:@"BROOWER_NAME"],[arrayOfDescription valueForKey:@"OPENING_BID"],[arrayOfDescription valueForKey:@"TRUSTEE_NAME"],[arrayOfDescription valueForKey:@"CRIER"],bidStatus]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
}

-(void)getDeviceAunthnticityResponse{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    if ([status isEqualToString:@"true"]) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Service is not working this time.Please try again later." cancelButtonTitle:@"OK"];
        
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
    
}



-(void)busyViewinSecondryThread:(id)sender{
    
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    
    
}



-(IBAction)btnNoBidPresses:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,203, 320, 44);
    pickerView.frame=CGRectMake(0,245, 320, 216);
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}

-(IBAction)maxBid:(id)sender{
    
    [self performSelector:@selector(reset:) withObject:nil afterDelay:1.0];
    
    [maxBid setTitle:[NSString stringWithFormat:@"$ %@",[arrayOfDescription valueForKey:@"MAX_BID"]] forState:UIControlStateNormal];
    
}

-(void)reset:(id)sender{
    
    [maxBid setTitle:@"Max Bid" forState:UIControlStateNormal];
    
}

-(IBAction)looseWon:(id)sender{
    
    
    //sessionId=&pid=<propertyId>&auctionId=<auctionId>&borrower=<borrower>&openingBid=<openingBid>&trustee=<trustee>&crier=<crierName>&bidStatus=<TBD/MISSED/POSTPONED/WON/LOST/CANCELLED/OPEN_BID_HIGH>&settleStatus=<TBD/SETTLED/SETTLE_LATER>$closingBid=<closingBid>
    
    NSDictionary *dictValues=[NSDictionary dictionaryWithObjectsAndKeys:sessionID,@"SESSION_ID",propertyID,@"PROPERTY_ID",[arrayOfDescription valueForKey:@"AUCTION_ID"],@"AUCION_ID",[arrayOfDescription valueForKey:@"BROOWER_NAME"],@"BORROWER_NAME",[arrayOfDescription valueForKey:@"OPENING_BID"],@"OPENING_BID",[arrayOfDescription valueForKey:@"TRUSTEE_NAME"],@"TRSTEE_NAME",bidStatus,@"BID_STATUS", nil];
    
    SendMaxBid *controller=[[SendMaxBid alloc] initWithNibName:@"SendMaxBid" bundle:nil];
    controller.propertyID=propertyID;
    controller.stringAddress=AddressLable.text;
    controller.sendStatusDICT=dictValues;
    controller.auctionID=[arrayOfDescription valueForKey:@"AUCTION_ID"];
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
