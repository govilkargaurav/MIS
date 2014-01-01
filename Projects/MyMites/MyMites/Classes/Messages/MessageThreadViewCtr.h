//
//  MessageThreadViewCtr.h
//  MyMites
//
//  Created by apple on 11/2/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageThreadViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *tbl_MessagesThred;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryDicResult;
    
    NSString *striFromId,*striToId;
    
}
@property(nonatomic,strong)NSString *striFromId,*striToId;
- (NSString *)removeNull:(NSString *)str;

@end
