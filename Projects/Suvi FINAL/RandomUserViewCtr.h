//
//  RandomUserViewCtr.h
//  Suvi
//
//  Created by Imac 2 on 4/29/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface RandomUserViewCtr : UIViewController <UIScrollViewDelegate,UISearchBarDelegate,UIActionSheetDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIScrollView *scl_Users;
    IBOutlet UILabel *lblTitle;
    
    NSMutableArray *ArrayUsersList;
    NSString *strFromView;
    
    
    NSURLConnection *connection;
    NSMutableData *webData;
    
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;
    
    IBOutlet UITextField *txtInviteId;
    NSString *strsearchtext;
    
    NSString *strFriendID;
    
    IBOutlet UIView *ViewSendRequest;
    
    int YaxisRandom;
    int XaxisRandom;
    int Yaxis;
    int Xaxis;
    
    int pageCount,TotalCount;
    int LastTotalArrayCount;
}
@property (nonatomic,strong) NSMutableArray *ArrayUsersList;
@property (nonatomic,strong) NSString *strFromView;
@property (nonatomic,readwrite)int pageCount,TotalCount;
//Call Service
-(void)_startSend;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

@end
