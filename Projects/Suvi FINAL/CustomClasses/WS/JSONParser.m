//
//  JSONParser.m
//  DemoNotification
//
//  Created by Dhaval on 3/5/13.
//  Copyright (c) 2013 i-phone. All rights reserved.
//

#import "JSONParser.h"
#import "Global.h"

@implementation JSONParser
@synthesize webData;

-(id)initWithURL:(NSString *)strURL withParam:(NSDictionary *)params isTypePOST:(BOOL)isTypePOST andPostData:(NSData *)postData withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject shouldRespond:(BOOL)shouldRespond isDataTypeVideo:(BOOL)isDataTypeVideo
{
        shouldSendRespond=shouldRespond;
        callBackObject = thecallBackObject;
        successSelector = sucessHandler;
        failureSelector=failureHandler;
        self.webData = [[NSMutableData alloc]init];
    
    NSURL *urlPost=[NSURL URLWithString:strURL];
    NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
    [dictPostParameters addEntriesFromDictionary:params];
    
    postRequest = [[NSMutableURLRequest alloc] init];
    
    [postRequest setURL:urlPost];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData  *body = [[NSMutableData alloc] init];
    
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    for (NSString *theKey in [dictPostParameters allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostParameters objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (postData!=nil)
    {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"somepic.%@\"\r\n",(isDataTypeVideo)?@"mp4":@"png"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:postData];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postRequest setHTTPBody:body];

    return self;
}

-(void)startRequest
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [postRequest setTimeoutInterval:kTimeOutInterval];

    connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //DisplayAlert(error.localizedDescription);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    if (shouldSendRespond)
    {
        [callBackObject performSelector:failureSelector withObject:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self.webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self.webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    //NSString *strResponse=[[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
    
    NSError *err;
    id objectResponse = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableLeaves error:&err];
    //NSMutableDictionary *responseDict=(NSMutableDictionary *)objectResponse;
    
    if (shouldSendRespond) {
        [callBackObject performSelector:successSelector withObject:objectResponse];
    }
}
@end
