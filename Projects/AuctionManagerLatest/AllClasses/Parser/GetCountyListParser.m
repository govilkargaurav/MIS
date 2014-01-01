//
//  GetCountyListParser.m
//  PropertyInspector
//
//  Created by apple on 10/18/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "GetCountyListParser.h"

@interface GetCountyListParser ()

@end

@implementation GetCountyListParser

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
	
    countyIdArr=[[NSMutableArray alloc] init];
    county_nameArr=[[NSMutableArray alloc] init];
    addressArr=[[NSMutableArray alloc] init];
    cityArr=[[NSMutableArray alloc] init];
    stateArr=[[NSMutableArray alloc] init];
    zipArr=[[NSMutableArray alloc] init];
    latArr=[[NSMutableArray alloc] init];
    longituteArr=[[NSMutableArray alloc] init];
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
    if ([elementName isEqualToString:@"county"]) {
        
        self.mCurrentTagValue=[[NSMutableString alloc]init];
        
            [countyIdArr addObject:[attributeDict objectForKey:@"id"]];
            [county_nameArr addObject:[attributeDict objectForKey:@"county_name"]];
            [addressArr addObject:[attributeDict objectForKey:@"address"]];
            [cityArr addObject:[attributeDict objectForKey:@"city"]];
            [stateArr addObject:[attributeDict objectForKey:@"state"]];
            [zipArr addObject:[attributeDict objectForKey:@"zip"]];
            [latArr addObject:[attributeDict objectForKey:@"lat"]];
            [longituteArr addObject:[attributeDict objectForKey:@"long"]];
            
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
	
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_COUNTY_LIST object:nil];
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{

	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_COUNTY_LIST object:nil];
	
}

@end
