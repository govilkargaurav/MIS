//
//  CellUpperViewViewController.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/30/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "CellUpperViewViewController.h"

@interface CellUpperViewViewController ()

@end

@implementation CellUpperViewViewController
@synthesize countOfMeetings;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forSigleOrMulti:(int)NoOfMeetings indexPthRow:(int)indexPathRow _dictMeetingInfo:(NSDictionary *)dictmeetingInfo arrayOfSubMeetings:(NSArray *)arrayOfSubMeetings
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ForMeetingsNo = NoOfMeetings;
        _dictMeetingInfo= dictmeetingInfo;
        if ([arrayOfSubMeetings count]>0) {
            countOfMeetings = [arrayOfSubMeetings count];
            if (countOfMeetings>2) {
                arrayOfSubMeetingsLocal = [arrayOfSubMeetings subarrayWithRange:NSMakeRange(0, 2)];
            }else{
                arrayOfSubMeetingsLocal = arrayOfSubMeetings;
            }
        }
    }
    return self;
}

+ (id)sharedManager {
    static CellUpperViewViewController *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *strTIMEWithAMPM = [_dictMeetingInfo valueForKey:MEETINGS_TIME];
    arrTimewithZone= [strTIMEWithAMPM componentsSeparatedByString: @" "];
    lblTitle.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    lblTitle.text = [_dictMeetingInfo valueForKey:MEETING_TITLE];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAnimationshow) name:@"NAMEPOST" object:nil];
    /* SetUp Single Event Cell */
    if ([arrayOfSubMeetingsLocal count]==0) {
        [self setupcell:nil];
    }else if([arrayOfSubMeetingsLocal count]==1){
         [self setupcell:nil];
        NSDictionary *dict = [arrayOfSubMeetingsLocal objectAtIndex:0];
        [self setupcellforTwo:dict];
    }else{
        [self setupcell:nil];
        NSDictionary *dict = [arrayOfSubMeetingsLocal objectAtIndex:0];
        NSDictionary *dict1= [arrayOfSubMeetingsLocal objectAtIndex:1];
        [self setupcellforTwo:dict];
        [self setupCellForThree:dict1];
    }
    
    
}

-(void)setupcell:(id)sender{
    
    lbltime = [[UILabel alloc] initWithFrame:CGRectMake(37, 51, 40, 25)];
    lbltime.textColor= [UIColor whiteColor];
    lbltime.text = [arrTimewithZone objectAtIndex:0];
    lbltime.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    lbltime.textAlignment=NSTextAlignmentCenter;
    lbltime.backgroundColor = [UIColor clearColor];
    
    lbltimeAMPM= [[UILabel alloc] initWithFrame:CGRectMake(53, 71, 19, 15)];
    lbltimeAMPM.textColor= [UIColor whiteColor];
    lbltimeAMPM.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    lbltimeAMPM.text = [arrTimewithZone objectAtIndex:1];
    lbltimeAMPM.textAlignment=NSTextAlignmentCenter;
    lbltimeAMPM.backgroundColor = [UIColor clearColor];

    lblDate = [[UILabel alloc] initWithFrame:CGRectMake(136, 60, 151, 21)];
    lblDate.textColor= [UIColor whiteColor];
    lblDate.text=[_dictMeetingInfo valueForKey:MEETING_DATE_TIME];
    lblDate.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    [self.view addSubview:lblDate];
    lblDate.textAlignment=NSTextAlignmentCenter;
    lblDate.backgroundColor=[UIColor clearColor];
    
    imgclock = [[UIImageView alloc] initWithFrame:CGRectMake(82, 56, 31, 31)];
    [imgclock setImage:[UIImage imageNamed:@"watchGreen.png"]];
    
    imgLableBgGreen=[[UIImageView alloc] initWithFrame:CGRectMake(127, 56, 173, 30)];
    [imgLableBgGreen setImage:[UIImage imageNamed:@"timeHolderCurrent.png"]];
    
    [self.view addSubview:lbltime];
    [self.view addSubview:lbltimeAMPM];
    [self.view addSubview:lblDate];
    [self.view addSubview:imgclock];
    [self.view addSubview:imgLableBgGreen];
    
}



