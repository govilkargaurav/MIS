//
//  SettleNowViewController.m
//  PropertyInspector
//
//  Created by apple on 10/30/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "SettleNowViewController.h"
#import "CustomCell.h"
#import "AlertManger.h"
#import "BusyAgent.h"
#import "LoginModel.h"
#import "ThreadManager.h"
#import "PaymentInfoModel.h"
#import "RecieptSubmitController.h"
#import "CheckInfoModel.h"
@interface SettleNowViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITextField *oweTextField;
    IBOutlet UITextField *paidTextField;
    IBOutlet UITextField *chequeNoTextField;
    IBOutlet UITextField *checkAmmount;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *textFieldsView;
    float l;
    IBOutlet UIView *cashView;
    IBOutlet UITextField *cashTextField;
    IBOutlet UIButton *documentButton;
    DAL *dt;
    DatabaseBean *bean;
    BOOL inserted;
    UIBarButtonItem *item2NewGlobal;
}
@property(nonatomic,strong)NSMutableArray *_arrayMutcheckNo;
@property(nonatomic,strong)NSMutableArray *chqueAmountArr;
@end

@implementation SettleNowViewController
@synthesize stringAddress;
@synthesize pID;
@synthesize oweSTR;
@synthesize _arrayMutcheckNo;
@synthesize chqueAmountArr;
@synthesize oweAmount;

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
    
    
    if ([navigateSTR isEqualToString:@"1"]) {
        
        navigateSTR=@"0";
        NSString *str=[oweSTR copy];
        
        //NSLog(@"%@",str);
        
        oweTextField.text=[NSString stringWithFormat:@"%@ %@",oweTextField.text,oweSTR];
        
    }else{


        
        oweSTR=[oweSTR stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:oweSTR locale:[NSLocale currentLocale]];
        //NSLog(@"%@",number);
        NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
        [frmtr setNumberStyle:NSNumberFormatterDecimalStyle];
        [frmtr setGroupingSize:3];
        [frmtr setGroupingSeparator:@","];
        [frmtr setUsesGroupingSeparator:YES];
        NSString *commaString = [frmtr stringFromNumber:number];
        commaString=[commaString stringByReplacingOccurrencesOfString:@"$" withString:@""];
        //NSLog(@"%@",commaString);
        
        oweTextField.text=[NSString stringWithFormat:@"%@ %@",oweTextField.text,commaString];
        
    }
    
    bean=[[DatabaseBean alloc] init];

    
    
    
    
    if (_arrayMutcheckNo!=nil) {
        
        _arrayMutcheckNo=nil;
        [_arrayMutcheckNo removeAllObjects];
    }
    _arrayMutcheckNo=[[NSMutableArray alloc] init];
    
    if (chqueAmountArr!=nil) {
        
        chqueAmountArr=nil;
        [chqueAmountArr removeAllObjects];
    }
    chqueAmountArr=[[NSMutableArray alloc] init];
    
    
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=stringAddress;
    //textFieldsView.hidden=YES;
    _tableView.hidden=YES;
    cashView.hidden=YES;
    
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];

    checkAmmount.inputAccessoryView = numberToolbar;
    
    
    
//    numberToolbar1.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(ApplyForcheck)],
//                           nil];
//    
//    
//    chequeNoTextField.inputAccessoryView = numberToolbar1;
    
    
    UIToolbar* numberToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar1.barStyle = UIBarStyleBlackTranslucent;
	UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)];
	item2NewGlobal = [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(ApplyForcheck)];
    item2NewGlobal.enabled=NO;
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	numberToolbar1.items = [NSArray arrayWithObjects: item1,item3, item2NewGlobal, nil];
    [numberToolbar1 sizeToFit];
    chequeNoTextField.inputAccessoryView = numberToolbar1;
    
    UIToolbar* numberToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar2.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar2.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(donePad)],
                           nil];
    [numberToolbar2 sizeToFit];
    
    cashTextField.inputAccessoryView = numberToolbar2;
    
    
}



