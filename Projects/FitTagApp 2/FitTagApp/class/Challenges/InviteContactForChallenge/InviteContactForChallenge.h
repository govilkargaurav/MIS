//
//  InviteContactForChallenge.h
//  FitTag
//
//  Created by Shivam on 3/21/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"

@interface InviteContactForChallenge : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{

    NSMutableArray *mutArraEmailIds,*mutArrSelectedUserForInvitation;
    AppDelegate *appDelegateRefrence;
    ABAddressBookRef addressBook ;

}
@property (strong, nonatomic) IBOutlet UITableView *tblViewUsers;
@property(strong,nonatomic)NSString *strChallengeName;

@property(nonatomic,strong)NSMutableArray *mutArraEmailIds;
@property(nonatomic,strong)NSMutableArray *mutArrSelectedUserForInvitation;
-(IBAction)donButtonCliked:(id)sender;
-(BOOL)isUserSelected:(NSString *)strEmailId;
-(void)getFirstChallenge;
@end
