//
//  ReadingListViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/18/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFTouch/PDFTouch.h>
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
    
    
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    
    int fileIndex;

    IBOutlet UIScrollView *scl_PDF_Download;
    int xAxis,yAxis;
    
    NSMutableArray *ArryDowloaded_PDF;
    NSMutableArray *ArryToTalDownload_PDF;
    
    YLPDFViewController *PDFViewCtr;
    
    //Google AdBanner
    GADBannerView *AbMob_DownloadView;
    IBOutlet UIView *adCustomView;
    IBOutlet UIButton *btnCancelAd;
}
//Orientation
-(void)setOrientation;

//Extracting files from documents
-(void)extractFiles;


@end
