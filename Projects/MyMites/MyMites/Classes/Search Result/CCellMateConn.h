//
//  CCellMateConn.h
//  MyMites
//
//  Created by apple on 10/29/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"

@interface CCellMateConn : UIViewController
{
    IBOutlet UILabel *lblName,*lblDesignation,*lblState,*lblComment;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIButton *btnViewProfile;
    NSDictionary *d;
    ImageViewURL *x;
    NSString *strNamePass;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal name:(NSString*)strName;
- (NSString *)removeNull:(NSString *)str;
@end
