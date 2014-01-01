//
//  DisplayMap.h
//  MapKitDisplay
//
//  Created by apple on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface DisplayMap : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
    NSUInteger Tag;

}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite) NSUInteger Tag;

@end

