//
//  Global.h
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
//#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif

//－－－－－测试地址－－－－－//
//#define httpUrl @"172.16.36.198:9007/MIS/"//开发时用
//#define OA_URL @"172.16.36.40"
//#define imageUrl @"http://172.16.36.198:9007"
//#define XKimageUrl @"http://218.5.80.4:14001"
//＝＝＝＝＝测试地址＝＝＝＝＝//

//－－－－－发布地址－－－－－//
//#define httpUrl @"121.40.163.175:8092/MIS" //APP接口
//#define imageUrl @"http://121.40.163.175:8092" //图片
//#define OA_URL @"121.40.163.175:8092" //OA接口
//＝＝＝＝＝发布地址＝＝＝＝＝//

//－－－－－金砖新发布地址－－－－－//
#define httpUrl @"222.76.243.127:8092" //APP接口
#define imageUrl @"http://222.76.243.127:8092" //图片
#define OA_URL @"121.40.163.175:8092" //OA接口

#define XKimageUrl @"http://222.76.243.117:8001"
//＝＝＝＝＝金砖新发布地址＝＝＝＝＝//

//－－－－－测试－－－－－//
//#define httpUrl @"218.5.80.4:14002/MIS" //APP接口
//#define imageUrl @"http://218.5.80.4:14002" //图片
//#define OA_URL @"121.40.163.175:8092" //OA接口
//
//#define XKimageUrl @"http://218.5.80.4:14001"
//＝＝＝＝＝测试＝＝＝＝＝//

#define bgColor [UIColor colorWithRed:247/255.0 green:246/255.0 blue:246/255.0 alpha:1]

#define caozuoUrl @"http://222.76.243.119:8092/Pages/admin/Operation.aspx"

//尺寸
#define iPhone4 4
#define iPhone5 5
#define iPhone6 6
#define iPhone6p 7
#define uPhoneType @"uPhoneType"

#define TXLText @"厦门同安"//厦门同安
#define LabelS @"上一级"
#define groupID @"2"
#define Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define mAddressSuccessful @"同步成功!"
#define mAddressFailure @"同步失败!"
#define mGTo @"确定同步常用联系人?"
#define mGATo @"确定同步通讯录？"
#define mActionSuccess @"提交成功"
#define mActionFailure @"提交失败"
#define mDeleteSuccess @"删除成功"
#define mDeleteFailure @"删除失败"
#define mAccount @"用户名不能为空"
#define mPassword @"密码不能为空"

#define mPasswordLong @"密码长度不能大于16"
#define mPass @"前后两次输入密码不一致"
#define mOldPass @"旧密码不能为空"
#define mNewPass @"新密码不能为空"
#define mSurePass @"确认密码不能为空"

#define mkTitle @"请填写标题"
#define mkDays @"请选择日期"
#define mkLeaders @"请选择相关领导"
#define mkProject @"请选择项目"
#define mkUnit @"请选择单位"
#define mkContent @"请填写内容"
#define mkStartTime @"请选择开始时间"
#define mkDept @"请选择部门"

#define kAccount @"kAccount"
#define kPassword @"kPassword"
#define kAccountD @"kAccountD"
#define kPasswordD @"kPasswordD"
#define kUserGoupID @"kUserGoupID"

#define kSex @"kSex"
#define kDspName @"kDspName"
#define kUserImage @"kUserImage"
#define kTitle @"kTitle"
#define kDeviceToken @"kDeviceToken"
#define kLastTime @"kLastTime"
#define KallowRotation @"allowRotation"
#define KsendSuccess @"KsendSuccess"
#define KRemember @"KRemember"
#define KPushNum @"KPushNum"
#define kFontSize @"kFontSize"
#define kPushNumWay @"kPushNumWay"
#define kPermissions @"kPermissions"
#define KAppRoleID @"KAppRoleID"
#define KPhoneNumber @"kUSER_Mb"
#define KType_no1_Ids @"kType_no1_Ids"

#define KGroupVerson @"KGroupVerson"//记录更新通讯录版本
#define KNewGroupVerson @"KNewGroupVerson"//记录更新通讯录版本

#define KMessageVerson @"KMessageVerson"//记录通知版本
#define KMessageUser @"KMessageUser"//记录通知查看的人

