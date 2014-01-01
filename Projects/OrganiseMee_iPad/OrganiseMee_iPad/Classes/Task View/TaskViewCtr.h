//
//  TaskViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewCtr.h"
#import "IIViewDeckController.h"
#import "AutoSyncViewCtr.h"

@interface TaskViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,IIViewDeckControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *lblNav_Title;
    IBOutlet UITableView *tbl_Tasks;
    IBOutlet UIButton *btnViewMenu,*btnAddTask;
    NSMutableArray *ArryTasks;
    int OrientationFlag;
    int senderTag;
    
    NSString *strQuery;
    
    IBOutlet UIButton *btnDelete,*btnArchieve,*btnMessage,*btnCallBack,*btnGiveBack;
    IBOutlet UIViewController *View_EditTask;
    UITextView *txtMesage;
    NSMutableDictionary *DicTask;
    
    CGPoint currentTouchPosition;

    IBOutlet UIImageView *imgbgTrans;
    
    IBOutlet UIImageView *imgLogo;
    NSIndexPath *chatindex;
    int selectedRow;
    BOOL Selected;

}
@property (nonatomic,strong)UIPopoverController *obj_popOver;
@property (nonatomic,strong)UIPopoverController *obj_popOver_Setting;
@end
