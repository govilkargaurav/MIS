//
//  LikerListViewController.h
//  FitTag
//
//  Created by apple on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LikerListViewController : UIViewController{

    IBOutlet UITableView *tblLikers;
    PFObject *like;
    PFUser *user;
}
@property(nonatomic,strong)NSMutableArray *arrLikerList;
@property(nonatomic)BOOL isFollower;
@property(nonatomic)BOOL isLike;
@end
