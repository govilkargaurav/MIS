//
//  HowItWorks.h
//  MyMite
//
//  Created by Vivek Rajput on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowItWorks : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    
    IBOutlet UITableView *tbl_RecentSearch;
}
- (NSString *)removeNull:(NSString *)str;
-(void)CallURL;
@end
