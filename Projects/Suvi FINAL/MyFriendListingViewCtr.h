//
//  MyFriendListingViewCtr.h
//  Suvi
//
//  Created by Imac 2 on 4/26/13.
//
//

#import <UIKit/UIKit.h>
#import "MyFriendCCell.h"
#import "AppDelegate.h"
#import "HPGrowingTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface MyFriendListingViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,HPGrowingTextViewDelegate>
{
    IBOutlet UITableView *tbl_friendList;
    IBOutlet MyFriendCCell *obj_myfrndCell;
    IBOutlet UIButton *btnEdit;
    NSMutableArray *ArryFriends,*ArryPendingRequest;
    
    BOOL EditTbl;
    int selectedindex;
    
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;
    NSURLConnection *connection;
    NSMutableData *webData;
    
    IBOutlet UITextField *txtSearch;
    
    // Auto Expand TextField
    UIView *containerView;
    HPGrowingTextView *tfautoExpandPost;
    
    BOOL SetKeyBoardTag;
}
@property (nonatomic,strong)NSMutableArray *ArryFriends,*ArryPendingRequest;
-(void)resignTextView;

@end
