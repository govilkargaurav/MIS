//
//  GetCountyListModel.h
//  PropertyInspector
//
//  Created by apple on 10/18/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetCountyListModel : NSObject

extern NSString *countyId;
extern NSString *county_name;
extern NSString *address;
extern NSString *city;
extern NSString *state;
extern NSString *zip;
extern NSString *lat;
extern NSString *longitute;



extern NSMutableArray *countyIdArr;
extern NSMutableArray *county_nameArr;
extern NSMutableArray *addressArr;
extern NSMutableArray *cityArr;
extern NSMutableArray *stateArr;
extern NSMutableArray *zipArr;
extern NSMutableArray *latArr;
extern NSMutableArray *longituteArr;


@end
