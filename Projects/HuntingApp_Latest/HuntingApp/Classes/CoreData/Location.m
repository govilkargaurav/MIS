//
//  Location.m
//  HuntingApp
//
//  Created by Habib Ali on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "Profile.h"


@implementation Location

@dynamic city;
@dynamic country;
@dynamic county;
@dynamic latitude;
@dynamic loc_id;
@dynamic longitude;
@dynamic state;
@dynamic user_favourite_locations;
@dynamic type;

- (NSString *)description
{
    if (self.state && self.county)
    {
        NSString *stateCode = [Utility getStateAbbreviationForState:self.state];
        if (!stateCode)
            stateCode = self.state;
        return [NSString stringWithFormat:@"%@;%@",self.county,stateCode];
    }
    else {
        return nil;
    }
}


@end
