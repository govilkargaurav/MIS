//
//  ContexualizationViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface UITextView (ContextualizationViewController)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface ContexualizationViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL isSelected;
    CGFloat customCellHeight[4];
    
    
    IBOutlet UITableViewCell *customCell;
    UIButton *btnArrow;
    
    UITableView *_tableView;
    
    NSMutableArray *selectedIndexes,*textFieldValue,*aryContextOption,*aryContexOptionAnswer;
    
    IBOutlet UITextField *tf_1,*tf_2,*tf_3,*tf_4;
    
    IBOutlet UIView *footerView;
    
    IBOutlet UILabel *lblTitle1,*lblTitle2;
    IBOutlet UIButton *btnExit;
    
    IBOutlet UIWebView *webView;
    NSMutableArray *aryAssessorInfo;
    //------------- Dynamic WebContent -------------
    IBOutlet UITextView *tvWebContent;
    IBOutlet UIImageView *ivBG;
    UIAlertView *alertNoContextOption;
    UITextField *temptf;
}
- (BOOL)cellIsSelected:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSArray *tableArray;
@property (nonatomic, retain) NSIndexPath *indexPathSelected;
@property (nonatomic, retain) NSArray * detailCellArray;
@end
