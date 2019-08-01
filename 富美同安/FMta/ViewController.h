//
//  ViewController.h
//  FMta
//
//  Created by wx_air on 2017/3/27.
//  Copyright © 2017年 push. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"


@interface ViewController : UIViewController<UITextFieldDelegate,RSeriveDelegate,UIAlertViewDelegate>
{
    UIButton *loginButton,*inButton,*forgetButton;
    UITextField *field1,*field2;
    BOOL yesBool;
    RequestSerive *serive;
    NSDictionary *myDictionary;
}


@end

