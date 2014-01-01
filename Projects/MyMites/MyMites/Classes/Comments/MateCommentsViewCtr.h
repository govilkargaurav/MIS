//
//  MateCommentsViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 10/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateCommentsViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *tbl_MateComments;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryDicResult;
}
- (NSString *)removeNull:(NSString *)str;

@end
