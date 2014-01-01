//
//  RadarView.m
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "RadarView.h"


@implementation RadarView

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
	self.title=@"Radar View";
   
 /*   locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locManager.distanceFilter = 10.0f;
    [locManager startUpdatingLocation];
    [locManager startUpdatingHeading];
   */ 
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"distance.csv" ofType:nil];
    CSVParser *parser = [[CSVParser alloc] init];
	[parser openFile:filename];
    distanceArray = [[NSArray alloc] initWithArray:[[parser parseFile] objectAtIndex:0]];
  

    zoomlevel=[distanceArray count]-1;
    nmLenght=[[distanceArray objectAtIndex:zoomlevel] floatValue];

	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain
																	 target:self action:@selector(ClickSetup:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;
	
	UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"easy AIS" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickBack:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
	
	
	
	scrollV.backgroundColor = [UIColor blackColor];
//	scrollV.frame=CGRectMake(-50, -50, scrollV.frame.size.width+100, scrollV.frame.size.height+100);
	
	scrollV.frame=CGRectMake(-84, -61, scrollV.frame.size.width+(2*84), scrollV.frame.size.height+(2*61));

	targetTags = [[NSMutableArray alloc] init];
	
	
/*	UIImageView *imgV = [[UIImageView alloc] init];
	imgV.frame=CGRectMake(0, 0, 720, 720);
	imgV.image= [UIImage imageNamed:@"round.png"];
	[scrollV addSubview:imgV];
*/
	
/*	scrollV.contentSize=CGSizeMake(720, 720);
	[scrollV setContentOffset:CGPointMake(180, 180)];
	
	MKMapView *mapV = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapV.mapType = MKMapTypeHybrid;

	CLLocationCoordinate2D pin ;//= mapV.userLocation.coordinate;
	pin.latitude=23.0;
	pin.longitude=72.0;
	
	MKCoordinateSpan span = {latitudeDelta: 0.2, longitudeDelta: 0.2};
	MKCoordinateRegion region = {pin, span};
	
	[mapV setRegion:region];

	CGRect rect = [mapV convertRegion:mapV.region toRectToView:scrollV];
	scrollV.contentSize=CGSizeMake(rect.size.width, rect.size.height);
	NSLog(@"%f	%f",rect.size.width,rect.size.height);
	
	CGPoint point = [mapV convertCoordinate:pin toPointToView:scrollV];	
	[self addSubviewWithPosition:point];
	
	[scrollV setContentOffset:point];
	
//	CGPoint point2 = [mapV convertCoordinate:pin toPointToView:mapV];
//	[self addSubviewWithPosition:point2];
*/
	

	delta=0.300000;
	[self addBackgroundImage];
	[self showZoomButtons];		

	tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollV.contentSize.width, scrollV.contentSize.height)];
	
	[scrollV addSubview:tmpView];	
scrollV.multipleTouchEnabled=YES;
	tmpView.userInteractionEnabled=YES;
	tmpView.multipleTouchEnabled=YES;
	
	map = [[CLSMapview alloc] initWithFrame:scrollV.bounds];
	[map initlizeMapCLSMapview];	
//	[scrollV addSubview:map];
	map.frame=CGRectMake(0, 0, scrollV.contentSize.width, scrollV.contentSize.height);
	map.delegate=self;
//	[self setRaderView];
	
	
	
	NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(setRaderView)];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature: sgn];
	[inv setTarget: self];
	[inv setSelector:@selector(setRaderView)];
	
	NSTimer *t = [NSTimer timerWithTimeInterval: 5.0
									 invocation:inv 
										repeats:YES];
	
	NSRunLoop *runner = [NSRunLoop currentRunLoop];
	[runner addTimer: t forMode: NSDefaultRunLoopMode];
	

	 [self showDistanceLabels];
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];    
	del= (AISAppDelegate*)[[UIApplication sharedApplication] delegate];
