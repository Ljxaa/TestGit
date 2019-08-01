//
//  ResEntity.h
//  iMcuSdk
//
//  Created by mac on 12-9-12.
//  Copyright (c) 2012年 Crearo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, Cvs2IResType)
{
	kCvs2Domain = 0, // 域
	kCvs2PeerUnit,	 // 设备
	kCvs2Camera,     // 摄像头
    kCvs2Storage
};

@interface Cvs2ResEntity : NSObject
{
    BOOL            enable;
    char            cIdx;
    NSString        *puid;
    BOOL            online;
    Cvs2IResType        resType;
    NSString        *resName;
    Cvs2ResEntity     *parent;
    NSMutableArray  *childrenArray;
}
@property (nonatomic, assign)   BOOL            enable;            // 资源是否使能
@property (nonatomic, assign)   char            cIdx;              // 资源的序号
@property (nonatomic, copy)     NSString        *puid;             
@property (nonatomic, assign)   BOOL            online;            // 是否在线
@property (nonatomic, assign)   Cvs2IResType        resType;         
@property (nonatomic, copy)     NSString        *resName;          // 资源名称
@property (nonatomic, assign)   Cvs2ResEntity     *parent;           // 父节点
@property (nonatomic, retain)   NSMutableArray  *childrenArray;    // 子节点集合

@end

/**
 *	@brief	设备资源
 */
@interface Cvs2PeerUnit : Cvs2ResEntity

{
    NSString *modelType;
    NSString *devID;
}
@property (nonatomic, copy) NSString *modelType;
@property (nonatomic, copy) NSString *devID;
@end

/**
 *	@brief	域节点
 */
@interface Cvs2DomainNode : Cvs2ResEntity

{
    
}


@end

@interface Cvs2StorageFile : NSObject

- (id)initWithDirPath:(NSString *)path name:(NSString *)name size:(NSInteger)size type:(BOOL)cefs;

@property (nonatomic, readonly)NSString *filePath;
@property (nonatomic, readonly)NSString *fileName;
@property (nonatomic, readonly)NSInteger fileSize;
@property (nonatomic, readonly)BOOL cefs;

@end