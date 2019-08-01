//
//  MyNavigationController.m
//  厦门信息集团
//
//  Created by _ADY on 15-2-6.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*)createBackButton
{

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 37*.75, 34*.75)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    return leftButton;
    
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"return_white"]
            style:UIBarButtonItemStylePlain
            target:self
            action:@selector(popself)];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    [super pushViewController:viewController animated:animated];

    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) { 

        viewController.navigationItem.leftBarButtonItem =[self createBackButton];

    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
