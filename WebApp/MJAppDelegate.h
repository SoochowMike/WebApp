//
//  MJAppDelegate.h
//  WebApp
//
//  Created by Mike Jin on 14-7-3.
//  Copyright (c) 2014年 Mike Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captuvo.h"


@class MJViewController;

@interface MJAppDelegate : UIResponder <UIApplicationDelegate,CaptuvoEventsProtocol>

@property (strong, nonatomic) UIWindow *window;

@end
