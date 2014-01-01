//
//  MateConnDetail.h
//  MyMites
//
//  Created by apple on 10/29/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterORLogin.h"

@interface MateConnDetail : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    
    IBOutlet UITableView *tblView;
    
    IBOutlet UILabel *lblDisplayCount;
    
    NSString *strID,*strName;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableArray *ArryMyMates;
    NSURLConnection *ConnectionRequest;
    
    //business, The ratings, telephone number, address, mobile, email , Mates link , no of connections , website
}
@property (nonatomic , strong)NSString *strID,*strName;
- (NSString *)removeNull:(NSString *)str;

@end
