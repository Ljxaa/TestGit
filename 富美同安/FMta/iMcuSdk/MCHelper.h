//
//  iMcuSdk.h
//  iMcuSdk
//
//  Created by  on 12-9-7.
//  Copyright (c) 2012年 Crearo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cvs2ResEntity.h"
#import "Cvs2VideoView.h"

#define SP_ERROR_MSG                        2001    //错误的消息体格式
#define SP_ERROR_PARAM                      2002    //错误的参数
#define SP_ERROR_NOT_SUPPORT                2003    //不支持的操作
#define SP_ERROR_VERITY_FAILED              2004    //目标鉴权失败
#define SP_ERROR_EPID                       2006    //EPID鉴权失败
#define SP_ERROR_TIMEOUT                    2009    //命令超时
#define SP_ERROR_ROUTE                      2010    //路由失败
#define SP_ERROR_DISPATCHER                 2018    //没有可用的分发单元

#define MC_ERROR_INTER_PARAM                3002    //函数参数错误
#define MC_ERROR_REQUEST_TIMEOUT            3003    //请求超时
#define MC_ERROR_ADDRESS                    -3002   //服务器地址或端口不可达
#define MC_ERROR_CONNECT_TIMEOUT            -3003   //命令连接超时
#define MC_ERROR_ROUTE                      -3008   //路由失败
#define MC_ERROR_CUI                        -3009   //服务为开启
#define MC_ERROR_CONNECT_ADDRESS            -3010   //地址不可达
#define MC_ERROR_USER                       -3301   //用户不存在
#define MC_ERROR_USER_DISABLED              -3302   //用户被禁用
#define MC_ERROR_PASSWORD                   -3306   //密码错误
#define MC_ERROR_CHECK_TIMEOUT              -3309   //认证超时
#define MC_ERROR_ROUTE_CUI                  -3310   //路由失败
#define MC_ERROR_NO_CUI                     -3503   //没有在线的用户接入服务
#define MC_ERROR_REDIRECT_CUI               -3504   //没有支持重定向的用户接入服务
#define DC_ERROR_DATA_TIMEOUT               -4005   //数据通道请求超时
#define DC_ERROR_CONNECT                    -4006   //连接错误
#define DC_ERROR_TCP_SEND                   -4007   //TCP发送出错
#define DC_ERROR_TCP_RECV                   -4008   //TCP接收出错

/** 路由ID类型 */
#ifndef _NC_ROUTE_ID_TYEP
#define _NC_ROUTE_ID_TYEP
#define NC_ROUTE_UNKNOWN					-1					// 未知/非法ID
#define NC_ROUTE_CUI						3					// 用户接入服务
#define NC_ROUTE_DISPATCH_SCHEDULER			5					// 分发调度服务
#define NC_ROUTE_PU							201					// 设备
#define NC_ROUTE_CU							153					// 用户连接
#define CSS_Scheduler						14					// 云存储调度

#endif	// _NC_ROUTE_ID_TYEP


typedef enum // 云台的转动的方向
{
    kCvs2PtzUp = 0,
    kCvs2PtzDown,
    kCvs2PtzLeft,
    kCvs2PtzRight,
}Cvs2PtzTurnDirection;

@class Cvs2VideoView;
@protocol MCHelperDelegate;

@interface MCHelper : NSObject

@property (nonatomic, readonly) NSString *version;
@property (nonatomic, assign) id<MCHelperDelegate>delegate;

/**
 *	@brief              连接服务器
 *
 *	@param 	address     地址
 *	@param 	usPort      端口
 *	@param 	userName 	用户名
 *	@param 	password 	密码
 *	@param 	epid        epid
 *
 *	@return             返回的错误码 0表示登录成功
 */
- (NSInteger)login:(NSString *)address
              port:(unsigned short)usPort
              user:(NSString *)userName
               psd:(NSString *)password
              epid:(NSString *)epid
         fixedAddr:(BOOL)fixed;

/**
 *	@brief	退出服务器
 */
- (void)loginOut;

/**
 *	@brief	获取当前服务器下所有的设备, 确保之前已经调用了fetchDomainNode,获取成功以后可以在rootDomain的childrenArray集合中查找
 *          这个函数会去发网络远程命令,一般只需要调用一次,除非想刷新资源.
 *	@param 	pDomain 	域节点
 *
 *	@return	错误码; 0表示成功
 */
- (NSArray *)fetchPeerUnits:(NSInteger *)error;

/**
 *	@brief	获取摄像头资源，确保之前已经调用了fetchDomainNode和fetchPeerUnits。如果参数peerUnit为空，则获取所有的设备。
 *          获取成功以后,如果想要查找某个摄像头,应该用摄像头的PUID和cIdx在对应的Cvs2PeerUnit实例的childrenArray集合中查找
 *
 *  @param 	pPU 	可为NULL或者域下某个具体的设备对象
 *
 *	@return	错误码; 0表示成功
 */
