//
//  AddFriendsViewController.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "AppDelegate.h"
#import "FriendsProfileVC.h"
#import "FriendsSearchViewController.h"
#import "UIButton+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "FBConnect.h"

@interface AddFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UISearchBarDelegate,UIActionSheetDelegate,UIScrollViewDelegate, UITextFieldDelegate,FBSessionDelegate>
{
    IBOutlet UITableView *tblview;
    
    NSURLConnection *connection;
    NSMutableData *webData;
    NSMutableString *action;
    NSMutableString *actionurl;
    NSMutableString *actionparameters;
    
    NSMutableArray *arrsuvifriendsfulllist;
    NSMutableArray *arrsuvifriends;
    NSMutableArray *arrpeopleknowfulllist;
    NSMutableArray *arrpeopleknow;
    NSMutableArray *arrrandomfulllist;
    NSMutableArray *arrrandom;
    NSMutableArray *arrpendingreuestfulllist;
    NSMutableArray *arrpendingreuest;
    NSMutableArray *arrsuvifriendssearchfulllist;
    NSMutableArray *arrsuvifriendssearch;
    
    UISearchBar *searchbar;
    NSInteger selectedindex;
    
    NSMutableDictionary *friendData;
    IBOutlet UITextField *txtSearch;

    // Friends Horizontal ScrollView
    IBOutlet UIScrollView *scl_MyFriends,*scl_PeopleMayKnow,*scl_Random;
    IBOutlet UIScrollView *scl_Main;
    
    IBOutlet UIButton *btn_MyFriends,*btn_PeopleMayKnow,*btn_Random;
    
    NSString *strFriendID;
    
    IBOutlet UILabel *lblMsgMyFriends;
    
    int RandomUserTotalCount,PeopleUKnowTotalCount;
    Facebook *facebook;
    
}
@property (nonatomic, retain) Facebook *facebook;

-(IBAction)btnbackclicked:(id)sender;

-(void)_searchFriend;
-(void)_startSend;
-(void)_stopReceiveWithStatus:(NSString *)statusString;
-(void)_receiveDidStopWithStatus:(NSString *)statusString;
-(void)setData:(NSDictionary*)dictionary;

@end