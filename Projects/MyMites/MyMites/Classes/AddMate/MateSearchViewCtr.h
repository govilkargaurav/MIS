//
//  MateSearchViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 9/8/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateSearchViewCtr : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *tblView;
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableArray *ArryMyMatesSearch;
    NSURLConnection *ConnectionRequest;
    
#pragma mark - Pass Parameter
    
    NSString *strName,*strLocation,*strOccupation;
}
@property (nonatomic,strong)NSString *strName,*strLocation,*strOccupation;
@property(nonatomic,retain)NSMutableDictionary *statuses;
@property(nonatomic,strong)NSURLRequest *requestMain;
- (NSString *)removeNull:(NSString *)str;


@end
