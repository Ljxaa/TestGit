//
//  OACell.h
//  同安政务
//
//  Created by wx_air on 16/5/13.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OaListModel.h"
#define OACell_height 80
@interface OACell : UITableViewCell

@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *contentLabel;

- (void)setModelData:(OaListModel *)model urlName:(NSString *)url;
@end
