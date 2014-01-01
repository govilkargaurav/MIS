//
//  AISMessage14.h
//  AIS
//
//  Created by apple on 6/21/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AISAppDelegate.h"
@interface AISMessage14 : NSObject{

    AISAppDelegate *appDelegate;
    NSString *bitRepresentation;
	NSString *MessageID;
	NSString *RepeatId;
    NSString *MMSINumber;
    NSString *SafetyMsg;
    int flag;

}
@property(nonatomic,retain) NSString *bitRepresentation;
@property(nonatomic,retain) NSString *MessageID;
@property(nonatomic,retain) NSString *MMSINumber;
@property(nonatomic,retain) NSString *RepeatId;
@property(nonatomic,retain) NSString *SafetyMsg;

-(void)convertBitstrToAisMessage14;
-(NSString*)bitsToCharString:(NSString*)str;
-(NSString*)bitsTo2Complement:(NSString*)str;
-(id)initWithBit:(NSString*)bitstr;
-(void)getRepeatIndicator;
-(void)getMessageIDForShip;
-(void)getMMSINumber;
-(void)getSafetyMessage;

@end
