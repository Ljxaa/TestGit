//
//  LeftSySViewController.h
//  同安政务
//
//  Created by _ADY on 16/1/14.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"

@interface LeftSySViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RSeriveDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSArray *listArray;
    NSArray *imageArray;
    
    RequestSerive *serive;
    
    NSDictionary *myDictionary;
    UITableView *myTableView;
    
}
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@end
