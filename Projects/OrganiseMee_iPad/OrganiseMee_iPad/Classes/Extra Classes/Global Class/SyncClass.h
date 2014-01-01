//
//  SyncClass.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/2/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSPContinuous;
@interface SyncClass : NSObject
{
    //NSUInteger Upload Mobile To Server;
    NSUInteger iUpdateList,iDeleteList,iAddList;
    NSUInteger iUpdateTask,iDeleteTask,iAddTask;
    NSUInteger iTaskOwnContact,iTaskOrgContact;
    NSUInteger iTaskCallBack,iTaskGiveBack,iTaskArchieve;
    NSUInteger iTaskMessage,iFadeDate;
    WSPContinuous *wsparser;
    
    
    BOOL ListUpdateRequiredDB;
    BOOL AddTaskUpdateRequiredDB,UpdateTaskUpdateRequiredDB;
    
    // NSMutableArray Upload Mobile To Server;
    NSMutableArray *ArryAddList;
    NSMutableArray *ArryAddTask,*ArryUpdateTasks;
    NSMutableArray *ArryretriveUserSettings;

}
-(void)CallSync:(NSString*)strCheckProgress;

@end
