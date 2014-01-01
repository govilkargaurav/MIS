//
//  SaveImageViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetStringPicker.h"
#import "CameraViewController.h"

@interface SaveImageViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,RequestWrapperDelegate>
{
    
    IBOutlet UITextField *txtCaption;
    UIView *titleView;
    IBOutlet UITextField *txtLocation;
    IBOutlet UISwitch *swShareOnTwitter;
    IBOutlet UISwitch *swShareOnFB;
    IBOutlet UISwitch *swShareViaEmail;
    ActionSheetStringPicker *albumPicker;
    NSArray *albumArray;
    WebServices *uploadImageRequest;
    DejalActivityView *loadingActivityIndicator;
    BOOL isUploading;
    ActionSheetStringPicker *locationPicker;
    int selectedLocation;
    NSArray *stateArray;
    NSArray *countiesArray;
    IBOutlet UIButton *btnAddLoc;
    BOOL shouldAddLocation;
}
@property (nonatomic, retain) IBOutlet UITextField *txtAlbum;
@property (nonatomic, retain) NSString *albumID;
@property (nonatomic,assign) UIImage *image;
@property (assign, nonatomic) CameraViewController *parentController;
- (IBAction)showLocationPicker:(id)sender;
@end