//	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(setRaderView) userInfo:nil repeats:YES];

    del.delegate=self;

    scrollV.delegate=self;
	radarSets= [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"radarsettings"]];
	
	[self setRaderView];
	[scrollV setContentOffset:CGPointMake(114, 170) animated:YES];
		

//	AISAppDelegate *appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];

}
-(void)viewWillDisappear:(BOOL)animated{
   
    [super viewWillDisappear:animated];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

	return tmpView;
}
#pragma mark -
#pragma mark DELEGATES


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f  %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	//NSLog(@"%f    %f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);	
    

}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
   // NSLog(@"Acc %f",[newHeading headingAccuracy]);
    
    //correct
   // NSLog(@"hdg %f",newHeading.trueHeading);
    

}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

  //  NSLog(@"alt %f",newLocation.altitude);
  //  NSLog(@"speed %f",newLocation.speed);

}


#pragma mark -
#pragma mark SET RADARVIEW

-(void)setRaderView{
	
	AISAppDelegate *appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
//	mapV = [[MKMapView alloc] initWithFrame:self.view.bounds];	
 
  
	NSLog(@"SetRadarView");
    radarSets= [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"radarsettings"]];

	int persi = [[radarSets valueForKey:@"persi"] intValue];

   // float  distanceInMiles = (2*nmLenght) * 1.15077945;
   // float latdelta = distanceInMiles / 69.0;    

    //InKiloMeter
   
    float  distanceInKM = (2*nmLenght) * 1.852;
    float latdelta = distanceInKM / 111.0;
    
    MKCoordinateSpan span;
	span.latitudeDelta=latdelta;
	span.longitudeDelta=latdelta;
	CLLocationCoordinate2D pin ;//= mapV.userLocation.coordinate;
	NSDictionary *dic1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];

	pin.latitude=[[dic1 valueForKey:@"lat"] floatValue];
	pin.longitude=[[dic1 valueForKey:@"lon"] floatValue];	
	//pin.latitude=49.457298;
	//pin.longitude=0.167000;
	
	float degree = [[dic1 valueForKey:@"angle"] floatValue];
	CATransform3D positionTransform = CATransform3DMakeRotation(((360-degree)*0.0174532925), 0.0, 0.0, 1.0);
	tmpView.layer.anchorPoint=CGPointMake(0.5, 0.5);
	tmpView.layer.transform = positionTransform;		
	
	if ([map.annotations count]) {
		[map removeAnnotations:map.annotations];		
	}
