//
//  NSMutableArray+convert.m
//  AIS
//
//  Created by apple on 4/4/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import "NSMutableArray+convert.h"


@implementation NSMutableArray (convert)

-(NSString*)BitValueForTheKey:(NSString*)key{
	NSString *returnValue;
		
	for (int i=0; i < [self count]; i++) {
		NSDictionary *dic = [self objectAtIndex:i];
		NSString *st = [NSString stringWithFormat:@"%@",[dic valueForKey:@"key"]];
		if ([st isEqualToString:key]) {
			returnValue =[[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"value"]];
			break;
		}
	}
	return returnValue;
}

-(NSString*)BitKeyForTheValue:(NSString*)key{
	NSString *returnValue;
	for (int i=0; i < [self count]; i++) {
		NSDictionary *dic = [self objectAtIndex:i];
		NSString *st = [NSString stringWithFormat:@"%@",[dic valueForKey:@"value"]];
		if ([st isEqualToString:key]) {
			returnValue =[[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"key"]];
			break;
		}
	}
	return returnValue;
}

@end
