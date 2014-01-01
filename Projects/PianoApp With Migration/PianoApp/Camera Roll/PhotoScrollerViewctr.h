//
//  PhotoScrollerViewctr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomMoviePlayerViewController.h"

@interface PhotoScrollerViewctr : UIViewController <UIScrollViewDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIScrollView *scl_Photo;
    NSMutableArray *ArryImages;
    NSUInteger indexclick;
    IBOutlet UILabel *lblTitle,*lblBottomBorder,*lblTopBorder;
    IBOutlet UIView *ViewBottom,*ViewTop;
    IBOutlet UIButton *btnBack;
   // UIImageView *imgView;
    BOOL HideShow;
    
    AppDelegate *appdel;
    UIWebView *webview;
    
    CustomMoviePlayerViewController *moviePlayer;
    UIScrollView *_inerScrollView;
    UIImageView *imgView;
    
    BOOL isPasswordInclude;
    
    IBOutlet UIView *ViewPass;
    IBOutlet UITextField *tfPassword;
    
    IBOutlet UITableView *tbl_Tags;
    NSMutableArray *ArryTags;
    
    IBOutlet UIButton *btnTag;
    UITextField *tfAddTag;
    
    BOOL KeyBoardMsg;
    
    IBOutlet UIButton *btnTblTagRemove;
}

@property(nonatomic,readwrite)NSUInteger indexclick;
@property(nonatomic,strong)NSArray *ArryImgsPass;
-(void)CallCountImg;
-(void)ReloadAllView;
@end
