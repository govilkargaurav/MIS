//
//  ParticipantSignView.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/10/12.
//
//

#import <UIKit/UIKit.h>


@protocol ParticipantSignViewControllerDelegate;
@interface ParticipantSignView : UIViewController
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
    
    BOOL strPushView;
}
// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;
// Delegate
@property(nonatomic,strong) id<ParticipantSignViewControllerDelegate> delegate;
// Clear the signature
-(void)clearSignature;
-(IBAction)selectDateTapped:(id)sender;
@end


// Delegate Protocol
@protocol ParticipantSignViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(ParticipantSignView *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(ParticipantSignView *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(ParticipantSignView *)sender;

@end
