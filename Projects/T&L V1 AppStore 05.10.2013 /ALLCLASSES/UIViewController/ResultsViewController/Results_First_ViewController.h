//
//  Results_First_ViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/2/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface UITextView (Result_First_ViewCotroller)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface Results_First_ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    UIButton *btnArrow,*btnTick,*btnDelete;
    
    IBOutlet UITableViewCell *customCell;
    
    IBOutlet UIView *footerView;
    
    IBOutlet UILabel *lblTitle1,*lblTitle2;
    IBOutlet UIButton *btnExit;
    
    IBOutlet UIWebView *webView;
    
    UITableView *_tableView;
    
    NSMutableArray *aryResults,*aryResultsOptions,*aryResultsOptionAnswer,*aryAssTaskPart,*selectedIndexes,*aryButtons,*aryNewAssTaskPart;
    
    NSMutableArray *tempArray1,*tempArray2,*tempArray3,*tempArray4;
    
    UITextField *tfComment;
    NSMutableArray *aryAssessorInfo;
    //------------- Dynamic WebContent -------------
    IBOutlet UITextView *tvWebContent;
    IBOutlet UIImageView *ivBG;
    UITextField *temptf;
}
@end
