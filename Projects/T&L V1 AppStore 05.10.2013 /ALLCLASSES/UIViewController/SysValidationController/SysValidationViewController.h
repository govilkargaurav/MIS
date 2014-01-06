//
//  SysValidationViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/4/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface UITextView (extended)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface SysValidationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    IBOutlet UITableViewCell *customCell;
    IBOutlet UITextField *tfSDate,*tfProcess,*tfP1,*tfP2,*tfP3,*tfP4,*tfP5,*tfOutcome;
    IBOutlet UIView *footerView;
    IBOutlet UILabel *lblTitle1,*lblTitle2;
    IBOutlet UIButton *btnExit;

    IBOutlet UIWebView *webView;
    
    UITableView *_tableView;
    UIButton *btnArrow;
    
    
    NSMutableArray *textFieldValue,*selectedIndexes;
    NSMutableArray *aryAssessorInfo;
    
    //------------- Dynamic WebContent -------------
    IBOutlet UITextView *tvWebContent;
    IBOutlet UIImageView *ivBG;
    IBOutlet UITextField *temptf;
}
@property (nonatomic, strong) NSMutableArray *tableArray;

@end
