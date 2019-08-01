//
//  NewsModel.h
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy)NSString *bgImage;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *person;
@property (nonatomic, copy)NSString *Source;
@property (nonatomic, copy)NSString *SumnaryString;
@property (nonatomic, copy)NSString *ClassId;
@end