//	myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollV.contentSize.width, scrollV.contentSize.height)];
	[map actionAddPinToPositionLat:[NSString stringWithFormat:@"%f",pin.latitude] andLon:[NSString stringWithFormat:@"%f",pin.longitude]];
	MKCoordinateRegion region = {pin, span};	
    //region = MKCoordinateRegionMakeWithDistance(pin, distanceInKM*1000,  distanceInKM*1000);

    map.region=region;
    
	NSDictionary *dic= [[NSDictionary alloc] initWithDictionary:appDelegate.dicData];
	
	for (NSString *aKey in dic) {

		float lat =	([[[dic valueForKey:aKey] valueForKey:@"Latitude"] floatValue]) ;
		float lon =	([[[dic valueForKey:aKey] valueForKey:@"Longitude"] floatValue]);
        
//        NSString *strMessage = [[[dic valueForKey:aKey] valueForKey:@"Message"] retain];
//        NSLog(@"Message String :: %@",strMessage);

		NSString *mmsi = [[NSString alloc] initWithFormat:@"%@  %@",[[dic valueForKey:aKey] valueForKey:@"MMSINum"],[[dic valueForKey:aKey] valueForKey:@"ShipName"]];

        int degree = [[[dic valueForKey:aKey] valueForKey:@"COG"] intValue];

		if (([[NSString stringWithFormat:@"%d",(int)lat] length] < 3) && ([[NSString stringWithFormat:@"%d",(int)lon] length] < 3)) {
			CLLocationCoordinate2D pin ;//= mapV.userLocation.coordinate;
			
			[map actionAddPinToPositionLat:[NSString stringWithFormat:@"%f",lat] andLon:[NSString stringWithFormat:@"%f",lon] withName:mmsi];  

			pin.latitude=lat;
			pin.longitude=lon;

			CGPoint startPoint = [map convertCoordinate:pin toPointToView:nil];
			int timeoutvalue = [[[dic valueForKey:aKey] valueForKey:@"UTCSecond"] intValue];
            NSDate *timeDate = (NSDate*)[[dic valueForKey:aKey] valueForKey:@"date"];
            
            float timeInterval = [[NSDate date] timeIntervalSinceDate:timeDate];
            timeInterval=timeInterval+timeoutvalue;
            timeInterval=timeInterval / 60.0;

			if (timeInterval < persi) {

                [[[tmpView viewWithTag:[mmsi intValue]] viewWithTag:10] removeFromSuperview];

                if (startPoint.x > 0 && startPoint.y > 0  && startPoint.x < scrollV.contentSize.width &&  startPoint.y < scrollV.contentSize.height) {
                    if (![targetTags containsObject:[NSNumber numberWithInt:[mmsi intValue]]]) {
                       
                         [self addSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue]  withDegree:degree withMessage:YES];
                        
//                        if ([strMessage isEqualToString:@"SART ACTIVE"] || [strMessage isEqualToString:@"SART TEST"]) {
//                            [self addSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue]  withDegree:degree withMessage:YES];
//                        }
//                        else
//                        {
//                            [self addSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue]  withDegree:degree withMessage:NO];
//                        }
					
                    }else {
                        
                        [self moveSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue] withDegree:degree withMessage:YES];
//                        if ([strMessage isEqualToString:@"SART ACTIVE"] || [strMessage isEqualToString:@"SART TEST"]) {
//                            [self moveSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue] withDegree:degree withMessage:YES];
//                        }
//                        else
//                        {
//                            [self moveSubviewWithPosition:startPoint andMMSINumber:[mmsi intValue] withDegree:degree withMessage:NO];
//                        }
                    }

                }else {
                    if ((UIView*)[tmpView viewWithTag:[mmsi intValue]]) {
                        [(UIView*)[tmpView viewWithTag:[mmsi intValue]] removeFromSuperview];
                        [targetTags removeObject:[NSNumber numberWithInt:[mmsi intValue]]];
                    }
                }
			
            }else {
				NSLog(@"remove > %d",timeoutvalue);
                
				[[tmpView viewWithTag:[mmsi intValue]] removeFromSuperview];
				[appDelegate.dicData removeObjectForKey:[NSString stringWithFormat:@"%d",[mmsi intValue]]];
				[appDelegate.arryMMSI removeObject:[NSString stringWithFormat:@"%d",[mmsi intValue]]];				
			}


		}
		[mmsi release];
	}
	
	CGPoint startPoint = [map convertCoordinate:pin toPointToView:nil];
	
	if (![targetTags containsObject:[NSNumber	numberWithInt:100000]]) {
		[self addCurrentPosition:startPoint withDegree:degree];		
	}else {
		[self moveCurrentPosition:startPoint withDegree:degree];
	}

	[dic release];	
	[NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(setRaderView) object:nil];	
	
	if ([timer isValid]) {
		[timer invalidate];
		timer=nil;
	}
	
    [radarSets release];
    
}

#pragma mark -
#pragma mark ADDING SUBVIEWS

