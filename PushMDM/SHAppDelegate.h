//
//  SHAppDelegate.h
//  WebUserAgent
//
//  Created by sherwin.chen on 13-9-22.
//  Copyright (c) 2013年 sherwin.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USE [NSUserDefaults standardUserDefaults]

@class SHViewController;

@interface SHAppDelegate : UIResponder <UIApplicationDelegate>
{
    
    
}

@property (nonatomic, retain) NSString *mainURLString;
@property (nonatomic, retain) NSURLRequest *req;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SHViewController *viewController;

@end
