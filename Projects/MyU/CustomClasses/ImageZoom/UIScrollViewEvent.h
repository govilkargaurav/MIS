//
//  UIScrollViewEvent.h
//  PhotoTest
//
//  Created by Yoo-Jin Lee on 28/11/12.
//  Copyright (c) 2012 Mokten Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIScrollViewEvent : UIScrollView {
    UIImageView * imgView;
}

@property (nonatomic,retain)    UIView * imgView;

@end
