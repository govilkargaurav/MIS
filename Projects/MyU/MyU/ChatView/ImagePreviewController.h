//
//  ImageZoomViewController.h
//  OBVENT
//
//  Created by W@rrior on 18/03/13.
//  Copyright (c) 2013 W@rrior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewEvent.h"


@interface ImagePreviewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIScrollViewEvent *scrollphoto;
    __block UIImageView *imgView;
    IBOutlet UIButton *btnDone;
    BOOL shouldLoadImage;
    IBOutlet UIActivityIndicatorView *actIndCenter;
}

@property (nonatomic,strong)NSString *strURL;
@property (nonatomic,strong)UIImage *imgPreview;

@end
