//
//  HomeViewController.m
//  PropertyInspector
//
//  Created by apple on 10/16/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginModel.h"
#import "ThreadManager.h"
#import "GetVersionModel.h"
#import "BusyAgent.h"
#import "AlertManger.h"
#import "GetCountyListModel.h"
#import "InfoViewController.h"
#import "SettingViewController.h"   
#import "GetAuctionStatusModel.h"

@class InfoViewController;

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    BOOL found;
}
@property(nonatomic,strong)NSMutableDictionary *sortDictioary;
@property(nonatomic,strong)IBOutlet UITableView *_tableView;
@property(nonatomic,strong)NSMutableArray *auctionRegistration;
@property(nonatomic,strong)NSMutableDictionary *sections;

@end

@implementation HomeViewController
@synthesize auctionRegistration;
@synthesize sections;
@synthesize _tableView;
@synthesize sortDictioary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (self.auctionRegistration!=nil) {
            
            self.auctionRegistration=nil;
            [self.auctionRegistration removeAllObjects];
            
        }
        self.auctionRegistration=[[NSMutableArray alloc] init];
        
        
        if (self.sections!=nil) {
            
            self.sections=nil;
            [self.sections removeAllObjects];
            
        }
        self.sections=[[NSMutableDictionary alloc] init];
        
        
        if (self.sortDictioary!=nil) {
            
            self.sortDictioary=nil;
            [self.sortDictioary removeAllObjects];
            
        }
    self.sortDictioary=[[NSMutableDictionary alloc] init];
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonSystemItemDone
                                                                   target: self
                                                                   action: @selector(settingButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title=@"Register for Auction";
   _tableView.alpha=0;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self performSelector:@selector(LOGout) withObject:self afterDelay:43200.0];
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread) toTarget:self withObject:nil];
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@appname=AH4RMIns&sessionId=%@",WEB_GET_VERSION_URL,sessionID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////NSLog(@"%@",soapMessage);
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:REQ_VERSION_KEY:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_VERSION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title=@"Register for Auction";
    
}

-(void)settingButtonClicked{
    
    
    SettingViewController *controller=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void)busyViewinSecondryThread{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    
}


-(void)LOGout{
    
    
    NSArray *vList = [[self navigationController] viewControllers];
    UIViewController *view;
    for (int i=[vList count]-1; i>=0; --i) {
        view = [vList objectAtIndex:i];
        if ([view.nibName isEqualToString: @"LoginViewController"])
            break;
    }
    [[self navigationController] popToViewController:view animated:YES];
    
}


-(void)getDeviceAunthnticityResponse{
    
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_VERSION_KEY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        ////NSLog(@"%@",getversionId);

            if ([VERSION isEqualToString:getversionId]) {
                
                [self getcountyList];
                
            }else{
                
                
                [[AlertManger defaultAgent]showAlertForDelegateWithTitle:APP_NAME message:@"You do not have the current version of the property inspection app installed. Please click on the INSTALL button below to install the latest version." cancelButtonTitle:@"INSTALL" okButtonTitle:nil parentController:self];
                
                
                [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
                
            }
        
        });
                   
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:getversionURL]];
        [self LOGout];

        
    }
    
    
}

-(void)getcountyList{
    
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@",WEB_GET_COUNTY_LIST,sessionID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:GET_COUNTY_LIST:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCountylistResponse) name:NOTIFICATION_GET_COUNTY_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
}


-(void)getCountylistResponse{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_COUNTY_LIST object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    int i=0;
    while (i<[stateArr count]) {
        
        NSString *satteSTR=[NSString stringWithFormat:@"%@-%@",[stateArr objectAtIndex:i],[county_nameArr objectAtIndex:i]];
        
        
        NSDictionary *_dict=[NSDictionary dictionaryWithObjectsAndKeys:satteSTR,@"Name",[countyIdArr objectAtIndex:i],@"ID",[addressArr objectAtIndex:i],@"Address",[cityArr objectAtIndex:i],@"City",[stateArr objectAtIndex:i],@"State",[zipArr objectAtIndex:i],@"ZIP",[latArr objectAtIndex:i],@"Latitude",[longituteArr objectAtIndex:i],@"Longitude", nil];
        
        [auctionRegistration addObject:_dict];
        
        i++;
        
    }
    
    if ([auctionRegistration count]==0) {
        
        [[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"NO RECORDS ARE AVAILABLE." cancelButtonTitle:@"OK"];
        
        
    }else{
        
        for (NSDictionary *book in auctionRegistration)
        {
            NSString *c = [[[book objectForKey:@"Name"] uppercaseString] substringToIndex:1];
            
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
        // Loop again and sort the books into their respective keys
        for (NSDictionary *book in auctionRegistration)
        {
            [[sections objectForKey:[[[book objectForKey:@"Name"] uppercaseString] substringToIndex:1]] addObject:book];
        }
        
        
        // Sort each section array
        for (NSString *key in [sections allKeys])
        {
            [sections objectForKey:[key uppercaseString]];
        }

    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    _tableView.alpha=1;
    [UIView commitAnimations];
    [_tableView reloadData];
    
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
    
}


#pragma mark UITABLEVIEW DELEGATE METHODS



// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[sections allKeys] count];;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections valueForKey:[[[sections allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
        cell=nil;
        [cell removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
     NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
      
    UILabel *descLblversion=[[UILabel alloc] initWithFrame:CGRectMake(10,5,290,25)];
    descLblversion.backgroundColor=[UIColor clearColor];
    descLblversion.textColor=[UIColor colorWithRed:81.0/255.0 green:82.0/255.0 blue:85.0/255.0 alpha:1.0];
    descLblversion.font=[UIFont boldSystemFontOfSize:16];
    NSString *getStr2=[book valueForKey:@"Name"];
    descLblversion.text=getStr2;
    [cell addSubview:descLblversion];

    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    
    cell.selectionStyle=FALSE;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *book = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    InfoViewController *controllerasd=[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    controllerasd.countyName=[NSString stringWithFormat:@"%@\n%@,%@ %@",[book valueForKey:@"Address"],[book valueForKey:@"City"],[book valueForKey:@"State"],[book valueForKey:@"ZIP"]];
    controllerasd.latitudeStr=[book valueForKey:@"Latitude"];
    controllerasd.longitudeStr=[book valueForKey:@"Longitude"];
    countyIDforSearch=[book valueForKey:@"ID"];
    controllerasd.countyID=[book valueForKey:@"ID"];
    countyIDNEW=[book valueForKey:@"ID"];
    self.navigationItem.title=@"Back";
    [self.navigationController pushViewController:controllerasd animated:YES];
    
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] indexOfObject:title];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
