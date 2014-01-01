//
//  CommentViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAlertView.h"

@protocol CommentControllerDelegate <NSObject>

- (void)dismissCommentView;

@end

@interface CommentViewController : UIViewController<TSAlertViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,RequestWrapperDelegate>
{
    WebServices *likeRequest;
    WebServices *commentRequest;
    WebServices *getImageRequest;
    WebServices *deleteCommentRequest;
    NSString *imageID;
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblComment;
    IBOutlet UILabel *lblLike;
    IBOutlet UIScrollView *likeScrollView;
    NSString *IDSelected;
    NSMutableArray *btnImageViews;
    TSAlertView* av;
    NSString *selectedID;
    IBOutlet UIView *viewBottom;
}
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@property (assign,nonatomic) id<CommentControllerDelegate> delegate;
@property (assign, nonatomic) Picture *selectedPicture;
@property (nonatomic) BOOL shouldLike;
@property (nonatomic,retain) NSArray *likesInfo;

- (void)addCommentControllerAsSubviewInController:(UIViewController *)controller;
- (IBAction)editTblView:(UIBarButtonItem *)btn;
- (IBAction)dismissView:(id)sender;
- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;
@end
