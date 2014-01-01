//
//  JSONParser.h
//  DemoNotification
//
//  Created by Dhaval on 3/5/13.
//  Copyright (c) 2013 i-phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject<NSURLConnectionDelegate>
{
    SEL successSelector;
    SEL failureSelector;
    NSObject *callBackObject;
    NSURLConnection *connection;
    BOOL shouldSendRespond;
    NSMutableURLRequest *postRequest;
}

@property(nonatomic,strong) NSMutableData *webData;

-(id)initWithURL:(NSString *)strURL withParam:(NSDictionary *)params isTypePOST:(BOOL)isTypePOST andPostData:(NSData *)postData withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject shouldRespond:(BOOL)shouldRespond isDataTypeVideo:(BOOL)isDataTypeVideo;
-(void)startRequest;

@end
