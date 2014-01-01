//
//  AISMessage5.m
//  AIS
//
//  Created by apple on 3/9/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "AISMessage5.h"


@implementation AISMessage5
@synthesize bitRepresentation,MMSINumber,NameOfTheShip,TypeOfShip,CallSign,Destination;

-(NSString*)bitsToIntegerString:(NSString*)str{
	
	int no;
	no=0;
	
	for (int i=[str length]; i > 0; i--) {
		BOOL bl = ([[str substringWithRange:NSMakeRange(i-1, 1)] intValue]);
		double db = pow(2, (double)([str length]-i));
		no = no+(bl*db);
	}
	return [NSString stringWithFormat:@"%d",no];
	
}
-(NSString*)bitsToCharString:(NSString*)str{
	
	/*
	NSArray *allkeys = [bit6data allKeys];
	NSArray *allvalues = [bit6data allValues];
	
	int n=0;
	
	for (int i=0; i<[allvalues count]; i++) {
		NSString *value = [NSString stringWithFormat:@"%@",[allvalues objectAtIndex:i]];
		n=i;
		if (value == str) {
			break;
		}				
	}
		*/
	NSString *returnStr = [[NSString alloc] initWithFormat:@"%@",[appDelegate.bit6dataAry BitKeyForTheValue:str]];
	return returnStr;
	
}
-(id)initWithBit:(NSString*)bitstr{
	self = [super init];
	if (self) {
		
		
		appDelegate = (AISAppDelegate*)[[UIApplication sharedApplication] delegate];
	/*	NSString *path =  [[NSBundle	mainBundle] pathForResource:@"bit6data" ofType:@"plist"];
		bit6dataAry = (NSMutableArray*)[[NSArray alloc] initWithContentsOfFile:path];
		
        //ship type
      
        NSString *path1 =  [[NSBundle	mainBundle] pathForResource:@"ShipType" ofType:@"plist"];
        shipTypes = (NSMutableDictionary*)[[NSMutableDictionary alloc] initWithContentsOfFile:path1];*/

       // NSLog(@"shipTypes %@",[[shipTypes valueForKey:@"ShipTypes"] valueForKey:@"33"]);
		self.bitRepresentation = bitstr;
		[self convertBitstrToAisMessage5];
		
	}
	return self;
}

