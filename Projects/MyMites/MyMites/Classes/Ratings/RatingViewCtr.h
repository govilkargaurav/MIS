//
//  RatingViewCtr.h
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface RatingViewCtr : UIViewController
{
    IBOutlet UITableView *tbl_Ratings;
    IBOutlet EDStarRating *AvgRat;
    IBOutlet UILabel *lblRateCount,*lblAvgRate;
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableDictionary *DicRatings;
    NSURLConnection *ConnectionRequest;
}
- (NSString *)removeNull:(NSString *)str;
@end
