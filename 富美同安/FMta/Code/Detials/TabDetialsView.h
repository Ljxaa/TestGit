//
//  TabDetialsView.h
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TabDetialsViewDelegat<NSObject>
-(void)getTag:(NSInteger)aTag;
@end

@interface TabDetialsView : UIView

@property (unsafe_unretained) id <TabDetialsViewDelegat> delegate;
- (id)initWithFrame:(CGRect)frame styleBool:(BOOL)gBool;
-(void)setDetialsViewDic:(NSMutableDictionary *)aSdic;
@property(nonatomic, retain) NSMutableDictionary* dic;
@end
