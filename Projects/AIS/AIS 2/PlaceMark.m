//
//  PlaceMark.m
//  iTransitBuddy
//
//  Created by Blue Technology Solutions LLC 09/09/2008.
//  Copyright 2010 Blue Technology Solutions LLC. All rights reserved.
//

#import "PlaceMark.h"


@implementation PlaceMark

@synthesize coordinate;
@synthesize place;
@synthesize tag;
-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
		
	}
	return self;
}

- (NSString *)subtitle
{
	return nil;
}
- (NSString *)title
{
	return self.place.name;
}

- (void) dealloc
{
//	[place release];
	[super dealloc];
}


@end
