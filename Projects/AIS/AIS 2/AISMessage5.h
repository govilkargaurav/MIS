//
//  AISMessage5.h
//  AIS
//
//  Created by apple on 3/9/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+convert.h"
#import "AISAppDelegate.h"
@interface AISMessage5 : NSObject {

	NSString *bitRepresentation;
	NSDictionary *bit6data;
	NSMutableArray *bit6dataAry;
    NSMutableDictionary *shipTypes;

	NSString *MMSINumber;
	NSString *NameOfTheShip;
	NSString *TypeOfShip;
	NSString *CallSign;
	NSString *Destination;
	AISAppDelegate *appDelegate;
}

@property(nonatomic,retain) NSString *bitRepresentation;
@property(nonatomic,retain) NSString *MMSINumber;
@property(nonatomic,retain) NSString *NameOfTheShip;
@property(nonatomic,retain) NSString *TypeOfShip;
@property(nonatomic,retain) NSString *CallSign;
@property(nonatomic,retain) NSString *Destination;

-(id)initWithBit:(NSString*)bitstr;
-(void)convertBitstrToAisMessage5;
-(void)getMMSINumber;
-(void)getNameForShip;
-(void)getTypeOfShip;
-(void)getCallSignForShip;
-(void)getDestinationForShip;
@end
