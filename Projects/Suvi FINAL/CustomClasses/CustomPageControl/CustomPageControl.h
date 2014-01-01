//
//  CustomPageControl.h
//  Suvi
//
//  Created by Dhaval Vaishnani on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@property(nonatomic, retain) UIImage* activeImage;
@property(nonatomic, retain) UIImage* inactiveImage;
@end
