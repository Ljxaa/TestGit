//
//  UsedItem.h
//  厦门信息集团
//
//  Created by _ADY on 15-3-31.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface UsedItem : BDModel

@property (nonatomic, copy) NSString *SelectValue;
@property (nonatomic, copy) NSString *SelectText;
@property (nonatomic, copy) NSString *SetName;
@property (nonatomic, copy) NSString *UserTitle;

@end