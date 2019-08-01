//
//  BDModel.h
//  BDKit
//
//  Created by Liu Jinyong on 14-2-19.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDModel : NSObject<NSCoding>

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

+ (void)cleanArchiveWithKey:(NSString *)key;
+ (void)cleanAllArchiveFile;

+ (void)setArchivePath:(NSString *)path;    //Default is [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/model"]

@end


@interface NSObject(BDModel)

+ (id)unarchiveWithKey:(NSString *)key;
- (void)archiveWithKey:(NSString *)key;

@end