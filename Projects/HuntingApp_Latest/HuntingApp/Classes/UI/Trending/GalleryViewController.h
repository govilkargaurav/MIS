//
//  GalleryViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumViewController.h"

@interface GalleryViewController : UIViewController<RequestWrapperDelegate,AlbumViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *titleView;
    NSMutableArray *btnImageViews;
    NSArray *picArray;
    Picture *selectedImage;
    DejalActivityView *loadingActivityIndicator;
    WebServices *searchImageRequest;
    BOOL isLoading;
    UILabel *lblNavigationImage;
    
}

//@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL hasAppeared;
- (void)pictureSelectedPUSH:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tblView;



@end
