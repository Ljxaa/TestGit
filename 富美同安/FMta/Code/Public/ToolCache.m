//
//  ToolCache.m
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "ToolCache.h"
#import "Global.h"
#import "GTMBase64.h"
#import "XMLReader.h"
#import "RegExCategories.h"

@implementation ToolCache

+(void)setSomething
{

}

+(void)customViewDidLoad
{
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_white"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    [UINavigationBar appearance].backItem.backBarButtonItem = item;
    if (![ToolCache userKey:kFontSize]) {
        [ToolCache setUserStr:[fontArray objectAtIndex:0] forKey:kFontSize];
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
                [[UINavigationBar appearance] setTitleTextAttributes:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [UIColor whiteColor],
                  NSForegroundColorAttributeName,
                  [UIFont fontWithName:@"QuicksandBold-Regular" size:labelSize],
                  NSFontAttributeName,
                  nil]];
    }

    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"title_logo_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}

+ (void)setUserStrForDictionary:(NSDictionary *)aStr forKey:(NSString*)StrKey
{
    [[NSUserDefaults standardUserDefaults] setObject:aStr forKey:StrKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)userKeyForDictionary:(NSString*)StrKey
{
    NSDictionary *accountId = [[NSUserDefaults standardUserDefaults] objectForKey:StrKey];
    return accountId;
}

+ (void)removeUserKey:(NSString*)StrKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:StrKey];
}

+ (void)setUserStr:(NSString *)aStr forKey:(NSString*)StrKey
{
    [[NSUserDefaults standardUserDefaults] setObject:aStr forKey:StrKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userKey:(NSString*)StrKey
{
    NSString *accountId = [[NSUserDefaults standardUserDefaults] objectForKey:StrKey];
    return accountId;
}

+(int)setString:(NSString*)aString setSize:(int)aType setHight:(int)labelWight
{
    if (![aString hash] || (id)aString == [NSNull null])
        return 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:aType]};
        CGSize totalTextSize = [aString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelWight) options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return totalTextSize.width+5;
    }
    else
    {
        CGSize totalTextSize = [aString sizeWithFont:[UIFont systemFontOfSize:aType]
                                   constrainedToSize:CGSizeMake(CGFLOAT_MAX, labelWight)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        return totalTextSize.width+5;
    }
}

+(int)setString:(NSString*)aString setSize:(int)aType setWight:(int)labelWight
{
    if (![aString hash] || (id)aString == [NSNull null])
        return 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:aType]};
        CGSize totalTextSize = [aString boundingRectWithSize:CGSizeMake(labelWight, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return totalTextSize.height+10;
    }
    else
    {
        CGSize totalTextSize = [aString sizeWithFont:[UIFont systemFontOfSize:aType]
                                                                        constrainedToSize:CGSizeMake(labelWight,CGFLOAT_MAX)
                                                                            lineBreakMode:NSLineBreakByWordWrapping];
        return totalTextSize.height+10;
    }
}

#pragma mark 设置web字体大小
+(NSString*)webString
{
    int lSize = [[ToolCache userKey:kFontSize] intValue];
    
    NSString *webviewText =  [NSString stringWithFormat:@"<style>body{margin:0;background-color:transparent;font:%dpx/%dpx Custom-Font-Name}img{width: %fpx}</style>",lSize,lSize+4,screenMySize.size.width-20];
    return webviewText;
}

#pragma mark 获取图片
+(NSMutableArray*)setUrlImage:(NSString*)string
{
    NSMutableArray *showControls = [[NSMutableArray alloc] init];
    NSArray* words = [string matches:RX(@"<\\s*img\\b[^>]*?\\bsrc\\b\\s*?=\\s*?(\"|').*?(\"|')")];
    for (NSString* src in words){
        NSString* srcDeal = [src stringByReplacingOccurrencesOfString:[src firstMatch:RX(@"<\\s*img\\b[^>]*? src.*?=.*?(\"|')")] withString:@""];
        if ([srcDeal hasSuffix:@"\""] || [srcDeal hasSuffix:@"'"]){
            srcDeal = [srcDeal substringToIndex:srcDeal.length-1];
            [showControls addObject:srcDeal];
        }
    }
    
    
//    NSMutableArray *showControls = [[NSMutableArray alloc] init];
//    NSArray *controls = [string componentsSeparatedByString:@"<img"];
//    if (controls.count > 1) {
//        for (NSString *temp in controls)
//        {
//            NSArray *controls1 = [temp componentsSeparatedByString:@"src=\""];
//            if (controls1.count > 1)
//            {
//                 for (NSString *temp1 in controls1)
//                 {
//                     NSArray *a = [temp1 componentsSeparatedByString:@"\"/>"];
//                     NSArray *b = [temp1 componentsSeparatedByString:@"\" />"];
//                     NSArray *c = [temp1 componentsSeparatedByString:@"g\">"];
//                     if (a.count > 1) {
//                         [showControls addObject:[a objectAtIndex:0]];
//                     }
//                     else if (b.count > 1) {
//                         [showControls addObject:[b objectAtIndex:0]];
//                     }
//                     else if (c.count > 1) {
//                         [showControls addObject:[NSString stringWithFormat:@"%@g",[c objectAtIndex:0]]];
//                     }
//                 }
//            }
//        }
//    }

    NSMutableArray *showArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < showControls.count; i ++)
    {
        NSString *aShowStr = [showControls objectAtIndex:i];
//        aShowStr = [aShowStr stringByReplacingOccurrencesOfString:@"http://wg.xmta.gov.cn/legend_note_client/image.do?id=" withString:@""];
//        aShowStr = [aShowStr stringByReplacingOccurrencesOfString:@"image.do?id=" withString:@""];
//        
//        NSArray *a = [aShowStr componentsSeparatedByString:@"&"];
//        if (a.count > 1) {
//            aShowStr = [a objectAtIndex:0];
//        }
        
        NSRange range = [aShowStr rangeOfString:@"http"];
        if (range.length >0)//包含
        {
            [showArray addObject:[NSString stringWithFormat:@"%@",aShowStr]];
        }
        else//不包含
        {
             [showArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,aShowStr]];
        }
    }

    return showArray;
}


