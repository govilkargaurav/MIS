//
//  CustomOverlayView.m
//  CustomCamera
//
//  Created by Carlos Balduz Bernal on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomOverlayView.h"

@implementation CustomOverlayView

@synthesize delegate, flashButton, changeCameraButton, pictureButton, lastPicture,cancelButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.opaque = NO;
        
        UIImage *buttonImageNormal;
        
        // Add the flash button
        if ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear]) {
            self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.flashButton.frame = CGRectMake(10, 30, 44, 32);
            buttonImageNormal = [UIImage imageNamed:@"flash02"];
            [self.flashButton setImage:buttonImageNormal forState:UIControlStateNormal];
            [self.flashButton addTarget:self action:@selector(setFlash:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.flashButton];
        }
        
        // Add the camera button
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.changeCameraButton.frame = CGRectMake(250, 30,64, 41);
            buttonImageNormal = [UIImage imageNamed:@"switch_button"];
            [self.changeCameraButton setImage:buttonImageNormal forState:UIControlStateNormal];
            [self.changeCameraButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.changeCameraButton];
        }
        
        // Add the bottom bar
        UIImage *image = [UIImage imageNamed:@"bar"];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(0, 415, 320, 65);
        [self addSubview:imageView];
        
        // Add the capture button
        self.pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pictureButton.frame = CGRectMake(128, 430, 64, 39);
        buttonImageNormal = [UIImage imageNamed:@"take_picture"];
        [self.pictureButton setImage:buttonImageNormal forState:UIControlStateNormal];
        [self.pictureButton setImage:buttonImageNormal forState:UIControlStateDisabled];
        [self.pictureButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pictureButton];
        
        // Add the gallery button
        self.lastPicture = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lastPicture.frame = CGRectMake(20, 430, 47, 36);
        [self.lastPicture setImage:[UIImage imageNamed:@"library"] forState:UIControlStateNormal];
        [self.lastPicture setImage:[UIImage imageNamed:@"library"] forState:UIControlStateDisabled];
        [self.lastPicture addTarget:self action:@selector(showCameraRoll:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.lastPicture];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(255, 430, 51, 35);
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateDisabled];
        [self.cancelButton addTarget:self action:@selector(gotoPreviousViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)dealloc
{
    self.flashButton = nil;
    self.changeCameraButton = nil;
    self.pictureButton = nil;
    self.changeCameraButton = nil;
    [super dealloc];
}

- (void)takePicture:(id)sender
{
    self.pictureButton.enabled = NO;
    [self.delegate takePicture];
}

- (void)setFlash:(id)sender
{
    [self.delegate changeFlash:sender];
}

- (void)changeCamera:(id)sender
{
    [self.delegate changeCamera];
}

- (void)showCameraRoll:(id)sender
{
    [self.delegate showLibrary];
}

- (void)gotoPreviousViewController:(id)sender
{
    [self.delegate.picker dismissModalViewControllerAnimated:YES];
    [self.delegate gotoPreviousViewController];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
