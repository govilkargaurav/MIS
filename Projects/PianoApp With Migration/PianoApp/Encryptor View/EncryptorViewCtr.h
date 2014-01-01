//
//  EncryptorViewCtr.h
//  PianoApp
//
//  Created by Imac 2 on 5/27/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "AESCrypt.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectFromPianoPass.h"
#import "UIImage+KTCategory.h"

@interface EncryptorViewCtr : UIViewController <UITextViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextView *txtViewEncrypt;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIView *ViewPass,*ViewText,*ViewPicture;
    IBOutlet UITextField *tfPassword;
    BOOL isPasswordInclude;
    
    IBOutlet UIButton *btnText,*btnPicture;
    IBOutlet UIImageView *imgPhotoForEncrypt;
    IBOutlet UILabel *lblChoose;
    
}
@end
