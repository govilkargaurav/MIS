//
//  UnitsView.h
//  AIS
//
//  Created by System Administrator on 11/24/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UnitsView : UIViewController<UIAlertViewDelegate>{

	IBOutlet UISegmentedControl *posi;
	IBOutlet UISegmentedControl *dis;
	IBOutlet UISegmentedControl *speed;
	IBOutlet UISegmentedControl *depth;
	NSMutableDictionary *unitssettings;
	
}
-(void)setValuesAsPerSettings;
-(void)saveSettingValue;
-(IBAction)postionSegmentValueChange:(id)sender;
-(IBAction)distanceSegmentValueChange:(id)sender;
-(IBAction)speedSegmentValueChange:(id)sender;
-(IBAction)depthSegmentValueChange:(id)sender;
@end