-(void)convertBitstrToAisMessage5{
	
	if ([self.bitRepresentation length] >= 426) {
		[self getMMSINumber];
		[self getNameForShip];
		[self getTypeOfShip];
		[self getCallSignForShip];
		[self getDestinationForShip];
		
        NSLog(@"message 5");
        
        for(int i = 0 ; i < [appDelegate.arryMMSI count]; i++) {
			
			//            NSLog(@"Current MMSI :: %@",self.MMSINumber);
			//            NSLog(@"Array`s MMSI No :: %@",[appDelegate.arryMMSI objectAtIndex:i]);
            
            if([[appDelegate.arryMMSI objectAtIndex:i] isEqualToString:self.MMSINumber])  {    
				
                NSLog(@"Compared MMSI");
                
				NSDictionary *dic = [appDelegate.dicData valueForKey:self.MMSINumber];
				
				[dic setValue:self.NameOfTheShip forKey:@"ShipName"];
				[dic setValue:self.Destination forKey:@"Destination"];
				[dic setValue:self.TypeOfShip forKey:@"TypeOfShip"];
				[dic setValue:self.CallSign forKey:@"CallSign"];
                [dic setValue:[NSDate date] forKey:@"date"];
                
				[appDelegate.dicData setValue:dic forKey:self.MMSINumber];

            }
        }
       		

        //NSLog(@"Array Count :: %d Dic Count :: %d",[appDelegate.arryMMSI count],[appDelegate.dicData count]);
        
		//NSLog(@"%@ %@ %@ %@",self.MMSINumber,self.NameOfTheShip,self.TypeOfShip,self.Destination,self.CallSign);
	}
}
-(void)getMMSINumber{
	
	NSString *mmsi = [self.bitRepresentation substringWithRange:NSMakeRange(8, 30)];
	//conv string to full bit 
	NSString *st =  [self bitsToIntegerString:mmsi];
	self.MMSINumber = [[NSString alloc] initWithString:st];
	
}
-(void)getNameForShip{

	NSString *mmsi = [self.bitRepresentation substringWithRange:NSMakeRange(112, 120)];
	//conv string to full bit 
	NSMutableString *name=[[NSMutableString alloc] init]; 
	int strt;
	strt = 0;
	for (int i=0; i <20 ;i++) {
		NSString *nameBit = [mmsi substringWithRange:NSMakeRange(strt, 6)];
		[name appendFormat:@"%@",[self bitsToCharString:nameBit]];		
		strt = strt+6;		
	}

	[name replaceOccurrencesOfString:@"@" withString:@"" options:0 range:NSMakeRange(0, [name length])];
	self.NameOfTheShip = [[NSString alloc] initWithString:name];
	[name release];

}
-(void)getTypeOfShip{
	
	NSString *type = [self.bitRepresentation substringWithRange:NSMakeRange(232, 8)];
	NSString *st =  [self bitsToIntegerString:type];
	int typevalue = [st intValue];
	NSString *sttmp;
	/*if (typevalue == 0 ) {
		sttmp=@"Not available";
	}else if((typevalue>0) && (typevalue<100)){
		sttmp=@"Not available";
	}else if((typevalue>=100) && (typevalue<200)){
		sttmp=@"reserved for regional Use";
	}else if((typevalue>=200) && (typevalue<256)){
		sttmp=@"reserved for future Use";
	}*/
    
    NSLog(@"type before %d",typevalue);
    if ((0 < typevalue) && (typevalue <20)) {
        typevalue=0;
    }
    if ((19 < typevalue) && (typevalue <30)) {
        typevalue=20;
    }
    if (typevalue == 39) {
        typevalue=38;
    }
    if ((39 < typevalue)&&(typevalue <50)) {
        typevalue=40;
    }
    if (typevalue == 57) {
        typevalue=56;
    }
    if ((59 < typevalue) && (typevalue <70)) {
        typevalue=60;
    }
    if ((70 < typevalue)&&(typevalue <75)) {
        typevalue=71;
    } 
    if ((74 < typevalue) && (typevalue <80)) {
        typevalue=75;
    }
    if ((80 < typevalue)&&(typevalue <85)) {
        typevalue=81;
    }
    if ((84 < typevalue) && (typevalue <90)) {
        typevalue=85;
    }
    if (typevalue > 89) {
        typevalue=90;
    }

        NSLog(@"type after %d",typevalue);
    
    NSString *key=[NSString stringWithFormat:@"%d",typevalue];
    sttmp=[[NSString alloc] initWithFormat:@"%@",[[appDelegate.shipTypes valueForKey:@"ShipTypes"] valueForKey:key]];
    
	self.TypeOfShip = [[NSString alloc] initWithString:sttmp];
    [sttmp release];
		
}
-(void)getCallSignForShip{
	
	NSString *cs = [self.bitRepresentation substringWithRange:NSMakeRange(70, 42)];
	
	//conv string to full bit 
	NSMutableString *callsign=[[NSMutableString alloc] init];
	int strt;
	strt = 0;
	for (int i=0; i <7 ;i++) {
		NSString *csbit = [cs substringWithRange:NSMakeRange(strt, 6)];
		[callsign appendFormat:@"%@",[self bitsToCharString:csbit]];
		strt = strt+6;		
	}
	[callsign replaceOccurrencesOfString:@"@" withString:@"" options:0 range:NSMakeRange(0, [callsign length])];

	self.CallSign = [[NSString alloc] initWithString:callsign];
	[callsign release];
}

-(void)getDestinationForShip{
		
	NSString *ds = [self.bitRepresentation substringWithRange:NSMakeRange(302, 120)];
	//conv string to full bit
	NSMutableString *desti=[[NSMutableString alloc] init];
	int strt;
	strt = 0;
	for (int i=0; i <20 ;i++) {
		
		NSString *dsbit = [ds substringWithRange:NSMakeRange(strt, 6)];
		[desti appendFormat:@"%@",[self bitsToCharString:dsbit]];
		strt = strt+6;		
	}

	[desti replaceOccurrencesOfString:@"@" withString:@"" options:0 range:NSMakeRange(0, [desti length])];
	self.Destination = [[NSString alloc] initWithString:desti];
	[desti release];
}

@end
