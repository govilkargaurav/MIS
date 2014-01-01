//
//  SearchChngCell.h
//  FitTagApp
//
//  Created by apple on 2/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@class PFImageView;

@interface SearchChngCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilrEgoImageView;
@property (strong, nonatomic) IBOutlet UIButton *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblChallengeName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescriptionTag;
@property (strong, nonatomic) IBOutlet UITextView *txtViewLikes;
@property (strong, nonatomic) IBOutlet UIButton *btnSeeOlgerComment;
@property (strong, nonatomic) IBOutlet UIImageView *teaserEgoImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnLikeChallenge;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnReport;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
//-(void)setDict:(NSDictionary *)dictionar;
//-(void)setProfileImageDict:(NSDictionary *)dictionary;
@end
