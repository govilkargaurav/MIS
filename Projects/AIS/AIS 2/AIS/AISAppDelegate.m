//
//  AISAppDelegate.m
//  AIS
//
//  Created by apple  on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "AISAppDelegate.h"

@implementation AISAppDelegate

@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize delegate=_delegate;

@synthesize dicData;
@synthesize arryMMSI;
@synthesize asyncSocket;
@synthesize deviceLocation;
@synthesize locManager;
@synthesize bit6dataAry;
@synthesize shipTypes;
@synthesize dataAry;
- (void)listInterfaces
{
	NSLog(@"listInterfaces");
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
			NSLog(@"%@", name);
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
}

- (NSData *)wifiAddress
{
	// On iPhone, WiFi is always "en0"
	
	NSData *result = nil;
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSLog(@"cursor->ifa_name = %s", cursor->ifa_name);
			
			if (strcmp(cursor->ifa_name, "en0") == 0)
			{
				if (cursor->ifa_addr->sa_family == AF_INET)
				{
					struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
					NSLog(@"cursor->ifa_addr = %s", inet_ntoa(addr->sin_addr));
					
					result = [NSData dataWithBytes:addr length:sizeof(struct sockaddr_in)];
					cursor = NULL;
				}
				else
				{
					cursor = cursor->ifa_next;
				}
			}
			else
			{
				cursor = cursor->ifa_next;
			}
		}
		freeifaddrs(addrs);
	}
	
	return result;
}

- (NSData *)cellAddress
{
	// On iPhone, 3G is "pdp_ipX", where X is usually 0, but may possibly be 0-3 (i'm guessing...)
	
	NSData *result = nil;
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSLog(@"cursor->ifa_name = %s", cursor->ifa_name);
			
			if (strncmp(cursor->ifa_name, "pdp_ip", 6) == 0)
			{
				if (cursor->ifa_addr->sa_family == AF_INET)
				{
					struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
					NSLog(@"cursor->ifa_addr = %s", inet_ntoa(addr->sin_addr));
					
					result = [NSData dataWithBytes:addr length:sizeof(struct sockaddr_in)];
					cursor = NULL;
				}
				else
				{
					cursor = cursor->ifa_next;
				}
			}
			else
			{
				cursor = cursor->ifa_next;
			}
		}
		freeifaddrs(addrs);
	}
	
	return result;
}

- (void)dnsResolveDidFinish
{
	NSLog(@"dnsResolveDidFinish");
	
	Boolean hasBeenResolved;
	CFArrayRef addrs = CFHostGetAddressing(host, &hasBeenResolved);
	
	if (!hasBeenResolved)
	{
		NSLog(@"Failed to resolve!");
		return;
	}
	
	CFIndex count = CFArrayGetCount(addrs);
	
	if (count == 0)
	{
		NSLog(@"Found 0 addresses!");
		return;
	}
	
	
	struct sockaddr_in remoteAddr;
	NSData *remoteAddrData = nil;
	
	BOOL found = NO;
	CFIndex i;
	for (i = 0; i < count && !found; i++)
	{
		CFDataRef addr = CFArrayGetValueAtIndex(addrs, i);
		
		struct sockaddr *saddr = (struct sockaddr *)CFDataGetBytePtr(addr);
		if (saddr->sa_family == AF_INET)
		{
			struct sockaddr_in *saddr4 = (struct sockaddr_in *)saddr;
			
			NSLog(@"Found IPv4 version: %s", inet_ntoa(saddr4->sin_addr));
			
			memcpy(&remoteAddr, saddr, sizeof(remoteAddr));
			
			int port = [[[NSUserDefaults standardUserDefaults] valueForKey:@"port"] intValue];
			NSLog(@"port port %d",port);
			remoteAddr.sin_port = htons(port);
			remoteAddrData = [NSData dataWithBytes:&remoteAddr length:sizeof(remoteAddr)];
			
			found = YES;
		}
	}
	
	if (found == NO)
	{
		NSLog(@"Found no suitable addresses!");
		return;
	}
	
	NSData *interfaceAddrData = [self wifiAddress];
	//	NSData *interfaceAddrData = [self cellAddress];
	if (interfaceAddrData == nil)
	{
		NSLog(@"Requested interface not available");
		return;
	}
	
	NSLog(@"Connecting...");
	
	asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
	
	
	NSError *err = nil;
	if (![asyncSocket connectToAddress:remoteAddrData viaInterfaceAddress:interfaceAddrData withTimeout:-1 error:&err])
	{
		NSLog(@"Error connecting: %@", err);
	}
	
	[asyncSocket readDataWithTimeout:200 tag:1];
	
	
}

