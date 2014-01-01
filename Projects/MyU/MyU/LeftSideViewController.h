//
//  LeftSideViewController.h
//  MyU
//
//  Created by Vijay on 7/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Home,
    University,
    News,
    Groups,
    Ratings,
    TellAFriend,
    AboutUs,
    Terms,
    PrivacyPolicy,
    Settings,
    SignOut
} viewType;

@interface LeftSideViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewHeader;
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblSchool;
    IBOutlet UILabel *lblSubject;
    NSArray *arrIcons;
    NSArray *arrSections;
    NSInteger selectedIndex;
    viewType theSelectedView;
}

@end
