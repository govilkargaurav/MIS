//
//  CacheManager.h
//  Oncology
//
//  Created by mac11 on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ArticleDesc.h"

@interface CacheManager : NSObject {
	NSMutableArray *_arrEditions;
	NSMutableArray *_arrArticles;
	NSMutableDictionary *_dictImages;
	NSString *_strGlobalAdImgUrl;
	NSData *imgDataGlobalAd;
	NSString *_loginStatus;
	NSUserDefaults *_prefs;  
	NSString *_searchStatus;
	
}
@property(nonatomic, retain) NSUserDefaults* _prefs;
@property(nonatomic,retain)NSString *_loginStatus;
@property(nonatomic,retain)NSString *_searchStatus;

@property(nonatomic,retain)NSString *_strGlobalAdImgUrl;
@property(nonatomic,retain)NSData *imgDataGlobalAd;

@property(nonatomic,retain)NSMutableArray *_arrArticles;
@property(nonatomic,retain)NSMutableArray *_arrEditions;
@property(nonatomic,retain)NSMutableDictionary *_dictImages;

+ (CacheManager*)sharedCacheManager;
@end
