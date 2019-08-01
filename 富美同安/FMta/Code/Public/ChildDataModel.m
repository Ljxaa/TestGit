//
//  ChildDataModel.m
//  同安政务
//
//  Created by wx_air on 16/4/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "ChildDataModel.h"
#import "Global.h"

@implementation ChildDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
//        NSLog(@"dictionary:%@",dictionary);
    if (self) {
        self.RowID =dictionary[@"RowID"];
        self.ClassName = dictionary[@"ClassName"];
        self.ParentId = dictionary[@"ParentId"];
        self.OrderNo = dictionary[@"OrderNo"];
        self.ClassLevel = dictionary[@"ClassLevel"];
        
        self.Entity =dictionary[@"Entity"];
        self.CreateDate =dictionary[@"CreateDate"];
        self.Picture = [NSString stringWithFormat:@"%@%@",imageUrl,dictionary[@"Picture"]];
        self.Type =dictionary[@"Type"];
        self.Url =dictionary[@"Url"];
        self.IsAdd =dictionary[@"IsAdd"];
        self.Unread = dictionary[@"Unread"];
    }
    return self;
}
@end
