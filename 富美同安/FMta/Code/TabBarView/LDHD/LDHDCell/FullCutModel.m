//
//  FullCutModel.m
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "FullCutModel.h"

@implementation FullCutModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
//        NSLog(@"dictionarydictionarydictionary:%@",dictionary);
        self.ClassId = dictionary[@"ClassId"];
        self.RowID = dictionary[@"RowID"];
        self.bgImage = dictionary[@"CoverPhotoUrl"];
        self.title = dictionary[@"Title"];
        self.SumnaryString = dictionary[@"AuthorName"];
        self.CreateTime = dictionary[@"PublishDate"];
        self.nameString = dictionary[@"Author"];
        self.Content = dictionary[@"Content"];
        self.AuthorCompany = dictionary[@"AuthorCompany"];
        self.isSex = dictionary[@"sex"];
        self.Rank = dictionary[@"Rank"];
        self.Pictureurl = dictionary[@"Pictureurl"];
        self.CreateID = dictionary[@"CreateID"];
        self.Location = dictionary[@"Location"];
        self.UDefine1 = dictionary[@"UDefine1"];
    }
    return self;
}
@end
