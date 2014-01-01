//
//  ListViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@class WSPContinuous;

@interface ListViewCtr : UIViewController <UITableViewDelegate,UITableViewDataSource,IIViewDeckControllerDelegate,UITextFieldDelegate,CallWSFromFGDelegate>
{
    WSPContinuous *wsparser;
    NSMutableArray *ArryretriveUserSettings;
    NSMutableArray *ArryList,*ArryPriority,*ArryScheduled;
    
    IBOutlet UITableView *tbl_List;
    
    IBOutlet UINavigationController *View_AddList,*View_EditList;
    
    IBOutlet UIButton *btnAdd;
    
    IBOutlet UITextField *tfAddList,*tfEditList;
    
    //Lang Setting
    NSDictionary *mainDict;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    
    IBOutlet UILabel *lblCreate;
    
    int senderTag;
    BOOL SetFromFG;
    
    IBOutlet UIImageView *imgbgTrans;


}
@property(nonatomic,strong)UIPopoverController *obj_popOver_AddList;
@end
