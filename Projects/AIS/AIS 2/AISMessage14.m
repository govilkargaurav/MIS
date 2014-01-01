//
//  AISMessage14.m
//  AIS
//
//  Created by apple on 6/21/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import "AISMessage14.h"

@implementation AISMessage14
@synthesize bitRepresentation,MMSINumber,MessageID,RepeatId,SafetyMsg;

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
	
	NSString *returnStr = [[NSString alloc] initWithFormat:@"%@",[appDelegate.bit6dataAry BitKeyForTheValue:str]];
	return returnStr;
	
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


-(id)initWithBit:(NSString*)bitstr{
	self = [super init];
	if (self) {
		self.bitRepresentation = bitstr;
		[self convertBitstrToAisMessage14];
		
	}
	return self;
}
-(void)convertBitstrToAisMessage14{
    appDelegate = (AISAppDelegate *)[[UIApplication sharedApplication]delegate];

    if ([self.bitRepresentation length] >= 40){
        [self getMessageIDForShip];
        [self getMMSINumber];
        [self getRepeatIndicator];
        [self getSafetyMessage];
    }
    
//    NSLog(@"********#############Message14 Recives##########**********For MMSINum :: %@",self.MMSINumber);
    
    NSMutableDictionary *dic;
    if(![appDelegate.dicData valueForKey:self.MMSINumber]) {
        
        dic = [[NSMutableDictionary alloc] init];
        [dic setValue:self.MMSINumber forKey:@"MMSINum"];
        [dic setValue:self.RepeatId forKey:@"Repeat"];
        [dic setValue:self.SafetyMsg forKey:@"Message"];
       // [dic setValue:self.MessageID forKey:@"mid"];
    
    } 
    else
    {
        dic = [[NSMutableDictionary alloc] initWithDictionary:[appDelegate.dicData valueForKey:self.MMSINumber]];
        [dic setValue:self.MMSINumber forKey:@"MMSINum"];
        [dic setValue:self.RepeatId forKey:@"Repeat"];
        [dic setValue:self.SafetyMsg forKey:@"Message"];
        //[dic setValue:self.MessageID forKey:@"mid"];
    }
    
    [appDelegate.dicData setValue:dic forKey:self.MMSINumber];
    
    //    NSLog(@"%@",dic);
    if(![appDelegate.arryMMSI containsObject:self.MMSINumber])
        [appDelegate.arryMMSI addObject:self.MMSINumber];

    //    NSLog(@"$$$$$$ THIS SHIP %@ REQUIERD HELP $$$$$$",self.MMSINumber);
    BOOL isAlarm = [[NSUserDefaults standardUserDefaults] boolForKey:@"alarmflag"];
    if(isAlarm)
    [appDelegate showAlertForShip:self.MMSINumber withMessage:self.SafetyMsg];
    
    [dic release];
    dic = nil;

}

-(void)getMessageIDForShip{
	
	NSString *mid = [self.bitRepresentation substringWithRange:NSMakeRange(0, 6)];
	//conv string to full bit
	NSString *st =  [self bitsToIntegerString:mid];
	self.MessageID = [[NSString alloc] initWithString:st];
	
}
-(void)getRepeatIndicator{
	NSString *repeat = [self.bitRepresentation substringWithRange:NSMakeRange(6, 2)];
	//conv string to full bit 
	NSString *st =  [self bitsToIntegerString:repeat];
	self.RepeatId = [[NSString alloc] initWithString:st];

}
-(void)getMMSINumber{
	
	NSString *mmsi = [self.bitRepresentation substringWithRange:NSMakeRange(8, 30)];
	//conv string to full bit 
	NSString *st =  [self bitsToIntegerString:mmsi];
	self.MMSINumber = [[NSString alloc] initWithString:st];
    
}
-(void)getSafetyMessage{
	NSString *safety = [self.bitRepresentation substringWithRange:NSMakeRange(40, 96)];
/*	//conv string to full bit 
	NSString *st =  [self bitsToIntegerString:safety];

	self.SafetyMsg = [[NSString alloc] initWithString:st];
    */
    NSMutableString *name=[[NSMutableString alloc] init]; 
	int strt;
	strt = 0;
	for (int i=0; i <16 ;i++) {
		NSString *nameBit = [safety substringWithRange:NSMakeRange(strt, 6)];
 
		[name appendFormat:@"%@",[self bitsToCharString:nameBit]];		
		strt = strt+6;		
	}
    
	[name replaceOccurrencesOfString:@"@" withString:@"" options:0 range:NSMakeRange(0, [name length])];
	self.SafetyMsg = [[NSString alloc] initWithString:name];
	[name release];

    
}
@end
