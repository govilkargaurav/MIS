//
//  HomeViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/12/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SMPageControl.h"

@class WSPContinuous;
@interface HomeViewCtr : UIViewController <UIScrollViewDelegate,CallWSFromFGDelegate>
{
    IBOutlet UIScrollView *scl_bg;
    
    WSPContinuous *wsparser;
    
    NSMutableArray *ArryretriveUserSettings;
    IBOutlet UILabel *lblScheduleDate;
    
    
    BOOL ListUpdateRequiredDB;
    BOOL AddTaskUpdateRequiredDB,UpdateTaskUpdateRequiredDB;
    
    // NSMutableArray Upload Mobile To Server;
    NSMutableArray *ArryAddList;
    NSMutableArray *ArryAddTask,*ArryUpdateTasks;
    
    //NSUInteger Upload Mobile To Server;
    NSUInteger iUpdateList,iDeleteList,iAddList;
    NSUInteger iUpdateTask,iDeleteTask,iAddTask;
    NSUInteger iTaskOwnContact,iTaskOrgContact;
    NSUInteger iTaskCallBack,iTaskGiveBack,iTaskArchieve;
    NSUInteger iTaskMessage,iFadeDate;
        
    BOOL SetSyncFlag;
    
    BOOL SetFromFG;
    
    IBOutlet UIButton *btnSync;
    
    IBOutlet UIImageView *imgTranBottom;
    
    IBOutlet UIButton *btnDoNow,*btnNewTask,*btnList,*btnManageList,*btnPriority,*btnSchedule,*btnProductivity,*btnSetting;
    
    IBOutlet SMPageControl *PageCntr;
}
-(void)updateui;
@end
