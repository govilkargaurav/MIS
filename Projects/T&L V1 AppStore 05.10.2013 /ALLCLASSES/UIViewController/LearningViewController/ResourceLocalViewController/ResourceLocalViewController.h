//
//  ResourceLocalViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 12/3/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "ImageViewURL.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomMoviePlayerViewController.h"

@interface ResourceLocalViewController : UIViewController
{
    NSMutableArray *aryAllLearningResouces,*aryTextArray,*aryFilesArray;
    NSMutableArray *aryText,*aryFiles,*aryTextViewHeight;
    
    IBOutlet UITableView *tblResourceFile;
    ImageViewURL *x;
    IBOutlet UILabel *lbl_1,*lbl_2;
    IBOutlet UITextView *tvWebContent;
    CustomMoviePlayerViewController *moviePlayer;
}
@property (nonatomic,strong)NSMutableArray *aryAllLearningResouces,*aryTextArray,*aryFilesArray;
@property (nonatomic,strong)NSMutableArray *aryResourceFiles;
@end
