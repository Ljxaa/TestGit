//
//  ChildDataModel.h
//  同安政务
//
//  Created by wx_air on 16/4/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
//文明传建等内部模型
@interface ChildDataModel : NSObject
@property(nonatomic,copy) NSString *RowID;
@property(nonatomic,copy) NSString *ClassName;
@property(nonatomic,copy) NSString *ParentId;
@property(nonatomic,copy) NSString *OrderNo;
@property(nonatomic,copy) NSString *ClassLevel;
@property(nonatomic,copy) NSString *Entity;
@property(nonatomic,copy) NSString *CreateDate;
@property(nonatomic,copy) NSString *Picture;
@property(nonatomic,copy) NSString *Type;
@property(nonatomic,copy) NSString *Url;
@property(nonatomic,copy) NSString *IsAdd;
@property(nonatomic,copy) NSString *Unread;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
