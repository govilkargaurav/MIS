//
//  InstrumentMoniter.h
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupView.h"
#import "AISAppDelegate.h"
#import "TLNMEASentence.h"
#import "TLNMEASentenceDecoding.h"
#import "EncodeTypeGSA.h"
@interface InstrumentMoniter : UIViewController<wifiDelegate> {

	AISAppDelegate *appDel;
	
	IBOutlet UILabel *lblCog;
	IBOutlet UILabel *lblSog;
	IBOutlet UILabel *lblLat;
	IBOutlet UILabel *lblLon;
	IBOutlet UILabel *lblGps;
	NSDictionary *unitssets;
    

	
}
-(BOOL)IsGPRMCString:(NSString*)string;
@end