-(void)busyViewinSecondryThread:(id)sender{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}


/* GET CHECKINFO WEBSERVICE RESULT */

-(void)getDeviceAunthnticityResponse1{
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_CHECK_AMOUNT_BY_NUMBER object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dt=[DAL getInstance];
        [dt deleteAllrecords:@"DELETE FROM checkInfo"];
        
        ////NSLog(@"Check::-->%@",checkNumber_amount);
        for (NSDictionary *book in checkNumber_amount) {
            
            bean.checkNumber=[book valueForKey:@"CHECKNUMBER"];
            bean.checkAmount=[book valueForKey:@"CHECKAMOUNT"];
            if ([dt insertintocheckinfo:bean]) {
                
                inserted=YES;
                
            }else{
                
                
            }

        }
        
        if (inserted==YES) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDuration:0.5];
            [textFieldsView setFrame:CGRectMake(0, 44,320,110)];
            textFieldsView.alpha=1;
            [UIView commitAnimations];
            
            [self.view addSubview:textFieldsView];
            [chequeNoTextField becomeFirstResponder];
        }
        
        
         [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
        
    });

   
  

   
    
}

/* DONE BUTTON CODE FOR GETTING AMOUNT OF CHECK NO */

-(IBAction)getamount:(id)sender{
    
    
    dt=[DAL getInstance];
    
    NSString *checkAmount=chequeNoTextField.text;
    NSString *getcheckAmont=[dt getCheckInfoAll:checkAmount];
    
    if ([getcheckAmont isEqualToString:@""] || getcheckAmont==nil) {
        
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"You have entered an invalid check number. Please enter another check number." cancelButtonTitle:@"OK"];
        
    }else{
       item2NewGlobal.enabled=YES;
        checkAmmount.text=getcheckAmont;
        
    }
    
}


/* TOOLBAR BUTTON FOR GETTING PROPER CHECK AMOUNT OF A CHECK */

-(void)ApplyForcheck{
    
    
    if ([checkAmmount.text isEqualToString:@""] || checkAmmount.text==nil || [chequeNoTextField.text isEqualToString:@""] || chequeNoTextField.text==nil) {
        
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Enter Check Number and press Done button first." cancelButtonTitle:@"OK"];
        
        
    }else{
        
        
        [self doneWithNumberPad];
        
    }
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title=stringAddress;
    
}


-(void)cancelNumberPad{
    
    //textFieldsView.hidden=YES;
    chequeNoTextField.text=@"";
    checkAmmount.text=@"";
    textFieldsView.alpha=0;
    [textFieldsView removeFromSuperview];
    [chequeNoTextField resignFirstResponder];
    [checkAmmount resignFirstResponder];
    
}

