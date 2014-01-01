//
//  AutoSyncViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 9/3/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SyncClass.h"

@interface AutoSyncViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblAutoSync;
    IBOutlet UILabel *lblAutoSync;
    NSArray *timerArr;
    IBOutlet UISwitch *timerSwitch;
    int checkmarkindexPath;
    NSTimer *timer;
    
    
    NSMutableDictionary *localizationDict;
    
    IBOutlet UIImageView *imgBg;
    
}
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *localizationDict;
@property(nonatomic,strong)NSString *strNav_Title;

@end
