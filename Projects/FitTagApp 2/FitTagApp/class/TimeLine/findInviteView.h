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
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface findInviteView : UIViewController<MFMessageComposeViewControllerDelegate>{

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
    
    NSMutableArray *mutArrAllEventTag;
    NSMutableArray *arrSugestedFriends;
}
@property(strong,nonatomic)NSMutableArray *arrAllUser;

@property(nonatomic)int intInviteTag;

- (IBAction)btnFBFriendPressed:(id)sender;
- (IBAction)btnTwitterFriendPressed:(id)sender;
- (IBAction)btnContectFriendPressed:(id)sender;


@end
