//
//  RecordNoteViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationSubclass.h"
#import <QuartzCore/QuartzCore.h>
#import <SpeechKit/SpeechKit.h>
#import "UIScrollViewSubclass.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import <AVFoundation/AVFoundation.h>

#define APPID @"NMDPTRIAL_Appsyndrome20130615050931"

#define APPKEY @"0xa4, 0x8b, 0x23, 0xc3, 0x2f, 0xec, 0x13, 0x67, 0xbe, 0x11, 0x83, 0x19, 0xbd, 0x3f, 0x18, 0x6c, 0xf1, 0x07, 0x9f, 0xb6, 0x88, 0x22, 0xf0, 0xf6, 0xf4, 0x19, 0x24, 0xf5, 0xe6, 0x47, 0xd6, 0x8a, 0xd2, 0xf9, 0x4d, 0x01, 0xe5, 0x60, 0x68, 0xa4, 0x71, 0xeb, 0xbd, 0x2e, 0x2a, 0xd5, 0x9a, 0x1b, 0xdc, 0x3a, 0xd1, 0x64, 0x5c, 0xc1, 0x5a, 0x50, 0xda, 0x7f, 0x45, 0xc0, 0xc6, 0x1c, 0x4a, 0x98"

#define APPHOST @"sandbox.nmdp.nuancemobility.net"

#define APPPORT 443

#define APPUSESSL NO


@interface RecordNoteViewController : UIViewController<SpeechKitDelegate, SKRecognizerDelegate,ATMHudDelegate>{
    ATMHud *hud;
    BOOL ISRECORDING;
    SKRecognizer* voiceSearch;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
    
    NSTimeInterval duration;
    
    //kk
    int App_DetectionType;
    AVAudioPlayer *audioPlayer;
    IBOutlet UIView *VwRecordOverlay;
    IBOutlet UILabel *timerLabel;
    IBOutlet UILabel *totalTime;
    IBOutlet UISlider *progressBar;
    NSTimer *playbackTimer;
    BOOL ISplaying;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnForChooseRecords;
}
@property (nonatomic,strong)NSString *strUpdateItemId;
@property (nonatomic,strong)NSMutableArray *arrOfLastObject;
@property (nonatomic, strong)IBOutlet UIView *viewPlayer;
@property (nonatomic, strong)NavigationSubclass *titleView;
@property (nonatomic, strong)IBOutlet UIScrollViewSubclass *scrollView;
@property (nonatomic, strong)IBOutlet UITextView *textView;
@property (nonatomic, strong)IBOutlet UIImageView *imgViewMic;
@property(readonly)         SKRecognizer* voiceSearch;
-(IBAction)saveIntoDatabseWithRecordingPath:(id)sender;
- (IBAction)recordButtonAction: (id)sender;
-(IBAction)stopRecording:(id)sender;
-(void)reverse:(id)sender;
@end
