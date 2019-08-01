//
//  SingleReplyButton.h
//  同安政务
//
//  Created by _ADY on 16/4/27.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleReplyButton : UIButton

@property (nonatomic, copy) NSString *rowID;
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, copy) NSString *createNickame;

@end