static void DNSResolveCallBack(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AISAppDelegate *instance = (AISAppDelegate *)info;
	[instance dnsResolveDidFinish];
	
	[pool release];
}

- (void)startDNSResolve
{
	NSLog(@"startDNSResolve");
	
	NSLog(@"Resolving google.com...");
	
	NSString *host1 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"host"]];
	//host = CFHostCreateWithName(kCFAllocatorDefault, CFSTR(host));

	
	host = CFHostCreateWithName(kCFAllocatorDefault, (CFStringRef)host1);
	if (host == NULL)
	{
		
		return;
	}
	
	Boolean result;
	
	CFHostClientContext context;
	context.version         = 0;
	context.info            = self;
	context.retain          = NULL;
	context.release         = NULL;
	context.copyDescription = NULL;
	
	result = CFHostSetClient(host, &DNSResolveCallBack, &context);
	if (!result)
	{
		
		return;
	}
	
	CFHostScheduleWithRunLoop(host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	
	CFStreamError error;
	bzero(&error, sizeof(error));
	
	result = CFHostStartInfoResolution(host, kCFHostAddresses, &error);
	if (!result)
	{
		NSLog(@"Failed to start DNS resolve");
		NSLog(@"error: domain(%i) code(%i)", (int)(error.domain), (int)(error.error));
	}
}


#pragma mark -
#pragma mark Socket

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"willDisconnectWithError");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alarmflag"]) {
        
        NSString *fname = [NSString stringWithFormat:@"Pizzicato01"];		
		NSURL *tapSound   = [[NSBundle mainBundle] URLForResource:fname
													withExtension: @"wav"];
		soundFileURLRef = (CFURLRef) [tapSound retain];
		AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
		AudioServicesPlayAlertSound (soundFileObject);
		AudioServicesPlaySystemSound(kAudioServicesSystemSoundClientTimedOutError);
        
    }

}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
	NSLog(@"onSocketDidDisconnect");
	
    
	[_delegate didDisconnectToServer];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)remoteHost port:(UInt16)remotePort
{
	NSLog(@"Socket is connected!");
	NSLog(@"Remote Address: %@:%hu", remoteHost, remotePort);
	
	NSString *localHost = [sock localHost];
	UInt16 localPort = [sock localPort];
	[_delegate didConnectToServer];
	
	NSLog(@"Local Address: %@:%hu", localHost, localPort);
}
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
	//	NSLog(@"receive data");
	
	NSString* newStr = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	
	if (receivedString) {
		[receivedString appendFormat:@"%@",newStr];		
	}else {
		receivedString = [[NSMutableString alloc] initWithFormat:@"%@",newStr];
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"myFile.text"];
	
		
    if (_delegate) {
        [_delegate didReceiveDataFile:appFile];        
    }

    NSLog(@"length length %d",[receivedString length]);
    
	if ([receivedString length] > 2000) {
		[NSThread detachNewThreadSelector:@selector(processInBackGround) toTarget:self withObject:nil];
		[receivedString replaceCharactersInRange:NSMakeRange(0, 2000) withString:@""];
	}
	

	NSData* datareceived=[receivedString dataUsingEncoding:NSUTF8StringEncoding];
	[[NSFileManager defaultManager] createFileAtPath:appFile contents:datareceived attributes:nil];	 
	
	
	[sock readDataWithTimeout:200 tag:1];
}

