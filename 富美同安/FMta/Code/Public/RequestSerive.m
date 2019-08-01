//
//  RequestSerive.m
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "RequestSerive.h"
#import "MKNetworkKit.h"
#import "XMLReader.h"
#import "JSONKit.h"
#import "Global.h"
#import "GiFHUD.h"

#import "AppDelegate.h"
#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@implementation RequestSerive
@synthesize delegate;
#define kFilePath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#pragma mark - POST方式获取
- (void)PostFromURL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading
{
    NSLog(@"Post数据%@",data);
    if (loading) {
        [GiFHUD setGifWithImageName:@"bp.gif"];
        [GiFHUD showWithOverlay];
    }

    MKNetworkHost *host = [[MKNetworkHost alloc]initWithHostName:mhttp];
    MKNetworkRequest *request = [host requestWithPath:Path params:data httpMethod:@"POST"];
    NSMutableDictionary *header=[[NSMutableDictionary alloc]init];
    [header setValue:@"application/json; encoding=utf-8" forKey:@"Content-Type"];
    [header setValue:@"application/json" forKey:@"Accept"];
    [request addHeaders:header];
    
    //    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
    //        NSLog(@"%@", cookie);
    //    }
    
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest){
        if ([completedRequest responseData]==nil)
        {
//            NSLog(@"POST数据dic_error = %@",[completedRequest responseAsString]);
//            [self alerViewMessage:[completedRequest responseAsString]];
            [delegate responseData:nil mUrl:Path];
        }
        else
        {
            NSLog(@"POST数据dic %@",[completedRequest responseAsString]);
//            [delegate responseData:[completedRequest responseAsJSON] mUrl:Path];
            NSDictionary *temp = [XMLReader dictionaryForXMLData:[completedRequest responseData] error:nil];
            NSString *content = [[temp objectForKey:@"string"] objectForKey:@"text"];
            NSDictionary *ret = nil;
            NSString *flgDicStr,*msgDicStr;
            if ([mhttp isEqualToString:OA_URL] || [Path isEqualToString:AOALogin2]||[Path isEqualToString:AOAGetLeader]||[Path isEqualToString:APwdChange2]||[Path isEqualToString:APhoneCode]||[Path isEqualToString:AgetTask]||[Path isEqualToString:AgetSignGWJH]||[Path isEqualToString:AgetSignHYTZ]||[Path isEqualToString:AgetOACount]||[Path isEqualToString:AgetSignHYTZ]||[Path isEqualToString:AgetHYTZDetail]||[Path isEqualToString:IPhoneCode])
            {
                ret = [XMLReader dictionaryForXMLString:content error:nil];
//                if ([Path isEqualToString:AgetOACount]) {
////                    NSLog(@"POST数据dic %@",ret);
//                    kAlertShow(ret[@"NewDataSet"][@"Table"][@"msg"][@"text"]);
//                }
                if ([ret isKindOfClass:[NSDictionary class]] && [ret.allKeys containsObject:@"flg"]) {
                    flgDicStr = ret[@"flg"][@"text"];
                    msgDicStr = ret[@"msg"][@"text"];
                }
                
            }
            else{
                ret = [content objectFromJSONString];
                if ([ret isKindOfClass:[NSDictionary class]] && [ret.allKeys containsObject:@"flg"]) {
                    flgDicStr = ret[@"flg"];
                    msgDicStr = ret[@"msg"];
                }
                
            }
            if (flgDicStr != nil &&[flgDicStr integerValue] == 5) {
                
                [APPDELEGATE.tabbarController dismissViewControllerAnimated:YES completion:^(void){
                    kAlertShow(ret[@"msg"]);
                }];
            }else{
                [delegate responseData:ret mUrl:Path];
            }
//            NSLog(@"POST数据dic %@",ret);
        }
        
        if (loading)
            [GiFHUD dismiss];
    }];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [host startRequest:request];
    });
    if (requestArray == nil) {
        requestArray = [[NSMutableArray alloc] init];
    }
    [requestArray addObject:request];
}
#pragma mark - GET方式获取
- (void)GetFromURL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading
{
    NSLog(@"Get数据%@",data);
    if (loading) {
        [GiFHUD setGifWithImageName:@"bp.gif"];
        [GiFHUD showWithOverlay];
    }
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSLog(@"session:%@",session.sessionDescription);
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:mhttp];
    MKNetworkRequest *request = [host requestWithPath:Path params:data httpMethod:@"GET"];
    NSMutableDictionary *header=[[NSMutableDictionary alloc]init];
    [header setValue:@"application/json; encoding=utf-8" forKey:@"Content-Type"];
    [header setValue:@"application/json" forKey:@"Accept"];
    [request addHeaders:header];
    
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
//        NSLog(@"responseAsStringresponseAsString:%@",[[completedRequest responseAsString]]);
        if ([completedRequest responseData]==nil) {
            //            [self alerViewMessage:[completedRequest responseAsString]];
            [delegate responseData:nil mUrl:Path];
        }
        else
        {
            //            [delegate responseData:[completedRequest responseAsJSON] mUrl:Path];
            NSDictionary *temp = [XMLReader dictionaryForXMLData:[completedRequest responseData] error:nil];
            NSString *content = [[temp objectForKey:@"string"] objectForKey:@"text"];
            NSDictionary *ret = nil;
            NSString *flgDicStr,*msgDicStr;
            if ([mhttp isEqualToString:OA_URL]||[Path isEqualToString:AOAGetGroups]||[Path isEqualToString:AOAGetGroupUsers]||[Path isEqualToString:AOAGetDept]||[Path isEqualToString:AOAgetGroupID]||[Path isEqualToString:AOAGetDept]||[Path isEqualToString:AgetServiceDateTime]||[Path isEqualToString:AOAGetGroupsForUnit])
            {
                ret = [XMLReader dictionaryForXMLString:content error:nil];
                if ([ret isKindOfClass:[NSDictionary class]] && [ret.allKeys containsObject:@"flg"]) {
                    flgDicStr = ret[@"flg"][@"text"];
                    msgDicStr = ret[@"msg"][@"text"];
                }
            }
            else
            {
                ret = [content objectFromJSONString];
                if ([ret isKindOfClass:[NSDictionary class]] && [ret.allKeys containsObject:@"flg"]) {
                    flgDicStr = ret[@"flg"];
                    msgDicStr = ret[@"msg"];
                }
            }
            NSLog(@"Get数据dic %@",ret);
            
            if (flgDicStr != nil &&[flgDicStr integerValue] == 5) {
                
                [APPDELEGATE.tabbarController dismissViewControllerAnimated:YES completion:^(void){
                    kAlertShow(ret[@"msg"]);
                }];
            }else{
                [delegate responseData:ret mUrl:Path];
            }
        }
        
        if (loading)
            [GiFHUD dismiss];
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [host startRequest:request];
    });
    if (requestArray == nil) {
        requestArray = [[NSMutableArray alloc] init];
    }
    [requestArray addObject:request];
}
#pragma mark - GET方式获取
- (void)GetFromOA_File_URL:(NSString *)Path params:(NSDictionary *)data mHttp:(NSString*)mhttp isLoading:(BOOL)loading
{
//    NSLog(@"Get数据%@",data);
    if (loading) {
        [GiFHUD setGifWithImageName:@"bp.gif"];
        [GiFHUD showWithOverlay];
    }
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:mhttp];
    MKNetworkRequest *request = [host requestWithPath:Path params:data httpMethod:@"GET"];