-(void)addSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree withMessage:(BOOL)flag{
	
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 27)];
        v.backgroundColor=[UIColor clearColor];
        v.center=point;
        v.tag=num;
        
        float posi  = [[radarSets valueForKey:@"posi"] floatValue];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:v.bounds];
     
        imgV.image=[UIImage imageNamed:@"arrow.png"];
    
        NSString *strTemp = [NSString stringWithFormat:@"%d",num];
        strTemp = [strTemp substringWithRange:NSMakeRange(0, 3)];
        NSLog(@"3 Char of MMSI NO :::  %@",strTemp);
        if([strTemp isEqualToString:@"970"])
        {
            NSLog(@"Add X here");
            UILabel *lable = [[UILabel alloc] initWithFrame:imgV.bounds];
            lable.text = @"X";
            [imgV addSubview:lable];
            [lable release];
        }
    
        [v addSubview:imgV];
        [imgV release];
        CGAffineTransform   positionTransformRotate;

        if (degree != 511) {
            //(float)degree*(M_PI/180)
            positionTransformRotate= CGAffineTransformMakeRotation(degree*0.0174532925);
        }
        
        CGAffineTransform positionTransformScale=CGAffineTransformMakeScale(posi/75.0f, posi/75);
        CGAffineTransform concate = CGAffineTransformConcat(positionTransformRotate, positionTransformScale);
        v.transform =concate;

        [self addLinesToDirection:v ofMMSI:num];
        [targetTags addObject:[NSNumber numberWithInt:num]];
        [tmpView addSubview:v];	
        [tmpView bringSubviewToFront:v];

}

-(void)moveSubviewWithPosition:(CGPoint)point andMMSINumber:(int)num withDegree:(int)degree withMessage:(BOOL)flag{
	UIView *v = [tmpView viewWithTag:num];
	v.center=point;
    CGAffineTransform positionTransformRotate;
	if (degree != 511) {
		//(float)degree*(M_PI/180)
        positionTransformRotate= CGAffineTransformMakeRotation(degree*0.0174532925);
	}

    float posi  = [[radarSets valueForKey:@"posi"] floatValue];
    CGAffineTransform positionTransformScale=CGAffineTransformMakeScale(posi/75.0f, posi/75);
    CGAffineTransform concate = CGAffineTransformConcat(positionTransformRotate, positionTransformScale);
    v.transform =concate;
    
	[[v viewWithTag:10] removeFromSuperview];
	[self addLinesToDirection:v ofMMSI:v.tag];
	[tmpView bringSubviewToFront:v];
}
-(void)addCurrentPosition:(CGPoint)point withDegree:(int)degree{
	
	//UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    v.backgroundColor=[UIColor clearColor];
	v.center=point;
	v.tag=100000;
    v.userInteractionEnabled=FALSE;
    
	v.layer.anchorPoint=CGPointMake(0.5, 0.5);
	v.layer.borderColor=[UIColor clearColor].CGColor;
	v.layer.borderWidth=0.5;
	float posi  = [[radarSets valueForKey:@"posi"] floatValue];
	
    UIImageView *imgV =[[UIImageView alloc] initWithFrame:v.bounds];
    imgV.image=[UIImage imageNamed:@"middle.png"];
    [v addSubview:imgV];
    [imgV release];
    
	v.transform = CGAffineTransformMakeScale(posi/75, posi/75);
	CGAffineTransform positionTransformRotate;

	if (degree != 511  && degree <= 360) {
		//(float)degree*(M_PI/180)
        positionTransformRotate =CGAffineTransformMakeRotation(degree*0.0174532925);// CATransform3DMakeRotation((degree*0.0174532925), 0.0, 0.0, 1.0);
		//v.layer.transform = positionTransform;
	}
	[targetTags addObject:[NSNumber numberWithInt:100000]];
	[tmpView addSubview:v];
    
    CGAffineTransform positionTransformScale=CGAffineTransformMakeScale(posi/75.0f, posi/75.0f);
    CGAffineTransform concate = CGAffineTransformConcat(positionTransformRotate, positionTransformScale);
    v.transform =concate;

    v.userInteractionEnabled=NO;
    [self addLinesToCurrentToDirection:v];
    
	[tmpView bringSubviewToFront:v];
}

