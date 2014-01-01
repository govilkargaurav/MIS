//
//  SignUp3FindFriendViewController.h
//  FitTagApp
//
//  Created by apple on 2/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "FrndSugestCustomCell.h"
#import "MBProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"

@interface SignUp3FindFriendViewController : UIViewController{

    IBOutlet UITableView *tblAllUser;
    NSMutableArray *arrImages;
    NSMutableArray *arrayTemp;
    BOOL toggle;
    FrndSugestCustomCell *cell;
    AppDelegate *appDelegateRefrence;
    IBOutlet UILabel *lbl1;
        IBOutlet UILabel *lbl2;
        IBOutlet UILabel *lbl3;
    IBOutlet UILabel *lbl4;
    
}
@property(strong,nonatomic)NSMutableArray *arrAllUser;
@property(nonatomic,strong)NSMutableArray *arrSugestedFriends;
@property(nonatomic)int intInviteTag;
//-(void)downloadAllImages;
- (IBAction)btnFBFriendPressed:(id)sender;
- (IBAction)btnTwitterFriendPressed:(id)sender;
- (IBAction)btnContectFriendPressed:(id)sender;


@end
