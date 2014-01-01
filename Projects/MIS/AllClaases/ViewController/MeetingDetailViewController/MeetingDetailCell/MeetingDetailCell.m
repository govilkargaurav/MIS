//
//  MeetingDetailCell.m
//  MinutesInSeconds
//
//  Created by Gaurav on 8/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "MeetingDetailCell.h"
@interface MeetingDetailCell ()

@end

@implementation MeetingDetailCell

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil _dictMeetingInfo:(NSDictionary *)dictMeetingInfo indexPath:(int) IndexPath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dictMeetingInfoLocal = dictMeetingInfo;
        _index_path= IndexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *strTIMEWithAMPM = [dictMeetingInfoLocal valueForKey:MEETINGS_TIME];
    NSArray *arrTimewithZone= [strTIMEWithAMPM componentsSeparatedByString: @" "];

    btnPlay.tag = _index_path+1000;
    btnStop.tag = _index_path+2000;
    lblTotalTimeOfClip.tag = _index_path+3000;
    sliderClipPlay.tag = _index_path + 4000;
    
    // Do any additional setup after loading the view from its nib.
    lblTitle.textColor= [UIColor blackColor];
    lblTitle.text=[NSString stringWithFormat:@"%@",[dictMeetingInfoLocal valueForKey:MEETING_TITLE]];
    lblTitle.font = [UIFont fontWithName:@"OpenSans-Light" size:22.0];
    lblTitle.textAlignment=NSTextAlignmentLeft;
    lblTitle.backgroundColor=[UIColor clearColor];
   
//    //get label string width
//    CGFloat lblWidth=[CustomUIApplicationClass getStringHeightforLabel:lblTitle];
//    lblTitle.frame=CGRectMake(18, 24, lblWidth+5, 27);
    
    lblTotalTimeOfClip.textColor= [UIColor whiteColor];
    lblTotalTimeOfClip.text=[NSString stringWithFormat:@"0:0/0:0"];
    lblTotalTimeOfClip.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    lblTotalTimeOfClip.textAlignment=NSTextAlignmentCenter;
    lblTotalTimeOfClip.backgroundColor=[UIColor clearColor];
    
    lblTimeLable.textColor= [UIColor blackColor];
    lblTimeLable.text=[NSString stringWithFormat:@"%@",[arrTimewithZone objectAtIndex:0]];
    lblTimeLable.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
    lblTimeLable.textAlignment=NSTextAlignmentRight;
    lblTimeLable.backgroundColor=[UIColor clearColor];
    
    lblZoneLable.textColor= [UIColor blackColor];
    lblZoneLable.text=[NSString stringWithFormat:@"%@",[arrTimewithZone objectAtIndex:1]];
    lblZoneLable.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    lblZoneLable.textAlignment=NSTextAlignmentRight;
    lblZoneLable.backgroundColor=[UIColor clearColor];
    
    txtVWDescription.textColor= [UIColor blackColor];
    txtVWDescription.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    txtVWDescription.text = [dictMeetingInfoLocal valueForKey:SPEECH_TO_TEXT];
    txtVWDescription.textAlignment=NSTextAlignmentCenter;
    txtVWDescription.backgroundColor=[UIColor clearColor];
    
    lblComment.font  = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    lblComment.textAlignment=NSTextAlignmentCenter;
    lblComment.textColor=[UIColor blackColor];
    
    lblAttendees.font=[UIFont fontWithName:@"OpenSans-Light" size:12];
    
    txtViewComment.textColor= [UIColor blackColor];
    txtViewComment.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    txtViewComment.text = [dictMeetingInfoLocal valueForKey:MEETING_COMMENT];
    txtViewComment.textAlignment=NSTextAlignmentCenter;
    txtViewComment.backgroundColor=[UIColor clearColor];
    
    
    NSData *data = [dictMeetingInfoLocal valueForKey:MEETING_ATTENDEES_ID];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    arrSelectedUserInfo = [[NSMutableArray alloc] init];
   
    // add attendees view
    for (int i=0; i<[array count]; i++) {
        
        NSDictionary *dict = [array objectAtIndex:i];
        ListItem *list = [[ListItem alloc] initWithFrame:CGRectZero image:[dict valueForKey:SELECTED_USER_IMAGE] text:[dict valueForKey:SELECTED_USER_NAME]];
        [arrSelectedUserInfo addObject:list];
    }
    
    POHorizontalList *list;
    list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0,331.0, 320.0, 88.0) title:nil items:arrSelectedUserInfo];
    [self.view addSubview:list];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
