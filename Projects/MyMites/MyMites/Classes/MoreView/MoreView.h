//
//  MoreView.h
//  MyMite
//
//  Created by Vivek Rajput on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MoreView : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tbl_MoreViewList;
    NSMutableArray *ArryMoreList;
}
-(void)CallAlertView:(NSString *)strMsg;
@end
