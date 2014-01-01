//
//  SearchListCell.h
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListCell : UIViewController
@property(nonatomic,strong)IBOutlet UIButton *btnLawyerPressed;
@property(nonatomic,strong)IBOutlet UILabel *lblLawyerName;
@property(nonatomic,strong)IBOutlet UILabel *lblFirmName;
@property(nonatomic,strong)IBOutlet UILabel *lblMobNumber;
@property(nonatomic,strong)IBOutlet UIImageView *imgVwUser;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dict:(NSMutableDictionary *)arrValue;
@property (nonatomic,strong)NSMutableDictionary *ArrLawyerInfo;
@end
