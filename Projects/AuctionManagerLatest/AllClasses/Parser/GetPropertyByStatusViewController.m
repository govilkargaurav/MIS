//
//  GetPropertyByStatusViewController.m
//  PropertyInspector
//
//  Created by apple on 11/9/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "GetPropertyByStatusViewController.h"

@interface GetPropertyByStatusViewController ()

@end

@implementation GetPropertyByStatusViewController

@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
        
        getPropertyID=[[NSMutableDictionary alloc] init];
        getPropertyArray=[[NSMutableArray alloc] init];
        
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
    
    if ([elementName isEqualToString:@"property"]) {
        
        
        getPropertyID=[NSMutableDictionary dictionaryWithObjectsAndKeys:[attributeDict valueForKey:@"id"],@"PROPERTYID", nil];
        
        [getPropertyArray addObject:getPropertyID];
        
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
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_PROPERTY_BY_STATUS object:nil];
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_PROPERTY_BY_STATUS object:nil];
	
	
}

@end
