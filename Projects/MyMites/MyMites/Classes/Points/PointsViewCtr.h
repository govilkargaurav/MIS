//
//  PointsViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 10/1/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsViewCtr : UIViewController
{
    IBOutlet UITableView *tbl_Points;
    IBOutlet UILabel *lblPoints;
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableDictionary *results;
    NSURLConnection *ConnectionRequest;
}
- (NSString *)removeNull:(NSString *)str;
@end
