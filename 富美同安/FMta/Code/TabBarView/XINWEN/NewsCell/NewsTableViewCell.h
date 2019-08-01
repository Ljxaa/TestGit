//
//  NewsTableViewCell.h
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

#define sizeHight 75

@interface NewsTableViewCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
+(UITableViewCell*)setImageCell:(UITableViewCell *)cell data:(NewsModel *)entity;
+(UITableViewCell*)setImageCell:(UITableViewCell *)cell data:(NewsModel *)entity forI:(int)iType;
- (void)setEntity:(NewsModel *)entity setSource:(BOOL)isSource;
@end
