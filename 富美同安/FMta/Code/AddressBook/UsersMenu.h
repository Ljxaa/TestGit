//
//  UsersMenu.h
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface UsersMenu : BDModel
@property (nonatomic, copy) NSString *User_Account;
@property (nonatomic, copy) NSString *User_DspName;
@property (nonatomic, copy) NSString *User_Email;
@property (nonatomic, copy) NSString *User_Tel;
@property (nonatomic, copy) NSString *User_Mb;
@property (nonatomic, copy) NSString *User_Fax;
@property (nonatomic, copy) NSString *User_Sex;
@property (nonatomic, copy) NSString *User_Delete;
@property (nonatomic, copy) NSString *USER_Title;
@end
