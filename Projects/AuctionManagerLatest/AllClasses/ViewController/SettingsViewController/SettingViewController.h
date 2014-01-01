//
//  SettingViewController.h
//  PropertyInspector
//
//  Created by Shivam on 10/23/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    
   IBOutlet UITableView *SettingTableView;
}

-(void)LogOutButtonClicked;
-(void)ChangePassWordButtonClicked;
-(void)about:(id)sender;

@end
