//
//  MyAppManager.h
//  DriversSafety
//
//  Created by Gagan Mishra on 3/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Constants.h"

#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication]delegate];

@interface MyAppManager : NSObject
{
    AppDelegate *appDelegate;
    NSFileManager *fileManager;
    NSDateFormatter *dateFormatter;
    NSString *documentsDirectory;
    UIImagePickerController *imgPickerCamera;
    UIImagePickerController *imgPickerLibrary;
    MBProgressHUD *hud;
}

+(id)sharedManager;
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSString *documentsDirectory;
@property (nonatomic,strong) UIImagePickerController *imgPickerCamera;
@property (nonatomic,strong) UIImagePickerController *imgPickerLibrary;
@property (nonatomic,strong) UIView *viewLoadOverlay;
@property (nonatomic,strong) UIImageView *imgLoader;


-(void)customiseAppereance;
-(void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName;

-(void)saveObject:(NSString *)strData ForKey:(NSString *)theKey;
-(NSString *)theObjectForKey:(NSString *)theKey;

-(void)showLoaderInMainThread;
-(void)hideLoaderInMainThread;
-(void)showLoader;
-(void)showLoaderWithtext:(NSString *)strText;
-(void)showLoaderWithtext:(NSString *)strText andDetailText:(NSString *)strDetailText;
-(void)hideLoader;
-(void)signOutFromApp;
-(void)updatenotificationbadge;
-(void)showSpinnerInView:(UIView *)theView;
-(void)hideSpinner;


@end
