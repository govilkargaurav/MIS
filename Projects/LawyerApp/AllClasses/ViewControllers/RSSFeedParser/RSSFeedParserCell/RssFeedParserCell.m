//
//  RssFeedParserCell.m
//  LawyerApp
//
//  Created by Gaurav on 7/27/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "RssFeedParserCell.h"
#import "UIImageView+WebCache.h"
#import "MWFeedItem.h"
#import "NSString+HTML.h"
@interface RssFeedParserCell ()

@end

@implementation RssFeedParserCell
@synthesize indexPathRow;
@synthesize lblTitle;
@synthesize lblDescription;
@synthesize btnLink;
@synthesize imgViewFeed;
@synthesize feedItems;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil MWFeedItem:(MWFeedItem *)feeditem indexPath:(int)indexPath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        feedItems=feeditem;
        indexPathRow= indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    lblTitle.text=feedItems.title;
    btnLink.tag= indexPathRow+1000;
    [btnLink setTitle:feedItems.link forState:UIControlStateNormal];
    lblDescription.text=feedItems.summary ? [feedItems.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
    if (feedItems.imgURLThumbnail) {
        
        [imgViewFeed setImageWithURL:[NSURL URLWithString:feedItems.imgURLThumbnail] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageRefreshCached];
    }else{
    [imgViewFeed setImageWithURL:[NSURL URLWithString:feedItems.imgURLThumbnail] placeholderImage:[UIImage imageNamed:@"icon.png"] options:SDWebImageRefreshCached];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
