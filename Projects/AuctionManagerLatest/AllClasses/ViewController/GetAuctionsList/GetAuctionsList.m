//
//  GetAuctionsList.m
//  PropertyInspector
//
//  Created by apple on 10/22/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "GetAuctionsList.h"
#import "BusyAgent.h"
#import "LoginModel.h"
#import "ThreadManager.h"
#import "GetTrusteesListModel.h"
#import "AlertManger.h"
#import "CustomCell.h"
#import "PropertYDescription.h"
#import "DAL.h"
#import "SettleNowViewController.h"
#import "AuctionStatusController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;


@interface GetAuctionsList ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    BOOL found;
    DAL *dt;
    IBOutlet UIView *editProfileView;
    IBOutlet UIButton *editDoneButton;
    UITextField *globleTextField;
    NSString *crierName;
    NSString *trusteeNoSending;
    NSString *openingBidSending;
    NSString *propertyIdSending;
    IBOutlet UITextField *borroweNameField;
    IBOutlet UITextField *trusteeNumberFiled;
    IBOutlet UITextField *openingBidField;
    IBOutlet UITextField *criedByTextField;
    IBOutlet UIView *searchView;
    IBOutlet UITextField *_textFieldSearch;
    BOOL SEARCHPRESSED;
    NSMutableArray *tableData;
    UIToolbar *toolBar;
    UIToolbar *toolBar1;
    UIPickerView *pickerView;
    UIPickerView *pickerView1;
    NSMutableArray *bidArray;
    NSMutableArray *bidArray1;
    int cID;
    NSString *searchType;
    NSString *searchType1;
}

@property(nonatomic,strong)NSMutableDictionary *sections;
@property(nonatomic,strong)IBOutlet UITableView *_tableView;
@property(nonatomic,strong)IBOutlet UITableView *_tableViewTrustee;
@end

@implementation GetAuctionsList

CGFloat animatedDistance;
@synthesize propertyIDARR;
@synthesize countyID;
@synthesize _tableView;
@synthesize sections;
@synthesize _tableViewTrustee;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        if (tableData!=nil) {
            
            tableData=nil;
            [tableData removeAllObjects];
        }
        
        tableData=[[NSMutableArray alloc] init];
        
        if (bidArray!=nil) {
            bidArray=nil;
            [bidArray removeAllObjects];
        }
        bidArray=[[NSMutableArray alloc] init];
        
        
        if (bidArray1!=nil) {
            bidArray1=nil;
            [bidArray1 removeAllObjects];
        }
        bidArray1=[[NSMutableArray alloc] init];
        
        propertyID_Dict=[[NSMutableDictionary alloc] init];
        propertyID_Arr=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    trusteeIDBadExcess=trusteeID;
    
    statusBar.enabled=YES;
    
    searchTwo.hidden=YES;
    _textFieldSearch.hidden=NO;
    cancleSearchButtonOne.hidden=NO;
    cancleSearchButtonTwo.hidden=YES;
    
    
       
/* TOOLBAR1 IS FOR SORETING PICKER'S TOOLBAR */
    
    toolBar1=[[UIToolbar alloc] init];
    toolBar1.frame=CGRectMake(0,520, 320, 44);
    toolBar1.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview:toolBar1];
    
	UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
    
	NSArray *buttons = [NSArray arrayWithObjects: item1, item2, nil];
    [toolBar1 setItems: buttons animated:NO];
    
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.frame=CGRectMake(0, 520, 320, 216);
    pickerView.backgroundColor=[UIColor grayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    bidArray=[[NSMutableArray alloc]initWithObjects:@"BORROWER NAME",@"CRY NUMBER",@"CITY",@"TRUSTEE NAME",@"ADDRESS",@"DATE",@"LEGAL DESCRIPTION", nil];
    
    
/************************************************************************************************************************************/ 
  
    
/* TOOLBAR IS FOR SEARCHING PICKER'S TOOLBAR */
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    toolBar.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview:toolBar];

    
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed1)];
    
	UIBarButtonItem *item12 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed1)];
    
	NSArray *buttons1 = [NSArray arrayWithObjects: item11, item12, nil];
    [toolBar setItems: buttons1 animated:NO];
    
  
    pickerView1 = [[UIPickerView alloc] init];
    pickerView1.frame=CGRectMake(0, 520, 320, 216);
    pickerView1.backgroundColor=[UIColor grayColor];
    pickerView1.delegate = self;
    pickerView1.dataSource = self;
    pickerView1.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView1];
    [pickerView1 selectRow:0 inComponent:0 animated:NO];
    
/************************************************************************************************************************************/
    
