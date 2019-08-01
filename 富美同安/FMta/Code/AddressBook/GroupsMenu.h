//
//  GroupsMenu.h
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface GroupsMenu : BDModel
@property (nonatomic, copy) NSString *Group_Code;
@property (nonatomic, copy) NSString *Group_ID;
@property (nonatomic, copy) NSString *Group_IsShow;
@property (nonatomic, copy) NSString *Group_Level;
@property (nonatomic, copy) NSString *Group_Name;
@property (nonatomic, copy) NSString *Group_Parent;
@property (nonatomic, copy) NSString *Group_ParentID;
@property (nonatomic, copy) NSString *Group_Type;
@end
