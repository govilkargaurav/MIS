//
//  DecodeAIVDM.h
//  AIS
//
//  Created by apple on 4/5/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitConvert.h"
#import "TLNMEASentenceDecoding.h"
@interface DecodeAIVDM : NSObject {

}
-(id)initWithAIVDM:(NSString*)string;
-(BOOL)checkSum:(NSString*)str lenght:(int)len;
-(NSString*)GetCheckSumForString:(NSString*)str;
@end
