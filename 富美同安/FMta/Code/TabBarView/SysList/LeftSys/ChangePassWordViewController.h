//
//  ChangePassWordViewController.h
//  何五路
//
//  Created by _ADY on 15/7/29.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"

@interface ChangePassWordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,RSeriveDelegate>
{
    UITextField *oldpassword,*password,*aPassWord;
    RequestSerive *serive;
    NSString *TeStr;
}
-(void)setField:(NSString*)aTextField;
-(void)setGoLogin:(BOOL)isBool;
@end
