//
//  RadarSetup.h
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RadarSetup : UIViewController<UIAlertViewDelegate> {

	IBOutlet UISlider *PosiSlider;
	IBOutlet UISlider *velocitySlider;
	IBOutlet UISlider *targetPersiSlider;
	
	IBOutlet UILabel *lblPosi;
	IBOutlet UILabel *lblVelo;
	IBOutlet UILabel *lblPersi;
	
	NSMutableDictionary *radarSettings;
}

-(IBAction)postionSliderValueChange:(id)sender;
-(IBAction)velocitySliderValueChange:(id)sender;
-(IBAction)persistenceSliderValueChange:(id)sender;
-(void)setValuesAsPerSettings;
@end
