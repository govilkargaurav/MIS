//
//  CacheManager.m
//  Oncology
//
//  Created by mac11 on 16/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
@synthesize _arrEditions,_dictImages,_strGlobalAdImgUrl,imgDataGlobalAd,_loginStatus,_prefs,_searchStatus;

static CacheManager *sharedInstance=nil;
-(id) init
{
	self = [super init];
	if (self != nil) {
		_arrEditions=[[NSMutableArray alloc] init];
		_dictImages=[[NSMutableDictionary alloc] init];
		_arrArticles=[[NSMutableDictionary alloc] init];
		_strGlobalAdImgUrl=[[NSString alloc] init];
		_loginStatus=[[NSString alloc] init];
			_prefs = [NSUserDefaults standardUserDefaults];
		_searchStatus=[[NSString alloc] init];
	}
	
	return self;
}


+(CacheManager*)sharedCacheManager
{
	@synchronized(self)
	{
		if(sharedInstance==nil)
		{
			[[self alloc] init];
			
		}
	}
	
	return sharedInstance;
}



+(id)allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(sharedInstance==nil)
		{
			sharedInstance=[super allocWithZone:zone];
			
			return sharedInstance;
		}
		
	}
	return nil;
	
}

-(id)copyWithZone:(NSZone*)zone
{
	return self;
}

-(id)retain
{
	return self;
}

-(unsigned)retainCount
{
	return UINT_MAX;
}



-(id)autorelease
{
	return self;
}


-(void)dealloc
{
	[super dealloc];
	_arrEditions=nil;
	_dictImages=nil;
	_strGlobalAdImgUrl=nil;
	_arrArticles=nil;
	_loginStatus=nil;
	_searchStatus=nil;
	[_arrEditions release];
	[_dictImages release];
	[_strGlobalAdImgUrl release];
	[_arrArticles release];
	imgDataGlobalAd=nil;
	[imgDataGlobalAd release];
	[_loginStatus release];
	[_searchStatus release];
}


@end
