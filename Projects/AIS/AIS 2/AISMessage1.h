//
//  AISMessage1.h
//  AIS
//
//  Created by apple on 3/3/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AISAppDelegate;
@interface AISMessage1 : NSObject {

	NSString *bitRepresentation;
	NSString *MessageID;
	NSString *MMSINumber;
	NSString *RateOfTurn;
	NSString *SpeedOverGround;
	NSString *Latitude;
	NSString *Longitude;
	NSString *CourseOverGround; 
	NSString *TrueHeading;
	NSString *UTCSeconds;
	
    AISAppDelegate *appDelegate;
	
	int flag;
	
}
@property(nonatomic,retain) NSString *MessageID;
@property(nonatomic,retain) NSString *bitRepresentation;
@property(nonatomic,retain) NSString *MMSINumber;
@property(nonatomic,retain) NSString *RateOfTurn;
@property(nonatomic,retain) NSString *SpeedOverGround;
@property(nonatomic,retain) NSString *Latitude;
@property(nonatomic,retain) NSString *Longitude;
@property(nonatomic,retain) NSString *CourseOverGround; 
@property(nonatomic,retain) NSString *TrueHeading;
@property(nonatomic,retain) NSString *UTCSeconds;

-(NSString*)bitsToIntegerString:(NSString*)str;
-(NSString*)bitsTo2Complement:(NSString*)str;
-(id)initWithBit:(NSString*)bitstr;
-(void)convertBitstrToAisMessage1;
-(void)convertBitstrToAisMessage5;

-(void)getMessageIDForShip;
-(void)getMMSINumber;
-(void)getRateOfTurnForShip;
-(void)getSpeedOverGroundForShip;

-(void)getLatitudeForShip;
-(void)getLongitudeForShip;

-(void)getCourseOverGroundForShip;
-(void)getTrueHeadingForShip;
-(void)getUTCSecondsForShip;



-(NSString *)toBinary:(NSUInteger)input;
-(void)hexadecimal_change:(NSString *)string;
@end
