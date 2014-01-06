//
//  ResourceDetailView.h
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheManager.h"
#import "DatabaseAccess.h"
#import "MBProgressHUD.h"

@interface ResourceDetailView : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UIButton *downloadStartBtn;
    UIWebView *_webView;
    BOOL toggleIsOn;
    IBOutlet UILabel *headerLable,*lblunitinfo;
    IBOutlet UIImageView *resourceImageView;
    NSMutableDictionary *aryAllQuestion;
    NSMutableArray *_aryQuestionOption;
    NSString *assTaskPartID,*assTaskID;
    
    AppDelegate *appDel;
    BOOL showAlertNoDataFound;
}
@property(nonatomic,strong)NSMutableDictionary *dicAssessementTask;
@property(nonatomic,strong)NSMutableArray *_taskId,*_taskPartId,*_AssTaskIDNew;
@property(nonatomic)BOOL IsEmptyBOOL;
@property(nonatomic,strong)CacheManager *_cMgr;
@property(nonatomic,strong)NSString *resourceImageStr,*downloadStatusImg,*unitinfo;
@property(nonatomic,strong)NSString *headerLableStr;
@property(nonatomic,strong)NSString* embedHTML,*rID_R;
@property(nonatomic,strong)UIWebView *_webView;
@property(nonatomic,strong)NSString *HTMLStr;
@property(nonatomic,strong)NSString *_resourceID;
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSMutableDictionary *statusesDict;
@property(nonatomic,strong)NSString *_download_dictStrValue;


-(void)parsingStartsandSaveInDatabase;
static inline BOOL IsEmpty(id thing);
-(void)saveAssessment_Task_Part;
-(void)getallQuestionsAccToTaskPart;
- (void)showWithLabel;
-(void)downloadInProgress;
@end
