//
//  JSONParsingAsync.m
//  LawyerApp
//
//  Created by ChintaN on 7/9/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "JSONParsingAsync.h"

static JSONParsingAsync *sharedMyManager = nil;

@implementation JSONParsingAsync
@synthesize request;


+ (id)sharedManager {
    
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
    
}
//criminal law
-(id)getserviceResponse:(NSString *)StrURL{
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[StrURL stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]]];
    NSError *jsonError = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&jsonError];
    if ([response length]==0) {
        
        return @"";
    }
    if (jsonError) {

        return @"";
    }
    id jsonObject = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&jsonError];
    
    if (jsonError) {
        
        return @"";
        
    }
    return jsonObject;

}



@end
