//
//  NSMutableArray+convert.h
//  AIS
//
//  Created by apple on 4/4/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (convert) 
-(NSString*)BitValueForTheKey:(NSString*)key;
-(NSString*)BitKeyForTheValue:(NSString*)key;
@end
