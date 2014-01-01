//
//  RssFeedParserCell.h
//  LawyerApp
//
//  Created by Gaurav on 7/27/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
@interface RssFeedParserCell : UIViewController
@property (nonatomic,strong)IBOutlet UILabel *lblTitle;
@property (nonatomic,strong)IBOutlet UILabel *lblDescription;
@property (nonatomic,strong)IBOutlet UIButton *btnLink;
@property (nonatomic,strong)IBOutlet UIImageView *imgViewFeed;
@property (nonatomic,strong)MWFeedItem *feedItems;
@property (assign)int indexPathRow;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil MWFeedItem:(MWFeedItem *)feeditem indexPath:(int)indexPath;
@end
