//
//  ThirdPartyStep2ViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myScrollView.h"
#import "GlobleClass.h"
#import "DatabaseAccess.h"

@protocol ThirdPartyStep2ViewControllerDelegate;

@interface ThirdPartyStep2ViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel *lblPartName;
    IBOutlet UILabel *lblIconName;
    IBOutlet UILabel *lbl1,*lbl2;
    
    IBOutlet UIScrollView *scrView;
    IBOutlet UITextField *tfName,*tfPostion,*tfOrg,*tfOffAdd,*tfCity,*tfState,*tfPostCode,*tfPhone,*tfEmail;

    IBOutlet UIImageView *ivIcon;
    
    
    NSMutableArray *aryThirdPartyInfo,*aryThirdPartyDetail;
    
    
    NSMutableArray *aryAssessorInfo;
    UIButton *btnClear;
    
    
}
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;


// Delegate
@property(nonatomic,strong) id<ThirdPartyStep2ViewControllerDelegate> delegate;

// Clear the signature
-(void)clearSignature;

@end



// Delegate Protocol
@protocol ThirdPartyStep2ViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(ThirdPartyStep2ViewController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(ThirdPartyStep2ViewController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(ThirdPartyStep2ViewController *)sender;

@end
