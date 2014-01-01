//
//  LeftViewController.h
//  ViewDeckExample
//


#import <UIKit/UIKit.h>
#import "LeftViewTableCell.h"
#import "Global.h"
#import "common.h"
#import "ViewControl1.h"
#import "ViewActivity.h"

@interface LeftViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate>
{
    NSString *action;
    NSURLConnection *connection;
    NSMutableData *webData;
    
    UIActionSheet *Actionsheet1;
    
    IBOutlet UIButton *btnMy;
    IBOutlet UIButton *btnFriends;

    IBOutlet UITableView *tblView;
    IBOutlet LeftViewTableCell *myLeftCell;
    
    IBOutlet UILabel *lblUsername;
    IBOutlet UIImageView*imgUserProfilePic;
    
    IBOutlet UIView *viewActivity;
    IBOutlet UIActivityIndicatorView *indicatorActivity;

    BOOL isLoading;
    IBOutlet UIView *viewFooter;
    IBOutlet UIActivityIndicatorView *indicator;
}

@property(nonatomic,readwrite)int PageCount;
@property(nonatomic,retain)NSString *strTotalPageCount;
@property(nonatomic,retain) NSString *action;
@property (nonatomic, retain)NSMutableArray *arrContent;
@property (nonatomic,strong) IBOutlet UITableView *tblView;

#pragma mark - Remove NULL
-(void)updateProfilePic;
-(void)ReloadTableData;

-(void)MyorFriendsActivity;

-(IBAction)_GetActivitiesGET:(id)sender;
-(void)_GetActivities;
-(void)_startSendNextActivities:(NSString *)count;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

-(NSString *)str :(NSDate *)getDate;
@end
