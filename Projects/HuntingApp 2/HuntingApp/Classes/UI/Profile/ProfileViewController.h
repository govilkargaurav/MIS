//
//  ProfileViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageView.h"
#import "AlbumViewController.h"

@interface ProfileViewController : UIViewController<RequestWrapperDelegate,AlbumViewDelegate,UIAlertViewDelegate>
{
    DejalActivityView *loadingActivityIndicator;
    WebServices *loadImagesRequest;
    WebServices *followRequest;
    NSMutableArray *btnImageViews;
    NSArray *picturesArray;
    NSArray *followersArray;
    NSArray *followingArray;
    Picture *selectedPicture;
    UIView *titleView;
    int currentSelection;
    IBOutlet UILabel *lblPicture;
    IBOutlet UILabel *lblFollowing;
    IBOutlet UILabel *lblFollowers;
    IBOutlet UIButton *btnFollowing;
    IBOutlet UIButton *btnFollowers;
    IBOutlet UIButton *btnPictures;
    IBOutlet UILabel *lblProfileBio;
    IBOutlet UIButton *btnFollow;
    NSString *selectedID;
    
    WebServices *deleteImageRequest;
}
@property (retain, nonatomic) Profile *userProfile;
@property (retain, nonatomic) IBOutlet FLImageView *profilePicView;
//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UILabel *tempLabel;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic) int currentSelection;
@property (nonatomic) BOOL isProfileTwo;
@property (nonatomic,retain) NSArray *displayArray;
- (IBAction)changeSection:(id)sender;
- (void)profileSelected:(UIButton *)sender;
@end
