//
//  FriendsSearchViewController.h
//  Suvi
//
//  Created by apple on 1/16/13.
//
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "AppDelegate.h"
#import "SuggestedFriendsCustomCell.h"
#import <MessageUI/MessageUI.h>
#import "FriendSearchCCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FriendsSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UISearchBarDelegate,UIActionSheetDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *tblview;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    
    NSMutableArray *arrsuvifriends;
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;

    IBOutlet UIView *viewtblheader;
    IBOutlet UITextField *txtInviteId;
    NSString *strsearchtext;
    
    IBOutlet FriendSearchCCell *obj_frndsearchCell;
    
    IBOutlet UILabel *lblNoUserFoundMessage;
}

-(IBAction)btnbackclicked:(id)sender;
-(void)_searchFriend;

//Call Service
-(void)_startSend;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

-(BOOL)validEmail:(NSString*) emailString;
-(BOOL)validPhone:(NSString*) phoneString;
@property(nonatomic,retain) NSString *strsearchtext;
-(void)sendEmailInvite;
-(void)sendSMSInvite;

@end
