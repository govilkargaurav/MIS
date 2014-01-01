//
//  FbFriendsViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//
@protocol sendDelegate <NSObject>

-(void)sendNote :(NSMutableArray *)arrSelectedFriends;
-(void)cancelSendNote;
@end
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
@interface FbFriendsViewController : UIViewController
{
    NSArray*arrfriends;
    NSMutableArray *arrSelectedFriends;
    IBOutlet UITableView *tblFriends;
}
-(IBAction)cencelNote:(id)sender;
@property(nonatomic,retain)id<sendDelegate> delegate;
@end
