//
//  LearningInfoViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 12/6/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "ResourceLocalViewController.h"
#import "MBProgressHUD.h"


@protocol LearningInfoDelegate
-(void)btnSuperViewReload:(id)sender;
@end

@interface LearningInfoViewController : UIViewController <UIWebViewDelegate,MBProgressHUDDelegate>
{
    NSString *HTMLStr,*headerLableStr,*resourceImageStr;
    
    IBOutlet UILabel *lblUnitName,*lblUnitInfo;
    IBOutlet UIButton *btnClose;
    IBOutlet UIImageView *ivSectorImage;
    UIWebView *_webView;
    NSString *strIndexPathRow;
    
    NSMutableDictionary *dictLearningResource;
    
    MBProgressHUD *HUD;
    UIImage *ivDownloadStatus;
    //id<LearningInfoDelegate>objlearninginfodelegate;
}
@property (nonatomic,strong)UIImage *ivDownloadStatus;
@property (nonatomic, strong) id<LearningInfoDelegate>objlearninginfodelegate;
@property (strong, nonatomic) NSMutableDictionary *dictLearningResource;
@property (strong, nonatomic)NSString *strIndexPathRow;
@property (strong, nonatomic) IBOutlet UIButton *btnDownloadResource;
@property(nonatomic)BOOL IsEmptyBOOL;
@property(nonatomic,strong)NSString *HTMLStr,*headerLableStr,*resourceImageStr,*unitinfo;
-(IBAction)btnCloseTapped:(id)sender;
- (IBAction)btnDownloadResourceTapped:(id)sender;
@end
