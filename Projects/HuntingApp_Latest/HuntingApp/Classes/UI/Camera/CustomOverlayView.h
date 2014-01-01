//
//  CustomOverlayView.h
//  CustomCamera
//
//  Created by Carlos Balduz Bernal on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface CustomOverlayView : UIView

@property (nonatomic, assign) CameraViewController *delegate;
@property (nonatomic, retain) UIButton *pictureButton;
@property (nonatomic, retain) UIButton *flashButton;
@property (nonatomic, retain) UIButton *changeCameraButton;
@property (nonatomic, retain) UIButton *lastPicture;
@property (nonatomic, retain) UIButton *cancelButton;
@end