-(void)setupcellforTwo:(id)sender{

    NSString *strTIMEWithAMPM = [sender valueForKey:MEETINGS_TIME];
    arrTimewithZone= [strTIMEWithAMPM componentsSeparatedByString: @" "];
    
    /* For Second Meeting */
    lbltimeForTwo = [[UILabel alloc] initWithFrame:CGRectMake(37, 113, 40, 25)];
    lbltimeForTwo.textColor= [UIColor whiteColor];
    lbltimeForTwo.text = [arrTimewithZone objectAtIndex:0];
    lbltimeForTwo.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    lbltimeForTwo.textAlignment=NSTextAlignmentCenter;
    lbltimeForTwo.backgroundColor = [UIColor clearColor];
    
    lbltimeAMPMForTwo= [[UILabel alloc] initWithFrame:CGRectMake(53, 133, 19, 15)];
    lbltimeAMPMForTwo.textColor= [UIColor whiteColor];
    lbltimeAMPMForTwo.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    lbltimeAMPMForTwo.text = [arrTimewithZone objectAtIndex:1];
    lbltimeAMPMForTwo.textAlignment=NSTextAlignmentCenter;
    lbltimeAMPMForTwo.backgroundColor = [UIColor clearColor];
    
    lblDateForTwo = [[UILabel alloc] initWithFrame:CGRectMake(136, 122, 151, 21)];
    lblDateForTwo.textColor= [UIColor whiteColor];
    lblDateForTwo.text=[sender valueForKey:MEETING_DATE_TIME];
    lblDateForTwo.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    lblDateForTwo.textAlignment=NSTextAlignmentCenter;
    lblDateForTwo.backgroundColor=[UIColor clearColor];
    
    imgclockForTwo = [[UIImageView alloc] initWithFrame:CGRectMake(82,118,31,31)];
    [imgclockForTwo setImage:[UIImage imageNamed:@"watchGreen.png"]];
    
    imgLableBgGreenForTwo=[[UIImageView alloc] initWithFrame:CGRectMake(127, 118, 173, 30)];
    [imgLableBgGreenForTwo setImage:[UIImage imageNamed:@"timeHolderCurrent.png"]];
    
    
    
    connector = [[UIImageView alloc] initWithFrame:CGRectMake(95, 84, 5, 35)];
    [connector setImage:[UIImage imageNamed:@"timeConnect.png"]];
    
//    [self.view addSubview:lbltime];
//    [self.view addSubview:lbltimeAMPM];
//    [self.view addSubview:lblDate];
//    [self.view addSubview:imgclock];
//    [self.view addSubview:imgLableBgGreen];
    [self.view addSubview:connector];
    
    [self.view addSubview:lbltimeForTwo];
    [self.view addSubview:lbltimeAMPMForTwo];
    [self.view addSubview:lblDateForTwo];
    [self.view addSubview:imgclockForTwo];
    [self.view addSubview:imgLableBgGreenForTwo];
    
}


-(void)setupCellForThree:(id)sender{
    
    NSString *strTIMEWithAMPM = [sender valueForKey:MEETINGS_TIME];
    arrTimewithZone= [strTIMEWithAMPM componentsSeparatedByString: @" "];
    

    
    /* For Third Meeting */
    lbltimeForThree = [[UILabel alloc] initWithFrame:CGRectMake(37, 167, 40, 25)];
    lbltimeForThree.textColor= [UIColor whiteColor];
    lbltimeForThree.text = [arrTimewithZone objectAtIndex:0];
    lbltimeForThree.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    lbltimeForThree.textAlignment=NSTextAlignmentCenter;
    lbltimeForThree.backgroundColor = [UIColor clearColor];
    
    lbltimeAMPMForThree= [[UILabel alloc] initWithFrame:CGRectMake(53, 187, 19, 15)];
    lbltimeAMPMForThree.textColor= [UIColor whiteColor];
    lbltimeAMPMForThree.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    lbltimeAMPMForThree.text = [arrTimewithZone objectAtIndex:1];
    lbltimeAMPMForThree.textAlignment=NSTextAlignmentCenter;
    lbltimeAMPMForThree.backgroundColor = [UIColor clearColor];
    
    lblDateForThree = [[UILabel alloc] initWithFrame:CGRectMake(136, 179, 151, 21)];
    lblDateForThree.textColor= [UIColor whiteColor];
    lblDateForThree.text=[sender valueForKey:MEETING_DATE_TIME];
    lblDateForThree.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    lblDateForThree.textAlignment=NSTextAlignmentCenter;
    lblDateForThree.backgroundColor=[UIColor clearColor];
    
    imgclockForThree = [[UIImageView alloc] initWithFrame:CGRectMake(82, 176, 31, 31)];
    [imgclockForThree setImage:[UIImage imageNamed:@"watchGreen.png"]];
    
    imgLableBgGreenForThree=[[UIImageView alloc] initWithFrame:CGRectMake(127, 176, 173, 30)];
    [imgLableBgGreenForThree setImage:[UIImage imageNamed:@"timeHolderCurrent.png"]];
    
    connector = [[UIImageView alloc] initWithFrame:CGRectMake(95, 139, 5, 40)];
    [connector setImage:[UIImage imageNamed:@"timeConnect.png"]];
    
    lblForMoreSubMeetings.textColor= [UIColor whiteColor];
    if ((countOfMeetings-2)==0) {
        lblForMoreSubMeetings.text = @"";
    }else{
        lblForMoreSubMeetings.text=[NSString stringWithFormat:@"%d More Meeting..",countOfMeetings-2];
    }
    lblForMoreSubMeetings.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    lblForMoreSubMeetings.textAlignment=NSTextAlignmentCenter;
    lblForMoreSubMeetings.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:connector];
    [self.view addSubview:lbltimeForThree];
    [self.view addSubview:lbltimeAMPMForThree];
    [self.view addSubview:lblDateForThree];
    [self.view addSubview:imgclockForThree];
    [self.view addSubview:imgLableBgGreenForThree];
}

@end