-(void)moveCurrentPosition:(CGPoint)point withDegree:(int)degree{
	
	UIView *v = [tmpView viewWithTag:100000];
	v.center=point;
    CGAffineTransform positionTransformRotate;
	if (degree != 511  && degree <= 360) {
		//(float)degree*(M_PI/180)
		positionTransformRotate = CGAffineTransformMakeRotation(degree*0.0174532925);
       
	}
	float posi  = [[radarSets valueForKey:@"posi"] floatValue];
    
    CGAffineTransform positionTransformScale=CGAffineTransformMakeScale(posi/75.0f, posi/75);
    CGAffineTransform concate = CGAffineTransformConcat(positionTransformRotate, positionTransformScale);
    v.transform =concate; 
    
    [self addLinesToCurrentToDirection:v];
	[tmpView bringSubviewToFront:v];
}

-(void)addLinesToDirection:(UIView*)view1 ofMMSI:(int)MMSINo{
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(5.0, 2, 1.5, -40)];
	float sog = [[(NSDictionary*)[del.dicData valueForKey:[NSString stringWithFormat:@"%d",MMSINo]] valueForKey:@"SOG"] floatValue];
    
  //  NSLog(@"MMSI: %d >> sog: %f",MMSINo,sog);
	int velo = [[radarSets valueForKey:@"velo"] intValue];
	v.tag=10;
    
    //In Miles
	float lengh = (sog * ((float)velo/60.0));
    
    float lenghtInNM = lengh * 0.868976242;
    
    //changes
    //totalLenght in NM
    float totalLenght = 2.0*nmLenght;

    lengh = (367.0*lenghtInNM)/totalLenght;
   
	v.frame=CGRectMake(5.0, 2, 1.5, -lengh);
	[v setClearsContextBeforeDrawing:YES];
	v.layer.masksToBounds=YES;
	//v.center=view1.center;
	v.backgroundColor=[UIColor yellowColor];
    
    [[view1 viewWithTag:10] removeFromSuperview];
	[view1 addSubview:v];
    
}

-(void)addLinesToCurrentToDirection:(UIView*)view1{

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(7.5, 2, 1.5, -40)];
    NSDictionary *dic1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];

    float sog = [[dic1 valueForKey:@"sog"] floatValue];
   
    //  NSLog(@"MMSI: %d >> sog: %f",MMSINo,sog);
	int velo = [[radarSets valueForKey:@"velo"] intValue];
	v.tag=10;
    
    //In Miles
	float lengh = (sog * ((float)velo/60.0));
    
    float lenghtInNM = lengh * 0.868976242;
    
    //changes
    //totalLenght in NM
    float totalLenght = 2.0*nmLenght;
    
    lengh = (367.0*lenghtInNM)/totalLenght;
    
	v.frame=CGRectMake(7.5, 2, 1.5, -lengh);
	[v setClearsContextBeforeDrawing:YES];
	v.layer.masksToBounds=YES;
	//v.center=view1.center;
	v.backgroundColor=[UIColor yellowColor];	
    
      [[view1 viewWithTag:10] removeFromSuperview];
	[view1 addSubview:v];
    [view1 sendSubviewToBack:v];
    
}

#pragma mark -
#pragma mark STATIC VIEWS

-(void)addBackgroundImage{

	UIImageView *imgV = [[UIImageView alloc] init];
	
	imgV.image=[UIImage imageNamed:@"round_1-1.png"];
	imgV.userInteractionEnabled=TRUE;

	scrollV.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:155.0f/255.0f alpha:1.0];
	//scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, scrollV.frame.size.height);
	scrollV.contentSize=CGSizeMake(720, (367.0*720.0)/320.0);
	NSLog(@"size %f	%f",scrollV.contentSize.width,scrollV.contentSize.height);
	imgV.frame=CGRectMake(0, 0, scrollV.contentSize.width, scrollV.contentSize.height);

	//rader = [[RaderBackground alloc] initWithFrame:imgV.bounds];
    //[imgV addSubview:rader];
    //   rader.alpha=0.0;
    [scrollV addSubview:imgV];
    [imgV release];
//	[scrollV addSubview:rader];
}

