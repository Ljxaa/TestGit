//
//  SMSValidationView.h
//  同安政务
//
//  Created by _ADY on 16/1/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMSValidationDelegat<NSObject>
-(void)setField:(NSString*)aTextField;
-(void)setGoLogin:(BOOL)isBool;//YES 重发验证码
@end
@interface SMSValidationView : UIView<UITextFieldDelegate>
{
    UITextField *account;
    UIButton *cxButton;
    UILabel *cxLabel;
    NSTimer *mTimer;
    int  mInt;
}
- (id)initWithFrame:(CGRect)frame isTime:(BOOL)aTime;//aTime YES 倒计时
@property (unsafe_unretained) id <SMSValidationDelegat> delegate;
-(void)setPush1;
@end
