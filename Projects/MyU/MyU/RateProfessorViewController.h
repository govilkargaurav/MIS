//
//  RateProfessorViewController.h
//  MyU
//
//  Created by Vijay on 7/17/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol rateProfessiorDelegate <NSObject>
-(void)ReloadNotiFicationData;
@end

@interface RateProfessorViewController : UIViewController
{
    
}

@property (nonatomic,strong) NSMutableDictionary *dictProfessor;
@property (nonatomic,assign) BOOL isNotificationRating;

@property (nonatomic,readwrite) NSInteger selectedratingindex;
@property (nonatomic,strong)id <rateProfessiorDelegate> _delegate;
@end
