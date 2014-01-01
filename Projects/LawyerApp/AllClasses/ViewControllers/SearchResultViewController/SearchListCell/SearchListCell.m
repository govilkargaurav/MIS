//
//  SearchListCell.m
//  LawyerApp
//
//  Created by ChintaN on 6/8/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "SearchListCell.h"
#import "UIImageView+WebCache.h"
@interface SearchListCell ()

@end

@implementation SearchListCell

@synthesize btnLawyerPressed;

@synthesize lblLawyerName;
@synthesize lblFirmName;
@synthesize lblMobNumber;
@synthesize ArrLawyerInfo;
@synthesize imgVwUser;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dict:(NSMutableDictionary *)arrValue
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ArrLawyerInfo = [[NSMutableDictionary alloc] init];
        ArrLawyerInfo = arrValue;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblLawyerName.text = [NSString stringWithFormat:@"%@ %@",[ArrLawyerInfo valueForKey:@"vFirstName"],[ArrLawyerInfo valueForKey:@"vLastName"]];
    
    self.lblMobNumber.text = [NSString stringWithFormat:@"%@",[ArrLawyerInfo valueForKey:@"vPhone"]];
    
    self.lblFirmName.text = [NSString stringWithFormat:@"%@",[ArrLawyerInfo valueForKey:@"vFirmName"]];
    
    [self.imgVwUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ArrLawyerInfo valueForKey:@"vProfilePic"]]] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageLowPriority];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
