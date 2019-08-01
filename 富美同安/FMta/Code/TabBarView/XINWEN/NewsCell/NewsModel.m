//
//  NewsModel.m
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        
        self.bgImage = dictionary[@"Entity"] ?(dictionary[@"Entity"]):(dictionary[@"VideoThumnAdd"]);
        self.title = dictionary[@"Title"];
        self.SumnaryString = dictionary[@"Sumnary"];
        self.time = dictionary[@"PublishDate"];
        self.person = dictionary[@"Author"];
        self.ClassId = dictionary[@"ClassId"];
        self.Source = dictionary[@"Source"];
        
    }
    return self;
}
@end
