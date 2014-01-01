//
//  AppDelegate.m
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SIAlertView.h"
#define BaseUrlPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
@implementation AppDelegate

@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize tabbarController;
@synthesize navigationController;
+ (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(2.0);
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabbarController = [[TabBarViewCtr alloc] initWithNibName:@"TabBarViewCtr" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:tabbarController];
    self.navigationController.navigationBarHidden=TRUE;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark - initialize Recorder dynamically
-(void)prepareToRecordAudioStreamFile
{
    
    /* AVFoundation Record */
    double CurrentTime = CACurrentMediaTime(); 
    NSString *soundFilePath = [BaseUrlPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f_MIS.caf",CurrentTime]];
    ////NSLog(@"==>> %@",soundFilePath);
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    audioRecorder = nil;
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        ////NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }
    /* AVFoundation Record */
}

+(void)showalert:(NSString *)massege{

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Minutes In Seconds" andMessage:massege];
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage imageNamed:@"CancelRED.png"] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[UIImage imageNamed:@"CancelRED.png"] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setCancelButtonImage:[UIImage imageNamed:@"OKOK.png"] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[UIImage imageNamed:@"OKOK.png"] forState:UIControlStateHighlighted];
    
    [alertView addButtonWithTitle:@""
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:@""
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"OK Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler3", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler3", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler3", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler3", alertView);
    };
    [alertView show];
    
}
@end
