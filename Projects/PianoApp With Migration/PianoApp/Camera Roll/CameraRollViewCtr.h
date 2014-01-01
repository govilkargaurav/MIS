//
//  CameraRollViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
// For Multiple Photo
#import "AGImagePickerController.h"
#import "OverlayViewController.h"
#import "PhotoScrollerViewctr.h"

@interface CameraRollViewCtr : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UISearchBarDelegate,AGImagePickerControllerDelegate>
{
    IBOutlet UIScrollView *Scl_Photo;
    int Xaxis,Yaxis;
    IBOutlet UIView *ViewPrivacy;
    IBOutlet UIButton *btnOk,*btnLayer;
    
    AppDelegate *appdel;
    NSUInteger TagLast;
    IBOutlet UILabel *lblNoPhoto;
    
    NSUInteger CountImage,TotalImages;
    
    AGImagePickerController *ipc;

    IBOutlet UISearchBar *imgvideosearchBar;
    OverlayViewController *ovController;
    BOOL searching;
    NSMutableArray *copyListOfItems;
    
    NSMutableArray *ArryPhotoVideo;
    
    UIImagePickerController *imagePickerPhotoLibrary,*imagePickerCamera;
    NSArray *paths;
    NSString *documentsDirectory;
}
- (void) doneSearching_Clicked;
@end
