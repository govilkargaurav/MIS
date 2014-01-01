//
//  IamWithViewController.h
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "common.h"
#import "AppDelegate.h"
#import "JSTokenField.h"
#import <AddressBookUI/AddressBookUI.h>
#import "UIImageView+WebCache.h"

@interface IamWithViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UITextViewDelegate,JSTokenFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *tblview;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableArray *arrallcontacts;
    NSMutableArray *arrsuvifriends;
    NSMutableArray *arraddressbookcontacts;
    NSMutableArray *arraddedcontactsfulllist;
    NSMutableArray *arrremainingcontactsfullist;
    
    UIScrollView *scrollContact;
    NSMutableArray *_toRecipients;
	JSTokenField *_toField;
}

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;
-(void)fetchIphoneContact;
@property(nonatomic,retain) NSMutableArray *arrsuvifriends;
@property(nonatomic,retain) NSMutableArray *arraddressbookcontacts;

-(void)_startSend;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSMutableDictionary*)dictionary;
-(void)maintainscroll;
-(void)_addContactToAddressBook;

@end
