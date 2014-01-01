//
//  FullProfessionViewCtr.h
//  MyMites
//
//  Created by apple on 11/20/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullProfessionViewCtr : UIViewController
{
    IBOutlet UILabel *lblProfession,*lblProfessionHeading;
    IBOutlet UILabel *lblBusinessName,*lblBusinessNameHeading;
    IBOutlet UILabel *lblBusinessCategory,*lblBusinessCategoryHeading;
    IBOutlet UILabel *lblDesc,*lblDescHeading;
    IBOutlet UILabel *lblExp,*lblExpHeading;
    IBOutlet UILabel *lblWorkEmail,*lblWorkEmailHeading;
    IBOutlet UILabel *lblWebsite,*lblWebsiteHeading;
    IBOutlet UIButton *btnEditProfession;
    IBOutlet UIScrollView *scrlFullDetail;
    int y;
    NSDictionary *DicResults;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Dic:(NSDictionary*)DValue;
-(CGSize)text:(NSString*)strTextContent;
@end
