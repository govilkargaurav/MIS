//
//  FindChallengesViewConroller.h
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
typedef enum {
    PDSearchTypeBeginsWith,
    PDSearchTypeContains
} PDSearchType;
@interface FindChallengesViewConroller : UIViewController{

    NSMutableArray *mutArrAllEventTag,*arrSearchDisplay;
    NSMutableArray *mAryUsers;
    __block NSMutableArray *mutArrEventTagResponse;
    BOOL isSearching;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tblFindResult;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnAtUser;

@property (strong, nonatomic) IBOutlet UIButton *btnHash;
@property (weak, nonatomic) IBOutlet UIImageView *imgHash;
@property (weak, nonatomic) IBOutlet UIImageView *imgAtUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;

@property(nonatomic)int intTypeOf;

@property(strong,nonatomic)NSMutableArray *mAryUsers;
@property(strong,nonatomic)NSArray *aryTagSearchDisplay;
@property(strong,nonatomic)NSArray *aryUserSearchDisplay;
@property (nonatomic, assign) PDSearchType searchType;
- (IBAction)btnHashPressed:(id)sender;
- (IBAction)btnMapPressed:(id)sender;

- (IBAction)btnAtUserPressed:(id)sender;
-(void)getTagsData;
//-(void)filterResults:(NSString *)searchTerm;
-(void)setSearchBarSubView;

@end
