//
//  CellUpperViewViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/30/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AwesomeMenu.h"


@interface CellUpperViewViewController : UIViewController
{
    IBOutlet UILabel *lblTitle;
    UILabel *lbltime;
    UILabel *lbltimeAMPM;
    UILabel *lblDate;
    UIImageView *imgclock;
    UIImageView *imgLableBgGreen;
    UIImageView *connector;
    IBOutlet UIImageView *imgViewBg;
    
    IBOutlet UILabel *lblForMoreSubMeetings;
    UILabel *lbltimeForTwo;
    UILabel *lbltimeAMPMForTwo;
    UILabel *lblDateForTwo;
    UIImageView *imgclockForTwo;
    UIImageView *imgLableBgGreenForTwo;
    UIImageView *connectorForTwo;
    
    
    UILabel *lbltimeForThree;
    UILabel *lbltimeAMPMForThree;
    UILabel *lblDateForThree;
    UIImageView *imgclockForThree;
    UIImageView *imgLableBgGreenForThree;
    
    int ForMeetingsNo;
    int indexPathRow;
    NSDictionary *_dictMeetingInfo;
    NSArray* arrTimewithZone;
    NSArray *arrayOfSubMeetingsLocal;
    
}
@property (nonatomic)int countOfMeetings;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forSigleOrMulti:(int)NoOfMeetings indexPthRow:(int)indexPathRow _dictMeetingInfo:(NSDictionary *)dictmeetingInfo arrayOfSubMeetings:(NSArray *)arrayOfSubMeetings;
+ (id)sharedManager;
@end