-(void)doneWithNumberPad{
    
    
    NSString *strAmount=paidTextField.text;
    strAmount=[strAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strAmount=[strAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    float h = [strAmount floatValue];
    NSString *numberFromTheKeyboard = checkAmmount.text;
    numberFromTheKeyboard=[numberFromTheKeyboard stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *strChequeNo = chequeNoTextField.text;
    chequeNoTextField.text=nil;
    checkAmmount.text=nil;
    
    
    float j =[numberFromTheKeyboard floatValue];
    
    ////NSLog(@"%@",oweSTR);
    oweSTR=[oweSTR stringByReplacingOccurrencesOfString:@"," withString:@""];
    float k=[oweSTR floatValue];
    

    
        
        h=h+j;
        l=k-h;
        
        //textFieldsView.hidden=YES;
    textFieldsView.alpha=0;
      [textFieldsView removeFromSuperview];
    
   
//    NSNumber *number = [NSNumber numberWithInt:l];
//    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
//    [frmtr setGroupingSize:3];
//    [frmtr setGroupingSeparator:@","];
//    [frmtr setUsesGroupingSeparator:YES];
//    NSString *commaString = [frmtr stringFromNumber:number];

    
    
    NSNumber *number = [NSNumber numberWithFloat:l];
    //NSLog(@"%@",number);
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    NSString *commaString = [frmtr stringFromNumber:number];
    commaString=[commaString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString);
    
    
    NSNumber *number1 = [NSNumber numberWithFloat:h];
    //NSLog(@"%@",number1);
    NSNumberFormatter *frmtr1 = [[NSNumberFormatter alloc] init];
    [frmtr1 setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr1 setGroupingSize:3];
    [frmtr1 setGroupingSeparator:@","];
    [frmtr1 setUsesGroupingSeparator:YES];
    NSString *commaString1 = [frmtr1 stringFromNumber:number1];
    commaString1=[commaString1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString1);
    
        oweTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString];
        paidTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString1];
        
        [chqueAmountArr addObject:numberFromTheKeyboard];
        [_arrayMutcheckNo addObject:strChequeNo];
        
        
        [_tableView reloadData];
        _tableView.hidden=NO;
        
        [chequeNoTextField resignFirstResponder];
    
    
}


#pragma mark UITABLEVIEW DELEGATE METHODS



// Customize the number of sections in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayMutcheckNo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell) {
            cell=nil;
            [cell removeFromSuperview];
            
        }
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChequeCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (CustomCell *) currentObject;
                    break;
                }
            }
        
        cell.selectionStyle=FALSE;
    }
    cell.checkAmountLbl.text=[chqueAmountArr objectAtIndex:indexPath.row];
    cell.chequeNumberLbl.text=[_arrayMutcheckNo objectAtIndex:indexPath.row];
    cell.removeButton.tag=indexPath.row;
    [cell.removeButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)refresh:(id)sender{
    
    float i;

     i=[sender tag];
    
    
    float t= [[chqueAmountArr objectAtIndex:i] floatValue];
    ////NSLog(@"%d",t);
    l=l+t;
    NSString *paidAmount=paidTextField.text;
    paidAmount=[paidAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];
    paidAmount=[paidAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    float s = [paidAmount floatValue];
    s = s - t;
    
    
    NSNumber *number = [NSNumber numberWithFloat:l];
    //NSLog(@"%@",number);
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    NSString *commaString = [frmtr stringFromNumber:number];
    commaString=[commaString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString);
    
    
    
    NSNumber *number1 = [NSNumber numberWithFloat:s];
    //NSLog(@"%@",number1);
    NSNumberFormatter *frmtr1 = [[NSNumberFormatter alloc] init];
    [frmtr1 setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr1 setGroupingSize:3];
    [frmtr1 setGroupingSeparator:@","];
    [frmtr1 setUsesGroupingSeparator:YES];
    NSString *commaString1 = [frmtr stringFromNumber:number1];
    commaString1=[commaString1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString1);

    
    
    
     oweTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString];
    paidTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString1];
    
    [_arrayMutcheckNo removeObjectAtIndex:i];
    [chqueAmountArr removeObjectAtIndex:i];
    [_tableView reloadData];
    
}

-(IBAction)chequeNo:(id)sender{
    
    
    /* CALL WEBSERVICE TO GET ALL THE CHECK AMOUNT FOR CHECK NUMBER IN LOCAL DATABASE */
    
    item2NewGlobal.enabled=NO;
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&countyID=%@",WEB_GET_CHECK_AMOUNT_BY_NUMBER,sessionID,countyIDforSearch]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:GET_CHECK_AMOUNT_BY_NUMBER:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse1) name:NOTIFICATION_GET_CHECK_AMOUNT_BY_NUMBER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
    
/***************************************************************************************/
    
    
       
    
}

-(IBAction)cashText:(id)sender{
    
    
    [cashTextField becomeFirstResponder];
    cashView.hidden=NO;
    
}