#define ACheckCommunication @"/AppUpgrade.asmx/CheckCommunication"//获取通讯录更新

#define AGetGroups @"/taqzfydoa/app.asmx/GetGroups"
#define AGetUsers @"/taqzfydoa/app.asmx/GetUsers"
#define AGetGroupUsers @"/taqzfydoa/app.asmx/GetGroupUsers"
#define AOAGetDept @"/OAService.asmx/OAGetDept"

#define AOAGetPerPhotoList_LD @"/OAService.asmx/GetPerPhotoList_LD"//17年8月24，区委抄告单获取列表接口
#define AOAGetLeader @"/OAService.asmx/OAGetLeader"

#define ACheckIOSPhone @"/AppUpgrade.asmx/CheckIOSPhone"
#define AOALogin2 @"/OAService.asmx/OALogin2"
#define APwdChange2 @"/OAService.asmx/PwdChange2"
#define AOAgetGroupID @"/OAService.asmx/OAgetGroupID"
#define AGetPosition @"/OAService.asmx/GetPosition"
#define APhoneCode @"/OAService.asmx/PhoneCode"//注册
#define IPhoneCode @"/OAService.asmx/IForgotPassword"//忘记密码发送验证码


#define APullPerPhotoListByClassID @"/PerPhotosService.asmx/PullPerPhotoListByClassID"
#define AGetDepartmentClassList @"/PerPhotosService.asmx/GetDepartmentClassList"
#define AGetPerPhotoList @"/PerPhotosService.asmx/GetPerPhotoList"
#define AGetPerPhotoList_All @"/PerPhotosService.asmx/GetPerPhotoList_All"
#define AGetPerPhotoList_LD @"/PerPhotosService.asmx/GetPerPhotoList_LD"
//17.8.27
#define AGetPerPhotoList_CGD @"/PerPhotosService.asmx/GetPerPhotoList_CGD"

#define AGetleaveList @"/PerPhotosService.asmx/GetleaveList"//外出报告
#define AGetConfList @"/PerPhotosService.asmx/GetConfList"
#define AGetConfDateList @"/PerPhotosService.asmx/GetConfDateList"
#define AGetDTInfoList @"/DTInfoService.asmx/GetDTInfoList"
#define AGetNewsList @"/NewsService.asmx/GetNewsList"

#define AGetDuBanList @"/NewsService.asmx/GetDuBanList"
#define AGetVideosList @"/VideosService.asmx/GetVideosList"//视频新闻列表
#define AGetVideosClassList @"/VideosService.asmx/GetVideosClassList"//视频新闻分类

#define AGetZengCaiList @"/NewsService.asmx/GetZengCaiList"
#define AUploadPhotoData @"/PerPhotosService.asmx/UploadPhotoData"//发送
#define AGetTodayList @"/NewsService.asmx/GetTodayList"//同安今日头条类别
#define AGetztjNewsList @"/NewsService.asmx/GetztjNewsList"//同安今日头条第二个分类的接口

#define AGetKnowledgeBaseIdList @"/NewsService.asmx/GetKnowledgeBaseIdList"//知识库类别
#define AGetzzcbList @"/NewsService.asmx/GetzzcbList"//政策采编类别
#define ACheckIfHasMsgNotice @"/NewsService.asmx/CheckIfHasMsgNotice"//获取数量 ldhd  hytz  jrtt  zcdt  gpdb  spxw
#define AUpFeedback @"/FeedbackService.asmx/UpFeedback"
#define AGetMyPerPhotosList @"/PerPhotosService.asmx/GetMyPerPhotosList"//我的发布
#define ADeletePerPhotosByRowID @"/PerPhotosService.asmx/DeletePerPhotosByRowID"//我的发布删除
#define ACheckPerPhoto @"/PerPhotosService.asmx/CheckPerPhoto"//我的发布修改
#define AUploadHeadPortrait @"/PerPhotosService.asmx/UploadHeadPortrait"//上传头像

#define AOAGetGroupUsers @"/OAService.asmx/OAGetGroupUsers"
#define AOAGetGroups @"/OAService.asmx/OAGetGroups"
#define AOAGetGroupsForUnit @"/OAService.asmx/OAGetGroupsForUnit"//获取部门通讯录

#define AUploadCommentData @"CommentService.asmx/UploadCommentData" //提交评论
#define ADeleteCommentByRowID @"CommentService.asmx/DeletePerPhotosByRowID"//删除评论

