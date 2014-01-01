//
//  ContactCustomCell.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCustomCell : UITableViewCell
{
    UIImageView *imgview;
    UILabel *lblcontactname;
    UIButton *btninvite;
}
@property(nonatomic,retain) UIImageView *imgview;
@property(nonatomic,retain) UILabel *lblcontactname;
@property(nonatomic,retain) UIButton *btninvite;
@end