-(void)processInBackGround{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 	
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"myFile.text"];

	NSArray *wordListArray = [[NSArray alloc] initWithArray:[[NSString stringWithContentsOfFile:appFile encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];

	for (int i=0; i< [wordListArray count]; i++) {
		NSString *sen = [[NSString alloc] initWithFormat:@"%@",[wordListArray objectAtIndex:i]];
     
        //sen = @"!AIVDM,1,1,,A,1>MA2GOP000jHb@LBhAtsOwt1P00,0*72";
		if([[self getTypeOfNMEAString:sen] isEqualToString:@"AIVDM"]){			
		
			DecodeAIVDM *decode = [[DecodeAIVDM alloc] initWithAIVDM:sen];
		}
		
	}
	[pool release];
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

-(NSString*)getTypeOfNMEAString:(NSString*)string{
	NSString *returnStr = [[NSString alloc] init];
	NSArray *ar = [string componentsSeparatedByString:@","];
	NSString *first = [NSString stringWithFormat:@"%@",[ar objectAtIndex:0]];
	if([first isEqualToString:@"$GPRMC"]){		
		returnStr=@"GPRMC";	
	}else if([first isEqualToString:@"!AIVDM"] || [first isEqualToString:@"!AIVDO"]){
		returnStr=@"AIVDM";	
	}	
	return returnStr;
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
	/*		NSLog(@"receive Partial data");
	 
	 
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"myFile.text"];
	 
	 [[NSFileManager defaultManager] createFileAtPath:appFile contents:receivedData attributes:nil];
	 //[data writeToFile:appFile atomically:YES];
	 
	 id trackFile = nil;
	 trackFile = [(TLNMEAFile*)[TLNMEAFile alloc] initWithContentsOfURL:[NSURL fileURLWithPath:appFile] error:NULL];
	 
	 NSLog(@"%@",trackFile);
	 */
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
	NSLog(@"write data");
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
	NSLog(@"write partial data");
}

-(void)disconnectFromSocket{
	
	[asyncSocket disconnect];
}

#pragma mark -
#pragma mark Conversation

-(NSString*)convertDMStoDD:(NSString*)DMSValue{
	
    return nil; 
}

-(NSString*)convertDDtoDMS:(NSString*)DDValue{
	
    return nil;
}
-(NSString*)getStringFromDate:(NSDate*)date{
    
    NSString *dateStr= [[NSString alloc] initWithFormat:@"%@",[formatter stringFromDate:date]];
    return dateStr;
}

-(NSDate*)getDateFromString:(NSString*)strDate{

    NSDate *date= [[NSDate alloc] init];
    date=[formatter dateFromString:strDate];

    return date;
}

-(void)showAlertForShip:(NSString*)MMSINumber withMessage:(NSString*)message{


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
    
    NSString *fname = [NSString stringWithFormat:@"Pizzicato01"];		
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource:fname
                                                withExtension: @"wav"];
    soundFileURLRef = (CFURLRef) [tapSound retain];
    AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
    AudioServicesPlayAlertSound (soundFileObject);
    AudioServicesPlaySystemSound(kAudioServicesSystemSoundClientTimedOutError);

    [alert show];
}

#pragma mark - Location
#pragma mark -

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    // NSLog(@"Acc %f",[newHeading headingAccuracy]);
    
    //correct
    // NSLog(@"hdg %f",newHeading.trueHeading);
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Upadating ...");
    self.deviceLocation=[newLocation retain];
      NSLog(@"alt %@",[NSString stringWithFormat:@"%f",self.deviceLocation.coordinate.latitude]);
      NSLog(@"speed %@",[NSString stringWithFormat:@"%f",self.deviceLocation.coordinate.longitude]);
    
//    NSString *currentLat=[NSString stringWithFormat:@"%f",self.deviceLocation.coordinate.latitude];
//    NSString *currentLong=[NSString stringWithFormat:@"%f",self.deviceLocation.coordinate.longitude];
//    
}

