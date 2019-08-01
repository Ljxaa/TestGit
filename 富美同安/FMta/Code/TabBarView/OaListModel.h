//
//  OaListModel.h
//  同安政务
//
//  Created by wx_air on 16/5/14.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
//oa消息列表model
@interface OaListModel : NSObject

@property(nonatomic,copy) NSString *ProcID;
@property(nonatomic,copy) NSString *ProcName;
@property(nonatomic,copy) NSString *ProcType;
@property(nonatomic,copy) NSString *ReceiveTime;
@property(nonatomic,copy) NSString *SubWfCat;
@property(nonatomic,copy) NSString *TaskCount;
@property(nonatomic,copy) NSString *TaskID;
@property(nonatomic,copy) NSString *TaskName;
@property(nonatomic,copy) NSString *User;
@property(nonatomic,copy) NSString *WfCat;
@property(nonatomic,copy) NSString *WfName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary urlType:(NSString *)url;
@end
