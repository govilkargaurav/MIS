//
//  TwitterViewController.h
//  Suvi
//
//  Created by apple on 2/7/13.
//
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UISearchBarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tblview;
    
    NSMutableArray *arrtwitterfollowersfulllist;
    NSMutableArray *arrtwitterfollowerslist;
    UISearchBar *searchbar;
    NSInteger selectedindex;
    NSMutableDictionary *photodict;
    NSInteger selectedtwitteracindex;
    NSMutableArray *arrtwitterac;
    NSInteger selectedfollowerindex;
}

-(IBAction)btnbackclicked:(id)sender;

-(void)accountsExistOrNot;
-(void)fetchTwitterContacts;
-(void)invitetwitterfollower:(id)sender;

@end