/* SELECTEDINDEX AND SEARCHPRESSED*/

    selectedIndex = -1;
    SEARCHPRESSED=FALSE;
    searchView.alpha=0;
    
    insertDatabseStr=@"1";
    
    if ([XIBchange isEqualToString:@"0"]) {
    
    _tableViewTrustee.alpha=0;
        
        
        UIBarButtonItem *button1 = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                   target:self
                                   action:@selector(newRefresh:)];
        self.navigationItem.rightBarButtonItem = button1;

    self.navigationItem.title=@"Trustees";
        
        dt=[DAL getInstance];
        [dt getAllSubCategorybyId1:GET_ALL_TRSUTEE];
        _arrTrusees=[databaseArray copy];
        
    }else if ([XIBchange isEqualToString:@"1"]) {
        searchGlobal.enabled=YES;
        _tableView.alpha=0;
        UIBarButtonItem *button2 = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                   target:self
                                   action:@selector(newRefresh:)];
        self.navigationItem.rightBarButtonItem = button2;

        self.navigationItem.title=@"All Properties";
        
    }else if ([XIBchange isEqualToString:@"3"]){
        
        XIBchange=@"1";
        dt=[DAL getInstance];
        
        [dt getAllSubCategorybyId:trusteeID :GET_RECORDS_TRUSTEE_ID];
        
        _arrTrusees=[databaseArray copy];
        
    }else if ([XIBchange isEqualToString:@"4"]){
        
        statusBar.enabled=NO;
        searchGlobal.enabled=NO;
        dt=[DAL getInstance];
        for (int count=0;count<[propertyIDARRGlobal count]; count++) {
            
            propertyID_Dict=[dt getAllSubCategorybyPropertyID:[[propertyIDARRGlobal valueForKey:@"PROPERTYID"] objectAtIndex:count] :GET_RECORDS_PROPERTY_ID];
            
            [propertyID_Arr addObject:propertyID_Dict];
            
        }
        
        _arrTrusees=propertyID_Arr;
        
        
        [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
        
    }
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    ////NSLog(@"%@",_arrTrusees);
    [self gettrusteesList];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    
    
    if ([pushPOPStr isEqualToString:@"1"]) {
        
        pushPOPStr =@"0";
        
        searchTwo.hidden=YES;
        _textFieldSearch.hidden=NO;
        cancleSearchButtonOne.hidden=NO;
        cancleSearchButtonTwo.hidden=YES;
        /* TOOLBAR1 IS FOR SORETING PICKER'S TOOLBAR */
        
        toolBar1=[[UIToolbar alloc] init];
        toolBar1.frame=CGRectMake(0,520, 320, 44);
        toolBar1.barStyle=UIBarStyleBlackTranslucent;
        [self.view addSubview:toolBar1];
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
        
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
        
        NSArray *buttons = [NSArray arrayWithObjects: item1, item2, nil];
        [toolBar1 setItems: buttons animated:NO];
        
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.frame=CGRectMake(0, 520, 320, 216);
        pickerView.backgroundColor=[UIColor grayColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        
        [self.view addSubview:pickerView];
        [pickerView selectRow:0 inComponent:0 animated:NO];
        bidArray=[[NSMutableArray alloc]initWithObjects:@"BORROWER NAME",@"CRY NUMBER",@"CITY",@"TRUSTEE NAME",@"ADDRESS",@"DATE",@"LEGAL DESCRIPTION", nil];
        //AUCTION_NUMBER
        //TRUSTEE_NAME
        
        /************************************************************************************************************************************/
        
        
        /* TOOLBAR IS FOR SEARCHING PICKER'S TOOLBAR */
        
        toolBar=[[UIToolbar alloc] init];
        toolBar.frame=CGRectMake(0,520, 320, 44);
        toolBar.barStyle=UIBarStyleBlackTranslucent;
        [self.view addSubview:toolBar];
        
        
        UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed1)];
        
        UIBarButtonItem *item12 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed1)];
        
        NSArray *buttons1 = [NSArray arrayWithObjects: item11, item12, nil];
        [toolBar setItems: buttons1 animated:NO];
        
        
        pickerView1 = [[UIPickerView alloc] init];
        pickerView1.frame=CGRectMake(0, 520, 320, 216);
        pickerView1.backgroundColor=[UIColor grayColor];
        pickerView1.delegate = self;
        pickerView1.dataSource = self;
        pickerView1.showsSelectionIndicator = YES;
        
        [self.view addSubview:pickerView1];
        [pickerView1 selectRow:0 inComponent:0 animated:NO];
        
        /************************************************************************************************************************************/
        
        selectedIndex = -1;
        SEARCHPRESSED=FALSE;
        searchView.alpha=0;
        
        insertDatabseStr=@"1";
        
        if ([XIBchange isEqualToString:@"0"]) {
            
            _tableViewTrustee.alpha=0;
            
            
            UIBarButtonItem *button1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                        target:self
                                        action:@selector(newRefresh:)];
            self.navigationItem.rightBarButtonItem = button1;
            
            self.navigationItem.title=@"Trustees";
            
            dt=[DAL getInstance];
            [dt getAllSubCategorybyId1:GET_ALL_TRSUTEE];
            _arrTrusees=[databaseArray copy];
            
            
        }else if ([XIBchange isEqualToString:@"1"]) {
            
            _tableView.alpha=0;
            UIBarButtonItem *button2 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                        target:self
                                        action:@selector(newRefresh:)];
            self.navigationItem.rightBarButtonItem = button2;
            
            self.navigationItem.title=@"All Properties";
            
        }else if ([XIBchange isEqualToString:@"3"]){
            
            XIBchange=@"1";
            dt=[DAL getInstance];
            
            [dt getAllSubCategorybyId:trusteeID :GET_RECORDS_TRUSTEE_ID];
            
            _arrTrusees=[databaseArray copy];
            
        }else if ([XIBchange isEqualToString:@"4"]){
            
            self.navigationItem.title=@"All Properties";
            statusBar.enabled=NO;
            
            if (propertyID_Dict!=nil) {
                
                propertyID_Dict=nil;
                [propertyID_Dict removeAllObjects];
                
            }
            propertyID_Dict=[[NSMutableDictionary alloc] init];
            
            if (propertyID_Arr!=nil) {
                propertyID_Arr=nil;
                [propertyID_Arr removeAllObjects];
            }
            propertyID_Arr =[[NSMutableArray alloc] init];
            
            dt=[DAL getInstance];
            for (int count=0;count<[propertyIDARRGlobal count]; count++) {
                
                propertyID_Dict=[dt getAllSubCategorybyPropertyID:[propertyIDARRGlobal objectAtIndex:count] :GET_RECORDS_PROPERTY_ID];
                
                [propertyID_Arr addObject:propertyID_Dict];
                
                [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
                
            }
            
            
            
            
        }
        [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
        
        
        [self gettrusteesList];

        
    }else{
        
        self.navigationItem.title=@"All Properties";
    }   
}


