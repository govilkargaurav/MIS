//
//  SetupView.h
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitsView.h"
#import "TCPView.h"
#import "RadarSetup.h"

@interface SetupView : UIViewController<UIAlertViewDelegate> {


}

-(void)ClickExit:(id)sender;
-(IBAction)ClickRadarSetup;
-(IBAction)ClickUnits;
-(IBAction)ClickTCP;

@end
