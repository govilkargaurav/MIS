//
//  HomeViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SHCTableViewCellDelegate.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AddMoteViewController.h"
#import "FbFriendsViewController.h"
#import "SubNoteViewController.h"
#import "SINavigationMenuView.h"
#import "FMMoveTableView.h"
#import <iAd/iAd.h>

@interface HomeViewController : UIViewController<UIGestureRecognizerDelegate,SHCTableViewCellDelegate,swipeToSave,FMMoveTableViewDataSource,FMMoveTableViewDelegate,sendDelegate,sendSubNoteDelegate,SINavigationMenuDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>
{
    
    ADBannerView *bannerView;
    AppDelegate *appDelegate;
    UISwipeGestureRecognizer  *swipeLeftRecognizer;
    
    IBOutlet FMMoveTableView *tblHome;
     FMMoveTableView *subNotsTable;
    NSMutableArray *arrHomeNotes;
    NSString *strNote;
    PFObject *objHomeGloble;
    
    BOOL isNewNote;
    NSInteger forwordNoteIndex;
    UILabel*    lblUserName;
    UIView *sbView;
    EGOImageView* userProfileImage;
    
    PFObject *objEditNote;
     PFObject *objEditSubNote;
    
    
    BOOL isloding;
    NSInteger pagingCount;
 }
@property(strong,nonatomic)NSMutableData *responseData;
@end