#pragma mark 更改html图片地址
+(NSString*)setHtmlStr:(NSString*)string
{
    NSMutableArray *showControls = [[NSMutableArray alloc] init];
    NSArray *controls = [string componentsSeparatedByString:@"<img"];
    if (controls.count > 1) {
        for (NSString *temp in controls)
        {
            NSArray *controls1 = [temp componentsSeparatedByString:@"src=\""];
            if (controls1.count > 1)
            {
                for (NSString *temp1 in controls1)
                {
                    NSArray *a = [temp1 componentsSeparatedByString:@"\"/>"];
                    NSArray *b = [temp1 componentsSeparatedByString:@"\" />"];
                    NSArray *c = [temp1 componentsSeparatedByString:@"g\">"];
                    if (a.count > 1) {
                        [showControls addObject:[a objectAtIndex:0]];
                    }
                    else if (b.count > 1) {
                        [showControls addObject:[b objectAtIndex:0]];
                    }
                    else if (c.count > 1) {
                        [showControls addObject:[NSString stringWithFormat:@"%@g",[c objectAtIndex:0]]];
                    }
                }
            }
        }
    }
    
    NSMutableArray *showArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < showControls.count; i ++)
    {
        NSString *aShowStr = [showControls objectAtIndex:i];
//        aShowStr = [aShowStr stringByReplacingOccurrencesOfString:@"http://wg.xmta.gov.cn/legend_note_client/image.do?id=" withString:@""];
//        aShowStr = [aShowStr stringByReplacingOccurrencesOfString:@"image.do?id=" withString:@""];
//        
//        NSArray *a = [aShowStr componentsSeparatedByString:@"&"];
//        if (a.count > 1) {
//            aShowStr = [a objectAtIndex:0];
//        }
        
        NSRange range = [aShowStr rangeOfString:@"http"];
        if (range.length >0)//包含
        {
            [showArray addObject:[NSString stringWithFormat:@"%@",aShowStr]];
        }
        else//不包含
        {
            [showArray addObject:[NSString stringWithFormat:@"%@%@",imageUrl,aShowStr]];
        }
    }
    for (int i = 0 ; i < showControls.count; i++) {
      string = [string stringByReplacingOccurrencesOfString:[showControls objectAtIndex:i] withString:[showArray objectAtIndex:i]];
    }
    
    return string;
}

#pragma mark 转Base64
+(NSString*)setUrlStr:(NSString*)str
{
    NSData* xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *retStr = [GTMBase64 stringByEncodingData:xmlData];
    return retStr;
}

#pragma mark 调整行间距
+(NSMutableAttributedString*)attributedString:(NSString*)aString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [aString length])];
    
    return attributedString;
}

#pragma mark 获取周几
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

#pragma mark 手机号码验证

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-345-9]|7[013678])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isCheckTel:(NSString *)str
{
    if (str.length < 11 || str.length > 11) {
        return NO;
    }else if([str characterAtIndex:0] != '1') {
        return NO;
    }
    else if([str characterAtIndex:1] <= '0'||[str characterAtIndex:1] > '9') {
        return NO;
    }else {
        return YES;
    }
}

#pragma mark 用户名验证不能数字
+ (BOOL) validateUserAcount:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z]{0,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

#pragma mark 用户名验证
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{0,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

#pragma mark 密码验证
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

#pragma mark 关注数据
+(NSMutableDictionary*)addgzRemData
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"Home-%@.plist",[ToolCache userKey:kAccount]]];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    return remData;
}
#pragma mark - 生成颜色。
+ (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }else if (str.length<7) {
        str=[NSString stringWithFormat:@"%@%@",str,[str substringFromIndex:1]];
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
#pragma mark - 生成一张有尺寸的纯色图。
+(UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - 生成一张1*1小图。
+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGSize size = CGSizeMake(1, 1);
    return [self createImageWithColor:color size:size];
}
#pragma mark - 设置手机样式
+ (void) SetPhoneDevice{
    NSInteger Device;
    if (screenMySize.size.height<500) {
        Device=iPhone4;
    }else if (screenMySize.size.height<600){
        Device=iPhone5;
    }else if (screenMySize.size.height<700){
        Device=iPhone6;
    }else{
        Device=iPhone6p;
    }
    NSLog(@"==-=--==-=%ld",Device);
    [[NSUserDefaults standardUserDefaults] setInteger:Device forKey:uPhoneType];
}
+ (NSInteger)GetPhoneDevice{
    //    NSString* phoneModel = [[UIDevice currentDevice] model];
    return [[NSUserDefaults standardUserDefaults] integerForKey:uPhoneType];
}
@end
