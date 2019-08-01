//
//  FKViewController.h
//  港务移动信息
//
//  Created by _ADY on 14-11-14.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"

@interface FKViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,RSeriveDelegate>
{
    UITextView *feedBackMsg;
    UILabel *label1;
    RequestSerive *serive;
}

@end
