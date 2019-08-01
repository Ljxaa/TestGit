//
//  BDModel.m
//  BDKit
//
//  Created by Liu Jinyong on 14-2-19.
//  Copyright (c) 2014年 Bodong Baidu. All rights reserved.
//

#include <objc/runtime.h>
#import "BDModel.h"

#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/model"]

static NSString *archivePath = nil;

@implementation BDModel

+ (void)setArchivePath:(NSString *)path {
    archivePath = path;
}

+ (void)cleanAllArchiveFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getPath]]) {
        [fileManager removeItemAtPath:[self getPath] error:nil];
    }
}

+ (NSString *)getPath {
    return archivePath ? archivePath : PATH;
}

+ (void)cleanArchiveWithKey:(NSString *)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[self getPath] stringByAppendingPathComponent:key];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = [self class];
    @synchronized (self) {
        while (cls != [NSObject class]) {
            unsigned int numberOfIvars = 0;
            //取得当前class的Ivar数组
            Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
            for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++)
            {
                Ivar const ivar = *p;
                //得到ivar的类型
                const char *type = ivar_getTypeEncoding(ivar);
                //取得它的名字，比如"year", "name".
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                //取得某个key所对应的值
                id value = [self valueForKey:key];
                if (value) {
                    switch (type[0]) {
                            //如果是结构体的话，将其转化为NSData，然后encode.
                            //其实cocoa会自动将CGRect等四种结构转化为NSValue，能够直接用value encode.
                            //但其他结构体就不可以，所以还是需要我们手动转一下.
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize = 0;
                            NSUInteger ivarAlignment = 0;
                            //取得变量的大小
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            //((const char *)self + ivar_getOffset(ivar))指向结构体变量
                            NSData *data = [NSData dataWithBytes:(const char *)self + ivar_getOffset(ivar)
                                                          length:ivarSize];
                            [encoder encodeObject:data forKey:key];
                        }
                            break;
                        default:
                            [encoder encodeObject:value
                                           forKey:key];
                            break;
                    }
                }
            }
            if (ivars) {
                free(ivars);
            }
            
            cls = class_getSuperclass(cls);
        }
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        Class cls = [self class];
        while (cls != [NSObject class]) {
            unsigned int numberOfIvars = 0;
            Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
            
            for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++)
            {
                Ivar const ivar = *p;
                const char *type = ivar_getTypeEncoding(ivar);
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                id value = [decoder decodeObjectForKey:key];
                if (value) {
                    switch (type[0]) {
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize = 0;
                            NSUInteger ivarAlignment = 0;
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            NSData *data = [decoder decodeObjectForKey:key];
                            char *sourceIvarLocation = (char*)self+ ivar_getOffset(ivar);
                            [data getBytes:sourceIvarLocation length:ivarSize];
                            memcpy((char *)self + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
                        }
                            break;
                        default:
                            [self setValue:[decoder decodeObjectForKey:key]
                                    forKey:key];
                            break;
                    }
                }
            }
            
            if (ivars) {
                free(ivars);
            }
            cls = class_getSuperclass(cls);
        }
    }
    
    return self;
}

@end


@implementation NSObject(BDModel)

+ (id)unarchiveWithKey:(NSString *)key {
    NSString * filePath = [[BDModel getPath] stringByAppendingPathComponent:key];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}


- (void)archiveWithKey:(NSString *)key {
    @autoreleasepool
    {
        @synchronized (self)
        {
            @try
            {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:[BDModel getPath]]) {
                    [fileManager createDirectoryAtPath:[BDModel getPath] withIntermediateDirectories:NO attributes:nil error:nil];
                }
                NSString * filePath = [[BDModel getPath] stringByAppendingPathComponent:key];
                [NSKeyedArchiver archiveRootObject:self toFile:filePath];
            }
            @catch (NSException *exception) {
//                BDLOG(@"%@", exception.description);
            }
        }
    }
}

@end