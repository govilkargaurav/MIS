//
//  AddFriendsCustomCell.m
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddFriendsCustomCell.h"

@implementation AddFriendsCustomCell

@synthesize imgview,lblheader,lbldesc,lblfriendcount,imgviewacc;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        imgview=[[UIImageView alloc]init];
        imgview.frame=CGRectMake(6,3,54,54);
        imgview.contentMode=UIViewContentModeScaleAspectFit;
        
        lblfriendcount=[[UILabel alloc]init];
        lblfriendcount.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"badge_red.png"]];
        lblfriendcount.frame=CGRectMake(50,1.5,18,19);
        lblfriendcount.font=[UIFont systemFontOfSize:12.0];
        lblfriendcount.textColor = [UIColor whiteColor];
        lblfriendcount.textAlignment=UITextAlignmentCenter;
        
        lblfriendcount.hidden=YES;
        
        lblheader=[[UILabel alloc]init];
        lblheader.frame=CGRectMake(75,15,215,30);
        lblheader.font=[UIFont fontWithName:@"Arial-Bold" size:22];
        lblheader.backgroundColor = [UIColor clearColor];
        lblheader.textColor = [UIColor grayColor];
        
        lbldesc=[[UILabel alloc]init];
        lbldesc.frame=CGRectMake(75,32,215,15);
        lbldesc.font=[UIFont fontWithName:@"Arial" size:14];
        lbldesc.backgroundColor = [UIColor clearColor];
        lbldesc.textColor = [UIColor grayColor];
        
        imgviewacc=[[UIImageView alloc]init];
        imgviewacc.frame=CGRectMake(283,19,22,22);
        imgviewacc.contentMode=UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:imgview];
        [self.contentView addSubview:lblfriendcount];
        [self.contentView addSubview:lblheader];
        [self.contentView addSubview:lbldesc];
        [self.contentView addSubview:imgviewacc];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
