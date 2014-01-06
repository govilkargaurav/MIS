//
//  ResourceFilesViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/2/12.
//
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"
#import <QuartzCore/QuartzCore.h>

@interface ResourceFilesViewController : UIViewController
{
    IBOutlet UITableView *tblResourceFile;
    NSMutableArray *aryResourceFiles;
    ImageViewURL *x;
    IBOutlet UILabel *lbl_1,*lbl_2;
    IBOutlet UITextView *tvWebContent;
    NSMutableArray *aryTextViewHeight;
}
@property (nonatomic,strong)NSMutableArray *aryResourceFiles;
@end
