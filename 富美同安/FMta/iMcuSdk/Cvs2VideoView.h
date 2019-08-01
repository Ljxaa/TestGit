//
//  Cvs2VideoView.h
//  iMobileMonitor
//
//  Created by crearo on 1/29/10.
//  Copyright 2010 crearo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Cvs2VideoView : UIView 
{
	CGImageRef  imageRef;
    CGRect      rendRect;
}

@property (nonatomic, readonly) CGImageRef  imageRef;
@property (nonatomic, assign)   CGRect      rendRect;

- (void)resizeForPortrait;
@end
