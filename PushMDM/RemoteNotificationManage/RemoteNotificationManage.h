//
//  RemoteNotificationManger.h
//  Mixc
//
//  Created by Knife on 12-11-20.
//  Update by sherwin.chen on 13-08-23
//  Copyright (c) 2012年 Knife. All rights reserved.
//

//版权所有：版权所有(C) 2013，陈胜 [Sherwin.Chen]
//系统名称：使用系统
//文件名称：文件名称
//作　　者：陈胜
//个人联系：chensheng12330@gmail.com or @checkchen2011
//创建日期：12-11-20
//修改日期：13-08-23
//完成日期：完成日期
//版   本：版本v0.1.2
//版本说明：
/*
 v0.0.1   基础版本
 v0.1.2   1、增加产品服务端消息处理能力 2、加入地理地址请求管理
 */
//功能说明：对消息推送进行管理
//---------------------------------------------------------
#define NOTIFICATIONKTOKENKEY   @"NotificationsTokenValueKey"

#import <UIKit/UIKit.h>
//#import "ASIHTTPRequest.h"
//#import "LBSLocation.h"
//#import "PushRegisterDao.h"

@interface RemoteNotificationManage : NSObject
{
    //old code
    //ASIHTTPRequest *_registerRequest;
    //ASIHTTPRequest *_unRegisterRequest;
    //end old code
    
    //new code
    
    NSString *_deviceToken;
    BOOL isOpen;
    
    /*
    LBSLocation *lbsLocation;
    CLLocationCoordinate2D coordinate;
    PushRegisterDao *pushRegisterDao;
     */
}

@property (nonatomic, copy) NSString *deviceToken;

// 获得推送管理对象
+ (RemoteNotificationManage*) sharedRemoteNotificationManage;

// 注册推送通知
- (void) registerNotification;

// 注册失败
- (void) failToRegisterForRemoteNotificationsWithError:(NSError*)error;

// 注册成功
- (void) registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

// 接收到远程通知
- (void) receiveRemoteNotification:(NSDictionary *)userInfo;

// 判断当前是否接收远程通知
- (BOOL) isOpenNotifications;

// 判断当前系统设置中是否支持推送
- (BOOL) sysIsOpenRemoteNotification;

// 设置是否接收推送通知

//上传Token
-(BOOL) uploadWithDeviceToken:(NSString*) strToken UserName:(NSString*) userName;

@end

#ifndef PUSHMANGER

#define PUSHMANGER ([RemoteNotificationManage sharedRemoteNotificationManage])

#endif