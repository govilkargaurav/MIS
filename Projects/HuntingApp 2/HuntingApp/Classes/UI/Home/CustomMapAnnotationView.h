//
//  CustomMapAnnotationView.h
//  HuntingApp
//
//  Created by Habib Ali on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FLImageView.h"

@interface CustomMapAnnotationView : MKAnnotationView<FLImageViewDelegate>

@property (retain, nonatomic) FLImageView *imgView;
@property (retain, nonatomic) UILabel *lblName;
@property (retain, nonatomic) NSString *latllongStr;
@property (retain, nonatomic) UIButton *btnThumbnail;
@property (retain, nonatomic) UIImageView *popOverArrowDownImage;
@property (retain, nonatomic) UIImageView *balloonImage;

@end
