//
//  AISMessage1.m
//  AIS
//
//  Created by apple on 3/3/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "AISMessage1.h"
#import "AISAppDelegate.h"

@implementation AISMessage1
@synthesize bitRepresentation,MMSINumber,RateOfTurn,SpeedOverGround,Latitude,Longitude,CourseOverGround,TrueHeading,UTCSeconds,MessageID;


-(NSString*)bitsToIntegerString:(NSString*)str{
	
	int no;
	no=0;
    appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
	
	
	int first = [[str substringWithRange:NSMakeRange(0, 1)] intValue];
	
	if (flag == 1) {
		//flag == 0	
		if (first==0) {
			for (int i=[str length]; i > 0; i--) {
				BOOL bl = ([[str substringWithRange:NSMakeRange(i-1, 1)] intValue]);
				double db = pow(2, (double)([str length]-i));
				no = no+(bl*db);
			}
		}else {
			NSString *st = [[NSString alloc] initWithFormat:@"%@",[self bitsTo2Complement:str]];;
			no=-[st intValue];
            [st release];
		}
	
	}else {
		//flag == 0
		for (int i=[str length]; i > 0; i--) {
			BOOL bl = ([[str substringWithRange:NSMakeRange(i-1, 1)] intValue]);
			double db = pow(2, (double)([str length]-i));
			no = no+(bl*db);
		}			
	}
	return [NSString stringWithFormat:@"%d",no];
}

-(id)initWithBit:(NSString*)bitstr{
	self = [super init];
	if (self) {
		self.bitRepresentation = bitstr;
		[self convertBitstrToAisMessage1];
		
	}
	return self;
}
-(NSString*)bitsTo2Complement:(NSString*)str{
	
	int no;
	no=0;

    appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];
	for (int i=[str length]; i > 0; i--) {
		BOOL bl = ([[str substringWithRange:NSMakeRange(i-1, 1)] intValue]);
		bl = !(bl);

		double db = pow(2, (double)([str length]-i));
		no = no+(bl*db);
	}	
	no=no+1;
	return [NSString stringWithFormat:@"%d",no];
}

-(void)convertBitstrToAisMessage1{		
	
	if ([self.bitRepresentation length] >= 168) {
		flag=0;
		[self getMessageIDForShip];
		[self getMMSINumber];
		[self getRateOfTurnForShip];
		[self getSpeedOverGroundForShip];
		flag=1;
		[self getLatitudeForShip];
		[self getLongitudeForShip];
		flag=0;
		[self getCourseOverGroundForShip];
		[self getTrueHeadingForShip];
		[self getUTCSecondsForShip];
		
		//     NSLog(@"message 1");
        NSMutableDictionary *dic;
        
        if(![appDelegate.dicData valueForKey:self.MMSINumber]) {
			
            dic = [[NSMutableDictionary alloc] init];
            
            [dic setValue:self.MMSINumber forKey:@"MMSINum"];
            [dic setValue:self.RateOfTurn forKey:@"RateOfTurn"];
            [dic setValue:self.SpeedOverGround forKey:@"SOG"];
            [dic setValue:self.TrueHeading forKey:@"TrueHeading"];
            [dic setValue:self.UTCSeconds forKey:@"UTCSecond"];			
            [dic setValue:[NSDate date] forKey:@"date"];
			//if ([self.Latitude intValue] != 0) {
				[dic setValue:self.Latitude forKey:@"Latitude"];				
			//}
			//if ([self.Longitude intValue] != 0) {
				[dic setValue:self.Longitude forKey:@"Longitude"];
			//}
            [dic setValue:self.CourseOverGround forKey:@"COG"];
                       
        } 
        else
        {
            dic = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.dicData valueForKey:self.MMSINumber]];
            
         //   NSLog(@"update dictionary %@",dic);
            [dic setValue:self.Latitude forKey:@"Latitude"];				
            [dic setValue:self.Longitude forKey:@"Longitude"];
            [dic setValue:self.UTCSeconds forKey:@"UTCSecond"];		
            
             
 
           // [dic setValue:[dateFormat stringFromDate:[NSDate date]] forKey:@"date"];
            [dic setValue:[NSDate date] forKey:@"date"];
            [dic setValue:self.RateOfTurn forKey:@"RateOfTurn"];
            [dic setValue:self.SpeedOverGround forKey:@"SOG"];
            [dic setValue:self.TrueHeading forKey:@"TrueHeading"];
            [dic setValue:self.CourseOverGround forKey:@"COG"];
            
            
       
          //  NSLog(@"update dictionary %@",dic);
        }
        
		                                                                                             
		if (([self.Latitude intValue] < 91) && ([self.Longitude intValue] < 181)) {
			[appDelegate.dicData setValue:dic forKey:self.MMSINumber];			
		
        
        if(![appDelegate.arryMMSI containsObject:self.MMSINumber])
            [appDelegate.arryMMSI addObject:self.MMSINumber];
		}
        [dic release];
        dic = nil;
        
        //insert
		//NSLog(@"%@ %@ %@ %@ %@ %@ %@",self.MMSINumber,self.RateOfTurn,self.SpeedOverGround,self.TrueHeading,self.UTCSeconds,self.Latitude,self.Longitude);
		
	}
	
	//[self hexadecimal_change:@"A"];
}

