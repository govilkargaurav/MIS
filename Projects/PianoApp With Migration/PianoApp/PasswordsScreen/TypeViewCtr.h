//
//  TypeViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DatabaseAccess.h"

@interface TypeViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appdel;
    IBOutlet UITableView *tbl_type;
    NSMutableArray *ArryType;
    NSString *strSelected,*strType;
    IBOutlet UILabel *lblTitle;
}
@property(nonatomic,strong)NSString *strSelected,*strType;
-(void)CallType;
@end
