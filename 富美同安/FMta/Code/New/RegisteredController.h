//
//  RegisteredController.h
//  同安政务
//
//  Created by _ADY on 16/1/23.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
#import "SMSValidationView.h"

@interface RegisteredController : UIViewController<UITextFieldDelegate,RSeriveDelegate,SMSValidationDelegat,UIActionSheetDelegate>
{
     RequestSerive *serive;
    NSArray *fArray,*sArray;
    UIButton *bgButton;
    SMSValidationView *aSmsView;
    NSString *TeStr;
    NSMutableArray *nArray;
    UIScrollView *gScrollView;
}
-(void)setField:(NSString*)aTextField;
-(void)setGoLogin:(BOOL)isBool; 

@end
