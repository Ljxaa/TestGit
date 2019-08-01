//
//  FontSizeView.h
//  同安政务
//
//  Created by _ADY on 16/1/19.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FontSizeViewDelegat<NSObject>
-(void)getFontSize;
@end

@interface FontSizeView : UIView
@property (unsafe_unretained) id <FontSizeViewDelegat> delegate;
- (id)initWithFrame:(CGRect)frame;
@end