-(void)viewDidDisappear:(BOOL)animated
{
    //[locManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
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


-(void)CanclePressed1
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerView1.frame=CGRectMake(0,520, 320, 216);
    [UIView commitAnimations];
    
}
-(void)DonePressed1
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerView1.frame=CGRectMake(0,520, 320, 216);
    [UIView commitAnimations];
    
    
    searchType1=[bidArray objectAtIndex:cID];
    
    if ([searchType1 isEqualToString:@"BORROWER NAME"]) {
        
        searchType1=@"BROOWER_NAME";
        
    }
    if ([searchType1 isEqualToString:@"CRY NUMBER"]) {
        
        searchType1=@"AUCTION_NUMBER";
        
    }
    if ([searchType1 isEqualToString:@"TRUSTEE NAME"]) {
        
        searchType1=@"TRUSTEE_NAME";
        
    }
    if ([searchType1 isEqualToString:@"LEGAL DESCRIPTION"]) {
        
        searchType1=@"LEGAL_DESCRIPTION";
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
    [self getsortResult];
    
}



-(void)CanclePressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar1.frame=CGRectMake(0,520, 320, 44);
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
    toolBar1.frame=CGRectMake(0,520, 320, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerView.frame=CGRectMake(0,520, 320, 216);
    [UIView commitAnimations];
    
    
    searchType=[bidArray objectAtIndex:cID];
    
    if ([searchType isEqualToString:@"BORROWER NAME"]) {
        
        searchType=@"BROOWER_NAME";
        
    }
    
    if ([searchType isEqualToString:@"CRY NUMBER"]) {
        
        searchType=@"AUCTION_NUMBER";
        
    }
    if ([searchType isEqualToString:@"TRUSTEE NAME"]) {
        
        searchType=@"TRUSTEE_NAME";
        
    }
    if ([searchType isEqualToString:@"LEGAL DESCRIPTION"]) {
        
        searchType=@"LEGAL_DESCRIPTION";
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    searchView.alpha=1;
    [UIView commitAnimations];
    [self gettrusteesList];
    
    
    
}



-(IBAction)globalSearchPressed:(id)sender{
    
    [self.view addSubview:globalSearchView];
    globalSearchView.alpha=0;
    globalSearchView.frame=CGRectMake(0,44,320, 30);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    
    globalSearchView.alpha=1;
    
    [UIView commitAnimations];
    
    [_globalSearchTextField becomeFirstResponder];
    
}


-(IBAction)removeGlobalSearch:(id)sender{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    globalSearchView.alpha=0;
    [UIView commitAnimations];
    _globalSearchTextField.text=@"";
    [globalSearchView removeFromSuperview];
    dt=[DAL getInstance];
    _arrTrusees=[dt getAllSubCategory:countyID];
    [self gettrusteesList];
}


-(void)refresh:(id)sender{
    
    getTableReload=@"TRUE";
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshList" object:nil];
   
}

-(void)newRefresh:(id)sender{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gettrusteesList) name:@"NewList" object:nil];
    
}


