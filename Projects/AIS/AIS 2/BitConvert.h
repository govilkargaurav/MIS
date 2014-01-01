//
//  BitConvert.h
//  AIS
//
//  Created by apple on 3/3/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AISMessage1.h"
#import "AISMessage5.h"
#import "AISMessage14.h"
#import "NSMutableArray+convert.h"
#import "AISAppDelegate.h"
@interface BitConvert : NSObject {

	NSDictionary *data;
	NSMutableArray *dataAry;
    AISAppDelegate *appDel;
}
@property(nonatomic,retain) NSDictionary *data;
-(void)getInitialize;
-(id)initWithStringData:(NSString*)strdata;
-(NSString*)bitsToIntegerString:(NSString*)str;
@end
