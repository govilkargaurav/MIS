//
//  ChlngFrndStep3ViewController.h
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "CreateChaalengeModel.h"

@interface ChlngFrndStep3ViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,MFMailComposeViewControllerDelegate>{

    NSMutableArray *arrUserForChallenge,*arrEmailIds;
    AppDelegate *appDelegateRefrence;
    IBOutlet UILabel *lbl1;
    IBOutlet UILabel *lbl2;
    IBOutlet UILabel *lbl3;
    IBOutlet UILabel *lbl4;

}
@property (strong,nonatomic) IBOutlet UITableView *tblFrndChallenge;
@property(strong,nonatomic)NSString *challengeName;
@property(strong,nonatomic)PFObject *pfObjchallengeInfop;
@property(strong,nonatomic)CreateChaalengeModel *objCreateChallengeModel;
@property(strong,nonatomic)NSMutableArray *_arrayImageData;

- (IBAction)btnClngFBPressed:(id)sender;
- (IBAction)btnTwitterPressed:(id)sender;
- (IBAction)btnContectPressed:(id)sender;
- (IBAction)btnDonePressed:(id)sender;

// Challenge save function code migration from step 2 to step 3

-(void)uploadImageOnServer;
-(void)uploadImage:(NSData *)teaserImageDate TeaserVedio:(NSData *)teaserVediaDate;
-(void)uploadMultipleImage;


@end
