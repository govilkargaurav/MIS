//
//  ReadingListViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/18/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFTouch/PDFTouch.h>
#import "UserInfoViewController.h"
#import "DatabaseAccess.h"
#import "AppDelegate.h"
#import "AppConstat.h"
#import "UIButton+WebCache.h"
#import "ScrollGalleryViewController.h"

// Google Ad
#import "GADBannerView.h"
#import "DFPBannerView.h"
#import "GADBannerViewDelegate.h"

@interface ReadingListViewController : UIViewController <YLPDFViewControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,GADBannerViewDelegate>
{
    int flagOrientation;
    
    IBOutlet UIButton *btnUser;
    
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    
    int fileIndex;
    
    //refresh
    IBOutlet UIButton *btnRefresh;


    
    IBOutlet UIScrollView *scl_PDF_Download;
    int xAxis,yAxis;
    
    NSMutableArray *ArryDowloaded_PDF;
    NSMutableArray *ArryToTalDownload_PDF;
    
    YLPDFViewController *PDFViewCtr;
    
    //Google AdBanner
    GADBannerView *AbMob_DownloadView;
    IBOutlet UIView *adCustomView;
    IBOutlet UIButton *btnCancelAd;
    
    
    IBOutlet UIButton* btnHiddenForSignInFrame,* btnHiddenForSubscriptionFrame;
    
}


-(IBAction)ClickBtnRefresh:(id)sender;

//Orientation
-(void)setOrientation;

//Extracting files from documents
-(void)extractFiles;


@end
