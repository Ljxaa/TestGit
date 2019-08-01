//
//  MapViewController.m
//  同安政务
//
//  Created by wx_air on 16/3/11.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "MapViewController.h"
#import "CCLocationManager.h"
#import "RequestSerive.h"
#import "Global.h"
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
@interface MapViewController ()<UIWebViewDelegate,CLLocationManagerDelegate>{
    UIWebView *webBodyView;
}
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) RequestSerive *serive;
@end

@implementation MapViewController
@synthesize type,url;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    
    webBodyView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    //下拉刷新和上拉刷新
    [webBodyView setBackgroundColor:[UIColor whiteColor]];
    [webBodyView setDelegate:self];
    [backView addSubview:webBodyView];
    
    if ([type isEqualToString:@"web"]) {
        [self loadHtmlWithUrl:url];
    }else{
        [self getLat];
    }
    
}
#pragma mark - 读取普通网页
-(void)loadHtmlWithUrl:(NSString *)loadUrl{
    if ([loadUrl isEqualToString:@"<null>"]) {
        loadUrl = @"https://www.baidu.com";
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURL *urlStr =[NSURL URLWithString:loadUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:urlStr];
    [webBodyView loadRequest:request];
}
#pragma mark - 读取地图网页
-(void)loadHtmlWithLNG:(float)lan withLAT:(float)lat{
    
    NSURL *urlStr =[NSURL URLWithString:[NSString stringWithFormat:@"http://218.5.80.4:12009/gh/index.html?lng=%f&lat=%f",lan,lat]];
    NSURLRequest *request =[NSURLRequest requestWithURL:urlStr];
    [webBodyView loadRequest:request];
}
-(void)getLat
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    [_locationManager setActivityType:CLActivityTypeFitness];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
    {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f;
    
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];
    }
    else {
        [RequestSerive alerViewMessage:@"请在设置中开启定位功能"];
    }
    
//    __block __weak MapViewController *wself = self;
//    //    NSLog(@"%d",)
//    if (IS_IOS8) {
//        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
//            NSLog(@"%f,%f",locationCorrrdinate.longitude,locationCorrrdinate.latitude);
//            [wself loadHtmlWithLNG:locationCorrrdinate.longitude withLAT:locationCorrrdinate.latitude];
//            //            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//            //            [dic setValue:@"" forKey:@""];
//            //            [dic setValue:@"" forKey:@""];
//            ////            [wself.serive GetFromURL:KGetMap params:dic mHttp:httpUrl isLoading:NO];
//            //            [wself.serive GetFromURL:KGetMap params:dic mHttp:@"" isLoading:YES];
//            //            NSLog(@"%f %f",,locationCorrrdinate.longitude);
//            
//            //            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
//        }];
//    }else{
//        [RequestSerive alerViewMessage:@"定位失败"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}
#pragma mark - CLLocationManagerDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    [self loadHtmlWithLNG:newLocation.coordinate.longitude withLAT:newLocation.coordinate.latitude];
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [RequestSerive alerViewMessage:@"定位错误"];
    NSLog(@"error:%@",error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
