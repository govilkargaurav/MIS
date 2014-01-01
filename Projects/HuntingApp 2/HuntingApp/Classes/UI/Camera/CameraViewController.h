//
//  CameraViewController.h
//  CustomCamera
//
//  Created by Carlos Balduz Bernal on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImageView *imageView;
    NSMutableArray *assets;
    BOOL shouldShowCamera;
    BOOL imageHasBeenTaken;
    UIImage *imageTaken;
}

@property (nonatomic, retain) UIImagePickerController *picker;

- (IBAction) backButton:(id)sender;
- (IBAction) doneButton:(id)sender;

- (void) changeFlash:(id)sender;
- (void) changeCamera;
- (void) showLibrary;

- (void)showCamera;
- (void)takePicture;

- (void)gotoPreviousViewController;

@end