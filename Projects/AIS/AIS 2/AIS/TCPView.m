//
//  TCPView.m
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import "TCPView.h"


@implementation TCPView

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
    appDel = (AISAppDelegate*)[[UIApplication sharedApplication] delegate];


    
	flag=0;
	self.title=@"TCP/IP";
	yDist=0.0;
	scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(txtPings.frame.origin.x+10, txtPings.frame.origin.y+10, txtPings.frame.size.width-20, txtPings.frame.size.height-20)];
	scrollV.contentSize=scrollV.bounds.size;
	[scrollV setShowsVerticalScrollIndicator:YES];
	[scrollV setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	txtPings.userInteractionEnabled=NO;
	scrollV.tag=11;	
	
	[self.view addSubview:scrollV];

	
	Host.text= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"host"]];
	Port.text= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"port"]];
	
		
	appDel.delegate=self;
	
	txtPings.layer.cornerRadius = 12.0;
	txtPings.layer.masksToBounds=YES;
	
	
	anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Hosts" style:UIBarButtonItemStylePlain
																	  target:self action:@selector(ClickExit:)];      
	self.navigationItem.leftBarButtonItem = anotherButton1;
	
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain
																	 target:self action:@selector(ClickSave:)];      
	self.navigationItem.rightBarButtonItem = anotherButton;
	
	
	if ([appDel.asyncSocket isConnected]) {
		[Link setOn:YES];
		[self linkOnOff:Link];
	}

    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"ips"]];
    
    if ([arr count] == 0) {
        [anotherButton1 setEnabled:NO];        
    }
    
    [arr release];
}

-(void)viewWillAppear:(BOOL)animated{

//    alarmflag
 //   locationflag
    [super viewWillAppear:animated];
    
    [Alarm setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"alarmflag"]];
    [Location  setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"locationflag"]];
    
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

-(IBAction)linkOnOff:(id)sender{
	UISwitch *swt  = (UISwitch*)sender;
	
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"ips"]];
    
    NSString *hostStr=[NSString stringWithFormat:@"%@",Host.text];
    NSString *portStr=[NSString stringWithFormat:@"%@",Port.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:hostStr,@"host",portStr,@"port", nil];
    
    if (![arr containsObject:dic]) {
        [arr addObject:dic];
        [[NSUserDefaults standardUserDefaults] setValue:arr forKey:@"ips"];
        [[NSUserDefaults standardUserDefaults] synchronize];
     
        [anotherButton1 setEnabled:YES];
    }
    

	if (swt.on) {
		
		appDel.delegate=self;
		[appDel listInterfaces];
		[appDel startDNSResolve];
        
        //[appDel startSimulationForData];
        
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"isConnected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}else {
		
	//	txtPings.text=@"";
		[appDel disconnectFromSocket];
		appDel.delegate=nil;
        [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"isConnected"];
        [[NSUserDefaults standardUserDefaults] synchronize];

	}
    
    [arr release];
	
} 

-(IBAction)locationOnOff:(id)sender{


    if (Location.on) {
        //on
        [appDel.locManager startUpdatingLocation];
        [appDel.locManager startUpdatingHeading];
    }else{
        //off
        [appDel.locManager stopUpdatingLocation];
        [appDel.locManager stopUpdatingHeading];

    }
    
    
}

#pragma mark -
#pragma mark Socket

-(void)didReceiveDataFile:(NSString*)fileName{
	
	NSString *st = [[NSString alloc] initWithContentsOfFile:fileName];
//	txtPings.text =st;
	
   
	flag++;
	if (flag == 5) {
        
        if(wordListArray){
            [wordListArray release];
        }
		wordListArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithContentsOfFile:fileName encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
		flag=0;
		yDist=0.0;
		for (int i=0; i<[scrollV.subviews count]; i++) {			
			[(UIView*)[scrollV.subviews objectAtIndex:i] removeFromSuperview];	
			i--;
		}
		
	
		
		[wordListArray removeLastObject];
		for (int i=0; i< [wordListArray count]; i++) {
			 NSString *sen = [NSString stringWithFormat:@"%@",[wordListArray objectAtIndex:i]];
			 UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, yDist, scrollV.frame.size.width-10, 15)];
			 lbl.text=sen;
			 lbl.textColor=[UIColor colorWithRed:126.0f/255.0f green:255.0f/255.0f blue: 37.0f/255.0f alpha:1.0];
			 lbl.userInteractionEnabled=NO;
			 lbl.backgroundColor=[UIColor clearColor];
			 lbl.textAlignment=UITextAlignmentLeft;		 		
			 lbl.font =[UIFont fontWithName:@"Helvetica" size:12];
			 lbl.tag=i;
			 [scrollV addSubview:lbl];
			 yDist=yDist+15;
			scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, yDist);
			[scrollV setContentOffset:CGPointMake(0, scrollV.contentSize.height-150)];
            [lbl release];
		}
		
		 
		
		
	}else {
		NSMutableArray	*TMPwordListArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithContentsOfFile:fileName encoding:NSMacOSRomanStringEncoding error:NULL] componentsSeparatedByString:@"\n"]];
		if ([TMPwordListArray count]>0) {
			[TMPwordListArray removeLastObject];
		}
		
		
		
		for (int i=0; i<[TMPwordListArray count]; i++) {
			
			if (![wordListArray containsObject:[TMPwordListArray objectAtIndex:i]]) {
				
				
				NSString *sen = [NSString stringWithFormat:@"%@",[TMPwordListArray objectAtIndex:i]];
				UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, yDist, scrollV.frame.size.width-10, 15)];
				lbl.text=sen;
				lbl.textColor=[UIColor colorWithRed:126.0f/255.0f green:255.0f/255.0f blue: 37.0f/255.0f alpha:1.0];
				lbl.userInteractionEnabled=NO;
				lbl.backgroundColor=[UIColor clearColor];
				lbl.textAlignment=UITextAlignmentLeft;		 		
				lbl.font =[UIFont fontWithName:@"Helvetica" size:12];
				[scrollV addSubview:lbl];
				yDist=yDist+15;
				
				[wordListArray addObject:[TMPwordListArray objectAtIndex:i]];
				
				scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, yDist);
				[scrollV setContentOffset:CGPointMake(0, scrollV.contentSize.height-150)];
                [lbl release];
			}
			
		}
		
        [TMPwordListArray release];
	
	}
    
    
  
    [st release];
	
}



