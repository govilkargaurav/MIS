//
//  UniversityCell.m
//  MyU
//
//  Created by Vijay on 8/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "UniversityCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UniversityCell

@synthesize imgMainBG,imgUniPic,lblUniName,lblUniAddress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imgMainBG=[[UIImageView alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,90.0)];
        [self.contentView addSubview:imgMainBG];
        
        imgUniPic=[[UIImageView alloc]initWithFrame:CGRectMake(10.0,10.0,70.0,70.0)];
        [self.contentView addSubview:imgUniPic];
        
        lblUniName=[[UILabel alloc]initWithFrame:CGRectMake(90.0,17.0,215.0,15.0)];
        lblUniName.numberOfLines=0;
        lblUniName.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblUniName.backgroundColor=[UIColor clearColor];
        lblUniName.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:lblUniName];
        
        lblUniAddress=[[UILabel alloc]initWithFrame:CGRectMake(90.0,32.0,180.0,15.0)];
        lblUniAddress.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        lblUniAddress.numberOfLines=0;
        lblUniAddress.backgroundColor=[UIColor clearColor];
        lblUniAddress.textColor=[UIColor grayColor];
        [self.contentView addSubview:lblUniAddress];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect theRect=lblUniName.frame;
    float thenameheight=[lblUniName.text sizeWithFont:lblUniName.font constrainedToSize:CGSizeMake(lblUniName.frame.size.width, CGFLOAT_MAX)].height;
    theRect.size.height=MIN(thenameheight,35.0);
    lblUniName.frame=theRect;
    
    theRect=lblUniAddress.frame;
    theRect.origin.y=lblUniName.frame.origin.y+lblUniName.frame.size.height+2.0;
    thenameheight=[lblUniAddress.text sizeWithFont:lblUniAddress.font constrainedToSize:CGSizeMake(lblUniAddress.frame.size.width, CGFLOAT_MAX)].height;
    theRect.size.height=MIN(thenameheight,30.0);
    lblUniAddress.frame=theRect;
}


@end
