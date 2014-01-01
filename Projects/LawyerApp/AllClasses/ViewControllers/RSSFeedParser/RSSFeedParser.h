//
//  RSSFeedParser.h
//  LawyerApp
//
//  Created by ChintaN on 7/27/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"


@interface RSSFeedParser : UIViewController<MWFeedParserDelegate,UITableViewDataSource,UITableViewDelegate>{
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    // Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    IBOutlet UIButton *btnTypeOfPane;
}
@property (nonatomic,strong)UITableView *tbleView;
@property (nonatomic, retain) NSArray *itemsToDisplay;
@end
