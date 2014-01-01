//
//  RSSFeedParser.m
//  LawyerApp
//
//  Created by ChintaN on 7/27/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "RSSFeedParser.h"
#import "RssFeedParserCell.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "UIImageView+WebCache.h"
#import "GlobalClass.h"
#import "FullFeedInfoController.h"

@interface RSSFeedParser ()
@end

@implementation RSSFeedParser
@synthesize itemsToDisplay;
@synthesize tbleView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=TRUE;
    
    // Parse
    [btnTypeOfPane addTarget:self action:@selector(paneSelector:) forControlEvents:UIControlEventTouchUpInside];
    
	NSURL *feedURL;
    if ([strFeedType isEqualToString:@"2"]) {
        feedURL = [NSURL URLWithString:@"http://blackamericaweb.com/category/news/national-news/feed/"];
    }else if ([strFeedType isEqualToString:@"3"]){
        feedURL = [NSURL URLWithString:@"http://thegrio.com/category/news/feed/"];
    }else if ([strFeedType isEqualToString:@"4"]){
        feedURL = [NSURL URLWithString:@"http://www.theroot.com/siterss/feed"];
    }else if ([strFeedType isEqualToString:@"5"]){
        feedURL = [NSURL URLWithString:@"http://www.jurist.org/feeds/usnews.php"];
    }else if ([strFeedType isEqualToString:@"6"]){
        feedURL = [NSURL URLWithString:@"http://www.huffingtonpost.com/feeds/verticals/black-voices/index.xml"];
    }
    
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
}

-(void)paneSelector:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSNavigationPaneOpenDirectionTop" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	self.tbleView.userInteractionEnabled = NO;
	self.tbleView.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO] ]];
    
    self.tbleView=[[UITableView alloc] initWithFrame:CGRectMake(0, 61, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    self.tbleView.delegate=self;
    self.tbleView.dataSource=self;
	self.tbleView.userInteractionEnabled = YES;
	self.tbleView.alpha = 1;
    [self.view addSubview:tbleView];
	[self.tbleView reloadData];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

#pragma mark-
#pragma mark UITableViewControllerDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 167;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        // Configure the cell.
        MWFeedItem *item;
        if ([itemsToDisplay count]>0) {
            
            item = [itemsToDisplay objectAtIndex:indexPath.row];
            
              }
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            RssFeedParserCell *obj_CCellMessage=[[RssFeedParserCell alloc] initWithNibName:@"RssFeedParserCell" bundle:nil MWFeedItem:item indexPath:indexPath.row];
            obj_CCellMessage.view.frame=CGRectMake(280, 0, 320, 167);
            obj_CCellMessage.view.alpha=0.0;
            [UIView animateWithDuration:0.6 animations:^{
                
                obj_CCellMessage.view.frame=CGRectMake(0, 0, 320, 167);
                obj_CCellMessage.view.alpha=1.0;
                [cell.contentView addSubview:obj_CCellMessage.view];
            }];
            
            obj_CCellMessage=nil;
      
    }
    cell.selectionStyle=FALSE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    // Show detail
	FullFeedInfoController *detail = [[FullFeedInfoController alloc] initWithNibName:@"FullFeedInfoController" bundle:nil];
	detail.itemFeeds = (MWFeedItem *)[itemsToDisplay objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detail animated:YES];


}


/* Open Url in UIWebView */

#pragma mark- 
#pragma mark OPEN URL 

/* This method is connected to the First Responder From Cell btnLink */

-(IBAction)openURLInWebView:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    MWFeedItem *item = [itemsToDisplay objectAtIndex:[btn tag]-1000];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.link]]];
    
}





@end
