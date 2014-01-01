//
//  TimeLineCell.h
//  HuntingApp
//
//  Created by Habib Ali on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLButton.h"
#import "CustomTimeLineFooter.h"

@interface TimeLineCell : UITableViewCell


@property (retain, nonatomic) IBOutlet FLButton *btn1;
@property (retain, nonatomic) IBOutlet FLButton *btn2;
@property (retain, nonatomic) IBOutlet CustomTimeLineFooter *footer1;
@property (retain, nonatomic) IBOutlet CustomTimeLineFooter *footer2;

@end
