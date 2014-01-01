//
//  FullFeedInfoController.m
//  LawyerApp
//
//  Created by Gaurav on 7/28/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "FullFeedInfoController.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"
@interface FullFeedInfoController ()

@end

@implementation FullFeedInfoController

@synthesize itemFeeds;

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
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IPHONE_5) {
        
        textViewSummary.frame=CGRectMake(0, 315, 320, 233);
    }else{
        
        textViewSummary.frame=CGRectMake(0, 315, 320, 144);
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    lblTitle.text= itemFeeds.title;
    textViewSummary.text= itemFeeds.summary ? [itemFeeds.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
    if (itemFeeds.imgViewBigImage) {
        [imgViewFeed setImageWithURL:[NSURL URLWithString:itemFeeds.imgViewBigImage] placeholderImage:[UIImage imageNamed:@"sync.png"] options:SDWebImageRefreshCached];
    }else{
        [imgViewFeed setImageWithURL:[NSURL URLWithString:itemFeeds.imgViewBigImage] placeholderImage:[UIImage imageNamed:@"NO_IMAGE.png"] options:SDWebImageRefreshCached];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backBtnPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
