//
//  Targets.m
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "Targets.h"
#import "AISAppDelegate.h"

@implementation Targets

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Targets";
	detailView.hidden=TRUE;
	
	dataSource = [[NSMutableArray alloc] init];
    dataDictionary = [[NSMutableDictionary alloc] init];
	dataArrayName = [[NSMutableArray alloc] init];
    dataMMSINum = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain
																	 target:self action:@selector(ClickSetup:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;
	
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"easy AIS" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickBackClicked:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
	
	
	NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];
	
	CLLocationDegrees lat = (CLLocationDegrees)[[locDic valueForKey:@"lat"]floatValue];
	CLLocationDegrees lon = (CLLocationDegrees)[[locDic valueForKey:@"lon"]floatValue];	
	currLoc=[[CLLocation alloc] initWithLatitude:lat longitude:lon];	
	
	
	
	[self performSelector:@selector(ClickBack:)];
	
	NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(ClickBack:)];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
	[inv setTarget: self];
	[inv setSelector:@selector(ClickBack:)];
	
	NSTimer *t = [NSTimer timerWithTimeInterval: 5.0
									 invocation:inv 
										repeats:YES];
	
	NSRunLoop *runner = [NSRunLoop currentRunLoop];
	[runner addTimer: t forMode: NSDefaultRunLoopMode];
	
	
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    AISAppDelegate *appDeleg = (AISAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDeleg.delegate=self;
    
    unitssets = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]];
    
	NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];
	
	CLLocationDegrees lat = (CLLocationDegrees)[[locDic valueForKey:@"lat"]floatValue];
	CLLocationDegrees lon = (CLLocationDegrees)[[locDic valueForKey:@"lon"]floatValue];	
	currLoc=[[CLLocation alloc] initWithLatitude:lat longitude:lon];
}
-(void)didDisconnectToServer{
    
}
-(void)didConnectToServer{
    
}

-(void)didReceiveDataFile:(NSString*)fileName{
	
    AISAppDelegate *appDel = (AISAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSArray *wordListArray = [[NSArray alloc] initWithArray:[[NSString stringWithContentsOfFile:fileName encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
	
	for (int i=0; i< [wordListArray count]; i++) {
		NSString *sen = [NSString stringWithFormat:@"%@",[wordListArray objectAtIndex:i]];
		
		//if([self IsGPRMCString:sen]){			
        TLNMEASentence	*nmeaSen = [[TLNMEASentence alloc] initWithLine:sen error:nil];
        
        //NSLog(@"%@",[nmeaSen decodeMessageOfTypeGGA]);
        
        if ([[nmeaSen messageType] isEqualToString:@"RMC"]) {
            NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:[nmeaSen decodeSentence]];
            
            
            if ([dataDic count] > 4 ) {
                
                NSString *st = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"Latitude (degrees)"]];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"locationflag"]) {
                    st=[NSString stringWithFormat:@"%f",appDel.deviceLocation.coordinate.latitude];
                }

                
                float degree = [st floatValue];
                
                NSString *st1 = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"Longitude (degrees)"]];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"locationflag"]) {
                    st1=[NSString stringWithFormat:@"%f",appDel.deviceLocation.coordinate.longitude];
                }

                float degree1 = [st1 floatValue];
                
                NSString *Cog=[[[NSString alloc] initWithFormat:@"%2.2f",[[dataDic valueForKey:@"Track made good (true degrees)"] floatValue]] retain];
                
                NSString *sog=[[NSString alloc] initWithFormat:@"%2.2f",[[dataDic valueForKey:@"Speed over ground (knots)"] floatValue]];
                
                if (degree && degree1) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:degree],@"lat",[NSNumber numberWithFloat:degree1],@"lon",nil];
                    
                    [dic setValue:[[NSString alloc] initWithFormat:@"%@",Cog] forKey:@"angle"];
                    [dic setValue:[[NSString alloc] initWithFormat:@"%@",sog] forKey:@"sog"];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"currentLocation"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [dic release];
                }
                //[Cog release];
                //[sen release];
                
               [dataDic release];
            }
        }        
                
		//	Horizontal Dilution of Precision
        [nmeaSen release];
        
    }
	
	[wordListArray release];
}


