//
//  EncodeTypeGSA.m
//  AIS
//
//  Created by apple on 6/16/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import "EncodeTypeGSA.h"

@implementation EncodeTypeGSA
@synthesize resultDic;
@synthesize numberOfSatelliteUse;
-(id)initWithsentence:(NSString*)string{
	self = [super init];
	if (self) {
		[self parseGSASentence:string];
	}
	return self;
}

-(void)parseGSASentence:(NSString*)string{

    NSArray *arr = [string componentsSeparatedByString:@","];
    if ([arr count] > 7) {
        NSString *st = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:0]];
        if ([st isEqualToString:@"$GPGGA"]) {
            
            self.numberOfSatelliteUse=[[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:7]];
            
        }
        [st release];
    }
    
    
}
@end
