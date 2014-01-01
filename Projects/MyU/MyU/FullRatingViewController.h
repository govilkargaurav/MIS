//
//  FullRatingViewController.h
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol fullRatingDelegate <NSObject>
-(void)removeRateNOW_With_rating_id:(NSInteger)ratingid;
@end

@interface FullRatingViewController : UIViewController
{
    
}
@property (nonatomic,strong) NSMutableDictionary *dictProfessor;
@property (nonatomic,assign) BOOL isNotificationRating;

@property (nonatomic,readwrite) NSInteger selectedratingindex;
@property (nonatomic,strong)id <fullRatingDelegate> _delegate;

@end
