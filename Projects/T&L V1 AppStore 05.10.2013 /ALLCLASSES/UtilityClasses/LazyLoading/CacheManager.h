//
//  CacheManager.h
//  Oncology
//
//  Created by mac11 on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property(nonatomic,strong) NSUserDefaults* _prefs;
@property(nonatomic,strong)NSString *_loginStatus;
@property(nonatomic,strong)NSString *_searchStatus;

@property(nonatomic,strong)NSString *_strGlobalAdImgUrl;
@property(nonatomic,strong)NSData *imgDataGlobalAd;

@property(nonatomic,strong)NSMutableArray *_arrArticles;
@property(nonatomic,strong)NSMutableArray *_arrEditions;
@property(nonatomic,strong)NSMutableDictionary *_dictImages;

+ (CacheManager*)sharedCacheManager;
@end
