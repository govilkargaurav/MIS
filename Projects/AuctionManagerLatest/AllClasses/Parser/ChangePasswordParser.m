//
//  ChangePasswordParser.m
//  PropertyInspector
//
//  Created by apple on 11/8/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "ChangePasswordParser.h"

@interface ChangePasswordParser ()

@end

@implementation ChangePasswordParser

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
        
        changepasswordStatus=[attributeDict valueForKey:@"success"];
        
        self.mCurrentTagValue=[[NSMutableString alloc]init];
        
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
        
        
	}
	
    self.mCurrentTagName=nil;
	self.mCurrentTagValue=nil;
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_POST_CHANGE_PASSWORD object:nil];
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_POST_CHANGE_PASSWORD object:nil];
	
	
}

@end