-(void)getInitializeBit6{
    NSString *path =  [[NSBundle	mainBundle] pathForResource:@"bit6data" ofType:@"plist"];
    self.bit6dataAry = (NSMutableArray*)[[NSArray alloc] initWithContentsOfFile:path];
   
    NSString *path1 =  [[NSBundle	mainBundle] pathForResource:@"ShipType" ofType:@"plist"];
    self.shipTypes = (NSMutableDictionary*)[[NSMutableDictionary alloc] initWithContentsOfFile:path1];
    
    NSString *path2 =  [[NSBundle	mainBundle] pathForResource:@"myData" ofType:@"plist"];
	self.dataAry  = (NSMutableArray*)[[NSArray alloc] initWithContentsOfFile:path2];


}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //disable power saving mode
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [self getInitializeBit6];
    
    deviceLocation=[[CLLocation alloc] init];
    startDate=[[NSDate alloc] init];
    startDate=[NSDate date];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/in/app/temple-run-brave/id524509185?mt=8"]];
    
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locManager.distanceFilter = 10.0f;
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"locationflag"]) {

        [self.locManager startUpdatingLocation];
        [self.locManager startUpdatingHeading];
//    }
    
    //set date formate
    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone: [NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"MM-dd-YYYY HH:mm:ss"];

    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.

    receivedData = [[NSMutableData alloc] init];
	receivedString= [[NSMutableString alloc] init];
    
    
//remove all saved data	
	//[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"dicData"];
	//[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"arryMMSI"];

    
	if([[NSUserDefaults standardUserDefaults] valueForKey:@"dicData"] && [[NSUserDefaults standardUserDefaults] valueForKey:@"arryMMSI"])
    {
        self.dicData = [[NSUserDefaults standardUserDefaults] valueForKey:@"dicData"];
        self.arryMMSI = [[NSUserDefaults standardUserDefaults] valueForKey:@"arryMMSI"];        
    }
    else
    {
        self.dicData = [[NSMutableDictionary alloc] init];
        self.arryMMSI = [[NSMutableArray alloc] init];
    }

	if(![[NSUserDefaults standardUserDefaults] valueForKey:@"radarsettings"]){
		
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"75",@"posi",@"5",@"velo",@"6",@"persi",nil];
		[[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"radarsettings"];
		
	}
	if(![[NSUserDefaults standardUserDefaults] valueForKey:@"unitssettings"]){
		
		NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"posi",@"0",@"dis",@"0",@"speed",@"0",@"depth",nil];
		[[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"unitssettings"];
		
	}
	
	if((![[NSUserDefaults standardUserDefaults] valueForKey:@"host"]) && (![[NSUserDefaults standardUserDefaults] valueForKey:@"port"]))
	{
		
		[[NSUserDefaults standardUserDefaults] setValue:@"192.168.10.1" forKey:@"host"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSUserDefaults standardUserDefaults] setValue:@"5101" forKey:@"port"];
		[[NSUserDefaults standardUserDefaults] synchronize];

		
	}
	


/*	BitConvert *con;
	NSData *datastr = [@"53iL`h02;oj4iQHh001H4hDq@TpD00000000000E02R0J5o6d=nQA@TUAiKD5DQS1E00000" dataUsingEncoding:NSMacOSRomanStringEncoding];
	NSString *str = [[NSString alloc] initWithData:datastr encoding:NSMacOSRomanStringEncoding];
	con= [[BitConvert alloc] initWithStringData:str];
	*/
//	[self validateAIVDSentence:@"!AIVDM,1,1,,A,13uo<D0uj=P>l:6MJV9C82On0<3E,0*20"];
	
	self.window.rootViewController = self.navigationController;
	self.navigationController.navigationBarHidden = YES;
	

    
    
    //    NSString *str = @"!AIVDM,1,1,,B,13ktppP000P0S@@LCu?888f62<1<,0*45";