#define AChangeConfState @"/PerPhotosService.asmx/ChangeConfState"//会议设置已读

#define KGetMap @"http://218.5.80.4:12009/gh/index.html?lng=xxxx&lat=xxxx"//lng为经度，lat为纬度，按照手机GPS接收的经纬度传过来就行

//待办   列表：getTask  数量：getTaskCount
//2、公文交换    列表：getSignGWJH   数量：getSignGWJHCount
//3、会议管理    列表：getSignHYTZ    数量：getSignHYTZCount   详情：getHYTZDetail
#define AgetTask @"OAService.asmx/GetTask"//待办
#define AgetSignGWJH @"OAService.asmx/GetSignGWJH"//公文交换
#define AgetSignHYTZ @"OAService.asmx/GetSignHYTZ"//会议管理

//#define AgetTaskCount @"/OAService.asmx/GetTaskCount"//待办数量
//#define AgetSignGWJHCount @"/OAService.asmx/GetSignGWJHCount"//公文交换数量
//#define AgetSignHYTZCount @"/OAService.asmx/GetSignHYTZCount"//会议管理数量
#define AgetOACount @"OAService.asmx/GetAllCount"

#define AgetHYTZDetail @"OAService.asmx/GetHYTZDetail"//会议管理详情

#define AgetServiceDateTime @"OAService.asmx/GetServiceDateTime"//获取服务器时间

#define AGetDepartmentClassList @"/PerPhotosService.asmx/GetDepartmentClassList"//获取关于和帮助的地址
#define itemLabel 10
#define labelSize ([[UIScreen mainScreen] bounds].size.height >= 1024)?(24):(18)
#define iPadOrIphone ([[UIScreen mainScreen] bounds].size.height >= 1024)? (1.5):(1)
#define screenMySize [[UIScreen mainScreen] bounds]
#define saveArray [[NSMutableArray alloc] init]
//#define menuArray [[NSArray alloc] initWithObjects:@"区级领导活动", @"会议管理",@"同安今日头条",@"征拆动态",@"挂牌督办",@"部门动态",@"视频新闻",@"经济指标",@"效能通报",@"城管执法",@"工业社区",@"通讯录",@"重点工程",@"流域治理",@"协税护税",@"工作手册",@"政策采编",@"多规地图",@"系统设置", nil]
/*
 1：区级领导活动、会议管理、OA消息（这个点击提示正在开发中）
 2：同安今日头条、视频新闻、部门动态
 3：征拆动态、重点工程、流域治理
 4：文明创建、城管执法、工业社区
 5：产业发展、食品安全、协税护税
 
 6：效能通报、挂牌督办、经济指标
 7：多规地图、工作手册、政策采编
 8：通讯录、系统设置
 
 @"区级领导活动", @"会议管理",@"同安今日头条",
 父id: @"77",@"79",@"43",
 权限id: @"132",@"150",@"55",
 
 @"征拆动态",@"挂牌督办",@"部门动态",
 父id: @"78",@"64",@"151",
 权限id: @"151",@"96",@"209",
 
 @"视频新闻",@"经济指标",@"效能通报",
 父id: @"75",@"",@"65",
 权限id: @"62",@"",@"149",
 
 @"城管执法",@"工业社区",@"通讯录",
 父id: @"165",@"170",@"",
 权限id: @"212",@"219",@"",
 
 @"重点工程",@"流域治理",@"协税护税",
 父id: @"261",@"262",@"281",
 权限id: @"223",@"222",@"227",
 
 @"工作手册",@"政策采编",@"多规地图",
 父id: @"",@"",@"",
 权限id: @"168",@"",@"",
 
 @"系统设置", @"食品安全"
 父id: @"",@"301"
 权限id: @"",@"232"
 */