-(void)gettrusteesList{
    

    
    sections=[[NSMutableDictionary alloc] init];
    
    
    if ([_arrTrusees count]==0) {
        
        //[[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"NO RECORDS ARE AVAILABLE." cancelButtonTitle:@"OK"];
        
        
    }else{
        
        if ([XIBchange isEqualToString:@"0"]) {
            
        for (NSDictionary *book in _arrTrusees)
        {
            
            if([book objectForKey:@"TRUSTEE_NAME"]==nil || [[book objectForKey:@"TRUSTEE_NAME"] isEqualToString:@""]){
            
                
            
            }else{
                
                NSString *c = [[[book objectForKey:@"TRUSTEE_NAME"] uppercaseString] substringToIndex:1];
                
                found = NO;
                
                for (NSString *str in [sections allKeys])
                {
                    if ([str caseInsensitiveCompare:c]==NSOrderedSame)
                    {
                        found = YES;
                    }
                }
                
                if (!found)
                {
                    [sections setValue:[[NSMutableArray alloc] init] forKey:c];
                }

                
                
            }
        }
        // Loop again and sort the books into their respective keys
        for (NSDictionary *book in _arrTrusees)
        {
            if([book objectForKey:@"TRUSTEE_NAME"]==nil || [[book objectForKey:@"TRUSTEE_NAME"] isEqualToString:@""]){
            
            
                
            }else{
                
                [[sections objectForKey:[[[book objectForKey:@"TRUSTEE_NAME"] uppercaseString] substringToIndex:1]] addObject:book];
                
            }
            
        }
        
        
        // Sort each section array
        for (NSString *key in [sections allKeys])
        {
            [sections objectForKey:[key uppercaseString]];
        }
        
    
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    _tableViewTrustee.alpha=1;
    [UIView commitAnimations];
    [_tableViewTrustee reloadData];

        }else{
        
        for (NSDictionary *book in _arrTrusees)
        {
            
            if([book objectForKey:@"BROOWER_NAME"]==nil || [[book objectForKey:@"BROOWER_NAME"] isEqualToString:@""]){
                
                
                
//                [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Brrower's Information is not available." cancelButtonTitle:@"OK"];
//                goto switchLable;
//                break;
                
            
            }else{
                
                NSString *c = [[[book objectForKey:@"BROOWER_NAME"] uppercaseString] substringToIndex:1];
                
                found = NO;
                
                for (NSString *str in [sections allKeys])
                {
                    if ([str caseInsensitiveCompare:c]==NSOrderedSame)
                    {
                        found = YES;
                    }
                }
                
                if (!found)
                {
                    [sections setValue:[[NSMutableArray alloc] init] forKey:c];
                }
                
                
                
            }
            
        }
        // Loop again and sort the books into their respective keys
        for (NSDictionary *book in _arrTrusees)
        {
            
            
            if([book objectForKey:@"BROOWER_NAME"]==nil || [[book objectForKey:@"BROOWER_NAME"] isEqualToString:@""]){
                
               
                
            }else{
                
                [[sections objectForKey:[[[book objectForKey:@"BROOWER_NAME"] uppercaseString] substringToIndex:1]] addObject:book];
                
            }

            
        }
        
        
        // Sort each section array
        for (NSString *key in [sections allKeys])
        {
            [sections objectForKey:[key uppercaseString]];
        }
        
    
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        _tableView.alpha=1;
        [UIView commitAnimations];
        [_tableView reloadData];
        
      }
    }
    
    switchLable:
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}



#pragma mark SORT RESULT


-(void)getsortResult{
    
    
    //////NSLog(@"%@",searchType1);
    
    if ([sections count]>0) {
        
        [sections removeAllObjects];
    }
    
    
    
    for (NSDictionary *book in _arrTrusees)
    {
        
        if(![[book objectForKey:searchType1] isEqualToString:@""]){
            
            NSString *c = [[[book objectForKey:searchType1] uppercaseString] substringToIndex:1];
            
            found = NO;
            
            for (NSString *str in [sections allKeys])
            {
                if ([str caseInsensitiveCompare:c]==NSOrderedSame)
                {
                    found = YES;
                }
            }
            
            if (!found)
            {
                [sections setValue:[[NSMutableArray alloc] init] forKey:c];
            }
        }else{
            
            ////NSLog(@"Gaurav");
            
        }
        
    }
    // Loop again and sort the books into their respective keys
    for (NSDictionary *book in _arrTrusees)
    {
        if(![[book objectForKey:searchType1] isEqualToString:@""]){
            
            [[sections objectForKey:[[[book objectForKey:searchType1] uppercaseString] substringToIndex:1]] addObject:book];
        }else{
            
            
            //////NSLog(@"Gaurav");
            
        }
        
        
    }
    
    
    // Sort; each section array
    for (NSString *key in [sections allKeys])
    {
       // [sections objectForKey:[key uppercaseString]];
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:searchType1 ascending:YES]]];
    }
    
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    _tableView.alpha=1;
    [UIView commitAnimations];
    [_tableView reloadData];
    
    
    
}




