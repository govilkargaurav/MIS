//
//  ImageViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface ImageViewController : UIViewController<UIScrollViewDelegate>
{
    UIView *titleView;
    IBOutlet UIScrollView *scrollView;
}
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) UIImage *image;
@property (assign, nonatomic) CameraViewController *parentController;
- (IBAction)share:(id)sender;
@end