#define menuArray @[\
                    @"区级领导活动", \
                    @"会议管理",\
                    @"区委抄告单",\
                    @"镇街领导活动",\
                    @"重点工程",\
                    @"银城清风",\
                    @"部门领导活动",\
                    @"征迁动态",\
                    @"专项督导",\
                    @"部门动态",\
                    @"城管执法",\
                    @"安全稳定",\
                    @"今日头条",\
                    @"视频新闻",\
                    @"民生补短板",\
                    @"流域治理",\
                    @"文明创建",\
                    @"招商引资",\
                    @"协税护税",\
                    @"企业服务",\
                    @"富民强村",\
                    @"工业社区",\
                    @"项目前期",\
                    @"美丽乡村",\
                    @"食品安全",\
                    @"环保督察",\
                    @"信访维稳",\
                    @"4+X",\
                    @"效能通报",\
                    @"挂牌督办",\
                    @"防讯视频",\
                    @"工作手册",\
                    @"政策采编",\
                    @"外出报告",\
                    @"通讯录",\
                    @"系统设置",\
                    @"多规地图",\
                    @"新闻线索",\
                    @"村情民意",\
                    @"石材整治",\
                    @"要事通报"\
                    ]
//@"村情民意",
//,@"防讯动态",//17-5-4暂时隐藏
//@"环保督察",//17-1-10暂时隐藏
//@"OA消息",@"经济指标",//16-12-12暂时隐藏
//@"防汛视频", @"公众上报",//17-4-18暂时隐藏

//#define menuArray [[NSArray alloc] initWithObjects:@"区级领导活动", @"会议管理",@"环保督察",@"同安今日头条",@"视频新闻",@"部门动态",@"征迁动态",@"重点工程",@"流域治理",@"文明创建",@"城管执法",@"工业社区",@"银城清风",@"企业服务",@"协税护税",@"专项督导",@"效能通报",@"挂牌督办",@"工作手册",@"政策采编",@"OA消息",@"富民强村",@"食品安全",@"通讯录",@"经济指标",@"新闻线索",@"招商引资",@"多规地图",@"系统设置", nil]
//#define menuArray [[NSArray alloc] initWithObjects:@"区级领导活动", @"会议管理",@"同安今日头条",@"征迁动态",@"文明创建",@"部门动态",@"视频新闻",@"重点工程",@"流域治理",@"城管执法",@"工业社区",@"效能通报",@"协税护税",@"食品安全",@"多规地图",@"经济指标",@"工作手册",@"政策采编",@"挂牌督办",@"产业发展",@"系统设置",@"通讯录", nil]

/*
 父类id start
 */
//#define wfSubCodeArray [[NSArray alloc] initWithObjects:@"77",@"79",@"43",@"78",@"309",@"151",@"75",@"261",@"262",@"165",@"170",@"65",@"281",@"301",@"",@"",@"",@"",@"64",@"310",@"",@"", nil]
//#define wfSubCodeArray [[NSArray alloc] initWithObjects:@"77",@"79",@"319",@"43",@"75",@"151",@"78",@"261",@"262",@"309",@"165",@"170",@"310",@"301",@"281",@"65",@"64",@"",@"",@"",@"",@"",@"320",@"",@"", nil]1411
//上面是原来的顺序
#define wfSubCodeDic [NSDictionary dictionaryWithObjectsAndKeys:@"77", @"区级领导活动",@"79", @"会议管理",@"319", @"新闻线索",@"43", @"今日头条",@"75", @"视频新闻",@"151", @"部门动态",@"78", @"征迁动态",@"261", @"重点工程",@"262", @"流域治理",@"365", @"环保督察",@"165", @"城管执法",@"170", @"工业社区",@"310", @"产业发展",@"301", @"食品安全",@"281", @"协税护税",@"65", @"效能通报",@"64", @"挂牌督办",@"", @"经济指标",@"", @"多规地图",@"", @"工作手册",@"", @"政策采编",@"", @"OA消息",@"320", @"富民强村",@"309", @"文明创建", @"", @"通讯录",@"", @"系统设置",@"313", @"招商引资",@"315", @"企业服务",@"352", @"银城清风",@"364", @"责任清单",@"352", @"责任落实",@"300", @"廉政参考",@"432", @"镇级和部门领导",@"522",@"专项督导",@"432",@"部门领导活动",@"527",@"镇街领导活动",@"432",@"请假出差报告",@"11",@"外出报告",@"532",@"项目前期", @"547", @"公众上报",@"553",@"清单落实",@"554",@"机制体制",@"552",@"\"x\"机制",@"151", @"安全稳定",@"782",@"美丽乡村",@"789",@"区委抄告单",@"151",@"信访维稳",@"151",@"民生补短板",@"804",@"村情民意",@"11",@"石材整治",@"11",@"要事通报",@"824",@"治理督导", nil]