#pragma mark UITABLEVIEW DELEGATE METHODS



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    keyboardBOOL=NO;
    if (tableView==_tableView) {
        
    
        
    if(selectedIndex == indexPath.row)
    {
        
        selectedIndex = -1;
        [editProfileView removeFromSuperview];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        rowPath=indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
        
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        crierName=[book valueForKey:@"CRIER_NAME"];
        trusteeNoSending=[book valueForKey:@"TRUSTEE_ID"];
        openingBidSending=[book valueForKey:@"OPENING_BID"];
        propertyIdSending=[book valueForKey:@"ID"];
        
        
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    rowPath=indexPath;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row && rowPath.section==indexPath.section)
    {
        return 105+164 ;
    }
    else {
        return 105;
    }
    
    
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[sections allKeys] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[sections valueForKey:[[[sections allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CustomCell";
     CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView==_tableView) {
    
   
    
    if (cell) {
        cell=nil;
        [cell removeFromSuperview];
        
    }
       
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell *) currentObject;
				break;
			}
		}
	}
        if(selectedIndex == indexPath.row && rowPath.section==indexPath.section)
        {
            
            
            editProfileView.frame=CGRectMake(0,cell.frame.size.height , 320, 164);
            [cell addSubview:editProfileView];
            cell.frame = CGRectMake(cell.frame.origin.x,
                                    cell.frame.origin.y,
                                    cell.frame.size.width,
                                    cell.frame.size.height+164);
        }
        else {
            
            //Otherwise just return the minimum height for the label.
            
            
            cell.frame = CGRectMake(cell.frame.origin.x,
                                    cell.frame.origin.y,
                                    cell.frame.size.width,
                                    cell.frame.size.height);
            
            
        }
        
       
        
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        if ([[book valueForKey:@"SETTLE_STATUS"] isEqualToString:@"SETTLE_LATER"]) {
            
            cell.bidStatus.text=@"W";
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self
                       action:@selector(aMethod:)
             forControlEvents:UIControlEventTouchDown];
            
            button.frame = CGRectMake(4.0, 23.0, 25.0, 25.0);
            [cell addSubview:button];
            
            cell.bidStatus.textColor=[UIColor colorWithRed:237.0/255.0 green:207.0/255.0 blue:36.0/255.0 alpha:1];
            
        }else if ([[book valueForKey:@"SETTLE_STATUS"] isEqualToString:@"SETTLED"]){
            
            cell.bidStatus.text=@"W";
            cell.bidStatus.textColor=[UIColor greenColor];            
            
        }else if ([[book valueForKey:@"STATUS"] isEqualToString:@"LOST"]){
            
            cell.bidStatus.text=@"L";
            cell.bidStatus.textColor=[UIColor redColor];
            
        }else{
            
            
            cell.bidStatus.text=@" ";
        }
        
        
        
        
        if ([[book valueForKey:@"STATUS"] isEqualToString:@"CANCELLED"] || [[book valueForKey:@"STATUS"] isEqualToString:@"MISSED"] || [[book valueForKey:@"STATUS"] isEqualToString:@"POSTPONED"] || [[book valueForKey:@"STATUS"] isEqualToString:@"OPEN BID HIGH"]){
            
            cell.bidStatus.text=@"C";
            cell.bidStatus.textColor=[UIColor blackColor];
            
        }
        
    cell.auctionLable.text=[book valueForKey:@"AUCTION_NUMBER"];
    cell.trusteeName.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"TRUSTEE_NAME"]];
    cell.titleLbl.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"ADDRESS"]];
    cell.detailLabl.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"CITY"]];
    cell.nameLbl.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"BROOWER_NAME"]];
    cell.lblDate.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"DATE"]];
    cell.lblLegalDescription.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"LEGAL_DESCRIPTION"]];
        
        
	cell.selectionStyle=FALSE;
        
    }
    
    else if(tableView==_tableViewTrustee){
        
        if (cell) {
            cell=nil;
            [cell removeFromSuperview];
            
        }
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCellTwo" owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (CustomCell *) currentObject;
                    break;
                }
            }
        }
        
                
        NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        cell.titleLbl.text=[NSString stringWithFormat:@"%@",[book valueForKey:@"TRUSTEE_NAME"]];

        cell.selectionStyle=FALSE;
        
        
    }
    
    return cell;
}

