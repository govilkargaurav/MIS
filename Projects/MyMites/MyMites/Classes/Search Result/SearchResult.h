//
//  SearchResult.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "RegisterORLogin.h"
#import "FsenetAppDelegate.h"

@interface SearchResult : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    
    FsenetAppDelegate *objMyMiteAppDelegate;
    
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblTitle;
    //IBOutlet UIImageView *imgProfile;
    
    NSString *strOccu,*strLoc;
    NSString *strTitle;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableArray *ArrySearch;
    NSURLConnection *ConnectionRequest;
    
    IBOutlet UILabel *lblHeading;
        
//business, The ratings, telephone number, address, mobile, email , Mates link , no of connections , website
}
@property (nonatomic , strong)NSString *strOccu,*strLoc;
@property (nonatomic , strong)NSString *strTitle;
-(IBAction)ConnectClicked:(id)sender;
-(IBAction)Back:(id)sender;
- (NSString *)removeNull:(NSString *)str;
@end
