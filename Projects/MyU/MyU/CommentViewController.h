//
//  CommentViewController.h
//  MyU
//
//  Created by Vijay on 7/12/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CommentTypeNone,
    CommentTypeBlog,
    CommentTypeNews,
    CommentTypeProfileNews,
    CommentTypeNotification
}
CommentType;

@interface CommentViewController : UIViewController
{
    
}

@property (nonatomic,readwrite) CommentType commenttype;
@property (nonatomic,readwrite) NSInteger selectedindex;

@end