-(void)ClickSetup:(id)sender{
	SetupView *obj=[[SetupView alloc]initWithNibName:@"SetupView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
    [nav setNavigationBarHidden:NO];
    [self.tabBarController presentModalViewController:nav animated:YES];
    //    [self.navigationController pushViewController:obj animated:YES];
	[obj release];
}
-(void)ClickBackClicked:(id)sender{

    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];

}
-(void)ClickBack:(id)sender{
	
	AISAppDelegate *appDeleg = (AISAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
    if([dataSource count] > 0)
    {
        [dataSource removeAllObjects];
        dataSource = [[NSMutableArray alloc] init]; 
    }
    
	dataDictionary =[[NSMutableDictionary alloc] initWithDictionary:appDeleg.dicData];// [appDeleg.dicData copy];
	NSArray *keys = [[NSArray alloc] initWithArray:[dataDictionary allKeys]];
	for (int i=0; i<[dataDictionary count]; i++) {
		NSDictionary *dic  = (NSDictionary*)[dataDictionary objectForKey:[keys objectAtIndex:i]];
		CLLocationDegrees lat = (CLLocationDegrees)[[dic valueForKey:@"Latitude"] floatValue];
		CLLocationDegrees lon = (CLLocationDegrees)[[dic valueForKey:@"Longitude"]floatValue];
		CLLocation *other =[[CLLocation alloc] initWithLatitude:lat longitude:lon];
		
		CLLocationDistance distanceInMeter = [other distanceFromLocation:currLoc];
		
		float disInNM = distanceInMeter*0.000539956803;
		
		NSString *dis = [[NSString alloc] initWithFormat:@"%3.2f",disInNM];
		[(NSMutableDictionary*)[dataDictionary objectForKey:[keys objectAtIndex:i]] setValue:dis forKey:@"dis"];
	}
    
	
	dataSource = [[NSMutableArray alloc] init];
	for (int i=0; i<[keys count]; i++) {
		[dataSource addObject:[[dataDictionary objectForKey:[keys objectAtIndex:i]] retain]];
	}

	dataSource = [[NSMutableArray alloc] initWithArray:[self sortedArray:[dataSource retain]]];
	     
    [tblView reloadData];
    
    
	
}

-(NSMutableArray*)sortedArray:(NSMutableArray*)arrayToSort{
	NSMutableArray *ar =[[NSMutableArray alloc] init];
	ar = (NSMutableArray*)[arrayToSort sortedArrayUsingComparator: ^(id a, id b) {
		float first = [[a valueForKey:@"dis"] floatValue];
		float second = [[b valueForKey:@"dis"] floatValue];
		
		if ( first < second ) {
			return (NSComparisonResult)NSOrderedAscending;
		} else if ( first > second ) {
			return (NSComparisonResult)NSOrderedDescending;
		} else {
			return (NSComparisonResult)NSOrderedSame;
		}
	}];
	
	return ar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataSource count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    CustomCellTarget *cell = (CustomCellTarget*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomCellTarget" owner:self options:nil];
        cell = objCustCell;
        objCustCell = nil;
    }    // Configure the cell...
	cell.lbl1.text = cell.lbl2.text=cell.lbl3.text =@"";
    //NSDictionary *dic = [dataDictionary valueForKey:[dataSource objectAtIndex:indexPath.row]]; 

	NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[dataSource objectAtIndex:indexPath.row]]; 
	
	//  NSLog(@"Dic Data :: %@",dataDictionary);
    
   
	
	
/*	CLLocationDegrees lat = (CLLocationDegrees)[[dic valueForKey:@"Latitude"] floatValue];
	CLLocationDegrees lon = (CLLocationDegrees)[[dic valueForKey:@"Longitude"]floatValue];
	CLLocation *other =[[CLLocation alloc] initWithLatitude:lat longitude:lon];
	
	CLLocationDistance distanceInMeter = [other distanceFromLocation:currLoc];
	
	float disInNM = distanceInMeter*0.000539956803;
	*/
	//cell.lbl1.text = [NSString stringWithFormat:@"%3.2f NM",disInNM];
   
    //---------------distance--------------
    NSString *dist;
    if ([[unitssets valueForKey:@"dis"] intValue] == 0) {
        dist = [NSString stringWithFormat:@"%@ NM",[dic valueForKey:@"dis"]]; 
    }else{
        dist = [NSString stringWithFormat:@"%@",[dic valueForKey:@"dis"]];
        dist = [NSString stringWithFormat:@"%3.2f Km",([dist floatValue]*1.852)];
    }
	cell.lbl1.text = [NSString stringWithFormat:@"%@",dist];
    //-----------------------------------
    
    
    
    //---------------distance--------------
     NSString *speed;
    if ([[unitssets valueForKey:@"speed"] intValue] == 0) {
   
        if(![[NSString stringWithFormat:@"%@",[dic valueForKey:@"SOG"]] isEqualToString:@"(null)"])
        {
           speed = [NSString stringWithFormat:@"%@ kn",[dic valueForKey:@"SOG"]];
        }
        
    }else{
        if(![[NSString stringWithFormat:@"%@",[dic valueForKey:@"SOG"]] isEqualToString:@"(null)"])
        {
            speed = [NSString stringWithFormat:@"%@",[dic valueForKey:@"SOG"]];
            speed = [NSString stringWithFormat:@"%.2f km/h",(float)([speed floatValue]*1.852)];
        }

    }
    cell.lbl2.text = [NSString stringWithFormat:@"%@",speed];
    //-----------------------------------
    
    
    
    //cell.lbl2.text = [NSString stringWithFormat:@"%@kn",[dic valueForKey:@"SOG"]];
    
    if([[NSString stringWithFormat:@"%@",[dic valueForKey:@"ShipName"]] isEqualToString:@"(null)"])
    {
        cell.lbl3.text = [NSString stringWithFormat:@"~%@",[dic valueForKey:@"MMSINum"]];
    }
    else
    {
        cell.lbl3.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ShipName"]];
		
    }
	
  //  [dic release];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	AISAppDelegate *appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
	NSDictionary *dic = [dataSource objectAtIndex:indexPath.row];
	DetailVIew *detail =[[DetailVIew alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	detail.backgroundColor=[UIColor whiteColor];
	detail.MMSI.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"MMSINum"]];
	
    NSString *key = [NSString stringWithFormat:@"%@",[dic valueForKey:@"MMSINum"]];    
    if ([appDelegate.dicData valueForKey:key]) {
        [detail setDictionaryValues:[NSDictionary dictionaryWithDictionary:[appDelegate.dicData valueForKey:key]]];        
    }
	
    [self.view addSubview:detail];
}

-(IBAction)clickDone{
	detailView.hidden=TRUE;		
	detailView.frame=CGRectMake(20, 490, 280, 290);
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
