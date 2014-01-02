//
//  ScrollGalleryViewController.h
//  NJJN_News
//
//  Created by Mac-i7 on 7/18/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "AppConstat.h"

@interface ScrollGalleryViewController : UIViewController <UIScrollViewDelegate>
{
    int flagOrientation;
    int indexclick;
    IBOutlet UIScrollView* scrollMainObj;
    IBOutlet UILabel* lblTitle;
}

@property (nonatomic, strong) NSMutableArray* arrayGalleryData;

-(IBAction)Back:(id)sender;

@end
