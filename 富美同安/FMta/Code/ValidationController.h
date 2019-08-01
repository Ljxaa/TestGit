//
//  ValidationController.h
//  同安政务
//
//  Created by _ADY on 16/1/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
#import "SMSValidationView.h"

@interface ValidationController : UIViewController<RSeriveDelegate,SMSValidationDelegat>
{
    RequestSerive *serive;
    SMSValidationView *aSmsView;
    NSString *TeStr;
}

@property (nonatomic, assign)BOOL isLogin;//yes 登录 no 修改
-(void)setField:(NSString*)aTextField;
-(void)setGoLogin:(BOOL)isBool;
@end
