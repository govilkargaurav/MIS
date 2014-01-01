//
//  DataExporter.h
//  InfoMe
//
//  Created by Mubin Lakadia on 21/08/12.
//  Copyright (c) 2012 Sevenstar Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataExporter : NSObject

+(NSString *)saveDataFromDictionary:(NSMutableDictionary *)preexportdata;
+(NSMutableDictionary *)getDictionaryFromURL:(NSURL *)importURL;
+(NSMutableDictionary *)getDictionaryFromData:(NSData *)importData;
@end
