//
//  FollowersListViewCltr.h
//  FitTagApp
//
//  Created by Apple1 on 2/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

#import "AppUtilityClass.h"

@interface FacebookFriendList : UITableViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>{

    NSMutableArray *friendUsers;
    
    NSMutableArray *arrInviteFriends;
}
- (IBAction)inviteButtonPressed:(UIButton *)sender;
-(IBAction)onClick_Done;


-(BOOL)CompareArray:(NSMutableArray *)arrayToCompare WithArray:(NSMutableArray *)byArray withKeyValue:(NSString *)Key;
-(BOOL)isArray:(NSMutableArray *)array ContainsObject:(id)object WithKey:(NSString *)key;
//-(NSComparisonResult (^) (id lhs, id rhs))compareObject;
@end
