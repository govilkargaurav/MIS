//
//  InboxViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SHCTableViewCellDelegate.h"
#import "EGOImageView.h"
#import "FbFriendsViewController.h"
#import "SubNoteViewController.h"
#import "FMMoveTableView.h"
@interface InboxViewController : UIViewController<SHCTableViewCellDelegate,sendDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,sendSubNoteDelegate,FMMoveTableViewDataSource,FMMoveTableViewDelegate>{

    AppDelegate *appDelegate;
    IBOutlet FMMoveTableView *tblInbox;
    UIView *sbView;
    UILabel *lblUserName;
    EGOImageView *userProfileImage;
    NSArray *arrCurrentInbox;
    NSString *strNote;
    
    FMMoveTableView *subNotsTable;
    PFObject *objEditSubNote;

}

@end
