//
//  CineBroadcasterView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterView.h"

@interface CineBroadcasterView ()
{
}

@end

@implementation CineBroadcasterView

@synthesize cameraView;
@synthesize statusView;
@synthesize status;
@synthesize controlsView;

const NSInteger StatusViewHeight = 40;
const NSInteger ControlsViewHeight = 86;


- (void)awakeFromNib
{
    [self setupUI];
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setupUI];

    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    
    cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    cameraView.backgroundColor = [UIColor clearColor];
    [cameraView setContentMode:UIViewContentModeCenter];
    [cameraView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIColor *translucentBlack = [[UIColor alloc] initWithWhite:0.0 alpha:0.25];
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight)];
    statusView.backgroundColor = translucentBlack;
    status = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, statusView.bounds.size.width-20, 20)];
    status.backgroundColor = [UIColor clearColor];
    status.textColor = [UIColor whiteColor];
    status.font = [UIFont systemFontOfSize:12];
    status.textAlignment = NSTextAlignmentLeft;
    status.numberOfLines = 1;
    status.clipsToBounds = YES;
    status.text = @"Initializing";
    [statusView addSubview:status];
    
    controlsView = [[CineBroadcasterControlsView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-ControlsViewHeight, self.bounds.size.width, ControlsViewHeight)];
    controlsView.backgroundColor = translucentBlack;
    
    [self addSubview:cameraView];
    [self addSubview:statusView];
    [self addSubview:controlsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    double rotation = 0;
    CGRect statusFrame = CGRectZero;
    CGRect cameraFrame = CGRectZero;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            NSLog(@"portrait");
            rotation = 0;
            statusFrame = CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight);
            cameraFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
            NSLog(@"portrait upside down");
            rotation = M_PI;
            statusFrame = CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight);
            cameraFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"landscape left");
            rotation = M_PI_2;
            statusFrame = CGRectMake(self.bounds.size.width-StatusViewHeight, 0, StatusViewHeight, self.bounds.size.height-ControlsViewHeight);
            cameraFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            NSLog(@"landscape right");
            rotation = -M_PI_2;
            statusFrame = CGRectMake(0, 0, StatusViewHeight, self.bounds.size.height-ControlsViewHeight);
            cameraFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
            break;
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
        default:
            return;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         cameraView.transform = statusView.transform = transform;
                         cameraView.frame = cameraFrame;
                         statusView.frame = statusFrame;
                     }
                     completion:nil];
    
}

@end