//    NSMutableDictionary *header=[[NSMutableDictionary alloc]init];
//    [header setValue:@"application/json; encoding=utf-8" forKey:@"Content-Type"];
//    [header setValue:@"application/json" forKey:@"Accept"];
//    [request addHeaders:header];
    
    [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
//        NSLog(@"Get数据dic%@",[completedRequest responseData]);
        if ([completedRequest responseData]==nil) {
            //            [self alerViewMessage:[completedRequest responseAsString]];
            [delegate responseData:nil mUrl:Path];
        }
        else
        {
            NSLog(@"Get数据dic %@",[completedRequest responseAsString]);
            NSData *resData = [completedRequest responseData];
//            NSString *filename=[Path stringByAppendingPathComponent:[SendService QLPreview]];
//            [resData writeToFile:filename atomically:YES];
            
            NSString *key = [NSString stringWithFormat:@"cache_filr.doc"];
            //    NSLog(@"缓存位置:%@",key);
            [NSKeyedArchiver archiveRootObject:resData toFile:[kFilePath stringByAppendingPathComponent:key]];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%@/%@",kFilePath,key] forKey:@"filePath"];
            
            [delegate responseData:dic mUrl:Path];
        }
        
        
        if (loading)
            [GiFHUD dismiss];
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [host startRequest:request];
    });
    if (requestArray == nil) {
        requestArray = [[NSMutableArray alloc] init];
    }
    [requestArray addObject:request];
}
#pragma mark - POST上传
- (void)UpLoadData:(NSString *)Path params:(NSDictionary *)dic mHttp:(NSString*)mhttp isLoading:(BOOL)loading
{
     if (loading)
     {
         [GiFHUD setGifWithImageName:@"bp.gif"];
         [GiFHUD showWithOverlay];
     }
    
    MKNetworkHost *host = [[MKNetworkHost alloc]initWithHostName:mhttp];
    MKNetworkRequest *request;
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        
        request = [host requestWithPath:Path params:nil httpMethod:@"POST" body:tempJsonData ssl:NO];
        [request setParameterEncoding:MKNKParameterEncodingJSON];
        
        NSMutableDictionary *header=[[NSMutableDictionary alloc]init];
        [header setValue:@"application/json; encoding=utf-8" forKey:@"Content-Type"];
        [header setValue:@"application/json" forKey:@"Accept"];
        [request addHeaders:header];
        
        [request addCompletionHandler:^(MKNetworkRequest *completedRequest) {
            if ([completedRequest responseData]==nil) {
//                [self alerViewMessage:[completedRequest responseAsString]];
                [delegate responseData:nil mUrl:Path];
            }else{
//                [delegate responseData:[completedRequest responseAsJSON] mUrl:Path];
                NSDictionary *temp = [XMLReader dictionaryForXMLData:[completedRequest responseData] error:nil];
                NSString *content = [[temp objectForKey:@"string"] objectForKey:@"text"];
                NSDictionary *ret = nil;
                if ([mhttp isEqualToString:OA_URL])
                {
                    ret = [XMLReader dictionaryForXMLString:content error:nil];
                }
                else
                    ret = [content objectFromJSONString];
                NSLog(@"POST上传dic %@",ret);
                [delegate responseData:ret mUrl:Path];
            }
            if (loading)
                [GiFHUD dismiss];
        }];
        [host startRequest:request];
    }
    if (requestArray == nil) {
        requestArray = [[NSMutableArray alloc] init];
    }
    [requestArray addObject:request];
}

#pragma mark 取消请求
-(void)cancelRequest
{
    for (MKNetworkRequest *request in requestArray) {
        [request cancel];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [requestArray removeAllObjects];
        requestArray = [[NSMutableArray alloc] init];
    });
}

#pragma mark UIAlertView弹窗
+(void)alerViewMessage:(NSString*)message
{
    if ([message isEqualToString:@"<null>"] ||![message hash]||[message isEqualToString:@"(null)"])
    {
        return;
    }
    NSRange range = [message rangeOfString:@"!"];//判断字符串是否包含
     NSRange range1 = [message rangeOfString:@"！"];//判断字符串是否包含
    if (range.length<=0 && range1.length<=0)
    {
        message = [NSString stringWithFormat:@"%@!",message];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    float timeFloat = 1.5;
    if (message.length > 15) {
        timeFloat = 3.0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeFloat * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //异步执行
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

@end
