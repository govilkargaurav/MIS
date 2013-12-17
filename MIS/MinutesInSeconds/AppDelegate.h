//
//  AppDelegate.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TabBarViewCtr.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic,strong)UINavigationController *navigationController;
@property (nonatomic,strong)TabBarViewCtr *tabbarController;
@property (strong, nonatomic) IBOutlet UIWindow *window;
+(void)showalert:(NSString *)massege;
+ (AppDelegate *)appDelegate;
-(void)prepareToRecordAudioStreamFile;
@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@end
