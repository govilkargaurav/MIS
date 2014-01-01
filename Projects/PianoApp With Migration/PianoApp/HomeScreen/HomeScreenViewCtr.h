//
//  HomeScreenViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "iAd/ADBannerView.h"

@interface HomeScreenViewCtr : UIViewController <ADBannerViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    IBOutlet ADBannerView* adBannerObj;
    IBOutlet UIScrollView *scl_bg;
    
    IBOutlet UITextView *txtEncryptedText;
    IBOutlet UIView *ViewPass;
    IBOutlet UITextField *tfPassword;
    
    IBOutlet UIButton *btnUpgradeToPremium;
        
    IBOutlet UIButton *btnDecode,*btnEncryptor;
    IBOutlet UILabel *lblTouchAdd;
    
    IBOutlet UIView *viewPurchase;
    
    //Enter Password - Forgot Password
    IBOutlet UIView *viewForgotPass,*viewWriteAns;
    IBOutlet UILabel *lblQuestion;
    IBOutlet UITextField *tfAns;
    NSString *strQue;
    IBOutlet UILabel *lblDescPurchase;
    IBOutlet UIButton *btnPurchase;
    IBOutlet UIButton *btnRestore;
    IBOutlet UIButton *btnRemovePurchseView;
    IBOutlet UIView *viewWithButton;
    
}
@end