-(void)didConnectToServer{
	
/*	NSMutableString *st = [NSMutableString stringWithFormat:@"%@",txtPings.text];
	[st appendFormat:@"\n-->CONNECT"];
	txtPings.text= st;
	[txtPings setContentOffset:CGPointMake(0, scrollV.contentSize.height)];
	*/
	
	
/*	if (yDist == 0.0) {
		yDist=5;
	}

	NSString *sen = @"-->CONNECT";
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, yDist, scrollV.frame.size.width-10, 15)];
	lbl.text=sen;
	lbl.textColor=[UIColor whiteColor];
	lbl.userInteractionEnabled=NO;
	lbl.backgroundColor=[UIColor clearColor];
	lbl.textAlignment=UITextAlignmentLeft;		 
	yDist=yDist+15;
	lbl.backgroundColor=[UIColor redColor];
	lbl.font =[UIFont fontWithName:@"Helvetica" size:12];
	[scrollV addSubview:lbl];
	scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, yDist);
	[scrollV setContentOffset:CGPointMake(0, scrollV.contentSize.height)];*/
}
-(void)didDisconnectToServer{
	
/*	NSMutableString *st = [NSMutableString stringWithFormat:@"%@",txtPings.text];
	[st appendFormat:@"\n-->DISCONNECT"];
	txtPings.text= st;
	[txtPings setContentOffset:CGPointMake(0, txtPings.contentSize.height)];
 */
	
	NSString *sen = @"-->DISCONNECT";
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, yDist, scrollV.frame.size.width-10, 15)];
	lbl.text=sen;
	lbl.textColor=[UIColor whiteColor];
	lbl.userInteractionEnabled=NO;
	lbl.backgroundColor=[UIColor clearColor];
	lbl.textAlignment=UITextAlignmentLeft;		 
	yDist=yDist+15;
	lbl.font =[UIFont fontWithName:@"Helvetica" size:12];
	[scrollV addSubview:lbl];
	scrollV.contentSize=CGSizeMake(scrollV.frame.size.width, yDist);
	[scrollV setContentOffset:CGPointMake(0, scrollV.contentSize.height)];
	
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
-(void)ClickExit:(id)sender{
	//[self.navigationController popViewControllerAnimated:YES];
    
    UIActionSheet *sheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];

    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"ips"];
   
    for (int i=0; i<[arr count]; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        NSString *str =[[NSString alloc] initWithFormat:@"%@  %@",[dic valueForKey:@"host"],[dic valueForKey:@"port"]];
        [sheet1 addButtonWithTitle:str];        
    }
    
    [sheet1 showInView:self.navigationController.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (buttonIndex == 0) {
        //delete
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ips"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [anotherButton1 setEnabled:NO];
        
    }else if(buttonIndex == 1){
        //cancel
        
    }else if(buttonIndex > 1){
        NSDictionary *dic  = (NSDictionary*)[(NSArray*)[[NSUserDefaults standardUserDefaults] valueForKey:@"ips"] objectAtIndex:buttonIndex-2];
        Host.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"host"]];
        Port.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"port"]]; 
        
        [Link setOn:YES];
        [self linkOnOff:Link];

    }    
}

-(void)ClickSave:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setBool:Alarm.on forKey:@"alarmflag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:Location.on forKey:@"locationflag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Data Saved"
												  message:@"Press OK to continue" 
												 delegate:self 
										cancelButtonTitle:nil 
										otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:NO];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[Link setOn:NO];
	[self linkOnOff:Link];
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	switch (textField.tag) {
		case 11:	
			[[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"host"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			break;
		case 22:	
			[[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"port"];
			[[NSUserDefaults standardUserDefaults] synchronize];

			break;
		default:
			break;
	}
	
	
	[textField resignFirstResponder];
	return YES;
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	appDel.delegate=nil;
    
    
  
	
}
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
