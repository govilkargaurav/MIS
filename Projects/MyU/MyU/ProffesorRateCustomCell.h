//
//  ProffesorRateCustomCell.h
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

@interface ProffesorRateCustomCell : UITableViewCell
{
    
}

//Header
@property (nonatomic,strong) UIImageView *imgMainBG;
@property (nonatomic,strong) UILabel *lblSubject;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnReport;

//Middle
@property (nonatomic,strong) OHAttributedLabel *lblattributed;
@property (nonatomic,strong) UIView *viewRate;
@property (nonatomic,strong) UIImageView *imgRate1;
@property (nonatomic,strong) UIImageView *imgRate2;
@property (nonatomic,strong) UIImageView *imgRate3;
@property (nonatomic,strong) UIImageView *imgRate4;

//Footer
@property (nonatomic,strong) UILabel *lblLikeCount;
@property (nonatomic,strong) UIButton *btnLike;

@property (nonatomic,readwrite) BOOL isCommentCell;


@end
