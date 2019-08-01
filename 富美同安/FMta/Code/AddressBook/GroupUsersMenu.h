//
//  GroupUsersMenu.h
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface GroupUsersMenu : BDModel
@property (nonatomic, copy) NSString *GroupName;
@property (nonatomic, copy) NSString *GPLD_GroupID;
@property (nonatomic, copy) NSString *GPLD_Group;
@property (nonatomic, copy) NSString *GPLD_User;
@property (nonatomic, copy) NSString *GPLD_UserDspName;
@property (nonatomic, copy) NSString *GPLD_JobTitle;
@property (nonatomic, copy) NSString *IsLeader;
@property (nonatomic, copy) NSString *GPLD_Ord;
@end