-(void)showDistanceLabels{
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];

    font=[UIFont boldSystemFontOfSize:12];
    distance1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
	distance1.center=CGPointMake(scrollV.contentSize.width/2, scrollV.contentSize.height/2-85);	
	distance1.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght/2];
	[scrollV addSubview:distance1];

	distance2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
	distance2.center=CGPointMake(scrollV.contentSize.width/2, scrollV.contentSize.height/2-178);	
	distance2.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght];
   // nmLenght=[distance2.text floatValue];
	[scrollV addSubview:distance2];

	distance3=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
	distance3.center=CGPointMake(scrollV.contentSize.width/2, scrollV.contentSize.height/2-270);	
	distance3.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght+nmLenght/2];
	[scrollV addSubview:distance3];
	
 	distance4=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
	distance4.center=CGPointMake(scrollV.contentSize.width/2, scrollV.contentSize.height/2-360);	
	distance4.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght+nmLenght];
	[scrollV addSubview:distance4];
    
    distance1.minimumFontSize=distance2.minimumFontSize=distance3.minimumFontSize=distance4.minimumFontSize=12;
    distance1.font=distance2.font=distance3.font=distance4.font=font;
    distance1.textAlignment=distance2.textAlignment=distance3.textAlignment=distance4.textAlignment=UITextAlignmentCenter;

    distance1.layer.cornerRadius=distance2.layer.cornerRadius=distance3.layer.cornerRadius=distance4.layer.cornerRadius=4.0;
    distance1.layer.masksToBounds=distance2.layer.masksToBounds=distance3.layer.masksToBounds=distance4.layer.masksToBounds=YES;
	
    distance1.textColor=distance2.textColor=distance3.textColor=distance4.textColor=[UIColor blueColor];
    
    distance1.userInteractionEnabled=distance2.userInteractionEnabled=distance3.userInteractionEnabled=NO;
}

-(void)showZoomButtons{
	
	UIButton *btnZoomPlus =[UIButton buttonWithType:UIButtonTypeRoundedRect];
	btnZoomPlus.frame=CGRectMake(12, 14, 45, 40);
	[btnZoomPlus setTitle:@"+" forState:UIControlStateNormal];
	btnZoomPlus.tag=1;
	[btnZoomPlus addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnZoomPlus.alpha=0.7;
    
	[self.view addSubview:btnZoomPlus];
	
	UIButton *btnZoomMin =[UIButton buttonWithType:UIButtonTypeRoundedRect];
	btnZoomMin.frame=CGRectMake(260, 14, 45, 40);
	[btnZoomMin setTitle:@"-" forState:UIControlStateNormal];
	btnZoomMin.tag=2;
	[btnZoomMin addTarget:self action:@selector(zoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnZoomMin.alpha=0.7;
	[self.view addSubview:btnZoomMin];
    
}

#pragma mark -
#pragma mark USER ACTION

-(void)zoomBtnClicked:(id)sender{
	UIButton *btn = (UIButton*)sender;
    int count = [distanceArray count];
		if (btn.tag == 1) {
			//+
 			if (zoomlevel+1 < count) {
				delta = delta/2;
                zoomlevel++;
                nmLenght=[[distanceArray objectAtIndex:zoomlevel] floatValue];
				[self setRaderView];
			}
		}else {
			//-			
			if (zoomlevel > 0) {
				delta = delta*2;
                 zoomlevel--;
                nmLenght=[[distanceArray objectAtIndex:zoomlevel] floatValue];
				[self setRaderView];
			}
			
		}		

//	NSString *lbl2str=[NSString stringWithFormat:@"%3.2f",((map.region.span.longitudeDelta )*0.539956803)];
//  distance2.text=[NSString stringWithFormat:@"%3.2f",nmLenght];
//	distance1.text=[NSString stringWithFormat:@"%3.2f",(((map.region.span.longitudeDelta )*0.539956803)/2)];

	distance1.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght/2];
    distance2.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght];
    distance3.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght+nmLenght/2];
    distance4.text=[NSString stringWithFormat:@"%3.2fNM",nmLenght+nmLenght];
    
    //NSLog(@"del %f",((map.region.span.latitudeDelta * 111)*0.539956803));	
}


