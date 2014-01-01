//
//  ViewNewPassViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import <MessageUI/MessageUI.h>

@interface ViewNewPassViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbl_ViewPass;
    NSString *strID;
    NSMutableArray *ArryViewPass;
    IBOutlet UIButton *btnFav;
}
@property(strong , nonatomic)NSString *strID;
-(void)GetArray;
@end
