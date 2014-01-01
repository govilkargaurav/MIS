//
//  FacebookViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

#import "AppDelegate.h"

#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"


@interface FacebookViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UISearchBarDelegate,UIActionSheetDelegate>
{
    
    
    IBOutlet UITableView *tblview;
    IBOutlet UIButton *btnFBConnect;
    
    MBProgressHUD *hud;
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableString *strWebServicePost;
    
    
    UISearchBar *searchbar;
   
}

@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, strong) Facebook *facebook;

-(IBAction)btnbackclicked:(id)sender;

-(IBAction)btnFacebookClicked:(id)sender;


@end
