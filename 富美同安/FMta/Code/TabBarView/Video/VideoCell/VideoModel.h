//
//  VideoModel.h
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy)NSString *bgImage;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *SumnaryString;
@end