- (NSInteger)fetchCameras:(Cvs2PeerUnit *)peerUnit;

/**
 *	@brief	单独获取指定的PUID的设备和摄像头资源
 *
 *  @param 	puid
 *  @error 	错误码
 *  @param 	puid
 *
 *	@return	Cvs2PeerUnit 返回的Cvs2PeerUnit需要上层调用者释放。
 */
- (Cvs2PeerUnit *)fetchOnePU:(NSString *)puid error:(NSInteger *)err;

/**
 *	@brief	渲染视频接口.
 *
 *	@param 	puid 	视频资源的PUID
 *	@param 	ucIdx 	视频资源的index
 *	@param 	type 	流类型 0：高清 1：标清 注意：设备支持高清流，但标清不一定支持。
 *	@param 	renderView 	播放窗口, renderView必须是Cvs2VideoView类的实例.
 *
 *	@return	0 成功
 */
- (NSInteger)rend:(NSString *)puid index:(unsigned char)ucIdx streamType:(NSInteger)type target:(Cvs2VideoView *)renderView;

/**
 *	@brief	打开声音
 *
 *	开始播放复合流中的声音数据
 */
- (void)startAudio;
- (void)stopAudio;

/**
 *	@brief	开始和设备对讲
 *
 */
- (int)startCall;
- (void)stopCall;

/**
 *	@brief	停止视频
 */
- (void)stopRend;

/**
 *	@brief	转动摄像头,设备必须有云台才能转动
 *
 *	@param 	pVideo 	摄像头对象
 *	@param 	direction 	转动的方向
 *
 *	@return	0表示成功
 */
- (NSInteger)ptzStartTurn:(Cvs2ResEntity *)pCamera direction:(Cvs2PtzTurnDirection)direction;

/**s
 *	@brief	停止转动摄像头
 *
 *	@param 	pVideo 	摄像头对象
 *
 *	@return	0 表示成功
 */
- (NSInteger)ptzStopTurn:(Cvs2ResEntity *)pCamera;

/**
 *	@brief	缩放图像
 *
 *	@param 	pVideo 	进行缩放的摄像头对象
 *	@param 	zoomIn 	YES表示放大图像, NO表示缩小图像
 *
 *	@return	0 返回成功
 */
- (NSInteger)ptzStartZoom:(Cvs2ResEntity *)pVideo zoomIn:(BOOL)zoomIn;

/**
 *	@brief	停止缩放
 *
 *	@param 	pVideo 	摄像头对象
 *
 *	@return	0返回成功
 */
- (NSInteger)ptzStopZoom:(Cvs2ResEntity *)pVideo;

/**s
 *	@brief	移动云台至预置位，设备必须有云台才能转动
 *
 *	@param 	pVideo 	摄像头对象
 *
 *	@return	0 表示成功
 */
- (NSInteger)moveToPresetPos:(uint)pos videoRes:(Cvs2ResEntity *)pCamera;


- (UIImage *)currentImage;

/**s
 *	@brief	录制当前正在播放的视频.
 *
 *	@param 	path文件全路径，需带上后缀如.mp4
 *
 *	@return	0 表示成功
 */
- (NSInteger)startRecord:(NSString *)path;
- (void)stopRecord;

/**s
 *	@brief	抓拍.
 *
 *	@param 	path文件全路径，需带上后缀如.png
 *
 *	@return	0 表示成功
 */
- (BOOL)snapshot:(NSString *)path;

/**s
 *	@brief	发送xml报文
 *
 *	@param 	合法的xml报文
 *	@param 	ucDstIDType 路由id 参考上面的宏定义 比如发给设备应该为201
 *	@param 	puid 如果发给设备表示设备的puid，如果发送给服务器，可以为空
 *	@param 	inOutBuffer 响应报文
*	@param 	inOutLen 响应报文长度
 *
 *	@return	0 表示成功。 －1表示传入接收缓冲的长度不够，此时inOutLen返回应该传入的数据长度。
 */
- (int)postXMLMessage:(NSString *)xmlStr dstType:(unsigned char)ucDstIDType toPuid:(NSString *)puid recvBuf:(char *)inOutBuffer inLen:(int *)inOutLen;

@end

/**
 *	@brief	代理类
 */
@protocol MCHelperDelegate <NSObject>

/**
 *	@brief	这个代理方法是执行在子线程中,主要是侦测连接服务器,接受数据出错时返回的错误码
 *
 *	@param 	error 	返回的错误码
 */
- (void)connectError:(NSInteger)error;

@end