#define roleIDDic [NSDictionary dictionaryWithObjectsAndKeys:@"132", @"区级领导活动",@"150", @"会议管理",@"150", @"新闻线索",@"55", @"今日头条",@"62", @"视频新闻",@"209", @"部门动态",@"151", @"征迁动态",@"223", @"重点工程",@"222", @"流域治理",@"", @"文明创建",@"212", @"城管执法",@"219", @"工业社区",@"", @"产业发展",@"232", @"食品安全",@"227", @"协税护税",@"149", @"效能通报",@"96", @"挂牌督办",@"", @"经济指标",@"231", @"多规地图",@"168", @"工作手册",@"", @"政策采编",@"", @"OA消息",@"243", @"富民强村",@"286", @"通讯录",@"", @"系统设置",@"245", @"招商引资",@"246", @"企业服务",@"252", @"银城清风",@"250", @"环保督察",@"256", @"镇级和部门领导",@"258",@"专项督导",@"256",@"部门领导活动",@"260",@"镇街领导活动",@"269",@"请假出差报告",@"269",@"外出报告",@"270",@"项目前期",@"547", @"公众上报",@"252",@"4+X",@"209", @"安全稳定",@"281",@"美丽乡村",@"282",@"区委抄告单",@"292",@"信访维稳",@"294",@"民生补短板",@"301",@"村情民意",@"306",@"石材整治",@"305",@"要事通报", nil]
//@"998",@"防汛视频"
#define keyDic [NSDictionary dictionaryWithObjectsAndKeys:@"ldhd", @"区级领导活动",@"hytz", @"会议管理",@"hyjs", @"新闻线索",@"jrtt", @"今日头条",@"spxw", @"视频新闻",@"bmdt", @"部门动态",@"zcdt", @"征迁动态",@"zdgc", @"重点工程",@"lyzl", @"流域治理",@"wmcj", @"文明创建",@"cgzf", @"城管执法",@"gysq", @"工业社区",@"spaq", @"食品安全",@"xshs", @"协税护税",@"xntb", @"效能通报",@"gpdb", @"挂牌督办",@"jjzb", @"经济指标",@"dgdt", @"多规地图",@"xxyd", @"工作手册",@"zccb", @"政策采编",@"oaxx", @"OA消息",@"fmqc", @"富民强村",@"", @"通讯录",@"", @"系统设置",@"zsyz", @"招商引资",@"qyfw", @"企业服务",@"rdhj", @"环保督察",@"zrls", @"银城清风",@"bmldhd", @"镇级和部门领导",@"zxdd",@"专项督导",@"bmldhd",@"部门领导活动",@"zjldhd",@"镇街领导活动",@"qjccbg",@"请假出差报告",@"qjccbg",@"外出报告",@"xmqq",@"项目前期",@"gzsb", @"公众上报",@"sjx",@"4+X",@"aqsc",@"安全稳定",@"mlxc",@"美丽乡村",@"qwzyldyq",@"区委抄告单",@"xfww",@"信访维稳",@"msbd",@"民生补短板",@"cqmy",@"村情民意",@"sczz",@"石材整治",@"ystb",@"要事通报", nil]

/*
 父类id end
 */

/*
 权限start
 */
//#define roleIDArray [[NSArray alloc] initWithObjects:@"132",@"150",@"55",@"151",@"",@"209",@"62",@"223",@"222",@"212",@"219",@"149",@"227",@"232",@"231",@"",@"168",@"",@"96",@"",@"",@"", nil]
//#define roleIDArray [[NSArray alloc] initWithObjects:@"132",@"150",@"150",@"55",@"62",@"209",@"151",@"223",@"222",@"",@"212",@"219",@"",@"232",@"227",@"149",@"96",@"",@"231",@"168",@"",@"",@"243",@"",@"", nil]
/*
 权限end
 */

