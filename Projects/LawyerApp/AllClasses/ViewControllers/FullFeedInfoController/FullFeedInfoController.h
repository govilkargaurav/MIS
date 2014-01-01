//
//  FullFeedInfoController.h
//  LawyerApp
//
//  Created by Gaurav on 7/28/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
@interface FullFeedInfoController : UIViewController
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgViewFeed;
    IBOutlet UITextView *textViewSummary;
}
@property (nonatomic,strong)MWFeedItem *itemFeeds;
@end
