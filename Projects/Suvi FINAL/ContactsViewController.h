//
//  ContactsViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBookUI/AddressBookUI.h>
#import "common.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIActionSheetDelegate,UITextViewDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tblview;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    
    NSMutableArray *arrallcontacts;
    NSMutableArray *arraddedcontactsfulllist;
    NSMutableArray *arraddedcontacts;

    UISearchBar *searchbar;
    NSInteger selectedindex;
    
    UIScrollView *scrollContact;
    NSMutableArray *_toRecipients;
    
    IBOutlet UIButton *btnInvite;
    
    IBOutlet UITextField *txtInviteId;
    NSString *strsearchtext;
    
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;
    
    NSMutableArray *valueArray;
    
    IBOutlet UIView *ViewSendRequest;
}
-(IBAction)btnbackclicked:(id)sender;
-(IBAction)btnInvite:(id)sender;
-(void)fetchIphoneContact;
-(void)_addContactToAddressBook;
-(void)btnInviteClicked:(id)sender;
@end
