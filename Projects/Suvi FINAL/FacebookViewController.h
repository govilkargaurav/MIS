//
//  FacebookViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "FbGraph.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FBConnect.h"

@interface FacebookViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UISearchBarDelegate,UIActionSheetDelegate,FBSessionDelegate,FBDialogDelegate,FBRequestDelegate>
{
    FbGraph *fbGraph;
    Facebook *_facebook;
    
    IBOutlet UITableView *tblview;
    IBOutlet UIButton *btnFBConnect;
    
    MBProgressHUD *hud;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableString *strWebServicePost;
    
    NSMutableArray *arrfbfriendsfullist;
    NSMutableArray *arrfbfriends;
    NSMutableDictionary *dictSelectedfriends;
    UISearchBar *searchbar;
    NSInteger selectedindex;
}

@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, strong) Facebook *facebook;

-(IBAction)btnbackclicked:(id)sender;
-(void)fbGraphCallback;
-(IBAction)btnFacebookClicked:(id)sender;
-(void)getfacebookfriends;
-(void)initializefacebook;
-(void)invitefacebookfriend;

@end
