//
//  ChildHomeView.m
//  同安政务
//
//  Created by wx_air on 16/4/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "ChildHomeView.h"
#import "ChildDataModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+CustomBadge.h"

@implementation ChildHomeView
@synthesize delegate,Title;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
        [self.layer setCornerRadius:10.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:1.5];
        [self setClipsToBounds:YES];
        
        [self addTarget:self action:@selector(touchBody) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [img setImage:[UIImage imageNamed:@"bg.png"]];
//        [self addSubview:img];
        bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        [bgImage setBackgroundColor:[UIColor whiteColor]];
//        bgImage.frame = self.frame;
        [self addSubview:bgImage];
    }
    return self;
}
- (void)setListDataWithFix:(NSArray *)arr NumberDic:(NSDictionary *)numberDic numberKeyArr:(NSArray *)keyArr{
    NSLog(@"number:::%@\n====%@",numberDic,keyArr);
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
    [labelTitle setText:Title];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:19]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [self addSubview:labelTitle];
    
    UIButton *btn1;
    for (int i=0; i<arr.count; i++) {
        if (i==0) {
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10+CGRectGetMaxY(labelTitle.frame), (self.frame.size.width-40)/3, (self.frame.size.width-40)/3*1.2)];
        }else if (i%3 == 0){
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10+CGRectGetMaxY(btn1.frame), btn1.frame.size.width, btn1.frame.size.height)];
        }else{
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10+CGRectGetMaxX(btn1.frame), btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height)];
        }
        [btn1 setTag:i];
        //显示数量
        
        //        [btn1 setTitle:model.ClassName forState:0];
        [btn1 addTarget:self action:@selector(touchListByRow:) forControlEvents:UIControlEventTouchUpInside];
        //        [btn1 setBackgroundColor:[UIColor redColor]];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, btn1.frame.size.width-10, btn1.frame.size.width-10)];
        [img setImage:[UIImage imageNamed:arr[i]]];
        [btn1 addSubview:img];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), btn1.frame.size.width, 20)];
        [label setText:arr[i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor whiteColor]];
        [btn1 addSubview:label];
        [NSDictionary dictionaryWithObjectsAndKeys:@"aa",@"aa", nil];
        [self addSubview:btn1];
//        NSLog(@"===%@",[self firstCharactor:model.ClassName]);
        
        if (i<keyArr.count) {
            [btn1 setBadgeWithNumber:[NSNumber numberWithInt:[[numberDic objectForKey:[keyArr objectAtIndex:i]] intValue]]];
        }
    }
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(btn1.frame)+10;
    [self setFrame:frame];
    
    bgImage.frame = frame;
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = bgImage.bounds;
    [bgImage addSubview:effectView];
    //设置模糊透明度
    //    effectView.alpha = .5f;
}
- (void)setListData:(NSArray *)arr NumberDic:(NSDictionary *)numberDic numberKeyArr:(NSArray *)keyArr{
    NSLog(@"number:::%@\n====%@",numberDic,keyArr);
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
    [labelTitle setText:Title];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:19]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [self addSubview:labelTitle];
    
    UIButton *btn1;
    for (int i=0; i<arr.count; i++) {
        ChildDataModel *model = [arr objectAtIndex:i];
        if (i==0) {
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10+CGRectGetMaxY(labelTitle.frame), (self.frame.size.width-40)/3, (self.frame.size.width-40)/3*1.2)];
        }else if (i%3 == 0){
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10+CGRectGetMaxY(btn1.frame), btn1.frame.size.width, btn1.frame.size.height)];
        }else{
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10+CGRectGetMaxX(btn1.frame), btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height)];
        }
        [btn1 setTag:i];
        //显示数量
        
//        [btn1 setTitle:model.ClassName forState:0];
        [btn1 addTarget:self action:@selector(touchListByRow:) forControlEvents:UIControlEventTouchUpInside];
//        [btn1 setBackgroundColor:[UIColor redColor]];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, btn1.frame.size.width-10, btn1.frame.size.width-10)];
        NSString *url = [[NSString stringWithFormat:@"%@",model.Picture] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"child_no_image"]];
        [btn1 addSubview:img];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), btn1.frame.size.width, 20)];
        [label setText:model.ClassName];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor whiteColor]];
        [btn1 addSubview:label];
        [NSDictionary dictionaryWithObjectsAndKeys:@"aa",@"aa", nil];
        [self addSubview:btn1];
        NSLog(@"===%@",[self firstCharactor:model.ClassName]);
        if ([Title isEqualToString:@"银城清风"]) {
            if ([model.ClassName isEqualToString:@"责任落实"]) {
                int num = 0;
                for (NSString *keyStr in keyArr) {
                    num += [[numberDic objectForKey:keyStr] intValue];
                }
                [btn1 setBadgeWithNumber:[NSNumber numberWithInt:num]];
            }
        }else{
            if (i<keyArr.count) {
                [btn1 setBadgeWithNumber:[NSNumber numberWithInt:[[numberDic objectForKey:[keyArr objectAtIndex:i]] intValue]]];
            }
        }
    }
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(btn1.frame)+10;
    [self setFrame:frame];
    
    bgImage.frame = frame;
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = bgImage.bounds;
    [bgImage addSubview:effectView];
    //设置模糊透明度
//    effectView.alpha = .5f;
}
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
-(void)touchListByRow:(UIButton *)btn{
    [delegate touchListByRow:btn.tag];
}
-(void)touchBody{
    [delegate touchBody];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
