//
//  SHAppDelegate.m
//  WebUserAgent
//
//  Created by sherwin.chen on 13-9-22.
//  Copyright (c) 2013年 sherwin.chen. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHViewController.h"
#import "RemoteNotificationManage.h"

@implementation SHAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.req = NULL;
    
    NSString *configString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MainURL"];
    self.mainURLString = @"http://120.197.93.102/ycmp/temobi/index.html";
    if (configString != NULL && ![configString isEqualToString:@""]) {
        self.mainURLString = configString;
    }
    
    NSString *devToken = [USE objectForKey:NOTIFICATIONKTOKENKEY];
    if(devToken)
    {
        if ([self.mainURLString rangeOfString:@"?"].location == NSNotFound) {
            self.mainURLString = [self.mainURLString stringByAppendingFormat:@"?devicetoken=%@",devToken];
        }
        else
        {
            self.mainURLString = [self.mainURLString stringByAppendingFormat:@"&devicetoken=%@",devToken];
        }
        
        //[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    }
    else{
        [PUSHMANGER registerNotification];
    }
    
    self.req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.mainURLString] cachePolicy:0 timeoutInterval:1000*24*60*60];

    //推送消息启动
    if (launchOptions) { //如无消息启动模式，则launchOptions为nil
        
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]; //远程推送
        if (pushNotificationKey) {
            [PUSHMANGER receiveRemoteNotification:pushNotificationKey];
        }
        else if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) ///本地消息
        {
            
        }
    }

    self.window.backgroundColor = [UIColor whiteColor];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    self.viewController = [[[SHViewController alloc] init] autorelease];
    self.viewController.mainRequest = self.req;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark handle Push

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString* newToken = [devToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if ([self.mainURLString rangeOfString:@"?"].location == NSNotFound) {
        self.mainURLString = [self.mainURLString stringByAppendingFormat:@"?devicetoken=%@",newToken];
    }
    else
    {
        self.mainURLString = [self.mainURLString stringByAppendingFormat:@"&devicetoken=%@",newToken];
    }
    self.req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.mainURLString] cachePolicy:0 timeoutInterval:1000*24*60*60];
    
    [self.viewController webViewReload:self.req];
    
    [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:NOTIFICATIONKTOKENKEY];
    
    //注册
    //[PUSHMANGER registerForRemoteNotificationsWithDeviceToken:devToken];
    return;
}

//远程通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    [PUSHMANGER receiveRemoteNotification:userInfo];
    return;
}

//本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}
@end
