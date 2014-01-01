//
//  EditProfileViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetStringPicker.h"

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,RequestWrapperDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    WebServices *updateProfileRequest;
    DejalActivityView *loadingActivityIndicator;
    UIImage *profileImage;
    BOOL imagePickerOpened;
    UIView *titleView;
    ActionSheetStringPicker *prefPicker;
    NSArray *prefArray;
}
@property (retain, nonatomic) Profile *userProfile;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtBio;
@property (retain, nonatomic) IBOutlet UITextField *txtPreference;

@property (retain, nonatomic) IBOutlet UITextField *txtPhone;
@property (retain, nonatomic) IBOutlet UIButton *avatar;
@property (retain, nonatomic) IBOutlet UILabel *lblEmail;
- (IBAction)disappearKeyboard:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@end
