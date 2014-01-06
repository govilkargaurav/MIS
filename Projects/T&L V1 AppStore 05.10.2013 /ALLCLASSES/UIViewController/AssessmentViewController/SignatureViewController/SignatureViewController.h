//
//  SignatureViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol SignatureViewControllerDelegate;
@interface SignatureViewController : UIViewController
{
    //-----------------------   Referencing Outles  -------------------------
    IBOutlet UILabel *lbl1,*lbl2;
    IBOutlet UILabel *lblAssName;
    IBOutlet UILabel *lblIconName;
    IBOutlet UIImageView *ivIcon;
    IBOutlet UITextField *tfAssName,*tfLocation,*tfDuration;
    IBOutlet UIButton *pickDate;
    
    
    UIButton *btnClear;
    UIDatePicker *datePickerViewNew;
    UIPopoverController *popOverControllerWithPicker;
    AppDelegate *appDel;

}
// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;
// Delegate
@property(nonatomic,strong) id<SignatureViewControllerDelegate> delegate;
// Clear the signature
-(void)clearSignature;
-(IBAction)selectDateTapped:(id)sender;
@end


// Delegate Protocol
@protocol SignatureViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(SignatureViewController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(SignatureViewController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(SignatureViewController *)sender;

@end