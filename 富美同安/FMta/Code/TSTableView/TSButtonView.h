//
//  TSButtonView.h
//  同安政务
//
//  Created by _ADY on 16/1/15.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TSButtonViewDelegate<NSObject>
- (void)setFiset:(int)isF setSecond:(int)isS;
@end

@interface TSButtonView : UIView<UIActionSheetDelegate>
{
    UIButton *inButton,*inButton1;
    
    UILabel *tLabel;
    NSArray *firstArray,*secondArray;
    int fInt,sInt;
}
@property (nonatomic, retain)id<TSButtonViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void)setFirst:(NSArray*)fArray setSecond:(NSArray*)sArray;
@end