-(void)aMethod:(id)sender{
    
	UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
	//From the cell get its index path.
    NSIndexPath *pathToCell = [self._tableView indexPathForCell:owningCell];
     NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:pathToCell.section]] objectAtIndex:pathToCell.row];
    propID=[book valueForKey:@"ID"];
    WONPRIZE=[book valueForKey:@"WON_PRIZE"];
    auctID=[book valueForKey:@"AUCTION_ID"];
    [self SENDSTATUS:nil];
    SettleNowViewController *controller=[[SettleNowViewController alloc] initWithNibName:@"SettleNowViewController" bundle:nil];
    controller.pID=[book valueForKey:@"ID"];
    controller.oweSTR=[book valueForKey:@"WON_PRIZE"];
    navigateSTR=@"1";
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
}


//https://206.246.135.196/AH4RMAuction/updateQualifiedProperty.aspx?sessionId=%@&pid=1&bidStatus=LOST&settleStatus=&lostPrice=90000

-(void)SENDSTATUS:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&auctionId=%@&settleStatus=%@&wonPrice=%@&bidStatus=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propID,auctID,@"SETTLED",WONPRIZE,@"WON"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse1) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
}



-(void)getDeviceAunthnticityResponse1{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    if ([status isEqualToString:@"true"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"You are about to settle this property." cancelButtonTitle:@"OK"];
        });
    }
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [_tableView reloadData];
    [globleTextField resignFirstResponder];
    
    if (tableView==_tableView) {
        
        PropertYDescription *controller=[[PropertYDescription alloc] initWithNibName:@"PropertYDescription" bundle:nil];
        controller.propertyID=[book valueForKey:@"ID"];
        self.navigationItem.title=@"Back";
        [self.navigationController pushViewController:controller animated:YES];

        
    }else{
        
        
        trusteeID=[book valueForKey:@"TRUSTEE_ID"];
        XIBchange=@"3";
        
        NSArray *nibObjs = [[NSBundle mainBundle] loadNibNamed:@"GetAuctionsList" owner:self options:nil];
        UIView *aView = [nibObjs objectAtIndex:0];
        self.view = aView;
        [self loadDatabase];
        
    }
    
}

-(void)loadDatabase{
    
    
    searchGlobal.enabled=NO;
    searchView.alpha=0;
    _textFieldSearch.hidden=YES;
    searchTwo.hidden=NO;
    cancleSearchButtonOne.hidden=YES;
    cancleSearchButtonTwo.hidden=NO;
    
/* TOOLBAR1 IS FOR SORETING PICKER'S TOOLBAR */
    
    toolBar1=[[UIToolbar alloc] init];
    toolBar1.frame=CGRectMake(0,520, 320, 44);
    toolBar1.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview:toolBar1];
    
	UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
    
	NSArray *buttons = [NSArray arrayWithObjects: item1, item2, nil];
    [toolBar1 setItems: buttons animated:NO];
    
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.frame=CGRectMake(0, 520, 320, 216);
    pickerView.backgroundColor=[UIColor grayColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    bidArray=[[NSMutableArray alloc]initWithObjects:@"BORROWER NAME",@"CRY NUMBER",@"CITY",@"TRUSTEE NAME",@"ADDRESS", nil];
    
    
/************************************************************************************************************************************/
    
    
/* TOOLBAR IS FOR SEARCHING PICKER'S TOOLBAR */
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(0,520, 320, 44);
    toolBar.barStyle=UIBarStyleBlackTranslucent;
	[self.view addSubview:toolBar];
    
    
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed1)];
    
	UIBarButtonItem *item12 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed1)];
    
	NSArray *buttons1 = [NSArray arrayWithObjects: item11, item12, nil];
    [toolBar setItems: buttons1 animated:NO];
    
    
    pickerView1 = [[UIPickerView alloc] init];
    pickerView1.frame=CGRectMake(0, 520, 320, 216);
    pickerView1.backgroundColor=[UIColor grayColor];
    pickerView1.delegate = self;
    pickerView1.dataSource = self;
    pickerView1.showsSelectionIndicator = YES;
    
    [self.view addSubview:pickerView1];
    [pickerView1 selectRow:0 inComponent:0 animated:NO];
    
    /************************************************************************************************************************************/

    
    
    if (_arrTrusees!=nil) {
        
        _arrTrusees=nil;
        [_arrTrusees removeAllObjects];
    }
    _arrTrusees=[[NSMutableArray alloc] init];
    
    if ([XIBchange isEqualToString:@"3"]){
        
        XIBchange=@"1";
        dt=[DAL getInstance];
        
        [dt getAllSubCategorybyId:trusteeID :GET_RECORDS_TRUSTEE_ID];
        
        _arrTrusees=[databaseArray copy];
        
    }
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    [self gettrusteesList];
    
    
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] indexOfObject:title];
    
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField==openingBidField) {
        
        identfyKeyBoard=YES;
    }else{
        
        identfyKeyBoard=NO;
    }
    
    
    
    if(textField==openingBidField || textField==trusteeNumberFiled)
    {
        doneButton.hidden = NO;
        phoneTagOrNot = FALSE;
    }
    else
    {
        doneButton.hidden = YES;
        phoneTagOrNot = TRUE;
    }
    
    
    globleTextField=textField;
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

