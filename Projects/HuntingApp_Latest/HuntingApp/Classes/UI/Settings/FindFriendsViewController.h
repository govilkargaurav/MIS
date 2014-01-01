//
//  FindFriendsViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FindFriendsViewController : UIViewController<UIAlertViewDelegate,RequestWrapperDelegate>
{
    UIView *titleView;
    WebServices *searchFriendRequest;
    DejalActivityView *loadingActivityIndicator;
    BOOL isSearching;
    BOOL facebookButtonPressed;
    NSMutableArray *arrContact;
}
@property (nonatomic) BOOL isLoggedFirstTime;
- (IBAction)search:(UIButton *)sender;
@end
