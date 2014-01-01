//
//  DraftViewcontrollerViewController.h
//  FitTag
//
//  Created by Vinod Jat on 6/5/13.
//
//

#import <UIKit/UIKit.h>

@interface DraftViewcontrollerViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>{
        
        NSMutableArray *mutArraDraftsChallenges;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tblViewDrafts;

@end
