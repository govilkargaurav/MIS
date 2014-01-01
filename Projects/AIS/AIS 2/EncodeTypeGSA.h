//
//  EncodeTypeGSA.h
//  AIS
//
//  Created by apple on 6/16/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeTypeGSA : NSObject{

    NSMutableDictionary *resultDic;
    NSString *numberOfSatelliteUse;
}
@property(nonatomic,retain)   NSString *numberOfSatelliteUse;

@property(nonatomic,retain)    NSMutableDictionary *resultDic;
-(id)initWithsentence:(NSString*)string;
-(void)parseGSASentence:(NSString*)string;

@end
