//
//  ResultAssSignViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@protocol ResultAssSignViewControllerDelegate;

@interface ResultAssSignViewController : UIViewController
{
    
    
    IBOutlet UILabel *lbl1,*lbl2;
    IBOutlet UILabel *lblAssName;
    IBOutlet UILabel *lblIconName;
    IBOutlet UIImageView *ivIcon;
    IBOutlet UITextField *tfAssName;
    IBOutlet UIButton *pickDate;
    
    UIButton *btnClear;
    UIDatePicker *datePickerViewNew;
    UIPopoverController *popOverControllerWithPicker;
    
    NSMutableArray *aryAssessorInfo;
    
    /*---------------- tbl_ResumeFTask Info --------------*/
    NSMutableArray *aryTInfos;
}
-(IBAction)exitbuttontapped:(id)sender;
// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;
// Delegate
@property(nonatomic,strong) id<ResultAssSignViewControllerDelegate> delegate;
// Clear the signature
-(void)clearSignature;
@end


// Delegate Protocol
@protocol ResultAssSignViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(ResultAssSignViewController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(ResultAssSignViewController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(ResultAssSignViewController *)sender;

@end