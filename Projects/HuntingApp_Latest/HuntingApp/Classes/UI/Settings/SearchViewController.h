//
//  SearchViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 8/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MFMessageComposeViewController.h"

@interface SearchViewController : UITableViewController<UIAlertViewDelegate,RequestWrapperDelegate,MFMessageComposeViewControllerDelegate>
{
    UIView *titleView;
    WebServices *followFriendRequest;
    DejalActivityView *loadingActivityIndicator;
    WebServices *searchFriendRequest;
    NSString *selectedPhoneNumber;
}
@property (nonatomic,retain) NSArray *items;
@end