- (void)keyboardWillShow:(NSNotification *)note
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
        [self addButtonToKeyboard];
    }
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
    {
        [self addButtonToKeyboard];
    }
}


#pragma mark - Add Keyboard
- (void)addButtonToKeyboard
{
    // create custom button
    
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    
    doneButton.adjustsImageWhenHighlighted = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0)
    {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    }
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
    
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    UIView *keyboard;
    
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        // keyboard found, add the button
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                
                if (keyboardBOOL!=YES) {
                    
                    [keyboard addSubview:doneButton];
                    
                }
            
        } else {
            
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                
                if (keyboardBOOL!=YES) {
                    
                    [keyboard addSubview:doneButton];
                    
                }
                    
            
            
            
        }
        if (phoneTagOrNot == TRUE) {
            doneButton.hidden = TRUE;
        }
    }
}

- (void)doneButton:(id)sender
{
    
    if (identfyKeyBoard==YES) {
        
        
        [openingBidField resignFirstResponder];
        
    }else{
    
        keyboardBOOL=YES;
        [trusteeNumberFiled resignFirstResponder];
        trusteeNumberFiled.keyboardType = UIKeyboardTypeDefault;
        [trusteeNumberFiled becomeFirstResponder];
        keyboardBOOL=NO;
        trusteeNumberFiled.keyboardType = UIKeyboardTypeNumberPad;
        
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
    
    if (textField==_textFieldSearch) {
        
        
        if ([tableData count]>0) {
            [tableData removeAllObjects];
        }
        NSInteger counter = 0;
        
        
        
        for(NSDictionary *s in _arrTrusees) {
            
            if ([string isEqualToString:@""]) {
                
                NSString *strCC = [_textFieldSearch.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
                
                if (strCC.length==0) {
                    
                    dt=[DAL getInstance];
                    tableData=[dt getAllSubCategory:countyIDforSearch];
                    
                }else
                {
                    NSString *strS = [s valueForKey:searchType];
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
                NSString *strS = [s valueForKey:searchType];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {
                    
                    [tableData addObject:s];
                }
                counter++;
                
            }        
        }
        
        
        if ([tableData count]>0) {
            
            _arrTrusees=[tableData copy];
            [self gettrusteesList];
            
        }else{
            
            [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"No items available with this character." cancelButtonTitle:@"OK"];
        }
        
   
    
}else if(textField==searchTwo){
        
        
        if ([tableData count]>0) {
            [tableData removeAllObjects];
        }
        NSInteger counter = 0;
    
    
        for(NSDictionary *s in _arrTrusees) {
            
            if ([string isEqualToString:@""]) {
                
                NSString *strCC = [searchTwo.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
                
                if (strCC.length==0) {
                    
                    dt=[DAL getInstance];
                    [dt getAllSubCategorybyId:trusteeID :GET_RECORDS_TRUSTEE_ID];
                    _arrTrusees=databaseArray;
                    tableData=_arrTrusees;
                    
                }else
                {
                    NSString *strS = [s valueForKey:searchType];
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
                NSString *strS = [s valueForKey:searchType];
                NSRange r = [[strS lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound && r.location==0) {
                    
                    [tableData addObject:s];
                }
                counter++;
                
            }
        }
        
        if ([tableData count]>0) {
            
            _arrTrusees=[tableData copy];
            [self gettrusteesList];
            
        }else{
            
            [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"No items available with this character." cancelButtonTitle:@"OK"];
        }

        
        
        
        
}else if (textField==_globalSearchTextField){
    
    search1=search2=search3=search4=search5=search6=search7=0;
    
    
    if ([tableData count]>0) {
        [tableData removeAllObjects];
    }
    NSInteger counter = 0;
    
    
    
    
    for(NSDictionary *s in _arrTrusees) {
        
        if ([string isEqualToString:@""]) {
            
            NSString *strCC = [_globalSearchTextField.text substringWithRange:NSMakeRange(0, textField.text.length-1)];
            
            if (strCC.length==0) {
                
                dt=[DAL getInstance];
                _arrTrusees=[dt getAllSubCategory:countyID];
                tableData=_arrTrusees;

                
            }else
            {       
                NSString *strS = [s valueForKey:@"BROOWER_NAME"];
                NSString *strS1 = [s valueForKey:@"AUCTION_NUMBER"];
                NSString *strS2 = [s valueForKey:@"CITY"];
                NSString *strS3 = [s valueForKey:@"TRUSTEE_NAME"];
                NSString *strS4 = [s valueForKey:@"ADDRESS"];
                NSString *strS5 = [s valueForKey:@"DATE"];
                NSString *strS6 = [s valueForKey:@"LEGAL_DESCRIPTION"];
                NSString *globalString=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",strS,strS1,strS2,strS3,strS4,strS5,strS6];
                NSRange r = [[globalString lowercaseString] rangeOfString:[strCC lowercaseString]];
                if(r.location != NSNotFound) {
                    [tableData addObject:s];
                }
                
                counter++;
                
            }
        }else if ([string isEqualToString:@"\n"])
        {
            
        }else{            
            
            NSString *strCC = [textField.text stringByAppendingString:string];
            NSString *strS = [s valueForKey:@"BROOWER_NAME"];
            NSString *strS1 = [s valueForKey:@"AUCTION_NUMBER"];
            NSString *strS2 = [s valueForKey:@"CITY"];
            NSString *strS3 = [s valueForKey:@"TRUSTEE_NAME"];
            NSString *strS4 = [s valueForKey:@"ADDRESS"];
            NSString *strS5 = [s valueForKey:@"DATE"];
            NSString *strS6 = [s valueForKey:@"LEGAL_DESCRIPTION"];
            NSString *globalString=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",strS,strS1,strS2,strS3,strS4,strS5,strS6];
            NSRange r = [[globalString lowercaseString] rangeOfString:[strCC lowercaseString]];
            if(r.location != NSNotFound) {

                [tableData addObject:s];
            }

            
            counter++;
            
        }
    }
    
    if ([tableData count]>0) {
        
        _arrTrusees=[tableData copy];
        [self gettrusteesList];
        
    }else{
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"No items available with this character." cancelButtonTitle:@"OK"];
    }
    
}
    
    
    return YES;
}


-(IBAction)DonePressed:(id)sender{
    
    NSString *borrowerNameSR=borroweNameField.text;
    NSString *trusteeNameStr=trusteeNumberFiled.text;
    NSString *openingBIdStr=openingBidField.text;
    
    borrowerNameSR = [borrowerNameSR stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trusteeNameStr = [trusteeNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    openingBIdStr  = [openingBIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
        
        [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
        
        NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&pid=%@&auctionNo=%@&borrower=%@&openingBid=%@&crier=%@",UPDATE_QUALIFIED_PROPERTY,sessionID,propertyIdSending,trusteeNumberFiled.text,borroweNameField.text,openingBidField.text,criedByTextField.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    
        NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
        
        [[ThreadManager getInstance]makeRequest:REQ_UPDATE_PROPERTY:soapMessage:tData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];

}


-(void)selectedIndexMethod{
    
    selectedIndex=-1;
    
}

-(void)getDeviceAunthnticityResponse{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_UPDATE_PROPERTY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    if ([status isEqualToString:@"true"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refresh:nil];
            dt=[DAL getInstance];
            _arrTrusees=[dt getAllSubCategory:countyID];            
            borroweNameField.text=@"";
            trusteeNumberFiled.text=@"";
            openingBidField.text=@"";
            criedByTextField.text=@"";
            [globleTextField resignFirstResponder];
            selectedIndex=1000000;
            [self selectedIndexMethod];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(gettrusteesList) name:@"gettrusteesList" object:nil];
            [_tableView reloadData];
            
            
        });        
    }
}


-(IBAction)searchButtonPressed:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar1.frame=CGRectMake(0,203, 320, 44);
    pickerView.frame=CGRectMake(0,245, 320, 216);
    [UIView commitAnimations];
    [pickerView reloadAllComponents];

}


-(IBAction)sortButtonPressed:(id)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(0,203, 320, 44);
    pickerView1.frame=CGRectMake(0,245, 320, 216);
    [UIView commitAnimations];
    [pickerView1 reloadAllComponents];
    
}


-(IBAction)cancelSearch:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    searchView.alpha=0;
    [UIView commitAnimations];
    _textFieldSearch.text=@"";
    searchTwo.text=@"";
    [_textFieldSearch resignFirstResponder];
    [searchTwo resignFirstResponder];
    
    dt=[DAL getInstance];
    _arrTrusees=[dt getAllSubCategory:countyIDforSearch];
    [self gettrusteesList];
    
}

-(IBAction)removeSearch:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    searchView.alpha=0;
    [UIView commitAnimations];
    [_textFieldSearch resignFirstResponder];
    [searchTwo resignFirstResponder];
    _textFieldSearch.text=@"";
    searchTwo.text=@"";
    dt=[DAL getInstance];
    [dt getAllSubCategorybyId:trusteeID :GET_RECORDS_TRUSTEE_ID];
    _arrTrusees=[databaseArray copy];
    [self gettrusteesList];
    
}


-(void)busyViewinSecondryThread:(id)sender{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
