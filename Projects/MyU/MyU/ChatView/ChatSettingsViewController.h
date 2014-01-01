//
//  ChatSettingsViewController.h
//  MyU
//
//  Created by Vijay on 9/21/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class REPhotoCollectionController;
@interface ChatSettingsViewController : UIViewController
{
    REPhotoCollectionController *photoCollectionController;
}
@property (nonatomic,strong)NSString *strGroupId;
@property (nonatomic,strong)NSMutableArray *arrmediaBYmonth;
@property(nonatomic,strong) NSMutableDictionary *dictGroupSettings;
@property(nonatomic,strong) NSMutableDictionary *dictGroupUsers;

@end
