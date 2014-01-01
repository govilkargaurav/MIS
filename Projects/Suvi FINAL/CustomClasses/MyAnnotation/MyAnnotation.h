//
//  MyAnnotation.h
//  FuelEye
//
//  Created by Dhaval on 4/4/13.
//  Copyright (c) 2013 i-phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface MyAnnotation : NSObject<MKAnnotation>
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,readwrite)int pinTag;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@end