//menuInt或jionInt等地方用
#define menuLDArray @[\
                    /* 0 */@"区级领导活动",\
                    /* 1 */@"会议管理",\
                    /* 2 */@"征迁动态",\
                    /* 3 */@"部门动态",\
                    /* 4 */@"城管执法",\
                    /* 5 */@"工业社区",\
                    /* 6 */@"重点工程",\
                    /* 7 */@"流域治理",\
                    /* 8 */@"协税护税",\
                    /* 9 */@"食品安全",\
                    /* 10 */@"新闻线索",\
                    /* 11 */@"富民强村",\
                    /* 12 */@"招商引资",\
                    /* 13 */@"企业服务",\
                    /* 14 */@"廉政参考",\
                    /* 15 */@"环保督察",\
                    /* 16 */@"责任落实",\
                    /* 17 */@"专项督导",\
                    /* 18 */@"部门领导活动",\
                    /* 19 */@"镇街领导活动",\
                    /* 20 */@"请假出差报告",\
                    /* 21 */@"外出报告",\
                    /* 22 */@"项目前期",\
                    /* 23 */@"公众上报",\
                    /* 24 */@"4+X",\
                    /* 25 */@"单位上报",\
                    /* 26 */@"安全稳定",\
                    /* 27 */@"美丽乡村",\
                    /* 28 */@"区委抄告单",\
                    /* 29 */@"信访维稳",\
                    /* 30 */@"民生补短板",\
                    /* 31 */@"综治维稳",\
                    /* 32 */@"村情民意",\
                    /* 33 */@"石材整治",\
                    /* 34 */@"要事通报"\
                    ]
#define wfSubCodeLDArray  @[\
                            /* 0 */@"77",\
                            /* 1 */@"79",\
                            /* 2 */@"78",\
                            /* 3 */@"11",\
                            /* 4 */@"165",\
                            /* 5 */@"170",\
                            /* 6 */@"261",\
                            /* 7 */@"262",\
                            /* 8 */@"281",\
                            /* 9 */@"301",\
                            /* 10 */@"319",\
                            /* 11 */@"320",\
                            /* 12 */@"313",\
                            /* 13 */@"315",\
                            /* 14 */@"357",\
                            /* 15 */@"365",\
                            /* 16 */@"352",\
                            /* 17 */@"522",\
                            /* 18 */@"432",\
                            /* 19 */@"527",\
                            /* 20 */@"432",\
                            /* 21 */@"11",\
                            /* 22 */@"532",\
                            /* 23 */@"547",\
                            /* 24 */@"553",\
                            /* 25 */@"",\
                            /* 26 */@"11",\
                            /* 27 */@"782",\
                            /* 28 */@"789",\
                            /* 29 */@"11",\
                            /* 30 */@"11",\
                            /* 31 */@"11",\
                            /* 32 */@"804",\
                            /* 33 */@"11",\
                            /* 34 */@"11"\
                            ]

//#define menuLDArray [[NSArray alloc] initWithObjects:@"区级领导活动", @"会议管理",@"征迁动态",@"部门动态",@"城管执法",@"工业社区",@"重点工程",@"流域治理",@"协税护税",@"食品安全",@"新闻线索",@"富民强村",@"招商引资",@"企业服务",@"廉政参考",@"环保督察",@"责任落实",@"专项督导",@"部门领导活动",@"镇级领导活动",@"请假出差报告",@"外出报告",@"项目前期", @"公众上报",@"4+X",@"单位上报",@"安全稳定",@"美丽乡村",@"区委抄告单",@"信访维稳",@"民生补短板",@"综治维稳",@"村情民意", nil]

//#define wfSubCodeLDArray  [[NSArray alloc] initWithObjects:@"77",@"79",@"78",@"11",@"165",@"170",@"261",@"262",@"281",@"301",@"319",@"320",@"313",@"315",@"357",@"365",@"352",@"522",@"432",@"527",@"432",@"11",@"532",@"547",@"553",@"",@"11",@"782",@"789",@"11",@"11",@"11",@"804", nil]

#define fontArray [[NSArray alloc] initWithObjects:@"17",@"21",@"26",nil]

#define kAlertShow(msg) [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil] show]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define lineColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0]
#define blueFontColor [UIColor colorWithRed:20/255.f green:168/255.f blue:228/255.f alpha:1.0]
#define grayFontColor [UIColor colorWithRed:173/255.f green:173/255.f blue:172/255.f alpha:1.0]

#define foneSizeRight 0//1显示右边字体切换 0不显示

//bool webBool;//判断是否转屏
//bool  my_wifi;
//NSMutableArray *saveArray;
