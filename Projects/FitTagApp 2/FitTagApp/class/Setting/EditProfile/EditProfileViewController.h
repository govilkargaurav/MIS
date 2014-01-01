//
//  EditProfileViewController.h
//  FitTag
//
//  Created by apple on 3/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "EGOImageButton.h"
#import "AddLocationView.h"
@interface EditProfileViewController : UIViewController<setLocation,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
  CGFloat animatedDistance;
}
@property (strong, nonatomic) IBOutlet UITextField *txtfieldUserName;
@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *txtViewBiography;
@property (strong, nonatomic) IBOutlet EGOImageButton *btnProfileImage;
@property (strong, nonatomic) IBOutlet UITextField *txtFiledWebsit;
@property (strong,nonatomic)UIImage *selectedImage;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UISwitch *switchLocation;

@property(strong,nonatomic)NSString *strLocationName;
@property(strong,nonatomic)NSString *strLat;
@property(strong,nonatomic)NSString *strLongi;
- (IBAction)btnProfileImagePressed:(id)sender;
-(IBAction)locationSwitchValueChange:(id)sender;
-(IBAction)btnSavePressed:(id)sender;
-(void)loadCurrentUserDetail;
- (void)uploadImage:(NSData *)imageData;
-(bool)validation;
-(BOOL)validateUrl: (NSString  *)candidate ;
-(void)convertImageToData;
-(IBAction)btnHeaderbackPressed:(id)sender;
@end
