//
//  CameraViewController.m
//  CustomCamera
//
//  Created by Carlos Balduz Bernal on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "CustomOverlayView.h"
#import "ImageViewController.h"
#import "AppDelegate.h"


#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1

// Screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH 480

@implementation CameraViewController
{
    CustomOverlayView *overlay;
    BOOL didCancel;
}

@synthesize picker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldShowCamera = YES;
    overlay = [[CustomOverlayView alloc]
               initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
    
    overlay.delegate = self;
    
	picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.navigationBarHidden = YES;
	picker.toolbarHidden = YES;
	picker.wantsFullScreenLayout = YES;
    assets = [[NSMutableArray alloc] init];

    [self performSelectorOnMainThread:@selector(showCamera) withObject:nil waitUntilDone:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (imageHasBeenTaken)
    {
        imageHasBeenTaken = NO;
        [self performSegueWithIdentifier:@"ImageView" sender:imageTaken];
    }
    else if (!shouldShowCamera)
    {
        [self doneButton:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"";
    [self.navigationItem setHidesBackButton:YES];
}

- (void)dealloc
{
    RELEASE_SAFELY(imageTaken);
    RELEASE_SAFELY(imageView);
    RELEASE_SAFELY(overlay);
    RELEASE_SAFELY(picker);
    RELEASE_SAFELY(assets);
    [super dealloc];
}

- (void) showCamera
{    
    shouldShowCamera = YES;
	self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Must be NO.
    self.picker.showsCameraControls = NO;

	self.picker.cameraViewTransform =
	CGAffineTransformScale(self.picker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);

    // When showCamera is called, it will show by default the back camera, so if the flashButton was
    // hidden because the user switched to the front camera, you have to show it again.
    if (overlay.flashButton.hidden) {
        overlay.flashButton.hidden = NO;
    }
    
    self.picker.cameraOverlayView = overlay;

    // If the user cancelled the selection of an image in the camera roll, we have to call this method
    // again.
    if (!didCancel) {
        [self presentModalViewController:self.picker animated:YES];	
    } else {
        didCancel = NO;
    }
    
}

- (void)takePicture
{
    [picker takePicture];
}

- (void) imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *aImage = [(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
    if(imageTaken)
        RELEASE_SAFELY(imageTaken);
    imageTaken = [aImage retain];
    if (aPicker.sourceType == UIImagePickerControllerSourceTypeCamera) 
    {
        UIImageWriteToSavedPhotosAlbum (aImage, nil, nil , nil);
        overlay.pictureButton.enabled = YES;
        [self.picker dismissModalViewControllerAnimated:YES];
        imageHasBeenTaken = YES;
    } 
    else 
    {
        overlay.pictureButton.enabled = YES;
        
        [self.picker dismissModalViewControllerAnimated:YES];
        imageHasBeenTaken = YES;
    }    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"ImageView"])
    {
        shouldShowCamera = NO;
        ImageViewController *controller = (ImageViewController *)[[((UINavigationController *)[segue destinationViewController]) viewControllers] objectAtIndex:0];
        [controller setImage:((UIImage *)sender)];
        [controller setParentController:self];
        
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    didCancel = YES;
    [self showCamera];
}

- (IBAction) backButton:(id)sender
{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;// UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:self.picker animated:YES];	
}

- (IBAction)doneButton:(id)sender
{
    shouldShowCamera = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (overlay.flashButton.hidden) {
        overlay.flashButton.hidden = NO;
    }
    [self presentModalViewController:self.picker animated:YES];	
}

- (void) changeFlash:(id)sender
{
    switch (self.picker.cameraFlashMode) {
        case UIImagePickerControllerCameraFlashModeAuto:
            [(UIButton *)sender setImage:[UIImage imageNamed:@"flash01"] forState:UIControlStateNormal];
            self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            break;
            
        case UIImagePickerControllerCameraFlashModeOn:
            [(UIButton *)sender setImage:[UIImage imageNamed:@"flash03"] forState:UIControlStateNormal];
            self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            break;
            
        case UIImagePickerControllerCameraFlashModeOff:
            [(UIButton *)sender setImage:[UIImage imageNamed:@"flash02"] forState:UIControlStateNormal];
            self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            break;
    }
}

- (void)changeCamera
{
    if (self.picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        overlay.flashButton.hidden = NO;
    } else {
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        overlay.flashButton.hidden = YES;
    }
}

- (void)showLibrary
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)gotoPreviousViewController
{
    [self dismissModalViewControllerAnimated:YES];
    shouldShowCamera = NO;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate gotoPreviousViewController];

}

@end
