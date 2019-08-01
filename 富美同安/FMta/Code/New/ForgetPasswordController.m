//
//  ForgetPasswordController.m
//  FMta
//
//  Created by 李景祥 on 2018/4/23.
//  Copyright © 2018年 push. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "ToolCache.h"
#import "Global.h"
#import "RequestSerive.h"

@interface ForgetPasswordController ()<RSeriveDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfied;//手机号码
@property (weak, nonatomic) IBOutlet UITextField *codeTextFied;//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//发送验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFied;//密码
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTextFied;//确认密码

@property (nonatomic, strong) NSTimer        *timer;//定时器
@property (nonatomic, assign) int            time;


@end

@implementation ForgetPasswordController{RequestSerive *serive;}

- (void)viewWillAppear:(BOOL)animated {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
}

#pragma mark - btnAction
//修改密码事件
- (IBAction)changepasswordBtnAction:(UIButton *)sender {
    if (_passwordTextFied.text.length == 0||_surePasswordTextFied.text.length == 0) {
        [RequestSerive alerViewMessage:@"请输入密码"];
        return;
    }else if (![_passwordTextFied.text isEqualToString:_surePasswordTextFied.text]) {
        [RequestSerive alerViewMessage:@"两次密码不一致"];
        return;
    }else if (_phoneTextfied.text.length==0){
        [RequestSerive alerViewMessage:@"手机号码不能为空"];
        return;
    }
    else{
        NSDictionary *params = @{@"Phone":_phoneTextfied.text,@"PWD":_passwordTextFied.text?[ToolCache setUrlStr:_passwordTextFied.text]:@"",@"Code":_codeTextFied.text?[ToolCache setUrlStr:_codeTextFied.text]:@""};
        [serive PostFromURL:IPhoneCode params:params mHttp:httpUrl isLoading:YES];
    }
}

//获取验证码
- (IBAction)getCodeBtnAction:(UIButton *)sender {
    if (![ToolCache isCheckTel:_phoneTextfied.text]) {
        [RequestSerive alerViewMessage:@"手机号码格式不正确"];
        return;
    }
//    _time = 59;
//    //定时器倒计时
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//    _codeBtn.enabled = NO;
//    [_timer fire];
    NSDictionary *params = @{@"Phone":_phoneTextfied.text,@"PWD":@"",@"Code":@""};
    [serive PostFromURL:IPhoneCode params:params mHttp:httpUrl isLoading:YES];
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:IPhoneCode])//验证码
    {
        if (dic)
        {
            if([dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]isEqualToString:@"修改密码成功！"]){
                [RequestSerive alerViewMessage:@"密码修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([dic[@"NewDataSet"][@"Table"][@"flag"][@"text"]isEqualToString:@"true"])
            {
                _time = 59;
                //定时器倒计时
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
                _codeBtn.enabled = NO;
                [_timer fire];
//                [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"flag"][@"text"]];
            }
            else{
                
                [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
            }
        }
    }
}

#pragma mark - 倒计时
- (void)countDown {
    
    if (_time < 0) {
        
        //停止定时器
        [_codeBtn setTitle:@"重新获取短信验证码" forState:UIControlStateNormal];
        _codeBtn.enabled = YES;
        [_timer invalidate];
        
        return;
    }
    
    [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒",_time] forState:UIControlStateDisabled];
    
    _time--;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
