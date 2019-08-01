//
//  BDCacheProtocol.h
//  BDKit
//
//  Created by Liu Jinyong on 14-2-20.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol BDCacheProtocol<NSObject>

- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

@end
