//
//  OAGetGroupUsers.h
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface OAGetGroupUsers : BDModel
@property (nonatomic, copy) NSString *Guid;
@property (nonatomic, copy) NSString *Id;//当前
@property (nonatomic, copy) NSString *ContactId;//上一级
@property (nonatomic, copy) NSString *Account;
@property (nonatomic, copy) NSString *DspName;
@property (nonatomic, copy) NSString *Tel;
@property (nonatomic, copy) NSString *Phone;
@property (nonatomic, copy) NSString *Job;
@property (nonatomic, copy) NSString *Source;
@property (nonatomic, copy) NSString *AState;
@property (nonatomic, copy) NSString *A_Type1Ids;
@property (nonatomic, copy) NSString *HomeTel;
@property (nonatomic, copy) NSString *Fax;
@property (nonatomic, copy) NSString *IsLinkMan;//等于1 显示
@property (nonatomic, copy) NSString *GroupID;
@end