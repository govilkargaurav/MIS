//
//  GlobalCustomCell.h
//  MyU
//
//  Created by Vijay on 7/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

@interface GlobalCustomCell : UITableViewCell
{

}
//Header
@property (nonatomic,strong) UIImageView *imgMainBG;
@property (nonatomic,strong) UIButton *imgProfilePic;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblSubject;
@property (nonatomic,strong) UILabel *lblTime;

//Middle
@property (nonatomic,strong) OHAttributedLabel *lblattributed;
@property (nonatomic,strong) UIImageView *imgMain;
@property (nonatomic,strong) UIImageView *imgMainBlurred;
@property (nonatomic,strong) UIButton *btnMain;

//Footer
@property (nonatomic,strong) UIImageView *imgFooter;
@property (nonatomic,strong) UILabel *lblLikeCount;
@property (nonatomic,strong) UILabel *lblCommentCount;
@property (nonatomic,strong) UIButton *btnLike;
@property (nonatomic,strong) UIButton *btnComment;

@property (nonatomic,readwrite) BOOL isNewsCell;
@property (nonatomic,readwrite) BOOL isCommentCell;

@property (nonatomic,readwrite) float imgwidth;
@property (nonatomic,readwrite) float imgheight;

@end
