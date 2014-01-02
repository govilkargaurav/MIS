//
//  WSPContinuous.h
//  ZawJi
//
//  Created by openxcell open on 11/16/10.
//  Copyright 2010 xcsxzc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WSPContinuous : NSObject <NSXMLParserDelegate>{
	NSURLRequest *rq;
	NSString *RootTag;
	NSDictionary *StartingTag;
	NSDictionary *EndTag;
	NSDictionary *OthereTags;
	SEL targetSelector;
	NSObject *MainHandler;
	BOOL didGetHTML;
	NSURLConnection *con;
	NSMutableData *myWebData;
	NSXMLParser *myXMLParser;
	
	NSMutableString *tmpString;
	NSMutableDictionary *tmpOther;
	NSMutableArray *tmpArray;
	NSMutableDictionary *tmpDic;
	NSMutableDictionary *tmpDic1;
}
-(id)initWithRequestForThread:(NSMutableURLRequest*)urlRequest rootTag:(NSString*)rootTag startingTag:(NSDictionary*)startingTag endingTag:(NSDictionary*)endingTag otherTags:(NSDictionary*)otherTags sel:(SEL)seletor andHandler:(NSObject*)handler;


@property(nonatomic,strong) NSURLRequest *rq;
@property(nonatomic,strong) NSString *RootTag;
@property(nonatomic,strong) NSDictionary *StartingTag;
@property(nonatomic,strong) NSDictionary *EndTag;
@property(nonatomic,strong) NSDictionary *OthereTags;
@property(nonatomic) SEL targetSelector;
@property(nonatomic,strong) NSObject *MainHandler;
@property(nonatomic,strong) NSMutableArray *objectArray;

@end
