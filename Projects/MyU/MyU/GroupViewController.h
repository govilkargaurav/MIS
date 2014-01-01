//
//  GroupViewController.h
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"

@interface GroupViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    XMPPRoom *xmppRoom;
    __strong id <XMPPRoomStorage> xmppRoomStorage;
    IBOutlet UITableView *tblView;
}
@property (nonatomic,strong)NSMutableArray *arrUserList;
@property (nonatomic,strong)NSMutableDictionary *_dictaccUserID;
@property (nonatomic,strong) XMPPUserCoreDataStorageObject *objUser;
@property (nonatomic,strong) NSString *strGroupOrPersonName;
-(void)msgRecieved:(XMPPMessage *)message;

@end
