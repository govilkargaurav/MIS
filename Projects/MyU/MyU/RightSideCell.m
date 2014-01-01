//
//  RightSideCell.m
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "RightSideCell.h"

@implementation RightSideCell

@synthesize viewBG,imgDevider,imgView,lblViewHeader,lblBadge,lblattributed,btnAccept,btnIgnore,theCellType,isSelectedBG;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBG=[[UIView alloc]init];
        [self.contentView addSubview:viewBG];

        imgView=[[UIImageView alloc]init];
        imgView.tag=107;
        [self.contentView addSubview:imgView];
        
        lblViewHeader=[[UILabel alloc]init];
        lblViewHeader.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        lblViewHeader.numberOfLines=0;
        lblViewHeader.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:lblViewHeader];
        
        lblattributed = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(20.0f,30.0f,280.0f,120.0f)];
        lblattributed.backgroundColor=[UIColor clearColor];
        lblattributed.numberOfLines=0.0;
        lblattributed.opaque=YES;
        lblattributed.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:lblattributed];
        
        lblBadge=[[UILabel alloc]init];
        lblBadge.textAlignment=NSTextAlignmentCenter;
        lblBadge.textColor=[UIColor whiteColor];
        [self.contentView addSubview:lblBadge];
        
        imgDevider=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_devider"]];
        [self.contentView addSubview:imgDevider];
        
        btnAccept=[[UIButton alloc]initWithFrame:CGRectMake(210, 50, 75, 20)];
        [btnAccept setImage:[UIImage imageNamed:@"btnaccept_small.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:btnAccept];
        
        btnIgnore=[[UIButton alloc]initWithFrame:CGRectMake(295, 50, 75, 20)];
        [btnIgnore setImage:[UIImage imageNamed:@"btnignore_small.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:btnIgnore];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    viewBG.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:(isSelectedBG)?@"bg_not_0":@"bg_not_1"]];
    
    switch (self.theCellType)
    {
        case CellType_Group_Updates:
        {
            viewBG.frame=CGRectMake(0, 0, 320, 80);
            imgDevider.frame=CGRectMake(0, 79, 320, 1);
            
            imgView.layer.cornerRadius=5.0;
            imgView.layer.opaque=YES;
            imgView.clipsToBounds=YES;
            imgView.frame=CGRectMake(5, 5, 70, 70);
            
            float theheader_height=MIN([lblViewHeader.text sizeWithFont:lblViewHeader.font constrainedToSize:CGSizeMake(135, CGFLOAT_MAX)].height,30);
            lblViewHeader.frame=CGRectMake(80, 10, 135,theheader_height);
            
            float thebody_height=MIN([[lblattributed.attributedText heightforAttributedStringWithWidth:150.0]floatValue],CGFLOAT_MAX);
            lblattributed.frame=CGRectMake(80,48, 150,thebody_height);
            
            lblBadge.backgroundColor=RGBCOLOR(149.0, 156.0, 166.0);
            lblBadge.layer.cornerRadius=2.5;

            float thebadge_width=MIN([lblBadge.text sizeWithFont:lblBadge.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,15.0)].width,28.0);
            lblBadge.frame=CGRectMake(218, 25, thebadge_width, 18.0);
            
            if ([[lblBadge.text removeNull] integerValue]==0) {
                lblBadge.frame=CGRectMake(0, 0, 0, 0);
            }
            
            btnAccept.frame=CGRectMake(0, 0, 0, 0);
            btnIgnore.frame=CGRectMake(0, 0, 0, 0);
        }
        break;
            
        case CellType_Private_Messages:
        {
            viewBG.frame=CGRectMake(0,0,320,70.0);
            imgDevider.frame=CGRectMake(0,69.0,320,1.0);
            
            imgView.layer.cornerRadius=5.0;
            imgView.layer.opaque=YES;
            imgView.clipsToBounds=YES;
            imgView.frame=CGRectMake(5,10,50,50);
            
            lblViewHeader.frame=CGRectMake(62,18, 148,15.0);
            lblattributed.frame=CGRectMake(62,40.0, 148,15.0+5.0);
            lblBadge.backgroundColor=RGBCOLOR(149.0, 156.0, 166.0);
            lblBadge.layer.cornerRadius=2.5;
            
            float thebadge_width=MIN([lblBadge.text sizeWithFont:lblBadge.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,15.0)].width,28.0);
            lblBadge.frame=CGRectMake(218,26, thebadge_width, 18.0);
            
            if ([[lblBadge.text removeNull] integerValue]==0) {
                lblBadge.frame=CGRectMake(0, 0, 0, 0);
            }
            
            btnAccept.frame=CGRectMake(0, 0, 0, 0);
            btnIgnore.frame=CGRectMake(0, 0, 0, 0);
        }
        break;
            
        case CellType_Notification_Simple:
        {
            imgView.frame=CGRectMake(0,0,53,53);
            
            float thebody_height=[[lblattributed.attributedText heightforAttributedStringWithWidth:150.0]floatValue];
            lblattributed.frame=CGRectMake(61.0,9.0,150.0,thebody_height);
            
            lblBadge.backgroundColor=[UIColor clearColor];
            lblBadge.font=[UIFont fontWithName:@"Helvetica" size:12.0];
            float thebadge_width=MIN([lblBadge.text sizeWithFont:lblBadge.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,15.0)].width,100.0);
            lblBadge.frame=CGRectMake(218,36, thebadge_width+2, 15.0);

            viewBG.frame=CGRectMake(0, 0, 320,MAX(9+thebody_height+5, 53.0));
            imgDevider.frame=CGRectMake(0,viewBG.frame.size.height, 320, 1);
            
            btnAccept.frame=CGRectMake(0, 0, 0, 0);
            btnIgnore.frame=CGRectMake(0, 0, 0, 0);
        }
        break;
            
        case CellType_Notification_Invite:
        {
            imgView.frame=CGRectMake(0,0,53,53);
            
            float thebody_height=[[lblattributed.attributedText heightforAttributedStringWithWidth:150.0]floatValue];
            lblattributed.frame=CGRectMake(61.0,9.0,150,thebody_height);
            
            lblBadge.backgroundColor=[UIColor clearColor];
            lblBadge.font=[UIFont fontWithName:@"Helvetica" size:12.0];
            float thebadge_width=MIN([lblBadge.text sizeWithFont:lblBadge.font constrainedToSize:CGSizeMake(CGFLOAT_MAX,15.0)].width,100.0);
            lblBadge.frame=CGRectMake(218,36, thebadge_width, 15.0);
            
            btnAccept.frame=CGRectMake(62.0,9+thebody_height+6, 73.0, 20.0);
            btnIgnore.frame=CGRectMake(139.0,9+thebody_height+6, 73.0, 20.0);
            
            viewBG.frame=CGRectMake(0, 0, 320,MAX(9+thebody_height+5+20, 53.0)+10);
            imgDevider.frame=CGRectMake(0,viewBG.frame.size.height, 320, 1);
        }
        break;
            
        case CellType_User_Searching:
        {
            btnAccept.hidden=YES;
            btnIgnore.hidden = YES;
            imgView.frame=CGRectMake(0.0,0.0,49.0,49.0);
            lblattributed.frame=CGRectMake(70.0,15.0,210.0,20.0);
            lblattributed.textColor=[UIColor whiteColor];
            lblattributed.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            viewBG.frame=CGRectMake(0,0,320,49.0);
            imgDevider.frame=CGRectMake(0,viewBG.frame.size.height,320.0,1.0);
        }
            break;
            
        default:
            break;
    }
}

@end
