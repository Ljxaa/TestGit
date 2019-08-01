//
//  ToolCache.h
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolCache : NSObject

+(void)setSomething;
+(void)customViewDidLoad;

+ (void)setUserStrForDictionary:(NSDictionary *)aStr forKey:(NSString*)StrKey;
+ (NSDictionary *)userKeyForDictionary:(NSString*)StrKey;
+ (void)setUserStr:(NSString *)aStr forKey:(NSString*)StrKey;
+ (NSString *)userKey:(NSString*)StrKey;
+ (void)removeUserKey:(NSString*)StrKey;

+(int)setString:(NSString*)aString setSize:(int)aType setHight:(int)labelWight;
+(int)setString:(NSString*)aString setSize:(int)aType setWight:(int)labelWight;
#pragma mark 设置web字体大小
+(NSString*)webString;
#pragma mark 获取图片
+(NSMutableArray*)setUrlImage:(NSString*)string;
#pragma mark 更改html图片地址
+(NSString*)setHtmlStr:(NSString*)string;
#pragma mark 转Base64
+(NSString*)setUrlStr:(NSString*)str;
#pragma mark 调整行间距
+(NSMutableAttributedString*)attributedString:(NSString*)aString;
#pragma mark 获取周几
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
#pragma mark 手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
#pragma mark 数字手机号码校验（第一位和11位）
+ (BOOL)isCheckTel:(NSString *)str;
#pragma mark 用户名验证不能数字
+ (BOOL) validateUserAcount:(NSString *)name;
#pragma mark 用户名验证
+ (BOOL) validateUserName:(NSString *)name;
#pragma mark 密码验证
+ (BOOL) validatePassword:(NSString *)passWord;
#pragma mark 关注数据
+(NSMutableDictionary*)addgzRemData;

#pragma mark - 生成颜色。
+ (UIColor *) stringTOColor:(NSString *)str;
#pragma mark - 生成一张有尺寸的图。
+(UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size;
#pragma mark - 生成一张1*1小图。
+(UIImage *) createImageWithColor: (UIColor *) color;
#pragma mark - 设置手机样式
+ (void) SetPhoneDevice;
+ (NSInteger)GetPhoneDevice;
@end