//    NSString *strCheckSum = [self checkSum:str lenght:[str length]];
    
 //   NSLog(@"Find Check Sum is %@",strCheckSum);
	
   // [self getvalueOfTheString:@"sunil",@"ankur",@"ankur",@"ankur",@"ankur1",@"anku2r",@"ankur4", nil];
    
   // [self startSimulationForData];
	[self.window makeKeyAndVisible];
    return YES;
}

-(void)startSimulationForData{

	NSString *path = [[NSBundle mainBundle] pathForResource:@"aisdata" ofType:@"log"];
	SimData = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //char 2053241
    //sent 40738
    //1 lenght 48
    simDataPosi=0;
    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(receiveDummyData)];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
	[inv setTarget: self];
	[inv setSelector:@selector(receiveDummyData)];
	
	NSTimer *t = [NSTimer timerWithTimeInterval: 5.0
									 invocation:inv 
										repeats:YES];
	
	NSRunLoop *runner = [NSRunLoop currentRunLoop];
	[runner addTimer: t forMode: NSDefaultRunLoopMode];

}
-(void)receiveDummyData{
   
    NSString *str=  [SimData substringWithRange:NSMakeRange(simDataPosi, 700)];
    
    if (simDataPosi < 2053141) {
        simDataPosi=simDataPosi+700;
    }else{
        simDataPosi=0;
    }

     NSData *dt = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self onSocket:asyncSocket didReadData:dt withTag:0];
}



-(void)getvalueOfTheString:(NSString *)value, ...{

    id eachObject;
    va_list argumentList;
    
    if (value)                    
    {                                
        NSLog(@"%@",value);
        va_start(argumentList, value);         
        while ((eachObject = va_arg(argumentList, id))){
            NSLog(@"%@",eachObject);
        }
    }                   
    va_end(argumentList);

}

-(NSString *)checkSum:(NSString*)str lenght:(int)len
{
    
    NSArray *arry = [str componentsSeparatedByString:@"*"];
    
    NSString *str1 = [arry objectAtIndex:0];
    
    str1 = [str1 substringFromIndex:1];
    char *a = (char*)[str1 UTF8String];
    
    for(int i = 0 ; i < len-1; i++)
    {
        a[i+1] = a[i] ^ a[i+1];
    }
	//   NSLog(@"XOR Char :: %x",(unsigned int)a[len-1]);
	NSString *result = [NSString stringWithFormat:@"%x",(unsigned int) a[len-1]];
	NSString *actual = [arry objectAtIndex:1];
	
	if([result isEqualToString:actual]){
		return YES;
	}
	
    return NO;
}
/*
- (void) transform:(NSData*)input
{
    NSString* key = @"ABCDEFG";
    unsigned char* pBytesInput = (unsigned char*)[input bytes];
    unsigned char* pBytesKey   = (unsigned char*)[key bytes];
    unsigned int vlen = [input length];
    unsigned int klen = [m_key length];
    unsigned int v = 0;
    unsigned int k = vlen % klen;
    unsigned char c;
	
    for (v; v < vlen; v++) {
        c = pBytesInput[v] ^ pBytesKey[k]; 
        pBytesInput[v] = c;
		
        k = (++k < klen ? k : 0);
    }
}*/
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	
	[[NSUserDefaults standardUserDefaults] setValue:self.dicData forKey:@"dicData"];
    [[NSUserDefaults standardUserDefaults] setValue:self.arryMMSI forKey:@"arryMMSI"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isConnected"]) {
        self.delegate=nil;
        [self listInterfaces];        
        [self startDNSResolve];
    }

    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    double sectime = [[NSDate date] timeIntervalSinceDate:startDate];
    
    NSLog(@"application timeline %f",(sectime/60.0f));
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
