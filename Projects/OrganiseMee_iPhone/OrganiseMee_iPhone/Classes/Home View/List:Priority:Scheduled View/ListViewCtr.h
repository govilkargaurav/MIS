//
//  ListViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by apple on 2/8/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@interface ListViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView *tbl_List;
    NSMutableArray *ArryLists,*ArryTasks;
    int ListIndex,PriorityIndex;
    IBOutlet UILabel *lblListHeading;
    int OrientationFlag;
    
    IBOutlet SMPageControl *PageList;
    
    NSString *strFromView;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UILabel *lblMessage;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    //DatePicker
    
    IBOutlet UIDatePicker *DatepickerView;
    IBOutlet UIToolbar *DatetoolBar;
    IBOutlet UIBarButtonItem *Btncancel;
    IBOutlet UIBarButtonItem *BtnDone;
    IBOutlet UIBarButtonItem *BtnDeleteDueDate;
    
    int IndexpathRow;
    
    IBOutlet UIImageView *imgbgTrans;
    
    IBOutlet UIScrollView *scl_bg;
}
@property(nonatomic,strong)NSString *strFromView;
@end
