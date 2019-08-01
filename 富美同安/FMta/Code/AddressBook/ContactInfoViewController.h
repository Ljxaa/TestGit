//
//  ContactInfoViewController.h
//  特房移动OA
//
//  Created by chenhuagui on 13-9-15.
//  Copyright (c) 2013年 yiyihulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
enum {
    ABHelperCanNotConncetToAddressBook,
    ABHelperExistSpecificContact,
    ABHelperNotExistSpecificContact
};
typedef NSUInteger ABHelperCheckExistResultType;
@interface ContactInfoViewController : UIViewController<UIAlertViewDelegate>
{
    bool zhuanF;
    NSString *zhuanFString;
    bool share;
}

@property (nonatomic, retain)NSDictionary *contactInfoDic;
@property (nonatomic, retain)NSString *nameSString;
@property (nonatomic, assign)BOOL boolString;
@end
