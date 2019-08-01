//
//  InfoUserController.h
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

enum {
    ABHelperCanNotConncetToAddressBook,
    ABHelperExistSpecificContact,
    ABHelperNotExistSpecificContact
};
typedef NSUInteger ABHelperCheckExistResultType;
@interface InfoUserController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, MFMessageComposeViewControllerDelegate,ABNewPersonViewControllerDelegate>
{
    bool zhuanF;
    NSString *zhuanFString;
    bool share;
}

@property (nonatomic, retain)NSDictionary *contactInfoDic;
@property (nonatomic, retain)NSString *nameSString;
@property (nonatomic, assign)BOOL boolString;
@end
