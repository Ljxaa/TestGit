//
//  HomeViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"

@interface HomeViewController : UIViewController<RSeriveDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    RequestSerive *serive;
    UIPageControl *ePageControl;
    
}
@end
