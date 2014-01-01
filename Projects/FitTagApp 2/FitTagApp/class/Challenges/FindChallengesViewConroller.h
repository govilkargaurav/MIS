//
//  FindChallengesViewConroller.h
//  FitTagApp
//
//  Created by apple on 2/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindChallengesViewConroller : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblFindResult;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnAtUser;

@property (strong, nonatomic) IBOutlet UIButton *btnHash;
@property(nonatomic)int intTypeOf;
- (IBAction)btnHashPressed:(id)sender;
- (IBAction)btnMapPressed:(id)sender;

- (IBAction)btnAtUserPressed:(id)sender;
@end
