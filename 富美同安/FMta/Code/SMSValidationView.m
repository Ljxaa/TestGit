//
//  SMSValidationView.m
//  同安政务
//
//  Created by _ADY on 16/1/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "SMSValidationView.h"
#import "Global.h"
#import "ToolCache.h"

@implementation SMSValidationView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame isTime:(BOOL)aTime
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *accoutImage = [UIImage imageNamed:@"yzm_box.png"];
        UIImage *loginImage = [UIImage imageNamed:@"yam_btn.png"];
        UIImage *loginImage1 = [UIImage imageNamed:@"yam_btn_press.png"];
        
        int aWith = (accoutImage.size.width*frame.size.height)/accoutImage.size.height;
        int bWith = (loginImage.size.width*frame.size.height)/loginImage.size.height;
        if (aWith+bWith >accoutImage.size.width)
        {
            aWith = frame.size.width*aWith/(aWith+bWith);
            bWith = frame.size.width*bWith/(aWith+bWith);
        }
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, bWith+aWith, frame.size.height);
        bgView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:bgView];
        
        UIImageView *accountImageView = [[UIImageView alloc] initWithImage:accoutImage];
        [accountImageView setFrame:CGRectMake(0, 0, aWith, frame.size.height)];
        [bgView addSubview:accountImageView];
        
        account = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, aWith, frame.size.height)];
        account.backgroundColor = [UIColor clearColor];
        [account setFont:[UIFont systemFontOfSize:labelSize-3]];
        account.returnKeyType = UIReturnKeyGo;
        account.keyboardType = UIKeyboardTypeNumberPad;
        account.delegate = self;
        account.textAlignment = 1;
        [account setPlaceholder:@"请输入验证码"];
        [bgView addSubview:account];
        
        cxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cxButton setFrame:CGRectMake(aWith, 0, bWith, frame.size.height)];
        [cxButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        [cxButton setBackgroundImage:loginImage1 forState:UIControlStateDisabled];
        [cxButton addTarget:self action:@selector(login1Action) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cxButton];
        
        cxLabel = [[UILabel alloc] initWithFrame:CGRectMake(aWith, 0, bWith, frame.size.height)];
        cxLabel.text = [NSString stringWithFormat:@"重新获取短信验证码"];
        cxLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-1];
        cxLabel.textAlignment = 1;
        cxLabel.backgroundColor = [UIColor clearColor];
        cxLabel.textColor = [UIColor blackColor];
        [bgView addSubview:cxLabel];
        
        if (aTime) {
            [self scPush];
        }
    }
    return self;
}

//重新获取短信验证码
-(void)login1Action
{
    if (mInt == 0)
    {
        [self scPush];
        [self Validation];
    }
}

//获取验证码
-(void)Validation
{
    [delegate setGoLogin:YES];
}

-(void)scPush
{
    cxButton.enabled = NO;
    if (mTimer != nil) {
        [mTimer invalidate];
        mTimer = nil;
    }
    mInt = 60;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setPush) userInfo:nil repeats:YES];
}

-(void)setPush1
{
    mInt = 1;
    [self setPush];
}
-(void)setPush
{
    mInt --;
    cxLabel.text = [NSString stringWithFormat:@"短信获取中,%d秒",mInt];
    if (mInt == 0) {
        cxButton.enabled = YES;
        cxLabel.text = [NSString stringWithFormat:@"重新获取短信验证码"];
        if (mTimer != nil) {
            [mTimer invalidate];
            mTimer = nil;
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
//限制输入长度 by zwb 2011.9.6
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [delegate setField:text];
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [delegate setField:textField.text];
    return YES;
}
@end
