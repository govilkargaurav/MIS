//
//  CCellMessage.h
//  MyMites
//
//  Created by Apple-Openxcell on 10/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"

@interface CCellMessage : UIViewController
{
    NSDictionary *d;
    
    IBOutlet UILabel *lblName,*lblDate,*lblDesc;
    IBOutlet UIImageView *imglogo,*imgSep;
    
    ImageViewURL *x;
    NSString *strTyp;
    int RowNo;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal type:(NSString*)strType rowint:(int)rowno;
- (NSString *)removeNull:(NSString *)str;
@end
