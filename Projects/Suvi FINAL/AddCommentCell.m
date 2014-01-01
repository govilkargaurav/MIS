//
//  AddCommentCell.m
//  Suvi
//
//  Created by Vivek Rajput on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCommentCell.h"

@implementation AddCommentCell

@synthesize lblDateCell,imgUser,lblComment,lblFullName;

-(void)setDict:(NSDictionary *)dictionar
{
    if ([dictionar valueForKey:@"urlAvtar"]!=nil)
    {
        NSString *strURLnew = [NSString stringWithFormat:@"%@",[dictionar valueForKey:@"urlAvtar"]];
        imgUser.tag=1001;
        [imgUser setImageWithURL:[NSURL URLWithString:strURLnew] placeholderImage:[UIImage imageNamed:@"profileUser.png"]];
    }
}

@end
