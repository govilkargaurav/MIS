//
//  MeetingDetailCell.h
//  MinutesInSeconds
//
//  Created by Gaurav on 8/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"
#import "CustomUIApplicationClass.h"

@interface MeetingDetailCell : UIViewController<POHorizontalListDelegate>
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblAttendees;
    IBOutlet UITextView *txtVWDescription;
    IBOutlet UILabel *lblTimeLable;
    IBOutlet UILabel *lblZoneLable;
    IBOutlet UISlider *sliderClipPlay;
    IBOutlet UILabel *lblTotalTimeOfClip;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnStop;
    NSDictionary *dictMeetingInfoLocal;
    IBOutlet UILabel *lblComment;
    IBOutlet UITextView *txtViewComment;
    int _index_path;
    NSMutableArray *arrSelectedUserInfo;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil _dictMeetingInfo:(NSDictionary *)dictMeetingInfo indexPath:(int) IndexPath;
@end
