//
//  TwitterFollowerList.h
//  LogInAndSignUpDemo
//
//  Created by Apple on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterFollowerList : UIViewController
{
    NSMutableArray *arrMyFollowers;
    NSMutableArray *arrInviteMyFollowers;
    BOOL isLoading;
    NSString *pagingIndexForTwitterFollowers;
}

#pragma mark loadingIndicator
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) IBOutlet UIView *activityIndicatorView;
@property (nonatomic,retain) UIActivityIndicatorView *footerActivityIndicator;

@property (retain, nonatomic) IBOutlet UITableView *tblTwitter;
- (IBAction)onClick_TwiterInviteAll:(id)sender;
- (IBAction)onClick_TwitterInviteSelected:(id)sender;
-(void)getTwitterFollowersOnScrolling;
@end
