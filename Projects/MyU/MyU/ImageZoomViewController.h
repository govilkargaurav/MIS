//
//  ImageZoomViewController.h
//  OBVENT
//
//  Created by W@rrior on 18/03/13.
//  Copyright (c) 2013 W@rrior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewEvent.h"

typedef enum
{
    PhotoTypeNone,
    PhotoTypeBlog,
    PhotoTypeNews,
    PhotoTypeProfilePosts,
    PhotoTypeNotification,
    PhotoTypeProfilePic
}
PhotoType;

@interface ImageZoomViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIScrollViewEvent *Scl_Photo;
    __block UIImageView *imgView;
    IBOutlet UIButton *btnDone,*btnLike;
    IBOutlet UILabel *lblLikeCount;
    
    BOOL LoadImage;
    IBOutlet UIView *bottomView;
    
    IBOutlet UIActivityIndicatorView *ActivityPhoto;
    CGFloat _keyboardHeight;
}

@property (nonatomic,strong)NSString *strURL;
@property (nonatomic,readwrite) NSInteger selectedindex;
@property (nonatomic,readwrite) PhotoType phototype;

@end
