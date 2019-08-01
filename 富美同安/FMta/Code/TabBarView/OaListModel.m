//
//  OaListModel.m
//  同安政务
//
//  Created by wx_air on 16/5/14.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OaListModel.h"
#import "Global.h"
@implementation OaListModel
//{
//    DocNo =                 {
//        text = "\U53a6\U540c\U91cd\U5927\U529e\Uff3b\Uff12\Uff10\Uff11\Uff16\Uff3d\Uff12\U53f7";
//    };
//    IsBack =                 {
//        text = "\U5426";
//    };
//    IsSign =                 {
//        text = "\U672a\U7b7e\U6536";
//    };
//    Reback =                 {
//    };
//    ReceiveDate =                 {
//        text = "2016-03-15 09:35:08";
//    };
//    SendDept =                 {
//        text = "\U533a\U59d4\U529e";
//    };
//    Title =                 {
//        text = "\U53a6\U95e8\U5e02\U540c\U5b89\U533a\U91cd\U5927\U9879\U76ee\U9886\U5bfc\U5c0f\U7ec4\U529e\U516c\U5ba4\U5173\U4e8e\U5370\U53d1\U300a\U540c\U5b89\U533a\U89c4\U8303\U4f7f\U7528\U623f\U5c4b\U5f81\U8fc1\U4e0d\U53ef\U9884\U89c1\U8d39\U548c\U6309\U65f6\U4ea4\U5730\U5956\U52b1\U91d1\U7684\U5de5\U4f5c\U610f\U89c1\U300b\U7684\U901a\U77e5";
//    };
//    Urgency =                 {
//        text = "\U4e00\U822c";
//    };
//    id =                 {
//        text = 42398;
//    };
//    num =                 {
//        text = 9;
//    };
//}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary urlType:(NSString *)url
{
    self = super.init;
    if (self) {
        if ([url isEqualToString:AgetTask]) {//代办
            self.ProcID =dictionary[@"ProcID"][@"text"];
            self.ProcName = dictionary[@"ProcName"][@"text"];
            self.ProcType = dictionary[@"ProcType"][@"text"];
            self.ReceiveTime = dictionary[@"ReceiveTime"][@"text"];
            self.SubWfCat = dictionary[@"SubWfCat"][@"text"];
            
            self.TaskCount =dictionary[@"TaskCount"][@"text"];
            self.TaskID =dictionary[@"TaskID"][@"text"];
            self.TaskName =dictionary[@"TaskName"][@"text"];
            self.User =dictionary[@"User"][@"text"];
            self.WfCat =dictionary[@"WfCat"][@"text"];
            self.WfName =dictionary[@"WfName"][@"text"];
        }else if ([url isEqualToString:AgetSignGWJH]){//公文管理
//            {
//                DocNo =                 {
//                    text = 1;
//                };
//                IsBack =                 {
//                    text = "\U5426";
//                };
//                IsSign =                 {
//                    text = "\U672a\U7b7e\U6536";
//                };
//                Reback =                 {
//                };
//                ReceiveDate =                 {
//                    text = "2016-04-14 16:10:03";
//                };
//                SendDept =                 {
//                    text = "\U653f\U5e9c\U529e";
//                };
//                Title =                 {
//                    text = "\U6d4b\U8bd5\U64a4\U56de";
//                };
//                Urgency =                 {
//                    text = "\U4e00\U822c";
//                };
//                id =                 {
//                    text = 43221;
//                };
//                num =                 {
//                    text = 1;
//                };
//            }
//            self.ProcID =dictionary[@"ProcID"][@"text"];
//            self.ProcName = dictionary[@"ProcName"][@"text"];
//            self.ProcType = dictionary[@"ProcType"][@"text"];
            self.ReceiveTime = dictionary[@"ReceiveDate"][@"text"];
//            self.SubWfCat = dictionary[@"SubWfCat"][@"text"];
//            
//            self.TaskCount =dictionary[@"TaskCount"][@"text"];
//            self.TaskID =dictionary[@"TaskID"][@"text"];
            self.TaskName =dictionary[@"Title"][@"text"];
            self.User =dictionary[@"SendDept"][@"text"];
//            self.WfCat =dictionary[@"WfCat"][@"text"];
            self.WfName =dictionary[@"IsSign"][@"text"];
        }else if ([url isEqualToString:AgetSignHYTZ]){//会议管理
//            {
//                Guid =                 {
//                    text = "da39a43b-a4d5-4b73-b85b-f704e1677f4a";
//                };
//                IsNeedReback =                 {
//                    text = 1;
//                };
//                IsReturn =                 {
//                    text = "\U662f";
//                };
//                IsSign =                 {
//                    text = 0;
//                };
//                MettingAddress =                 {
//                };
//                MettingID =                 {
//                    text = 1103;
//                };
//                MettingTime =                 {
//                    text = "2016/3/15 9:00:00";
//                };
//                MettingTitle =                 {
//                    text = "\U96c6\U4f53\U7ea6\U8c08\U4f1a\U8bae\U901a\U77e5";
//                };
//                ReceiveDate =                 {
//                    text = "2016-03-14 14:50:09";
//                };
//                SendDate =                 {
//                    text = "2016-03-14 14:52:00";
//                };
//                SendDept =                 {
//                    text = "\U533a\U59d4\U529e";
//                };
//                Urgency =                 {
//                    text = "\U7279\U6025";
//                };
//                id =                 {
//                    text = 13424;
//                };
//                iscqs =                 {
//                    text = 1;
//                };
//                num =                 {
//                    text = 1;
//                };
//            }
            if ([dictionary[@"flag"][@"text"] isEqualToString:@"False"]) {
                return nil;
            }
            self.ProcID =dictionary[@"id"][@"text"];
            //            self.ProcName = dictionary[@"ProcName"][@"text"];
            //            self.ProcType = dictionary[@"ProcType"][@"text"];
            self.ReceiveTime = dictionary[@"MettingTime"][@"text"];
            //            self.SubWfCat = dictionary[@"SubWfCat"][@"text"];
            //
            //            self.TaskCount =dictionary[@"TaskCount"][@"text"];
            //            self.TaskID =dictionary[@"TaskID"][@"text"];
            self.TaskName =dictionary[@"MettingTitle"][@"text"];
            self.User =dictionary[@"SendDept"][@"text"];
            //            self.WfCat =dictionary[@"WfCat"][@"text"];
            //            self.WfName =dictionary[@"WfName"][@"text"];
        }
        
    }
    return self;
}
@end
