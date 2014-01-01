//
//  FavLocTableViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationViewController.h"

@interface FavLocTableViewController : NotificationViewController

@property (nonatomic)NSInteger selectedSection;
@property (nonatomic) NSInteger selectedRow;
@property (nonatomic,strong)NSMutableArray *arrcustomLocation;
@property (nonatomic,strong)NSMutableArray *arrDefinedLocation;

@end
