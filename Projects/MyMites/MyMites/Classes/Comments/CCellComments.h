//
//  CCellComments.h
//  MyMites
//
//  Created by Apple-Openxcell on 10/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"

@interface CCellComments : UIViewController
{
    NSDictionary *d;
    
    IBOutlet UILabel *lblName,*lblDate,*lblDesc;
    IBOutlet UIImageView *imglogo;
    
    ImageViewURL *x;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal;
- (NSString *)removeNull:(NSString *)str;
@end
