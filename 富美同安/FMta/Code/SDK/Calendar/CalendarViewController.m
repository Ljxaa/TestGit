//
//  RecViewController.m
//  文广传媒
//
//  Created by _ADY on 14-6-26.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateHelp.h"
#import "Global.h"
@interface CalendarViewController ()

@end

#define mHight 60
//static LoadingView *loading= nil;

@implementation CalendarViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = bgColor;
    }
    return self;
}

-(void)popself
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)aInBction:(id)sender
{
    int type = (int)((UIButton*)sender).tag-1;
    if (type != selectedIndex) {
        selectedIndex = type;
    }
    [UIView animateWithDuration:.5 animations:^{
        [selectView setFrame:CGRectMake(selectedIndex*(self.view.bounds.size.width/sidebarArray.count), mHight-2, self.view.bounds.size.width/sidebarArray.count, 2)];
    }];
    [self gotoSectel];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, mHight)];
    bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bView];
    
    selectedIndex = 0;
    sidebarArray = [NSArray arrayWithObjects:@"开始时间",@"结束时间", nil];
    for (int i = 0; i < sidebarArray.count; i ++)
    {
        UIButton *inButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0,0, self.view.bounds.size.width/sidebarArray.count, mHight);
        [inButton setFrame:frame];
        
        [inButton setTitle:[sidebarArray objectAtIndex:i] forState:UIControlStateNormal];
        [inButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        inButton.titleLabel.textAlignment = 1;
        inButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+1];
        inButton.center = CGPointMake(self.view.bounds.size.width*i/sidebarArray.count+self.view.bounds.size.width/(sidebarArray.count*2), mHight/4);
        inButton.tag = i+1;
        [inButton addTarget:self action:@selector(aInBction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:inButton];
        
        UILabel *aLabel = [[UILabel alloc] init];
        [aLabel setFrame:CGRectMake(0, 0, self.view.bounds.size.width/sidebarArray.count, mHight/2)];
        aLabel.textAlignment = 1;
        aLabel.tag = i +10;
        aLabel.textColor = [UIColor redColor];
        aLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        aLabel.center = CGPointMake(self.view.bounds.size.width*i/sidebarArray.count+self.view.bounds.size.width/(sidebarArray.count*2), mHight*3/4);
        [self.view addSubview:aLabel];
    }

    
    selectView = [[UIView alloc] initWithFrame:CGRectMake(selectedIndex, mHight-2, self.view.bounds.size.width/sidebarArray.count, 2)];
    selectView.backgroundColor = [UIColor redColor];
    [self.view addSubview:selectView];
    
    calendar = [[VRGCalendarView alloc] init];
    CGRect frame = CGRectMake(0, mHight+1, self.view.bounds.size.width, screenMySize.size.height-mHight);
    calendar.backgroundColor = bgColor;
    calendar.frame = frame;
    calendar.delegate = self;
    [self.view addSubview:calendar];

    [self.view setUserInteractionEnabled:YES];
    [self.view setMultipleTouchEnabled:YES];

    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(addPressed)];

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treatedATask) name:kTreatedCompleteNotification object:nil];
}
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{

    NSDate* cm = calendarView.currentMonth;
    [self getPersonalCalendarCount:cm];
    
}
-(void)refreshCalendarCount
{
    [self getPersonalCalendarCount:calendar.currentMonth];
}

-(NSArray*)getMonthDays:(NSDate*)cm
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormat stringFromDate:cm];
    NSArray* array = [dateString componentsSeparatedByString:@"-"];
    int year = [[array objectAtIndex:0] intValue];
    int month = [[array objectAtIndex:1] intValue];
    int day = [[array objectAtIndex:2] intValue];

    
    DateHelp* d = [[DateHelp alloc] initWithMonth:month day:day year:year];
    int days = d.monthLength;
    
    NSString* start = [NSString stringWithFormat:@"%@-01 00:00:00", [dateString substringToIndex:7]];
    NSString* end = [NSString stringWithFormat:@"%@-%d 23:59:59", [dateString substringToIndex:7], days];
    
    NSArray* resultArray = [[NSArray alloc] initWithObjects:start, end, nil];
    
    [self gotoSectel];
    
    return resultArray;
    
}
-(void)setFlag:(NSArray*)array
{
    NSMutableArray* dayArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary* d in array)
    {
        NSString* DayKey = [[d objectForKey:@"DayKey"] objectForKey:@"text"];
        NSArray* ay = [DayKey componentsSeparatedByString:@"-"];
        int day = [[ay objectAtIndex:2] intValue];
        [dayArray addObject:[NSNumber numberWithInt:day]];
        
    }
    [calendar markDates:dayArray];
}


