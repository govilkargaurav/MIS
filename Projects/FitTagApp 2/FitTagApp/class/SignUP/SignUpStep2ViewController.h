//
//  SignUpStep2ViewController.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import <Parse/Parse.h>

@interface SignUpStep2ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CGFloat animatedDistance;

}
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UITextField *txtWebSite;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileImage;
@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *txtViewBio;
@property (strong,nonatomic)UIImage *selectedImage;

#pragma mark Button Actions
- (IBAction)btnProfileImagPressed:(id)sender;
- (IBAction)btnSkipPressed:(id)sender;
- (IBAction)btnSavePressed:(id)sender;

#pragma mark Upload profile image on server
-(void)convertImageToData;
-(void)uploadImage:(NSData *)imageData;
-(BOOL)validateUrl: (NSString  *)candidate;
-(bool)validation;
@end
