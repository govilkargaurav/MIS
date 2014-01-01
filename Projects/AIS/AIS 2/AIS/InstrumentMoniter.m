//
//  InstrumentMoniter.m
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "InstrumentMoniter.h"


@implementation InstrumentMoniter

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
	
	lblSog.layer.cornerRadius=5;
    lblSog.layer.borderWidth=4;
    lblSog.layer.borderColor=[UIColor grayColor].CGColor;   
    lblSog.layer.masksToBounds=YES;

    lblCog.layer.cornerRadius=5;
    lblCog.layer.borderWidth=4;
    lblCog.layer.borderColor=[UIColor grayColor].CGColor;   
    lblCog.layer.masksToBounds=YES;

    lblGps.layer.cornerRadius=5;
    lblGps.layer.borderWidth=4;
    lblGps.layer.borderColor=[UIColor grayColor].CGColor;   
    lblGps.layer.masksToBounds=YES;

    lblLat.layer.cornerRadius=5;
    lblLat.layer.borderWidth=4;
    lblLat.layer.borderColor=[UIColor grayColor].CGColor;   
    lblLat.layer.masksToBounds=YES;
   
    lblLon.layer.cornerRadius=5;
    lblLon.layer.borderWidth=4;
    lblLon.layer.borderColor=[UIColor grayColor].CGColor;   
    lblLon.layer.masksToBounds=YES;
    

    
	self.title=@"Instrument Moniter";
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain
																	 target:self action:@selector(ClickSetup:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;

	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"easy AIS" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickBack:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
}
-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	lblCog.text=@"";
	lblSog.text=@"";
	lblLat.text=@"";
	lblLon.text=@"";
	lblGps.text=@"";
    appDel = (AISAppDelegate*)[[UIApplication sharedApplication] delegate];

	appDel.delegate=self;
	unitssets= [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]];
	NSLog(@"%@",unitssets);
	
}

-(void)getLocationInformation{

}

-(void)didReceiveDataFile:(NSString*)fileName{
	
    appDel = (AISAppDelegate*)[[UIApplication sharedApplication] delegate];

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
			float min = (degree - ((int)degree))*60.0;
			float second0 = (min - ((int)min))*60.0;

			NSString *st1 = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"Longitude (degrees)"]];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"locationflag"]) {
                    st1=[NSString stringWithFormat:@"%f",appDel.deviceLocation.coordinate.longitude];
                }
            float degree1 = [st1 floatValue];
			float min1 = (degree1 - ((int)degree1))*60.0;
			float second1 = (min1 - ((int)min1))*60.0;

			NSString *cog=[[[NSString alloc] initWithFormat:@"%2.2f",[[dataDic valueForKey:@"Track made good (true degrees)"] floatValue]] retain];
			
                if ([cog floatValue]) {
                    lblCog.text= cog;
                }
                
            NSString *sog=[[NSString alloc] initWithFormat:@"%2.2f",[[dataDic valueForKey:@"Speed over ground (knots)"] floatValue]];

			if (degree && degree1) {
				NSMutableDictionary *dic;
                
                dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:degree],@"lat",[NSNumber numberWithFloat:degree1],@"lon",nil];
				
				[dic setValue:[[NSString alloc] initWithFormat:@"%@",lblCog.text] forKey:@"angle"];
                [dic setValue:[[NSString alloc] initWithFormat:@"%@",sog] forKey:@"sog"];
				

				[[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"currentLocation"];
				[[NSUserDefaults standardUserDefaults] synchronize];
                //[dic release];
				
			}
                if ([sog floatValue] > 0.0) {
                    lblSog.text=sog;                    
                }
                
                if (degree > 0.0) {
                                
			if ([[unitssets valueForKey:@"posi"] intValue] == 0) {
				lblLat.text=[NSString stringWithFormat:@"%d°%d'%2.2f''",(int)degree,(int)min,(float)second0];
				lblLon.text=[NSString stringWithFormat:@"%d°%d'%2.2f''",(int)degree1,(int)min1,(float)second1]; 
			}else {
				lblLat.text=[NSString stringWithFormat:@"%3.2f°",degree];
				lblLon.text=[NSString stringWithFormat:@"%3.2f°",degree1];			
			}
                }
                
                [sog release];
                [cog release];
            [dataDic release];
            }
            
        }
        
        
       // sen=[NSString stringWithString:@"$GPGGA,124641.000,4926.7467,N,01100.3988,E,1,10,0.9,318.4,M,47.8,M,,0000*54"];
       // nmeaSen=[[TLNMEASentence alloc] initWithLine:sen error:nil];

       if ([[nmeaSen messageType] isEqualToString:@"GGA"]) {
            EncodeTypeGSA *encode = [[EncodeTypeGSA alloc] initWithsentence:sen];
           if ([encode.numberOfSatelliteUse intValue] != 0) {
               lblGps.text= encode.numberOfSatelliteUse;               
           }
       }
            
                
		//	Horizontal Dilution of Precision
        [nmeaSen release];
            
		}
	
	[wordListArray release];
}

-(void)didDisconnectToServer{

}
-(void)didConnectToServer{

}

-(BOOL)IsGPRMCString:(NSString*)string{
	
	NSArray *ar = [string componentsSeparatedByString:@","];
	NSString *first = [NSString stringWithFormat:@"%@",[ar objectAtIndex:0]];
	if([first isEqualToString:@"$GPRMC"]){		
		return 1;		
	}else {
		return 0;
	}	
	
}
-(void)ClickSetup:(id)sender{
	SetupView *obj=[[SetupView alloc]initWithNibName:@"SetupView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
    [nav setNavigationBarHidden:NO];
    [self.tabBarController presentModalViewController:nav animated:YES];
//    [self.navigationController pushViewController:obj animated:YES];
	[obj release];
}

-(void)ClickBack:(id)sender{
	//[self.navigationController popViewControllerAnimated:YES];
    
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];

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
