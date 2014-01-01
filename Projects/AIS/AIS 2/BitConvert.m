//
//  BitConvert.m
//  AIS
//
//  Created by apple on 3/3/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "BitConvert.h"
#import "parseCSV.h"

@implementation BitConvert
@synthesize data;
-(void)getInitialize{
	dataAry = [[NSMutableArray alloc] init];	
	NSString *path =  [[NSBundle	mainBundle] pathForResource:@"myData" ofType:@"plist"];
	dataAry  = (NSMutableArray*)[[NSArray alloc] initWithContentsOfFile:path];
}

-(id)initWithStringData:(NSString*)strdata{
	self = [super init];
	if (self) {
		
       // strdata=@"1>MA2GOP000jHb@LBhAtsOwt1P00";
      //  [self getInitialize];
        appDel = (AISAppDelegate*)[[UIApplication sharedApplication] delegate];
		NSMutableString *bits = [[NSMutableString alloc] init];
		for (int i=0; i<[strdata length]; i++) {
			[bits appendFormat:@"%@",[appDel.dataAry BitValueForTheKey:[strdata substringWithRange:NSMakeRange(i, 1)]]];
		}
		
		if ([bits length] >= 6) {
			NSString *mid = [bits substringWithRange:NSMakeRange(0, 6)];

			//conv string to full bit 
			NSString *st =  [self bitsToIntegerString:mid];
			NSString *msgID = [[NSString alloc] initWithString:st];

			if ([msgID intValue] == 5) {
				AISMessage5 *msg;
				msg= [[AISMessage5 alloc] initWithBit:bits];
                [msg release];
			}else if(([msgID intValue] == 1) ||  ([msgID intValue] == 2) || ([msgID intValue] == 3)){
				AISMessage1 *msg;
				msg= [[AISMessage1 alloc] initWithBit:bits];
				[msg release];
			}else if([msgID intValue] == 14){
                AISMessage14 *msg;
				msg= [[AISMessage14 alloc] initWithBit:bits];
                [msg release];

            }
            [msgID release];
		
		}
        [bits release];
		
	}
	return self;
}

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
@end
