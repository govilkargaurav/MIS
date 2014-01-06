//
//  PopoverSort.h
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverSort : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *_arraywithName;
    
}
@property(nonatomic,strong)UITableView *_tableView;

@end
