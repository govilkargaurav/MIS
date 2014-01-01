//
//  MyAnnotation.h
//  FitTag
//
//  Created by apple on 3/15/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>{

	CLLocationCoordinate2D	coordinate;
    NSString*	title;
    NSString*	subtitle;
    int annonationIndex;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)	NSString*	title;
@property (nonatomic, copy)	NSString*	subtitle;
@property(nonatomic)int annonationIndex;
@end