-(void)DsetFlag:(NSArray*)array
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormat stringFromDate:calendar.currentMonth];
    NSArray* array1 = [dateString componentsSeparatedByString:@"-"];
    int year = [[array1 objectAtIndex:0] intValue];
    int month = [[array1 objectAtIndex:1] intValue];
    int day = [[array1 objectAtIndex:2] intValue];
    
    DateHelp* d = [[DateHelp alloc] initWithMonth:month day:day year:year];
    int days = d.monthLength;
    
    NSString* start = [NSString stringWithFormat:@"%@-01", [dateString substringToIndex:7]];
    NSString* end = [NSString stringWithFormat:@"%@-%d", [dateString substringToIndex:7], days];
    
    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@""];
    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableArray* dayArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString* d1 in array)
    {
        
        NSString* d = [d1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        int aTime,bTime;
        if ([start intValue]> [d intValue])
        {
            aTime = [start intValue];
        }
        else
            aTime = [d intValue];
        
        if ([end intValue]> [d intValue])
        {
            bTime = [d intValue];
        }
        else
            bTime = [end intValue];
        
        
        NSString *aString = [NSString stringWithFormat:@"%d",aTime];
        NSString *bString = [NSString stringWithFormat:@"%d",bTime];
        if (aString.length<2 ||bString.length <2) {
            return;
        }
        NSString *aSubString = [aString substringFromIndex:aString.length-2];
        NSString *bSubString = [bString substringFromIndex:bString.length-2];

        for (int i = [aSubString intValue] ; i< [bSubString intValue]+1; i ++)
        {
            [dayArray addObject:[NSNumber numberWithInt:i]];
        }
        
    }
    [calendar markDates:dayArray];
}
- (void)getPersonalCalendarCount:(NSDate*)cm
{
    NSArray* array = [self getMonthDays:cm];
    [self DsetFlag:array];
//    NSString* start = [array objectAtIndex:0];
//    NSString* end = [array objectAtIndex:1];
//   
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:start forKey:@"beginDate"];
//    [dic setValue:end forKey:@"endDate"];

//    [serive PostFromURL:AGetConfDateList params:dic mHttp:httpUrl isLoading:NO];

}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    
    if ([urlName isEqualToString:AGetConfDateList])
    {
        if (dic != nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *a in dic) {
              [array addObject:a];
            }
            [self DsetFlag:array];
        }
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* selDateString = [dateFormatter stringFromDate:date];
    [delegate getTime:selDateString setIndex:selectedIndex];
    UILabel *aLabel = (UILabel*)[self.view viewWithTag:10+selectedIndex];
    aLabel.text = selDateString;
    if (selectedIndex == 0) {
        selectedIndex = 1;
        fTime = selDateString;
    }
    else
    {
        selectedIndex = 0;
        eTime = selDateString;
    }
    [UIView animateWithDuration:.5 animations:^{
        [selectView setFrame:CGRectMake(selectedIndex*(self.view.bounds.size.width/sidebarArray.count), mHight-2, self.view.bounds.size.width/sidebarArray.count, 2)];
    }];
    
    [self gotoSectel];
    
//        [self.navigationController popViewControllerAnimated:YES];

}
//选择颜色改变
-(void)gotoSectel
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (selectedIndex == 0) {
        if (fTime) {
            [array addObject:fTime];
        }
    }
    else
    {
        if (eTime) {
            [array addObject:eTime];
        }
    }

    [self Dset1Flag:array];
}

-(void)Dset1Flag:(NSArray*)array
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormat stringFromDate:calendar.currentMonth];
    NSArray* array1 = [dateString componentsSeparatedByString:@"-"];
    int year = [[array1 objectAtIndex:0] intValue];
    int month = [[array1 objectAtIndex:1] intValue];
    int day = [[array1 objectAtIndex:2] intValue];
    
    DateHelp* d = [[DateHelp alloc] initWithMonth:month day:day year:year];
    int days = d.monthLength;
    
    NSString* start = [NSString stringWithFormat:@"%@-01", [dateString substringToIndex:7]];
    NSString* end = [NSString stringWithFormat:@"%@-%d", [dateString substringToIndex:7], days];
    
    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@""];
    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableArray* dayArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString* d1 in array)
    {
        
        NSString* d = [d1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        int aTime;
        if ([start intValue] <= [d intValue] && [end intValue]>= [d intValue])
        {
            aTime = [d intValue];
        }

        NSString *aString = [NSString stringWithFormat:@"%d",aTime];
        if (aString.length<2 ) {
            return;
        }
        NSString *aSubString = [aString substringFromIndex:aString.length-2];

        [dayArray addObject:[NSNumber numberWithInt:[aSubString intValue]]];
        
        
    }
    [calendar markDates:dayArray];
}

//-(void)treatedATask
//{
//    returnReload = YES;
//}
//

//
//#pragma mark 新增
-(void)addPressed
{
    UILabel *aLabel = (UILabel*)[self.view viewWithTag:10];
    if (aLabel.text.length == 0) {
        [RequestSerive alerViewMessage:mkStartTime];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KsendSuccess object:self];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}

//#pragma mark 数据获取
//-(void)gotoAcquire
//{
//    [self getPersonalCalendarCount:calendar.currentMonth];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
