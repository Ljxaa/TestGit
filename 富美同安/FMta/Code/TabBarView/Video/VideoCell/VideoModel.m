//
//  VideoModel.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        
        self.bgImage = dictionary[@"VideoThumnAdd"];
        self.title = dictionary[@"Title"];
        self.SumnaryString = dictionary[@"Sumnary"];
    }
    return self;
}

@end
