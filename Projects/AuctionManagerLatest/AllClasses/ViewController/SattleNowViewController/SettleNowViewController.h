//
//  SettleNowViewController.h
//  PropertyInspector
//
//  Created by apple on 10/30/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAL.h"
#import "DatabaseBean.h"
@interface SettleNowViewController : UIViewController
@property(nonatomic,strong)NSString *oweSTR;
@property(nonatomic,strong)NSString *pID;
@property(nonatomic,strong)NSString *stringAddress;
@property(nonatomic,strong)NSString *oweAmount;

@end
