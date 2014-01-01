//
//  PhotoReviewViewController.h
//  MyU
//
//  Created by Vijay on 8/10/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewEvent.h"

@interface PhotoReviewViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIScrollViewEvent *scrollphoto;
    __block UIImageView *imgView;
}

@property (nonatomic,strong)UIImage *imgPreview;

@end
