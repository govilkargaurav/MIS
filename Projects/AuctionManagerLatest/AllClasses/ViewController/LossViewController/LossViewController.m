//
//  LossViewController.m
//  PropertyInspector
//
//  Created by apple on 11/8/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "LossViewController.h"
#import "LoginListParser.h"
#import "ThreadManager.h"
#import "UpdaePropertyModel.h"
#import "AlertManger.h"
#import "BusyAgent.h"

@interface LossViewController (){
    UIBarButtonItem *button;
    IBOutlet UITextField *_textField;
    NSString *amountString;
    IBOutlet UILabel *winningBid;
    
}

@end

@implementation LossViewController

@synthesize wonPrise;
@synthesize propertyID;
@synthesize auctionID;

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
    
    
    self.navigationItem.title=@"Lost Amount";
    
    button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                               target:self
                               action:@selector(refresh:)];
    button.tag=1;
    self.navigationItem.rightBarButtonItem = button;
    button.enabled=FALSE;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    _textField.inputAccessoryView = numberToolbar;

    winningBid.text=wonPrise;
    
    [_textField becomeFirstResponder];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title=@"Lost Amount";
    
}


//https://206.246.135.196/AH4RMAuction/updateQualifiedProperty.aspx?sessionId=9CA77958-C1A6-428E-B683-95E4F9F2892E&pid=1&bidStatus=LOST&settleStatus=&lostPrice=90000
-(void)refresh:(id)sender{
    
        
        [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
        
        NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&bidStatus=%@&auctionId=%@&wonPrice=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propertyID,@"LOST",auctionID,_textField.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        ////NSLog(@"SOAPMESS:::---%@",soapMessage);
        
        NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
        
        [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
}


-(void)doneWithNumberPad{
    
    button.enabled=TRUE;
    amountString=_textField.text;
//    NSNumber *number = [NSNumber numberWithInt:[_textField.text intValue]];
//    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
//    [frmtr setGroupingSize:3];
//    [frmtr setGroupingSeparator:@","];
//    [frmtr setUsesGroupingSeparator:YES];
//    NSString *commaString = [frmtr stringFromNumber:number];
//    ////NSLog(@"%@",commaString);
//    _textField.text=commaString;
//    [_textField resignFirstResponder];

    
    
    NSNumber *number1 = [NSNumber numberWithFloat:[_textField.text floatValue]];
    //NSLog(@"%@",number1);
    NSNumberFormatter *frmtr1 = [[NSNumberFormatter alloc] init];
    [frmtr1 setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr1 setGroupingSize:3];
    [frmtr1 setGroupingSeparator:@","];
    [frmtr1 setUsesGroupingSeparator:YES];
    NSString *commaString1 = [frmtr1 stringFromNumber:number1];
    _textField.text=commaString1;
    [_textField resignFirstResponder];

    
}

-(void)busyViewinSecondryThread:(id)sender{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

-(void)getDeviceAunthnticityResponse{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
 
    if ([status isEqualToString:@"true"]) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Service is not working this time.Please try again later." cancelButtonTitle:@"OK"];
        
    }
    
           });
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
