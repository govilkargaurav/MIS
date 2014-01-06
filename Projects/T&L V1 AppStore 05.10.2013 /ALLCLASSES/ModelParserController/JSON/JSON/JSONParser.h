//
//  JSONParser.h
//  TestWebService
//
//  Created by apple on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"


@interface JSONParser : NSObject {

	NSURLConnection *con;
	NSMutableData *myWebData;
	NSObject *MainHandler;
	SEL targetSelector;
	NSMutableURLRequest *rq;
    BOOL InternetAccessibility;
}
@property (nonatomic,strong)NSObject *MainHandler;
@property (nonatomic)SEL targetSelector;
@property (nonatomic,strong) NSMutableURLRequest *rq;
-(id)initWithRequestForThread:(NSMutableURLRequest*)url sel:(SEL)seletor andHandler:(NSObject*)handler;

@end
