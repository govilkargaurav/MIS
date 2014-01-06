//
//  TPAssessorSignViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/3/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@protocol TPAssessorSignViewControllerDelegate;
@interface TPAssessorSignViewController : UIViewController
{
    //-----------------------   Referencing Outles  -------------------------
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
// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;
// Delegate
@property(nonatomic,strong) id<TPAssessorSignViewControllerDelegate> delegate;
// Clear the signature
-(void)clearSignature;
-(IBAction)selectDateTapped:(id)sender;
@end


// Delegate Protocol
@protocol TPAssessorSignViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(TPAssessorSignViewController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(TPAssessorSignViewController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(TPAssessorSignViewController *)sender;

@end