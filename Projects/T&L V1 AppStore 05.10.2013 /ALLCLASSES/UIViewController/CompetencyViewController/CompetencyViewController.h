//
//  CompetencyViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 10/9/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface UITextView (CompetencyViewController)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface CompetencyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    //------------------------   Referencing Outlets ----------------------------
    IBOutlet UIView *footerView;
    IBOutlet UILabel *lblTitle1,*lblTitle2;
    IBOutlet UIButton *btnExit;
    IBOutlet UIWebView *webView;
    
    UITableView *_tableView;
    UIButton *btnArrow,*TickButton;
    
    NSMutableArray *selectedIndexes,*aryButtons,*aryCompetencyQuestions;
    NSMutableArray *tempArray1,*tempArray2;
    
    NSMutableArray *arytasktitle;
    NSMutableArray *aryAssessorInfo;
    
    //------------- Dynamic WebContent -------------
    IBOutlet UITextView *tvWebContent;
    IBOutlet UIImageView *ivBG;
    
    //-------- Horizontal Scrolling ------
    IBOutlet UIScrollView *scrView;
    int tWidht;
    IBOutlet UIImageView *footImage;
}
@end
