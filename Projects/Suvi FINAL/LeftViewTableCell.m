//
//  LeftViewTableCell.m
//  Suvi
//
//  Created by Vivek Rajput on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeftViewTableCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation LeftViewTableCell

@synthesize imgCellBG;
@synthesize btnCell;
@synthesize lblTitle;
@synthesize imgUserPic;
@synthesize imgPostType;
@synthesize imgComentLikeDislike;
@synthesize lblDate;
-(void)setDict:(NSDictionary *)dictionar
{
    //imgUserPic.layer.cornerRadius=4.0;
    //imgUserPic.clipsToBounds=YES;
    if ([dictionar valueForKey:@"urlAvtar"]!=nil)
    {
        NSString *strURLnew = [NSString stringWithFormat:@"%@",[dictionar valueForKey:@"urlAvtar"]];
        imgUserPic.tag=1001;
        [imgUserPic setImageWithURL:[NSURL URLWithString:strURLnew] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    }
    if ([dictionar valueForKey:@"ImagePost"]!=nil)
    {
        NSString *strURLnew = [NSString stringWithFormat:@"%@",[dictionar valueForKey:@"ImagePost"]];
        imgPostType.tag=1001;
        [imgPostType setImageWithURL:[NSURL URLWithString:strURLnew] placeholderImage:[UIImage imageNamed:@"sync.png"]];
    }
}
@end
