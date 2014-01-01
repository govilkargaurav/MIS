//
//  WSManager.m
//  Suvi
//
//  Created by Gagan on 6/4/13.
//
//

#import "WSManager.h"
#import "MyAppManager.h"

@implementation WSManager
@synthesize webData,strFeedId;

-(id)initWithWSData:(NSDictionary *)dictWS withsucessHandler:(SEL)sucessHandler withfailureHandler:(SEL)failureHandler withCallBackObject:(NSObject *)thecallBackObject shouldRespond:(BOOL)shouldRespond
{
    shouldSendRespond=shouldRespond;
    callBackObject = thecallBackObject;
    successSelector = sucessHandler;
    failureSelector=failureHandler;
    strFeedId=[NSString stringWithString:[dictWS objectForKey:@"iActivityID"]];
    self.webData = [[NSMutableData alloc]init];
    
    NSURL *urlPost=[NSURL URLWithString:[dictWS objectForKey:@"POSTURL"]];
    NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
    [dictPostParameters addEntriesFromDictionary:[dictWS objectForKey:@"params"]];
    
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
    
    if ([dictWS objectForKey:@"filePath"])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",[dictWS objectForKey:@"fileName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *postData=[NSData dataWithContentsOfFile:[dictWS objectForKey:@"filePath"]];

        [body appendData:postData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postRequest setHTTPBody:body];
    
    return self;
}

