//
//  AlbumViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FirstScreen.h"
#import "TSAlertView.h"
#import "FLButton.h"
#import "CommentViewController.h"
#import <MessageUI/MessageUI.h>


@protocol AlbumViewDelegate <NSObject>

- (void)disappearAlbumView;

@end

@interface AlbumViewController : UIViewController<UIScrollViewDelegate,CommentControllerDelegate,RequestWrapperDelegate,MFMailComposeViewControllerDelegate>
{
    //NSMutableArray *albumDictionary;
    NSMutableArray *scrollViewArray;
    DejalActivityView *loadingActivityIndicator;
    Picture *currentImage;
    CommentViewController *commentController;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *btnLocation;
    WebServices *getImageRequest;
    WebServices *likeRequest;
    WebServices *delLocRequest;
    WebServices *findLocation;
    WebServices *addLocation;
    BOOL pageChanged;
    NSString *imageIDLiked;
    NSNumber *selectedIndex;
    BOOL viewHasAppeared;
    BOOL isCommentViewLoading;
    NSString *selectedID;
    
    IBOutlet UIView *viewNavigation;
    
    
    IBOutlet UIButton *btnProfileImg;
    IBOutlet UIImageView *imgUsrProfile;
    
    
}


@property (nonatomic,retain) Picture *pic;
@property (nonatomic,retain) NSArray *picArray;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (retain, nonatomic) IBOutlet UIButton *btnLike;
@property (retain, nonatomic) IBOutlet UILabel *lblLikes;
@property (retain, nonatomic) IBOutlet UILabel *lblComment;
@property (retain, nonatomic) IBOutlet UIButton *btnComment;
@property (retain, nonatomic) IBOutlet UIButton *btnShare;
@property (assign, nonatomic) id<AlbumViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblDesc;
@property (retain, nonatomic) IBOutlet FLButton *profilePic;
@property (retain, nonatomic) IBOutlet UIButton *btnName;
@property (nonatomic) NSInteger comeFromView;
@property (nonatomic) BOOL isLikeBtnSelected;
@property (nonatomic) BOOL gotoCommentView;
- (IBAction)gotoProfile:(id)sender;
- (IBAction)shareImage:(id)sender;
- (IBAction)comment:(id)sender;
- (IBAction)like:(id)sender;
- (IBAction)dismissAlbumView:(id)sender;
- (IBAction)followLocation:(UIButton *)sender;
-(void)gotoProfilePUSH:(NSString *)sender;
@end
