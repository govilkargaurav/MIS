//
//  RightSideViewController.h
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface RightSideViewController : UIViewController{
    XMPPRoom *xmppRoom;
    __strong id <XMPPRoomStorage> xmppRoomStorage;
}
@property (nonatomic,strong)IBOutlet UIImageView *imgSegmentUpper;
@property (nonatomic,strong)NSString *strGroupOrPersonName;
@property (nonatomic,strong) XMPPUserCoreDataStorageObject *objUser;
-(void)msgRecieved:(XMPPMessage *)message;
@end
