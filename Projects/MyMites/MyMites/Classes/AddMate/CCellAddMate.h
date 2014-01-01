//
//  CCellAddMate.h
//  MyMites
//
//  Created by Apple-Openxcell on 10/4/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"

@interface CCellAddMate : UIViewController
{
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblOccu;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIButton *btnAddMate;
    NSDictionary *d;
    ImageViewURL *x;
    int i;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal indexpathval:(int)indexpath;
- (NSString *)removeNull:(NSString *)str;
@end
