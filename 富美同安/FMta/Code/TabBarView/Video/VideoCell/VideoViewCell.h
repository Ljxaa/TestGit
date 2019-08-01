//
//  VideoViewCell.h
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#define sizeHight screenMySize.size.width*.2

@interface VideoViewCell : UITableViewCell
- (void)setEntity:(VideoModel *)entity;
@end
