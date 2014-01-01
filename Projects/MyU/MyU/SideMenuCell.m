//
//  SideMenuCell.m
//  MyU
//
//  Created by Vijay on 7/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "SideMenuCell.h"


@implementation SideMenuCell
@synthesize imgView,lblView,view_bg,theCellType,isSelectedBG,lblUni;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        view_bg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 92.0)];
        [self.contentView addSubview:view_bg];
        
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40.0, 40.0)];
        imgView.contentMode=UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        
        lblView=[[UILabel alloc]initWithFrame:CGRectMake(50.0, 0,130.0, 40.0)];
        lblView.backgroundColor=[UIColor clearColor];
        lblView.font=[UIFont fontWithName:@"Arial" size:17.0];
        lblView.textColor=[UIColor lightTextColor];
        [self.contentView addSubview:lblView];
        
        lblUni=[[UILabel alloc]initWithFrame:CGRectMake(180.0, 0,60.0, 40.0)];
        lblUni.backgroundColor=[UIColor clearColor];
        lblUni.font=[UIFont fontWithName:@"Arial" size:14.0];
        lblUni.textColor=[UIColor whiteColor];
        lblUni.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:lblUni];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (theCellType) {
        case CellType_Header:
        {
            view_bg.frame=CGRectMake(0, 0, 320,46.0);
            view_bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(isSelectedBG)?@"cellbg_header_s.png":@"cellbg_footer.png"]];
            imgView.frame=CGRectMake(0,1.0,40.0,40.0);
            lblView.frame=CGRectMake(50.0,1.0,130,40.0);
            lblUni.frame=CGRectMake(180.0,1.0,60,40.0);
        }
            break;
            
        case CellType_Middle:
        {
            view_bg.frame=CGRectMake(0, 0, 320,41.0);
            view_bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(isSelectedBG)?@"cellbg_middle_s.png":@"cellbg_middle.png"]];
            imgView.frame=CGRectMake(0,0.0,40.0,40.0);
            lblView.frame=CGRectMake(50.0,0,130,40.0);
            lblUni.frame=CGRectMake(180.0,0,60,40.0);
        }
            break;
            
        case CellType_Footer:
        {
            view_bg.frame=CGRectMake(0, 0, 320,45.0);
            view_bg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(isSelectedBG)?@"cellbg_footer_s.png":@"cellbg_footer.png"]];
            imgView.frame=CGRectMake(0,0.0,40.0,40.0);
            lblView.frame=CGRectMake(50.0,0,130,40.0);
            lblUni.frame=CGRectMake(180.0,0,60,40.0);
        }
            break;
            
        default:
            break;
    }
}

@end
