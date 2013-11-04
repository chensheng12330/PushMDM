//
//  SHViewController.h
//  WebUserAgent
//
//  Created by sherwin.chen on 13-9-22.
//  Copyright (c) 2013年 sherwin.chen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HMSideMenu.h"
#import "QuadCurveMenu.h"

//@protocol QuadCurveMenuDelegate;

@interface SHViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,QuadCurveMenuDelegate>
{
    NSURLRequest *mainRequest;
    NSURLConnection *aa;
}

@property (retain, nonatomic) IBOutlet UIWebView *myWebView;
@property (retain, nonatomic) IBOutlet UIButton *btnPress;

@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, retain) HMSideMenu *sideMenu;

- (IBAction)toggleMenu:(id)sender;
@end
