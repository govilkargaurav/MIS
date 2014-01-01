//
//  IamWithContactsCustomCell.h
//  Suvi
//
//  Created by Vivek Rajput on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IamWithContactsCustomCell : UITableViewCell
{
    UIImageView *imgview;
    UILabel *lblcontactname;
}
@property(nonatomic,retain) UIImageView *imgview;
@property(nonatomic,retain) UILabel *lblcontactname;

@end
