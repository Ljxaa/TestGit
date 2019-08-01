//
//  FullCutModel.h
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullCutModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy)NSString *ClassId;
@property (nonatomic, copy)NSString *RowID;
@property (nonatomic, copy)NSString *bgImage;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *SumnaryString;

@property (nonatomic, copy)NSString *CreateTime;
@property (nonatomic, copy)NSString *nameString;
@property (nonatomic, copy)NSString *Content;
@property (nonatomic, copy)NSString *AuthorCompany;
@property (nonatomic, copy)NSString *isSex;
@property (nonatomic, copy)NSString *Rank;
@property (nonatomic, copy)NSString *Pictureurl;
@property (nonatomic, copy)NSString *CreateID;

@property (nonatomic, copy)NSString *Location;
@property (nonatomic, copy)NSString *UDefine1;
@end