-(void)getMessageIDForShip{
	
	NSString *mid = [self.bitRepresentation substringWithRange:NSMakeRange(0, 6)];
	//conv string to full bit
	NSString *st =  [self bitsToIntegerString:mid];
	self.MessageID = [[NSString alloc] initWithString:st];
	
}


-(void)getMMSINumber{
	
	NSString *mmsi = [self.bitRepresentation substringWithRange:NSMakeRange(8, 30)];
 //   NSLog(@"%@",mmsi);
	//conv string to full bit 
	NSString *st =  [self bitsToIntegerString:mmsi];
	self.MMSINumber = [[NSString alloc] initWithString:st];

	
}
-(void)getRateOfTurnForShip{
	
	NSString *rot = [self.bitRepresentation substringWithRange:NSMakeRange(42, 8)]; 
	NSString *st =  [self bitsToIntegerString:rot];
	self.RateOfTurn = [[NSString alloc] initWithString:st];
	
}

-(void)getSpeedOverGroundForShip{
	
	NSString *sog = [self.bitRepresentation substringWithRange:NSMakeRange(50, 10)]; 
	NSString *st =  [self bitsToIntegerString:sog];
	
	if ((float)([st floatValue]/10) < 102.2) {
		self.SpeedOverGround = [[NSString alloc] initWithFormat:@"%.2f",(float)([st floatValue]/10)];
	}
}
-(void)getLatitudeForShip{
	NSString *lt = [self.bitRepresentation substringWithRange:NSMakeRange(89, 27)]; 
	NSString *st =  [self bitsToIntegerString:lt];
	
	float tmp1 = (float)[st floatValue]/10000.0;
	float degree = tmp1*(0.0166666667);
	
	if (degree != 91) {
        self.Latitude = [[NSString alloc] initWithFormat:@"%f",([st floatValue]/10000.0)*(0.0166666667)];		
	}else {
		self.Latitude = [[NSString alloc] initWithString:@"91"];
	}

                                                                                                                           
}
-(void)getLongitudeForShip{
	NSString *ln = [self.bitRepresentation substringWithRange:NSMakeRange(61, 28)];
	NSString *st =  [self bitsToIntegerString:ln];	
		
	float tmp1 = (float)[st floatValue]/10000.0;
	float degree = tmp1*(0.0166666667);
	
	if (degree != 181) {
        self.Longitude = [[NSString alloc] initWithFormat:@"%f",([st floatValue]/10000.0)*(0.0166666667)];
	}else {
		self.Latitude = [[NSString alloc] initWithString:@"181"];	
	}

}
-(void)getCourseOverGroundForShip{
	NSString *cog = [self.bitRepresentation substringWithRange:NSMakeRange(116, 12)]; 
	NSString *st =  [self bitsToIntegerString:cog];
	
	if ((float)([st floatValue]/10)  < 360) {
		self.CourseOverGround = [[NSString alloc] initWithFormat:@"%.2f",(float)([st floatValue]/10)];		
	}
	
}
-(void)getTrueHeadingForShip{
	NSString *th = [self.bitRepresentation substringWithRange:NSMakeRange(128, 9)]; 
	NSString *st =  [self bitsToIntegerString:th];
    
    if ((int)([st intValue])  < 360) {    
        self.TrueHeading = [[NSString alloc] initWithString:st];	
    }
			
}
-(void)getUTCSecondsForShip{
	NSString *utc = [self.bitRepresentation substringWithRange:NSMakeRange(137, 6)]; 
	NSString *st =  [self bitsToIntegerString:utc];
	//NSLog(@"UTC %@",st);
	if ([st intValue]<60) {
		self.UTCSeconds = [[NSString alloc] initWithString:st];		
	}	
}


-(void)hexadecimal_change:(NSString *)string{
	
	
	NSString *hex = string;
	NSUInteger hexAsInt;
	[[NSScanner scannerWithString:hex] scanHexInt:&hexAsInt];
	NSString *binary = [NSString stringWithFormat:@"%@",[self toBinary:hexAsInt]];
	
	
	long v = strtol([binary UTF8String], NULL, 2);
	NSString *dec=[NSString stringWithFormat:@"%ld",v];
	
	
}



-(NSString *)toBinary:(NSUInteger)input{
    if (input == 1 || input == 0)
        return [NSString stringWithFormat:@"%u", input];
    return [NSString stringWithFormat:@"%@%u", [self toBinary:input / 2], input % 2];
}


@end
