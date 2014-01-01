//
//  AuctionStatusController.m
//  PropertyInspector
//
//  Created by apple on 11/8/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "AuctionStatusController.h"
#import "CustomCell.h"
#import "ThreadManager.h"
#import "LoginModel.h"
#import "GetAuctionStatusModel.h"
#import "BusyAgent.h"
#import "GetTrusteesListModel.h"
#import "GetAuctionsList.h"
#import "GetPropertyByModel.h"
#import "GetAuctionsList.h"
#import "AlertManger.h"


@interface AuctionStatusController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *_Dict;
@property(nonatomic,strong)IBOutlet UITableView *_tableView;

@end

@implementation AuctionStatusController
@synthesize _Dict;

@synthesize typeArray;
@synthesize statusArray;
@synthesize _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        propertyIDARRGlobal=[[NSMutableArray alloc] init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Auction Status";
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh:)];
    
    self.navigationItem.rightBarButtonItem = button;

    
    statusArray=[[NSMutableArray alloc] init];
    
    statusSendingArray=[[NSMutableArray alloc] init];
    
    [statusSendingArray addObject:@"open"];
    [statusSendingArray addObject:@"won settled"];
    [statusSendingArray addObject:@"won unsettled"];
    [statusSendingArray addObject:@"lost"];
    [statusSendingArray addObject:@"cancelled"];
    
    [statusArray addObject:@"Remaining Properties"];
    [statusArray addObject:@"Settled Properties"];
    [statusArray addObject:@"Unsettled Properties"];
    [statusArray addObject:@"Lost Properties"];
    [statusArray addObject:@"Cancelled Properties"];
    
    
    
    [self refresh:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationItem.title=@"Auction Status";
}

-(void)refresh:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    NSString *soapMessage = [[NSString stringWithFormat:@"%@&sessionId=%@&countyId=%@",WEB_GET_AUCTION_STATUS,sessionID,countyIDNEW]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:GET_AUCTION_STATUS:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_GET_AUCTION_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];
    
    
    
    
    
    
}


-(void)busyViewinSecondryThread:(id)sender{
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
    
}


-(void)getDeviceAunthnticityResponse{
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_POST_PAYMENT_LIST object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];

    
    [_tableView reloadData];
    
    [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell) {
        cell=nil;
        [cell removeFromSuperview];
        
    }
    
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AuctionStatusCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell *) currentObject;
				break;
			}
		}
	}
    

    if ([[[statusArrayAuction valueForKey:@"TYPE"] objectAtIndex:indexPath.row] isEqualToString:@"open"]) {
        
        cell.statusLable.hidden=YES;
        
        
    }else if ([[[statusArrayAuction valueForKey:@"TYPE"] objectAtIndex:indexPath.row] isEqualToString:@"won settled"]){
        
        cell.statusLable.textColor=[UIColor greenColor];
        
    }else if ([[[statusArrayAuction valueForKey:@"TYPE"] objectAtIndex:indexPath.row] isEqualToString:@"won unsettled"]){
        
        cell.statusLable.textColor=[UIColor colorWithRed:237.0/255.0 green:207.0/255.0 blue:36.0/255.0 alpha:1];
        
    }else if ([[[statusArrayAuction valueForKey:@"TYPE"] objectAtIndex:indexPath.row] isEqualToString:@"lost"]){
        
        cell.statusLable.text=@"L";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.statusLable.textColor=[UIColor redColor];
        
    }else if ([[[statusArrayAuction valueForKey:@"TYPE"] objectAtIndex:indexPath.row] isEqualToString:@"cancelled"]){
        
        cell.statusLable.text=@"C";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.statusLable.textColor=[UIColor blackColor];
        
    }
    cell.totalNumber.text=[[statusArrayAuction valueForKey:@"COUNT"] objectAtIndex:indexPath.row];
    cell.totalAmount.text=[[statusArrayAuction valueForKey:@"AMOUNT"] objectAtIndex:indexPath.row];
    cell.realStatus.text=[statusArray objectAtIndex:indexPath.row];
    cell.selectionStyle=FALSE;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {


    NSString *status =[statusSendingArray objectAtIndex:indexPath.row];
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread:) toTarget:self withObject:nil];
    NSString *soapMessage = [[NSString stringWithFormat:@"%@sessionId=%@&status=%@&countyId=%@",WEB_GET_PROPERTY_BY_STATUS,sessionID,status,countyIDNEW]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////NSLog(@"%@",soapMessage);
    
    NSData *tData = [NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]];
    
    [[ThreadManager getInstance]makeRequest:GET_PROPERTY_BY_STATUS:soapMessage:tData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceAunthnticityResponseNew) name:NOTIFICATION_GET_PROPERTY_BY_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];



}

-(void)getDeviceAunthnticityResponseNew{
    
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_PROPERTY_BY_STATUS object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
    if ([getPropertyArray count]!=0) {
        
        XIBchange=@"4";
        
        propertyIDARRGlobal=[getPropertyArray copy];

        if ([pushPOPStr isEqualToString:@"0"]) {
        
        GetAuctionsList *controller=[[GetAuctionsList alloc] initWithNibName:@"GetAuctionsList" bundle:nil];
        self.navigationItem.title=@"Back";
        [self.navigationController pushViewController:controller animated:YES];
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"No data available." cancelButtonTitle:@"OK"];
        [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
        
    }
    
}

@end
