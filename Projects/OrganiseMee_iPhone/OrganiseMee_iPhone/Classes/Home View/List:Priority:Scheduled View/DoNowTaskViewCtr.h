//
//  DoNowViewCtr.h
//  OrganiseMee_iPhone
//
//  Created by apple on 2/20/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoNowTaskViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tbl_Task;
    NSMutableArray *ArryTasks;
    int OrientationFlag;
    IBOutlet UIImageView *imgbgTrans;
    IBOutlet UIScrollView *scl_bg;
    IBOutlet UILabel *lblDoNow;
    NSString *UserLanguage;
    NSMutableDictionary *localizationDict;
    NSDictionary *mainDict;
}

@end