-(void)cancelPad{
    
    [cashTextField resignFirstResponder];
    [cashView setHidden:YES];
    
}
-(void)donePad{
    
    
    
    
    NSString *stringCommaRemove=oweTextField.text;
    stringCommaRemove=[stringCommaRemove stringByReplacingOccurrencesOfString:@"$" withString:@""];
    stringCommaRemove=[stringCommaRemove stringByReplacingOccurrencesOfString:@"," withString:@""];
    float k =[stringCommaRemove floatValue];
    NSString *strAmount=paidTextField.text;
    strAmount=[strAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strAmount=[strAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    float h = [strAmount floatValue];
    NSString *numberFromTheKeyboard = cashTextField.text;
    NSString *strChequeNo = @"CASH";
    chequeNoTextField.text=nil;
    checkAmmount.text=nil;
    
    float j =[numberFromTheKeyboard floatValue];
    
    
    
    
        l=k-j;
    ////NSLog(@"%d",l);
        h=h+j;
    ////NSLog(@"%d",h);
    
        
        
        cashView.hidden=YES;
        
        
    NSNumber *number = [NSNumber numberWithFloat:l];
    //NSLog(@"%@",number);
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    NSString *commaString = [frmtr stringFromNumber:number];
    commaString=[commaString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString);
        ////NSLog(@"%@",commaString);
        
        
    NSNumber *number1 = [NSNumber numberWithFloat:h];
    //NSLog(@"%@",number1);
    NSNumberFormatter *frmtr1 = [[NSNumberFormatter alloc] init];
    [frmtr1 setNumberStyle:NSNumberFormatterDecimalStyle];
    [frmtr1 setGroupingSize:3];
    [frmtr1 setGroupingSeparator:@","];
    [frmtr1 setUsesGroupingSeparator:YES];
    NSString *commaString1 = [frmtr stringFromNumber:number1];
    commaString1=[commaString1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
    //NSLog(@"%@",commaString1);
        
        oweTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString];
        paidTextField.text=[NSString stringWithFormat:@"%@ %@",@"$",commaString1];
        
        [chqueAmountArr addObject:numberFromTheKeyboard];
        [_arrayMutcheckNo addObject:strChequeNo];
        
        
        [_tableView reloadData];
        _tableView.hidden=NO;
        cashTextField.text=nil;
        [cashTextField resignFirstResponder];
    
}

-(IBAction)doneButton:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    
    NSString *paidAmount =paidTextField.text;
    
    paidAmount =[paidAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *appendingCheckNo;
    NSString *newStr;
    for (int i=0; i<[_arrayMutcheckNo count]; i++) {
        
        
        newStr=[_arrayMutcheckNo objectAtIndex:i];
        
        
        if ([appendingCheckNo hasSuffix:@"," ]) {
            
            appendingCheckNo=[appendingCheckNo stringByAppendingFormat:@"%@,",newStr];
        }else{
            
            appendingCheckNo=[newStr stringByAppendingFormat:@","];
        }
        
    }
    if ([appendingCheckNo hasSuffix:@","]) {
        
        appendingCheckNo = [appendingCheckNo substringToIndex:[appendingCheckNo length]-1];
        
    }else{
        
         appendingCheckNo= [appendingCheckNo substringFromIndex:1];
    }

    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@appName=%@&sessionId=%@&pid=%@&owe=%@&paid=%@&chkNums=%@",WEB_POST_PAYMENT_LIST,APP_NAME,sessionID,pID,oweSTR,paidAmount,appendingCheckNo]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////NSLog(@"SOAPMESS:::---%@",soapMessage);
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:POST_PAYMENT_LIST:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_POST_PAYMENT_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];    
}

-(void)getDeviceAunthnticityResponse{
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_POST_PAYMENT_LIST object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    if ([statuspaymentInfo isEqualToString:@"true"]) {
        
        
        documentButton.hidden=NO;
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"This Property has now been settled. Tap on DOCUMENT button to capture images of the reciept and checks." cancelButtonTitle:@"OK"];
        
        
    }else{
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Try again later" cancelButtonTitle:@"OK"];
        
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}

-(IBAction)documentButtonPressed:(id)sender{
    
    RecieptSubmitController *controller=[[RecieptSubmitController alloc] initWithNibName:@"RecieptSubmitController" bundle:nil];
    controller.propertyID=pID;
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
