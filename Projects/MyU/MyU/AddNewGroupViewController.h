//
//  AddNewGroupViewController.h
//  MyU
//
//  Created by Vijay on 7/19/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPPRoomHybridStorage.h"

@interface AddNewGroupViewController : UIViewController<XMPPRoomDelegate>
{
XMPPRoom *xmppRoom;
__strong id <XMPPRoomStorage> xmppRoomStorage;
}

@property (nonatomic,strong) XMPPUserCoreDataStorageObject *objUser;

@end
