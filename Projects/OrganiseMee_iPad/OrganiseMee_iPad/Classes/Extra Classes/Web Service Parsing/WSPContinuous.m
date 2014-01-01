//
//  WSPContinuous.m
//  ZawJi
//
//  Created by openxcell open on 11/16/10.
//  Copyright 2010 xcsxzc. All rights reserved.
//

#import "WSPContinuous.h"
#import "AppDelegate.h"

@implementation WSPContinuous
@synthesize  rq,RootTag,StartingTag,EndTag,OthereTags,targetSelector,MainHandler,objectArray;

-(id)initWithRequestForThread:(NSMutableURLRequest*)urlRequest rootTag:(NSString*)rootTag startingTag:(NSDictionary*)startingTag endingTag:(NSDictionary*)endingTag otherTags:(NSDictionary*)otherTags sel:(SEL)seletor andHandler:(NSObject*)handler{
	if (self=[super init]) {
		self.RootTag = rootTag;didGetHTML =NO;
		self.StartingTag = startingTag;
		self.EndTag = endingTag;
		self.OthereTags = otherTags;
		self.MainHandler = handler;
		self.targetSelector = seletor;
		self.rq = urlRequest;
		
		tmpArray = [[NSMutableArray alloc] init];
		
		[self performSelectorOnMainThread:@selector(startParse) withObject:nil 
							waitUntilDone:NO];
	}

	return rq;
}
-(void)startParse{
	
	
	tmpDic1 = [[NSMutableDictionary alloc] init];
	
	con = [[NSURLConnection alloc] initWithRequest:rq delegate:self];
	if (con) {
		myWebData = [NSMutableData data];
	}else {
		[self performSelectorOnMainThread:@selector(targetSelector:) withObject:nil waitUntilDone:NO];
	}
	
}

//-------------------------------connection-----------------

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
	[myWebData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
	[myWebData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     [AppDel dismissGlobalHUD];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSString *thexml = [[NSString alloc] initWithBytes:[myWebData mutableBytes] length:[myWebData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"Response : %@",thexml);
	myXMLParser = [[NSXMLParser alloc] initWithData:myWebData];
	[myXMLParser setDelegate:self];
	[myXMLParser setShouldResolveExternalEntities:YES];
	tmpOther = [[NSMutableDictionary alloc] init];
	[myXMLParser parse];
	myWebData = nil;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([elementName isEqualToString:RootTag]) {
		tmpDic  = [[NSMutableDictionary alloc] init];
		
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

	
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [string length])];
	string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [string length])];
	
	if (tmpString ==nil && !didGetHTML) {
		tmpString = [[NSMutableString alloc] initWithString:string];
	}else if (!didGetHTML) {
		NSString *t = [NSString stringWithString:tmpString];
		if (tmpString >0) {
			tmpString = nil;}
		
		tmpString = [[NSMutableString alloc] initWithFormat:@"%@%@",t,string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

	
	if ([EndTag objectForKey:elementName]) {
		[tmpDic setValue:tmpString forKey:elementName];
	}
	if ([RootTag isEqualToString:elementName]) {
		[tmpArray addObject:tmpDic];
	
	}
	if ([OthereTags objectForKey:elementName]) {
		NSLog(@"ok");
		//tmpDic1 = [[NSMutableDictionary alloc] init];
		[tmpDic1 setValue:tmpString forKey:elementName];
		
	}
	tmpString = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
	
    
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	
	[dic setValue:tmpArray forKey:@"array"];
	[dic setValue:tmpDic1 forKey:@"other"];
    
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }

	[MainHandler performSelector:targetSelector withObject:dic afterDelay:0.0f];
    
}
@end
