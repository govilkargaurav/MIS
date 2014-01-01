//
//  MasterViewControlleriPhone5.h
//  PianoApp
//
//  Created by Imac 2 on 4/24/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MasterViewControlleriPhone5 : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *C, *C1, *D, *D1, *E, *F, *F1, *G, *G1, *A, *A1, *B,*H;
    NSUInteger settag1,settag2,settag3,settag4,settag5,settag6,settag7,settag8;
    NSUInteger settag11,settag12,settag13,settag14,settag15,settag16,settag17,settag18,settag19,settag20,settag21,settag22,settag23;
    IBOutlet UIButton *btnPlay,*btnLight,*btnVerify,*btnRedo,*btnOldPass,*btnLablEn,*btnSoundEnble;
    int secondsLeft,settag,i,setold;
    NSTimer *timerCountdown;
    NSString *strSetPass;
    IBOutlet UIImageView *TimerImg,*imgStartRec,*imgVerify,*imgGrad1,*imgGrad2,*imgGrad3,*imgIncorrect,*imgOldPass;
    NSUInteger EnablLbl,EnablSound,ReVerifySet;
    IBOutlet UILabel *lblC,*lblD,*lblE,*lblF,*lblG,*lblA,*lblB,*lblC1,*lblD1,*lblF1,*lblG1,*lblA1,*lblH;
    NSMutableArray *ArrySetPasscode;
    NSDate *FDate,*SDate;
    
    //Password Recovery
    IBOutlet UIView *ViewPassRecovery;
    IBOutlet UIView *viewPassInstr,*viewPassQuesAns;
    IBOutlet UILabel *lblInst,*lblPassTitle;
    IBOutlet UITextField *tfPassRecovery;
    NSMutableArray *ArryInstruction;
    int IndexArry;
    
    NSString *strFromGoToHomeScreen;
    
    //Enter Password - Forgot Password
    IBOutlet UIView *viewForgotPass,*viewWriteAns;
    IBOutlet UILabel *lblQuestion;
    IBOutlet UITextField *tfAns;
}
-(void)CallSetImgEnable;
-(void)countdownTimer;
-(void)CallVerify:(NSString*)strpass;
-(void)CallImgSet;

@end
