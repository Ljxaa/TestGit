//
//  VideoPlayController.m
//  iMcuSdk
//
//  Created by cs on 12-9-10.
//  Copyright (c) 2012年 cs. All rights reserved.
//

#import "VideoPlayController.h"
#import "Cvs2VideoView.h"
#import "AppDelegate.h"
#import "ToolCache.h"
#import "Global.h"

@implementation VideoPlayController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _playing = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
//    self.navigationItem.title = @"防汛视频";
    Cvs2VideoView *videoView = (Cvs2VideoView *)self.view;
//    [videoView setCenter:self.view.center];
    [videoView setRendRect:CGRectMake(0, 0, self.view.frame.size.width * 2, self.view.frame.size.width*1.5)];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
    videoView.transform = transform;
    
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 - 44, self.view.frame.size.width, 50)];
//    [backBtn setBackgroundImage:[ToolCache createImageWithColor:blueFontColor] forState:UIControlStateNormal];
//    [backBtn setTitle:@"显示资源列表" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [self.wrapper stopCall];
//    [self.wrapper stopRend];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)controllVideo:(id)sender
{
    if (_playing)
    {
        [self.wrapper stopRend];
    }
    
    _playing = NO;
}

- (IBAction)goBack:(id)sender
{
    [self.wrapper stopRend];
    [self.view removeFromSuperview];
}

- (IBAction)snapshot:(id)sender
{
    UIImage *image  = [self.wrapper currentImage];
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

- (void)dealloc
{
//    [super dealloc];
}

- (IBAction)startOrStopAudio:(id)sender
{
    //    if (!_audioPlaying)
    //    {
    //        [self.wrapper startAudio];
    //    }
    //    else
    //    {
    //         [self.wrapper stopAudio];
    //    }
    //
    //    _audioPlaying = !_audioPlaying;
    [self startCall2];
}

- (IBAction)startOrStopCall:(id)sender
{
    if (!_calling)
    {
        [self.wrapper startCall];
    }
    else
    {
        [self.wrapper stopCall];
    }
    
    _calling = !_calling;
}

- (void)startCall2
{
    NSString *s = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    
    "<M Type=\"ComReq\">"
    
    "<C Type=\"S\">"
    
    "<Res Type=\"ST\" Idx=\"0\" OptID=\"F_ST_EnableGuard\">"
    
    "<Param  Value=\"1\"></Param>"
    
    "</Res>"
    
    "</C>"
    
    "</M>";
    
    char buf[1024];
    int dataLen = 1024;
    int nRet = [self.wrapper postXMLMessage:s dstType:NC_ROUTE_PU toPuid:@"201115200318767498" recvBuf:buf inLen:&dataLen];
    NSString *sf = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
    NSLog(@" 测试发送报文-- ------------ %s", buf);
}

- (IBAction)record:(id)sender
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:@"test.mp4"];
    if (!_recording)
    {
        [self.wrapper startRecord:path];
    }
    else
    {
        [self.wrapper stopRecord];
    }
    _recording = !_recording;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    Cvs2VideoView *videoView = (Cvs2VideoView *)self.view;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [videoView resizeForPortrait];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        srcRect = videoView.rendRect;
        [videoView setRendRect:videoView.bounds];
    }
}

@end
