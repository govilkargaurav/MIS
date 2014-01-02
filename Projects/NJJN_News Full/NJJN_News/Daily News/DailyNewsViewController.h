//
//  DailyNewsViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "AppConstat.h"
#import "ASIHTTPRequest.h"
#import <PDFTouch/PDFTouch.h>
#import "DatabaseAccess.h"
#import "UIButton+WebCache.h"
#import "ScrollGalleryViewController.h"

// Google Ad
#import "GADBannerView.h"
#import "DFPBannerView.h"
#import "GADBannerViewDelegate.h"


@class SettingsViewController;

@interface DailyNewsViewController : UIViewController<UIGestureRecognizerDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIActionSheetDelegate,YLPDFViewControllerDelegate,GADBannerViewDelegate>
{
    
    int flagOrientation;
    
    IBOutlet UIButton *btnUser;
    
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    
    //refresh
    IBOutlet UIButton *btnRefresh;
    
    IBOutlet UIScrollView *scl_PDF;
    
    int xAxis,yAxis;
    
    //Download Section
    NSOperationQueue *downloadingRequestsQueue;
    
    YLPDFViewController *PDFViewCtr;
    
    //Google AdBanner
    GADBannerView *AbMob_PDFView;
    IBOutlet UIView *adCustomView;
    IBOutlet UIButton *btnCancelAd;
    
    IBOutlet UIButton* btnHiddenForSignInFrame,* btnHiddenForSubscriptionFrame;
}


@property (nonatomic, strong) UIPopoverController* popOverUserObj;

//Orientation
-(void)setOrientation;


//Pdf
-(void)LoadPdf;
-(void)loadPDFDataAgain;


#pragma mark - Download Section

-(void)initializeDownloadingArrayIfNot;
-(void)createDirectoryIfNotExistAtPath:(NSString *)path;
-(void)createTemporaryFile:(NSString *)path;
-(ASIHTTPRequest *)initializeRequestAndSetProperties:(NSString *)urlString isResuming:(BOOL)isResuming;
-(void)addDownloadRequest:(NSString *)urlString;
-(void)initializeDownloadingRequestsQueueIfNot;
-(void)updateProgressForCell:(UIView *)cell withRequest:(ASIHTTPRequest *)request;
-(void)resumeInterruptedDownloads:(int)indexPath :(NSString *)urlString;
-(void)insertTableviewCellForRequest:(ASIHTTPRequest *)request;
-(void)writeURLStringToFileIfNotExistForResumingPurpose:(NSString *)urlString;
-(void)removeURLStringFromInterruptedDownloadFileIfRequestCancelByTheUser:(NSString *)urlString;
-(void)removeRequest:(ASIHTTPRequest *)request :(int)indexPath;
-(void)showAlertViewWithMessage:(NSString *)message;
-(void)resumeAllInterruptedDownloads;
-(int)ReurnIndexofArrayDownload:(NSString*)strUrl;
-(int)ReurnIndexofArrayMain:(NSString*)strUrl;


#pragma mark - DownLoad Delegate MEthod for Start,Receive,Finish,Fail,Pause,Cancel

-(void)downloadRequestStarted:(ASIHTTPRequest *)request;
-(void)downloadRequestReceivedResponseHeaders:(ASIHTTPRequest *)request responseHeaders:(NSDictionary *)responseHeaders;
-(void)downloadRequestFinished:(ASIHTTPRequest *)request;
-(void)downloadRequestFailed:(ASIHTTPRequest *)request;
-(void)downloadRequestPaused:(ASIHTTPRequest *)request;
-(void)downloadRequestCanceled:(ASIHTTPRequest *)request;
@end
