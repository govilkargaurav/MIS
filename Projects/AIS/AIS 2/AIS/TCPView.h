//
//  TCPView.h
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AISAppDelegate.h"
#import "TLNMEASentence.h"
#import "TLNMEASentenceDecoding.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
@interface TCPView : UIViewController <wifiDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIActionSheetDelegate>{

	IBOutlet UITextView *txtPings;
	UIScrollView *scrollV;
	IBOutlet UITextField *Host;
	IBOutlet UITextField *Port;
	IBOutlet UISwitch *Link;
    
    IBOutlet UISwitch *Alarm;
    IBOutlet UISwitch *Location;

	AISAppDelegate *appDel;
	float yDist;
	
	int flag;
	NSMutableArray *wordListArray;
    UIBarButtonItem *anotherButton1;
    CLLocationManager *locManager;

}
-(IBAction)linkOnOff:(id)sender;
-(IBAction)locationOnOff:(id)sender;
-(BOOL)IsGPRMCString:(NSString*)string;
-(void)addLabelWithString:(NSString*)lblStr;

-(IBAction)setAlarm:(id)sender;
-(IBAction)setLocation:(id)sender;
@end
