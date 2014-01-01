//
//  RatingsCustomCell.m
//  MyU
//
//  Created by Vijay on 7/16/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RatingsCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RatingsCustomCell

@synthesize imgMainBG,lblProffessorName,lblRatings,imgRate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,50.0)];
        [self.contentView addSubview:imgMainBG];
        
        lblProffessorName=[[UILabel alloc]initWithFrame:CGRectMake(10.0,4.0,190.0,23.0)];
        lblProffessorName.font=[UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        lblProffessorName.backgroundColor=[UIColor clearColor];
        lblProffessorName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblProffessorName];
        
        lblRatings=[[UILabel alloc]initWithFrame:CGRectMake(10.0,28.0,190.0,15.0)];
        lblRatings.font=[UIFont fontWithName:@"Helvetica" size:14.0];
        lblRatings.backgroundColor=[UIColor clearColor];
        lblRatings.textColor=[UIColor grayColor];
        [self.contentView addSubview:lblRatings];
        
        imgRate=[[UIImageView alloc]initWithFrame:CGRectMake(210.0,5.0,40.0,40.0)];
        [self.contentView addSubview:imgRate];
    }
    return self;
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}

@end
