//
//  SearchResult_Cell.h
//  MyMites
//
//  Created by Apple-Openxcell on 9/8/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewURL.h"
#import "EDStarRating.h"

@interface SearchResult_Cell : UIViewController
{
    IBOutlet UILabel *lblName,*lblDesignation,*lblState,*lblConnNo,*lblS,*lblRating,*lblmobileno,*lblLandNo,*lblwebSite;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIButton *btnConnect,*btnMateConn,*btnmobileno,*btnlanno,*btnWebSite,*btnEmail;
    NSDictionary *d;
    ImageViewURL *x;
    IBOutlet EDStarRating *starRating;
    
    int i;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal indexpathval:(int)indexpath;
- (NSString *)removeNull:(NSString *)str;
@end
