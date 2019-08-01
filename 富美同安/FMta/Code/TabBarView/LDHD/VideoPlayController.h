//
//  VideoPlayController.h
//  iMcuSdk
//
//  Created by cs on 12-9-10.
//  Copyright (c) 2012年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHelper.h"

@interface VideoPlayController : UIViewController
{
    BOOL _playing;
    BOOL _audioPlaying;
    BOOL _calling;
    BOOL _recording;
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *snapshotButton;
    IBOutlet UIButton *startButton;
    
    CGRect srcRect;
}
@property (nonatomic, strong)MCHelper *wrapper;
@property (nonatomic, strong)Cvs2ResEntity *pVideo;
- (IBAction)controllVideo:(id)sender;
- (IBAction)goBack:(id)sender;

- (IBAction)record:(id)sender;
- (IBAction)snapshot:(id)sender;
- (IBAction)startOrStopAudio:(id)sender;
- (IBAction)startOrStopCall:(id)sender;
@end