-(void)removeSumViewFromScrollV{
	NSArray *ar = [scrollV subviews];
	for (int i=0; i<[ar count]; i++) {
		if ([(UIView*)[ar objectAtIndex:i] tag] > 10) {
			[(UIView*)[ar objectAtIndex:i] removeFromSuperview];
			i++;			
		}
	}
}

#pragma mark -
#pragma mark TOUCH EVENT
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	[scrollV setScrollEnabled:NO];
	if ([[touches allObjects] count] > 1) {
		//[[touch view] setAlpha:0.4];
		UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
		UITouch *touch2 = [[touches allObjects] objectAtIndex:1];
		
		 diffx = [touch1 locationInView:self.view].x -[touch2 locationInView:self.view].x;
		 diffy = [touch1 locationInView:self.view].y -[touch2 locationInView:self.view].y;

		diffx=fabs(diffx);
		diffy=fabs(diffy);
		
		NSLog(@"%f  %f",diffx,diffy);
	}
	moving=0;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	moving=1;
	if ([[touches allObjects] count] > 1) {
		UITouch *touch1 = [[touches allObjects] objectAtIndex:0];
		UITouch *touch2 = [[touches allObjects] objectAtIndex:1];
		
		double diffx1 = fabs([touch1 locationInView:self.view].x -[touch2 locationInView:self.view].x);
		double diffy1 = fabs([touch1 locationInView:self.view].y -[touch2 locationInView:self.view].y);
	
		if ((diffx1-diffx) > 8.0  ||  (diffy1-diffy) > 8.0 ) {
			//NSLog(@">>>");
			
			//+
			UIButton *btn = [[UIButton alloc] init];
			btn.tag=1;
			[self zoomBtnClicked:btn];
            [btn release];
			diffx=fabs(diffx1);
			diffy=fabs(diffy1);
		}else if ((diffx1-diffx) < -8.0  ||  (diffy1-diffy) < -8.0 ){
			//NSLog(@"<<<");
			
			UIButton *btn = [[UIButton alloc] init];
			btn.tag=2;
			[self zoomBtnClicked:btn];
             [btn release];
			diffx=fabs(diffx1);
			diffy=fabs(diffy1);
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	[scrollV setScrollEnabled:YES];
	NSLog(@"count %d",[[touches allObjects] count]);
	if ([[touches allObjects] count] <= 1) {
		if ([touch view].tag > 2  && moving==0) {
		AISAppDelegate *appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
		//[[touch view] setAlpha:1.0];
		NSLog(@"%d",[touch view].tag);
		DetailVIew *detail =[[DetailVIew alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		detail.backgroundColor=[UIColor whiteColor];
		detail.MMSI.text=[NSString stringWithFormat:@"%d",[touch view].tag];
            
            NSString *key = [NSString stringWithFormat:@"%d",[touch view].tag];
            if ([appDelegate.dicData valueForKey:key]) {
                [detail setDictionaryValues:[NSDictionary dictionaryWithDictionary:[appDelegate.dicData valueForKey:key]]];
            }            
		[self.view addSubview:detail];
            
		}
	}
}

#pragma mark -

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

#pragma mark -

-(CGPoint)convertPoint:(CGPoint)point{
	CGPoint returnPoint;
	CGFloat xDel = scrollV.contentSize.width;
	CGFloat yDel = scrollV.contentSize.height;
	
	
	//h 460 720
	//w	320 720
	float x = (point.x*xDel)/367.0;
	float y = (point.y*yDel)/320.0;
	returnPoint = CGPointMake(x, y);
	
	return returnPoint;
}

-(void)didDisconnectToServer{
    
}

-(void)didConnectToServer{
    
}

-(void)didReceiveDataFile:(NSString*)fileName{
	
    AISAppDelegate *appDel = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
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
                
                }
                [dataDic release];
            }
        }
		//	Horizontal Dilution of Precision
        [nmeaSen release];
    }
	[wordListArray release];
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
