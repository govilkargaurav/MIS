//
//  TredingViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"


@interface TredingViewController : UIViewController<FirstScreenModelViewDelegate>
{
    UIView *titleView;
}

- (IBAction)showGallery:(id)sender;
- (void) createAlbums;
@end
