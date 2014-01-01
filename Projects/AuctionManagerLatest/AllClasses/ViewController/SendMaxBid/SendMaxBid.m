//
//  SendMaxBid.m
//  PropertyInspector
//
//  Created by apple on 10/27/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "SendMaxBid.h"
#import "ThreadManager.h"
#import "BusyAgent.h"
#import "LoginModel.h"
#import "UpdaePropertyModel.h"
#import "AlertManger.h"
#import "SettleNowViewController.h"



@interface SendMaxBid ()<UIAlertViewDelegate>{
    UIBarButtonItem *button;
    int i;
    NSString *amountString;
    UIButton *settleLater;
    NSString *sattleStatus;
    
    int settleLaterTag;
}
@property(nonatomic,strong)IBOutlet UITextField *textFieldStudy;
@end

@implementation SendMaxBid
@synthesize stringAddress;
@synthesize propertyID;
@synthesize textFieldStudy;
@synthesize sendStatusDICT;
@synthesize auctionID;
@synthesize commaString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(BOOL)textFiledSouldBeginEditing:(UITextField *)textField{
    
    return NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=stringAddress;
    
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
    
    textFieldStudy.inputAccessoryView = numberToolbar;
    
    [textFieldStudy becomeFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title=stringAddress;
    
}

-(void)doneWithNumberPad{

    button.enabled=TRUE;
    amountString=textFieldStudy.text;
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:textFieldStudy.text locale:[NSLocale currentLocale]];
    //NSLog(@"%@",number);
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    commaString = [frmtr stringForObjectValue:number];
    commaString=[commaString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString);
    textFieldStudy.text=commaString;
    [textFieldStudy resignFirstResponder];

}


-(void)refresh:(id)sender{
    
    
    if ([sender tag]==1) {
        
        [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
        
        NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&auctionId=%@&wonPrice=%@&settleStatus=%@&bidStatus=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propertyID,auctionID,textFieldStudy.text,@"SETTLE_LATER",@"WON"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        i=1;
        //NSLog(@"SOAPMESS:::---%@",soapMessage);
        
        NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
        
        [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
        
        
        
    }else{
        
        
        [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
        
        NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&auctionId=%@&settleStatus=%@&wonPrice=%@&bidStatus=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propertyID,auctionID,sattleStatus,textFieldStudy.text,@"WON"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        i=2;
        ////NSLog(@"SOAPMESS:::---%@",soapMessage);
        
        NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
        
        [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
        
        
    }
    
    
    
    
    
}


-(void)getDeviceAunthnticityResponse{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    if ([status isEqualToString:@"true"]) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (i==1) {
                 
                 [textFieldStudy resignFirstResponder];
                 
             }else{
                 
                 if (settleLaterTag==0) {
                     
                 
                     [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"You are about to settle this property." cancelButtonTitle:@"OK"];
                 
                 
                 }else{
                     
                     
                     
                     [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"The property has been recorded as purchased, but the settlement is pending." cancelButtonTitle:@"OK" okButtonTitle:nil parentController:self];
                 }
                 
             }
             
             
             
         });
        
    }else{
        
        
        
        [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"Please Try Again Later." cancelButtonTitle:@"OK" okButtonTitle:nil parentController:self];
        
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}



-(IBAction)sattleLater:(id)sender{
    
    settleLater.tag=2;
    settleLaterTag=1;
    sattleStatus=@"SETTLE_LATER";
    [self refresh:sender];
    
    
    
}

-(IBAction)settleNow:(id)sender{
    
    settleLater.tag=2;
    settleLaterTag=0;
    sattleStatus=@"SETTLED";
    [self refresh:sender];
    
    SettleNowViewController *controller=[[SettleNowViewController alloc] initWithNibName:@"SettleNowViewController" bundle:nil];
    controller.oweSTR=textFieldStudy.text;
    controller.pID=propertyID;
    controller.stringAddress=stringAddress;
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    controller=nil;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        
        [self LOGout];
        
    }
}

-(void)LOGout{
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i1=[vList count]-1; i1>=0; --i1) {
        view = [vList objectAtIndex:i1];
        if ([view.nibName isEqualToString: @"InfoViewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
    
}

-(void)busyViewinSecondryThread:(id)sender{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
