//
//  HomeViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 11/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "ViewControl1.h"
#import "MyFeedsViewController.h"
#import "SettingViewController.h"
#import "FriendsProfileVC.h"
#import "AFPhotoEditorController.h"

@class ViewControl1;
@class MyFeedsViewController;
@class SettingViewController;

@interface HomeViewController : UIViewController<MPMediaPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ViewControl1 *objViewControl1;
    MyFeedsViewController *objMyFeedsViewController;
    SettingViewController *objSettingViewController;
    UINavigationController *navPostImage;
}
-(void)MuzinPost :(NSMutableDictionary *)dict;
-(void)ChangeView:(NSNotification *)notif;

@property (nonatomic,retain)NSString *imgFlag;
-(void)openCamera:(NSString *)str;
-(void)openLibrary:(NSString *)str;
-(void)TakeVideo:(NSString *)str;
-(void)ChooseVideo:(NSString *)str;

-(void)NotiforVideoPost:(NSURL *)url;
-(void)NotiforIMGPost:(UIImage *)image;

@end
