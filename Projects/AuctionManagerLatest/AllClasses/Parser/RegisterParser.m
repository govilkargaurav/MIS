//
//  RegisterParser.m
//  PropertyInspector
//
//  Created by apple on 10/18/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "RegisterParser.h"
#import "RegisterModel.h"



@interface RegisterParser ()

@end

@implementation RegisterParser

@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
	}
	return self;
}

- (void)parseData:(NSData*)rawData :(int)reqType
{
	
    //////NSLog(@"Response:> %@",[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding]);
    
    requestType=reqType;
	parser = [[NSXMLParser alloc] initWithData: rawData];
	[parser setDelegate: self];
	[parser setShouldResolveExternalEntities: YES];
	[parser parse];
    
}

#pragma mark ParserDelegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	
	
    self.mCurrentTagName = elementName;
    if ([elementName isEqualToString:@"response"]) {
        
        self.mCurrentTagValue=[[NSMutableString alloc]init];
        
        //responseStr=[attributeDict objectForKey:@"authenticated"];
        //sessionID=[attributeDict objectForKey:@"sessionId"];
        
        statusRegister=[attributeDict objectForKey:@"authenticated"];
        sessionIDRegister=[attributeDict objectForKey:@"sessionId"];
        
    }
    
    
    
    
    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if([self.mCurrentTagName  isEqualToString:@"response"]){
        
		[self.mCurrentTagValue appendString:string];
        
	}
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
    if([elementName isEqualToString:@"response"]){
        
        // responseStr=[NSString stringWithFormat:@"%@",self.mCurrentTagValue];
        
	}
	
    self.mCurrentTagName=nil;
	self.mCurrentTagValue=nil;
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_VERSION_KEY object:nil];
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_VERSION_KEY object:nil];
	
	
}

@end
