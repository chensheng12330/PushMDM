
//版权所有：版权所有(C) 2013，陈胜 [Sherwin.Chen]
//系统名称：<#使用系统#>
//文件名称：RemoteNotificationManger.m
//作　　者：陈胜
//个人联系：chensheng12330@gmail.com or @checkchen2011
//创建日期：12-11-20
//修改日期：13-08-23
//完成日期：<#完成日期#>
//版   本：版本v0.1.2
//版本说明：

#import "RemoteNotificationManage.h"
//#import "MessageNotification.h"

#define NOTIFICATIONKEY         @"NotificationsValueKey"
#define NOTIFICATIONKTOKENKEY   @"NotificationsTokenValueKey"
#define NOTIFICATIONTAG         68786

static RemoteNotificationManage *static_remoteNotificationManage = nil;

@implementation RemoteNotificationManage

@synthesize deviceToken = _deviceToken;

+ (RemoteNotificationManage*) sharedRemoteNotificationManage
{
    @synchronized(self){
        if ( nil == static_remoteNotificationManage ) {
            static_remoteNotificationManage = [[RemoteNotificationManage alloc] init];
        }
    }
    
    return static_remoteNotificationManage;
}

////1、获取当前用户位置 
//- (void) registerNotification
//{
//    lbsLocation = [[LBSLocation alloc] init];
//    lbsLocation.delegate = self;
//    [lbsLocation showsUserLocation];
//}
//
////
//- (void)lbsLocation:(LBSLocation *)flbsLocation didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    coordinate = userLocation.location.coordinate;
//    
//    //注册通知
//    [self registerNotification1];
//    
//    [lbsLocation release]; lbsLocation = nil;
//}
//
//- (void)lbsLocation:(LBSLocation *)flbsLocation didFailToLocateUserWithError:(NSError *)error
//{
//    if ([error code] == kCLErrorDenied)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"你未启用定位服务"
//                                                        message:@"你可到系统设置页面启用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alertView show];
//        [alertView release];
//    }
//    
//    coordinate.longitude = 22.5460540;
//    coordinate.latitude  = 114.025974;
//    
//    //注册通知
//    [self registerNotification1];
//    [lbsLocation release]; lbsLocation = nil;
//}

//2、向apple注册push 通知
- (void) registerNotification;
{
    UIApplication *application = [UIApplication sharedApplication];
    
    //application.applicationIconBadgeNumber = 0;
    
    // 让应用支持接收推送消息
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | 
                                                     UIRemoteNotificationTypeSound | 
                                                     UIRemoteNotificationTypeAlert)];
}

- (void) failToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"获取推送设备令牌错误: %@", error);
    
    // 从本地获取deviceToken
    NSString *oldDeviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATIONKTOKENKEY];
    self.deviceToken = oldDeviceToken;
}

#pragma mark Register Push Messsage
//3、向产品服务器注册push接收对象
- (void) registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // 新获取的deviceToken
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 保存当前deviceToken
    self.deviceToken = newToken;
    
    NSLog(@"远程通知DeviceToken:%@",newToken);
    
    // 从本地获取deviceToken
    NSString *oldDeviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATIONKTOKENKEY];
    
    //获取device token以检查device token是否改变，如果改变了就应该把新token传给push provider
    
    // 如果之前都没有保存deviceToken，则保存当前deviceToken
    if ( oldDeviceToken == nil || [oldDeviceToken length] == 0 || ![oldDeviceToken isEqualToString:newToken] ) {
        
        // 将当前deviceToken写入到本地
        [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:NOTIFICATIONKTOKENKEY];
    }
    
    // 根据系统设置，向后台发送打开或关闭推送通知
    if ( [self sysIsOpenRemoteNotification] ) {
        /*
        //向产品服务端 注册消息服务
        pushRegisterDao = [[PushRegisterDao alloc] init];
        pushRegisterDao.delegate = self;
        
        [pushRegisterDao asyncPushRegister:newToken Longitude:coordinate.longitude Latitude:coordinate.latitude];
         */
    }
    else{
        //关闭
    }
    
    return;
}

////请求成功
//- (void)requestFinished:(BaseDao *)  dao
//             dataOrigin:(DataOrigin) dataOrigin
//               dataType:(DataType)   dataType
//                   data:(NSObject*)  object
//{
//    NSLog(@"产品 注册消息服务成功");
//    
//    return;
//}
//
////请求失败
//- (void)requestFailed:(BaseDao *) dao failedInfo:(NSString*) info
//{
//    NSLog(@"产品 注册消息服务失败");
//
//    return;
//}


//4、 接受到远程推送信息
- (void) receiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplication *application = [UIApplication sharedApplication];
    
    

    //将消息标号减1
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber-1;
    
    /*
    if ( application.applicationIconBadgeNumber!=0) {
        application.applicationIconBadgeNumber = [[userInfo objectForKey:@"badge"] integerValue];
    }
     */
    
    NSString *msgInfo = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    if ([msgInfo rangeOfString:@"http"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msgInfo]];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                    message:msgInfo
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //消息存入数据库
        //消息数据库管理
        //[pushRegisterDao dbSavePushMessage:msgInfo];
        
        //[MessageNotification postMessageNotificationObject:self MessageInfo:userInfo];
    });
    
    
}

// 判断当前是否接收远程通知
- (BOOL) isOpenNotifications
{
    int flag = [[NSUserDefaults standardUserDefaults] integerForKey:NOTIFICATIONKEY];
    
    NSString *oldDeviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:NOTIFICATIONKTOKENKEY];
    
    return flag == 1 && oldDeviceToken != nil && [oldDeviceToken length] != 0;
}

// 判断当前系统设置中是否支持推送
- (BOOL) sysIsOpenRemoteNotification
{
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    return UIRemoteNotificationTypeNone != types;
}

- (void) dealloc
{
    //[pushRegisterDao release]; pushRegisterDao = nil;
    
    self.deviceToken = nil;
    [super dealloc];
}

@end
