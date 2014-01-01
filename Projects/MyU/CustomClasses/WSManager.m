//
//  WSManager.m
//  Suvi
//
//  Created by Gagan on 6/4/13.
//
//

#import "WSManager.h"


@implementation WSManager
@synthesize webData;
@synthesize callBackObject,shouldShowProgress;
-(id)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara postData:(NSDictionary *)dictPostData withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject
{
    NSLog(@"The URL:%@ and Para:%@",postURL,dictPostPara);
    
    strPostURL=[NSString stringWithFormat:@"%@",postURL];
    callBackObject = thecallBackObject;
    successSelector = sucessHandler;
    failureSelector=failureHandler;
    self.webData = [[NSMutableData alloc]init];
    postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:postURL];
    [postRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData  *body = [[NSMutableData alloc] init];
    
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    for (NSString *theKey in [dictPostPara allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostPara objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (NSString *theKey in [dictPostData allKeys])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"pic.png\"\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[dictPostData objectForKey:theKey]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postRequest setHTTPBody:body];
    
    return self;
}

-(id)initWithURL:(NSURL *)postURL postPara:(NSDictionary *)dictPostPara withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject andRequestType:(WS_REQUEST_TYPE)wsRequestType
{
    return self;
}
-(void)startASIRequest
{
    
}
-(void)stopASIRequest
{
    
}
-(void)startRequest
{
    activitycount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
}

-(void)stopRequest
{
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }
    
    [connection cancel];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"the error:%@",error.localizedDescription);
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }
    
    if (failureSelector)
    {
        [callBackObject performSelector:failureSelector withObject:(id)[NSDictionary dictionaryWithObject:error.localizedDescription forKey:@"error"]];
    }
}

//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
// totalBytesWritten:(NSInteger)totalBytesWritten
//totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//    NSLog(@"totalsend bytes:%d total written:%d and expected:%d",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"the datta:%d",[data length]);
    [self.webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    activitycount--;
    if (activitycount<=0)
    {
        activitycount=0;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }

    NSError *err;
    id objectResponse = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableContainers error:&err];

    if (objectResponse)
    {
        NSLog(@"The Response:%@",objectResponse);
        
        if ([strPostURL isEqualToString:kUpdateBadgeNotificationURL] || [strPostURL isEqualToString:kBadgeNotificationURL] || [strPostURL isEqualToString:kUpdateChatNotificationURL] || [strPostURL isEqualToString:POST_OLD_TIMESTAMP])
        {
            NSDictionary *dictResponse=(NSDictionary *)objectResponse;
            if ([dictResponse objectForKey:@"unread_count"])
            {
                unread_notificationcount=[[dictResponse objectForKey:@"unread_count"] integerValue];
                [UIApplication sharedApplication].applicationIconBadgeNumber=unread_notificationcount;

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyUpdateNotificationBadge object:nil];
            }
        }
        
        if (successSelector)
        {
            [callBackObject performSelector:successSelector withObject:objectResponse];
        }
    }
    else
    {
        if (failureSelector)
        {
            NSString *strData = [[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
            [callBackObject performSelector:failureSelector withObject:(id)[NSDictionary dictionaryWithObject:strData forKey:@"error"]];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (shouldShowProgress)
    {
        if (successSelector)
        {
            float  progess= (float)totalBytesWritten / totalBytesExpectedToWrite;
            //NSLog(@"%f",progess);
            NSString *strData = [[NSString alloc]initWithFormat:@"%f",progess];
            [callBackObject performSelector:successSelector withObject:(id)[NSDictionary dictionaryWithObject:strData forKey:@"progress"]];
        }
    }
}

@end
