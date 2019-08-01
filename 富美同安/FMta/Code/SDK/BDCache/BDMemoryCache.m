//
//  BDMemoryCache.m
//  BDKit
//
//  Created by Liu Jinyong on 14-2-20.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import "BDMemoryCache.h"


#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

#pragma mark -

@interface BDMemoryCache() {
	BOOL					_clearWhenMemoryLow;
	NSUInteger				_maxCacheCount;
	NSUInteger				_cachedCount;
	NSMutableArray *		_cacheKeys;
	NSMutableDictionary *	_cacheObjs;
}
@end


@implementation BDMemoryCache

BD_SYNTHESIZE_SINGLETON_FOR_CLASS(BDMemoryCache);

- (id)init {
	self = [super init];
	if (self) {
		_clearWhenMemoryLow = YES;
		_maxCacheCount = DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}

	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_cacheObjs removeAllObjects];
    [_cacheObjs release];
	
	[_cacheKeys removeAllObjects];
	[_cacheKeys release];
	
    [super dealloc];
}

- (BOOL)hasObjectForKey:(id)key {
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key {
	return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key {
	if (nil == key)
		return;
	
	if (nil == object)
		return;
	
	_cachedCount += 1;

	while (_cachedCount >= _maxCacheCount) {
		NSString * tempKey = [_cacheKeys objectAtIndex:0];

		[_cacheObjs removeObjectForKey:tempKey];
		[_cacheKeys removeObjectAtIndex:0];

		_cachedCount -= 1;
	}

	[_cacheKeys addObject:key];
	[_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
	if ([_cacheObjs objectForKey:key]) {
		[_cacheKeys removeObjectIdenticalTo:key];
		[_cacheObjs removeObjectForKey:key];

		_cachedCount -= 1;
	}	
}

- (void)removeAllObjects {
	[_cacheKeys removeAllObjects];
	[_cacheObjs removeAllObjects];
	
	_cachedCount = 0;
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification {
    if (_clearWhenMemoryLow) {
        [self removeAllObjects];
    }
}

@end