-(void)startRequest
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [postRequest setTimeoutInterval:kTimeOutInterval];

    connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
}
-(void)stopRequest
{
    isBackGroundUploadRunning=NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [connection cancel];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //DisplayAlert(error.localizedDescription);
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    if (!isSocialSharing)
    {
        if (shouldSendRespond)
        {
            [callBackObject performSelector:failureSelector withObject:nil];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self.webData setLength:0];
    
    if (!isUserLoggedIn)
    {
        [self stopRequest];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self.webData appendData:data];
    
    if (!isUserLoggedIn)
    {
        [self stopRequest];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    NSError *err;
    id objectResponse = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableLeaves error:&err];
    NSString *strResponse=[[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
    NSLog(@"Response:%@",strResponse);

    if (!isSocialSharing)
    {
        NSMutableDictionary *responseDict=(NSMutableDictionary *)(objectResponse);
        
        NSString *strMSG =[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"MESSAGE"]];
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            //Share via Social Networks...
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            
            NSMutableString *strParameters=[[NSMutableString alloc]init];
            NSDictionary *params=[[NSDictionary alloc]initWithDictionary:[responseDict objectForKey:@"Post_Info"]];
            for (int i=0;i<[[params allKeys] count];i++)
            {
                NSString *strPara=[NSString stringWithFormat:@"%@",[params objectForKey:[[params allKeys] objectAtIndex:i]]];
                [strParameters appendFormat:@"%@%@=%@",(i==0)?@"":@"&",[[params allKeys] objectAtIndex:i],[strPara stringByReplacingOccurrencesOfString:@"&" withString:@"and"]];
            }
            
            postRequest=nil;
            postRequest = [[NSMutableURLRequest alloc] init];
            self.webData = [[NSMutableData alloc]init];
            NSURL *posturl= [NSURL URLWithString:[strPostFeatured stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [postRequest setURL:posturl];
            [postRequest setHTTPMethod:@"POST"];
            NSMutableData *postParaData = [[NSMutableData alloc]init];
            [postParaData appendData:[[NSString stringWithFormat:@"%@",[strParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postParaData length]];
            [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [postRequest setHTTPBody:postParaData];
            
//            NSURL *urlPost=[NSURL URLWithString:strPostFeatured];
//            NSDictionary *params=[[NSDictionary alloc]initWithDictionary:[responseDict objectForKey:@"Post_Info"]];
//            NSLog(@"the resoobse :%@",responseDict);
//            NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
//            [dictPostParameters addEntriesFromDictionary:[responseDict objectForKey:@"Post_Info"]];
//            
//            postRequest=nil;
//            postRequest = [[NSMutableURLRequest alloc] init];
//            self.webData = [[NSMutableData alloc]init];
//            [postRequest setURL:urlPost];
//            [postRequest setHTTPMethod:@"POST"];
//            
//            NSString *boundary = @"---------------------------14737809831466499882746641449";
//            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//            NSMutableData  *body = [[NSMutableData alloc] init];
//            
//            [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
//            
//            for (NSString *theKey in [dictPostParameters allKeys])
//            {
//                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostParameters objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
//            }
//            
//            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            [postRequest setHTTPBody:body];
            
            isSocialSharing=YES;
            [self startRequest];
            
            //Delete Feed From PList & Add to JSON...
            
            NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
            NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
            NSString *filePath = [NSString stringWithFormat:@"%@/bgpost_%@.plist",dirPath,strUserId];
            
            if ([[[MyAppManager sharedManager] fileManager] fileExistsAtPath:filePath])
            {
                NSInteger selectedfeed=0;
                
                BOOL isFeedFound=NO;
                
                NSMutableArray *arrBGPosts=[[NSMutableArray alloc]initWithContentsOfFile:filePath];
                
                for (int i=0;i<[arrBGPosts count]; i++)
                {
                    if ([[[arrBGPosts objectAtIndex:i]objectForKey:@"iActivityID"] isEqualToString:strFeedId]) {
                        isFeedFound=YES;
                        selectedfeed=i;
                    }
                }
                
                if (isFeedFound)
                {
                    NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DETAIL"]];

                    NSMutableDictionary *dictJSONFeed=[[NSMutableDictionary alloc]init];
                    
                    NSMutableDictionary *dictUInfoFeed=[[NSMutableDictionary alloc]init];
                    
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"eGender"] forKey:@"eGender"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"admin_email"] forKey:@"admin_email"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"eAccountStatus"] forKey:@"eAccountStatus"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"admin_fname"] forKey:@"admin_fname"];
                    [dictUInfoFeed setObject:[params objectForKey:@"userID"] forKey:@"admin_id"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"admin_lname"] forKey:@"admin_lname"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"image_path"] forKey:@"image_path"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"uname"] forKey:@"uname"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"school"] forKey:@"school"];
                    [dictUInfoFeed setObject:[userDefaults objectForKey:@"numFriends"] forKey:@"hasNoOfFriends"];
                    
                    [dictJSONFeed setObject:dictUInfoFeed forKey:@"UserInfo"];
         
                    [dictJSONFeed setObject:[params objectForKey:@"userID"] forKey:@"iAdminID"];
                    
                    if ([[params objectForKey:@"vType_of_content"] isEqualToString:@"activity"])
                    {
                        [dictJSONFeed setObject:[params objectForKey:@"iActivityID"] forKey:@"iActivityID"];
                        [dictJSONFeed setObject:@"" forKey:@"url"];
                        [dictJSONFeed setObject:@"" forKey:@"vimageName"];
                    }
                    else if([[params objectForKey:@"vType_of_content"] isEqualToString:@"image"])
                    {
                        [dictJSONFeed setObject:[params objectForKey:@"iImageID"] forKey:@"iImageID"];
                        [dictJSONFeed setObject:[params objectForKey:@"url"] forKey:@"url"];
                        [dictJSONFeed setObject:[params objectForKey:@"iImageID"] forKey:@"vimageName"];
                        [dictJSONFeed setObject:[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"imageWidth"] forKey:@"width"];
                        [dictJSONFeed setObject:[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"imageHeight"] forKey:@"height"];
                    }
                    else if([[params objectForKey:@"vType_of_content"] isEqualToString:@"location"])
                    {
                        [dictJSONFeed setObject:[params objectForKey:@"iGroupLocationID"] forKey:@"iGroupLocationID"];
                        [dictJSONFeed setObject:[[NSString stringWithFormat:@"%@",[[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"params"] objectForKey:@"dcLatitude"]] removeNull] forKey:@"dcLatitude"];
                        [dictJSONFeed setObject:[[NSString stringWithFormat:@"%@",[[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"params"] objectForKey:@"dcLongitude"]] removeNull] forKey:@"dcLongitude"];
                    }
                    else if([[params objectForKey:@"vType_of_content"] isEqualToString:@"music"])
                    {
                        [dictJSONFeed setObject:[params objectForKey:@"iMusicID"] forKey:@"iMusicID"];
                        [dictJSONFeed setObject:[params objectForKey:@"vMusicName"] forKey:@"vMusicName"];
                        [dictJSONFeed setObject:[params objectForKey:@"vMusicName2"] forKey:@"vMusicName2"];
                        [dictJSONFeed setObject:[params objectForKey:@"url"] forKey:@"music_img"];
                    }
                    else if([[params objectForKey:@"vType_of_content"] isEqualToString:@"video"])
                    {
                        [dictJSONFeed setObject:[params objectForKey:@"iVideoID"] forKey:@"iVideoID"];
                        [dictJSONFeed setObject:[params objectForKey:@"video_url"] forKey:@"video_url"];
                        [dictJSONFeed setObject:[params objectForKey:@"url"] forKey:@"url"];
                        [dictJSONFeed setObject:[params objectForKey:@"vTitle"] forKey:@"vTitle"];
                    }
                    
                    [dictJSONFeed setObject:[params objectForKey:@"vActivityText"] forKey:@"vActivityText"];

                    [dictJSONFeed setObject:[params objectForKey:@"vIamAt"] forKey:@"vIamAt"];
                    [dictJSONFeed setObject:[params objectForKey:@"vIamAt2"] forKey:@"vIamAt2"];
                    
                    [dictJSONFeed setObject:[params objectForKey:@"vType_of_content"] forKey:@"vType_of_content"];

                    [dictJSONFeed setObject:[[[params objectForKey:@"vImWithflname"] removeNull] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""] forKey:@"vImWithflname"];
                    [dictJSONFeed setObject:[params objectForKey:@"vImWithEmailIds"] forKey:@"vImWithEmailIds"];

                    [dictJSONFeed setObject:[params objectForKey:@"tsInsertDt"] forKey:@"tsInsertDt"];
                    [dictJSONFeed setObject:[params objectForKey:@"tsLastUpdateDt"] forKey:@"tsLastUpdateDt"];
                    [dictJSONFeed setObject:[params objectForKey:@"unixTimeStamp"] forKey:@"unixTimeStamp"];
                    
                    [dictJSONFeed setObject:@"Yes" forKey:@"canLike"];//
                    [dictJSONFeed setObject:@"No" forKey:@"hasCommented"];//
                    [dictJSONFeed setObject:@"Yes" forKey:@"canUnLike"];//
                    [dictJSONFeed setObject:@"" forKey:@"vLikersIDs"];//
                    [dictJSONFeed setObject:@"" forKey:@"vUnlikersIDs"];//
                    [dictJSONFeed setObject:@"0" forKey:@"vLikersIDs_count"];//
                    [dictJSONFeed setObject:@"0" forKey:@"vUnlikersIDs_count"];//
                    [dictJSONFeed setObject:@"0" forKey:@"Total_like_unlikes"];//
                    [dictJSONFeed setObject:@"0" forKey:@"Comment_counts"];//
                    
                    if ([[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"filePath"])
                    {
                        if([[params objectForKey:@"vType_of_content"] isEqualToString:@"image"] && [params objectForKey:@"url"])
                        {
                            NSString *strFileName=[NSString stringWithFormat:@"%@",[[params objectForKey:@"url"] removeNull]];
                            NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,[[MyAppManager sharedManager] strImageNameFromURL:strFileName]];
                            [[[MyAppManager sharedManager] fileManager] moveItemAtPath:[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"filePath"] toPath:filePath error:nil];
                        }
                        else
                        {
                            [[[MyAppManager sharedManager] fileManager] removeItemAtPath:[[arrBGPosts objectAtIndex:selectedfeed] objectForKey:@"filePath"] error:nil];
                        }
                    }
                    
                    [arrBGPosts removeObjectAtIndex:selectedfeed];
                    
                    if ([arrBGPosts writeToFile:filePath atomically:YES])
                    {
                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                        NSMutableDictionary *userDefaults=[[NSMutableDictionary alloc]initWithDictionary:[defaults valueForKey:@"USER_DETAIL"]];
                        NSString *strHomeFileName=[NSString stringWithFormat:@"user_home_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
                        NSString *strTimeLineFileName=[NSString stringWithFormat:@"user_timeline_%@_1p2.json",[userDefaults valueForKey:@"admin_id"]];
                        NSMutableArray *arrHomeData=[[NSMutableArray alloc]init];
                        NSMutableArray *arrTimeLineData=[[NSMutableArray alloc]init];
                        NSMutableDictionary *dictJSONWriteHome=[[NSMutableDictionary alloc]initWithDictionary:[strHomeFileName getDataFromFile]];
                        NSMutableDictionary *dictJSONWriteTimeLine=[[NSMutableDictionary alloc]initWithDictionary:[strTimeLineFileName getDataFromFile]];
                        
                        if ([dictJSONWriteHome objectForKey:@"USER_RECORDS"])
                        {
                            [arrHomeData addObjectsFromArray:[[strHomeFileName getDataFromFile] objectForKey:@"USER_RECORDS"]];
                            [arrHomeData insertObject:dictJSONFeed atIndex:0];
                            [dictJSONWriteHome setObject:arrHomeData forKey:@"USER_RECORDS"];
                            [dictJSONWriteHome writeToFileName:strHomeFileName];
                        }
                        
                        if ([dictJSONWriteTimeLine objectForKey:@"USER_RECORDS"])
                        {
                            [arrTimeLineData addObjectsFromArray:[[strTimeLineFileName getDataFromFile] objectForKey:@"USER_RECORDS"]];
                            [arrTimeLineData insertObject:dictJSONFeed atIndex:0];
                            [dictJSONWriteTimeLine setObject:arrTimeLineData forKey:@"USER_RECORDS"];
                            [dictJSONWriteTimeLine writeToFileName:strTimeLineFileName];
                        }
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBGPostRefresh object:nil];
        }
        else
        {
            NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
            NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
            NSString *filePath = [NSString stringWithFormat:@"%@/bgpost_%@.plist",dirPath,strUserId];
            if ([[[MyAppManager sharedManager] fileManager] fileExistsAtPath:filePath])
            {
                NSInteger selectedfeed=0;
                
                BOOL isFeedFound=NO;
                
                NSMutableArray *arrBGPosts=[[NSMutableArray alloc]initWithContentsOfFile:filePath];
                
                for (int i=0;i<[arrBGPosts count]; i++)
                {
                    if ([[[arrBGPosts objectAtIndex:i]objectForKey:@"iActivityID"] isEqualToString:strFeedId]) {
                        isFeedFound=YES;
                        selectedfeed=i;
                    }
                }
                
                if (isFeedFound)
                {
                    NSMutableDictionary *dictFailureData=[[NSMutableDictionary alloc]initWithDictionary:[arrBGPosts objectAtIndex:selectedfeed]];
                    [arrBGPosts addObject:dictFailureData];
                    [arrBGPosts removeObjectAtIndex:selectedfeed];
                    
                    if ([arrBGPosts writeToFile:filePath atomically:YES])
                    {
                        NSLog(@"feed deleted - upload failed");
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBGPostRefresh object:nil];
            
            if (shouldSendRespond)
            {
                [callBackObject performSelector:failureSelector withObject:nil];
            }
        }
    }
    else
    {
        if (shouldSendRespond)
        {
            [callBackObject performSelector:successSelector withObject:objectResponse];
        }
    }
}
@end
