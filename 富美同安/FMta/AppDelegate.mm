//
//  AppDelegate.m
//  同安政务
//
//  Created by _ADY on 15/12/16.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "AppDelegate.h"
#import "ToolCache.h"
#import "ViewController.h"
#import "NewMenuItem.h"
#import "Global.h"
#import "MyNavigationController.h"
#import "Reachability.h"
//#import "MCHelper.h"

@interface AppDelegate (){
//    ViewController* _viewController;
}
@property(nonatomic,retain) Reachability *hostReachability;
//@property(nonatomic,retain) MCHelper *wrapper;
@end

@implementation AppDelegate

//- (void)dealloc
//{
//    [_window release];
//    [_viewController release];
//    [navContrller release];
//    [self.wrapper release];
//    [super dealloc];
//}

- (void)connectError:(NSInteger)error
{
    
}

+ (AppDelegate *)app
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSMutableCharacterSet* set = [[NSMutableCharacterSet alloc] init];
    [set formUnionWithCharacterSet:CharacterSet];
    NSString* subString = [token stringByTrimmingCharactersInSet:set]; // stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]
    
    
    NSArray* array = [subString componentsSeparatedByString:@" "];
    NSMutableString* tokenString = [[NSMutableString alloc] initWithCapacity:40];
    for (NSString* s in array)
    {
        [tokenString appendString:s];
    }
    
    [ToolCache setUserStr:tokenString forKey:kDeviceToken];
    NSLog(@"tokenString = %@", tokenString);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [aWrapper release];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSLog(@"setUrlStrsetUrlStr:%@",[ToolCache setUrlStr:@"abc,123"]);
    
    //网络监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.baidu.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoHome) name:kReturnHome object:nil];
    
    //    //消息推送注册
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
    //                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
    //                                                                             categories:nil]];
    //        [[UIApplication sharedApplication] registerForRemoteNotifications];
    //    }
    //    else
    //    {
    //        //消息推送注册
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
    //    }
    
    [ToolCache customViewDidLoad];
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [ToolCache setUserStr:identifierForVendor forKey:kDeviceToken];
    
    
    //    [@"" archiveWithKey:@"NewsClass"];
    //    [ToolCache setUserStr:@"121e12f33323e13" forKey:kDeviceToken];
    [self gotoHome];
    
    
    [self.window makeKeyAndVisible];
    
    //设置尺寸
    [ToolCache SetPhoneDevice];
    
    return YES;
}

-(void)gotoHome
{
    ViewController* vc1 = [[ViewController alloc] init];
    MyNavigationController* nav1 = [[MyNavigationController alloc] initWithRootViewController:vc1];
    self.window.rootViewController = nav1;
    
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[ToolCache userKey:KallowRotation] isEqualToString:@"1"]) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^()
    //     {
    //         //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
    //     }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //后台到前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable)
    {
        //        kAlertShow(@"当前网络未连接");
        [[NSUserDefaults standardUserDefaults] setObject:@"当前网络未连接" forKey:@"networkState"];
    }
    else if (status == ReachableViaWWAN)
    {
        //        kAlertShow(@"当前使用手机网络");
        //        my_wifi = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"当前使用手机网络" forKey:@"networkState"];
    }
    else if (status == ReachableViaWiFi)
    {
        //        kAlertShow(@"当前使用WIFI");
        //        my_wifi = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"当前使用WIFI" forKey:@"networkState"];
        
    }
    
}
@end
