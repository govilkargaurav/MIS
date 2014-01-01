//
//  CCellRatings.h
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface CCellRatings : UIViewController
{
    NSDictionary *d;
    IBOutlet UILabel *lblName,*lblRating;
    IBOutlet EDStarRating *CostRating,*ProRating,*QuaRating,*OverallRating;
    IBOutlet UITextView *txtComment;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal;
@end
