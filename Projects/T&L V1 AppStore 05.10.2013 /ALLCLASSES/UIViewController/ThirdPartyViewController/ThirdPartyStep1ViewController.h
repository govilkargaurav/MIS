//
//  ThirdPartyStep1ViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface UITextView (ThirdPartyStep1ViewController)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface ThirdPartyStep1ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    IBOutlet UITableViewCell *customCell;
    UIButton *btnArrow;
    UITableView *_tableView;
    NSMutableArray *selectedIndexes,*textFieldValue;
    IBOutlet UITextField *tf_1,*tf_2,*tf_3;
    
    IBOutlet UIView *footerView;
    
    IBOutlet UILabel *lblTitle1,*lblTitle2;
    IBOutlet UIButton *btnExit;
    IBOutlet UIWebView *thirdpartyinfo;
    
    NSMutableArray *aryThirdPartyInfo,*aryThirdPartyAnswer;
    
    IBOutlet UILabel *lbl1,*lbl2;
    NSMutableArray *aryAssessorInfo;
    //------------- Dynamic WebContent -------------
    IBOutlet UITextView *tvWebContent;
    IBOutlet UIImageView *ivBG;
    IBOutlet UITextField *temptf;
}
@property (nonatomic, retain) NSArray *tableArray;

@end
