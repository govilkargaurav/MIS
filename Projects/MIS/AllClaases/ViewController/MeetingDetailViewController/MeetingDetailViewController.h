//
//  MeetingDetailViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 8/1/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NavigationSubclass.h"
#import <AVFoundation/AVFoundation.h>
@interface MeetingDetailViewController : UIViewController<UITableViewDataSource ,UITableViewDelegate>{
    
    BOOL ISplaying;
    UIButton *btnPlay;
    AVAudioPlayer *audioPlayer;
    NSTimer *playbackTimer;
    UILabel *timerLabel;
    UISlider *progressBar;
}
@property (nonatomic, strong)IBOutlet UIScrollView *scrlView;
@property (nonatomic, strong)IBOutlet UIView *viewPlayerVw;
@property (nonatomic, strong)IBOutlet UITextView *textView;
@property (nonatomic, strong)NavigationSubclass *titleView;
@property (nonatomic, strong)NSMutableArray *arrOfMeetings;
@property (nonatomic, strong)IBOutlet UITableView *_tableView;
-(IBAction)playAudioRecorded :(id)sender;
-(IBAction)stopAudio:(id)sender;
@end
