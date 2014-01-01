//
//  JSONParsingAsync.h
//  LawyerApp
//
//  Created by ChintaN on 7/9/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParsingAsync : NSObject
@property (strong, nonatomic)NSURLRequest *request;
+ (id)sharedManager;
-(id)getserviceResponse:(NSString *)StrURL;
@end
