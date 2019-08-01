//
//  RequestSerive.h
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSeriveDelegate <NSObject>
- (void)responseData:(NSDictionary*)dic mUrl:(NSString*)urlName;
@end
@interface RequestSerive : NSObject
{
    id <RSeriveDelegate> delegate;
     NSMutableArray *requestArray;

}
@property (nonatomic,retain) id <RSeriveDelegate> delegate;

#pragma mark - POST方式获取
- (void)PostFromURL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading;
#pragma mark - GET方式获取
- (void)GetFromURL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading;
#pragma mark - POST上传
- (void)UpLoadData:(NSString *)Path params:(NSDictionary *)dic mHttp:(NSString*)mhttp isLoading:(BOOL)loading;
- (void)GetFromOA_File_URL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading;
#pragma mark 取消请求
-(void)cancelRequest;
#pragma mark UIAlertView弹窗
+(void)alerViewMessage:(NSString*)message;
@end
