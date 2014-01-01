//
//  CustomMapCalloutView.h
//  HuntingApp
//
//  Created by Habib Ali on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomTextField3.h"

@protocol CustomMapCalloutViewDelegate <NSObject>

- (void)areaNameDidEntered:(NSString *)areaName;

@end

@interface CustomMapCalloutView : MKAnnotationView<UITextFieldDelegate>

@property (nonatomic,retain) CustomTextField3 *areaName;
@property (nonatomic, retain) UILabel *lblState;
@property (nonatomic,retain) UIImageView *pinDown;
@property (nonatomic,assign) id<CustomMapCalloutViewDelegate> delegate;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *area;
@end
