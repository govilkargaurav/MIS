//
//  TPParticipantSignViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/3/12.
//
//

#import <UIKit/UIKit.h>
@protocol TPParticipantSignViewControllerDelegate;
@interface TPParticipantSignViewController : UIViewController
{
    UIButton *btnClear;
    
    IBOutlet UILabel *lbl1,*lbl2;
    NSMutableArray *aryAssessorInfo;
    
    IBOutlet UIImageView *ivIcon;
    IBOutlet UILabel *lblIconName;
    IBOutlet UILabel *lblPartName;
}
// Allows you to set th background images in different states
@property(nonatomic,strong) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;
// Delegate
@property(nonatomic,strong) id<TPParticipantSignViewControllerDelegate> delegate;
// Clear the signature
-(void)clearSignature;
@end


// Delegate Protocol
@protocol TPParticipantSignViewControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(TPParticipantSignViewController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(TPParticipantSignViewController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(TPParticipantSignViewController *)sender;

@end