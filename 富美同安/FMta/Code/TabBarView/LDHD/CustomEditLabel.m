//
//  CustomEditLabel.m
//  FMta
//
//  Created by wx_air on 2017/9/8.
//  Copyright © 2017年 push. All rights reserved.
//

#import "CustomEditLabel.h"

@implementation CustomEditLabel
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addLongPressEvent];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addLongPressEvent];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addLongPressEvent];
    }
    return self;
}

- (void)addLongPressEvent{
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionS:)];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];
    
}


- (void)actionS:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyS:)];
        UIMenuController *menuC = [UIMenuController sharedMenuController];
        
        menuC.menuItems = @[menuItem1];
        menuC.arrowDirection = UIMenuControllerArrowUp;
        
        if (menuC.menuVisible) {
            //        NSLog(@"menuC.menuVisible    判断 --  %d", menuC.menuVisible);
            return ;
        }
        
        [menuC setTargetRect:self.frame inView:self.superview];
        [menuC setMenuVisible:YES animated:YES];
        
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if ( action == @selector(copyS:)  || (action == @selector(pasteS:) && [UIPasteboard generalPasteboard].string) || action == @selector(cutS:) ) {
        //        NSLog(@"粘贴板   --  %@", [UIPasteboard generalPasteboard].string);
        return YES;
    }else{
        return NO;
    }
}
//剪切事件（暂时不用）
- (void)cutS:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    //剪切 功能
    self.text = nil;
}

//拷贝
- (void)copyS:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
    
}
//粘贴
- (void)pasteS:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    self.text = pboard.string;
}

@end
