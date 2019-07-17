//
//  BLEKey0203.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <EHBluetooth/EHBluetooth.h>

@class BLEW266;
@protocol BleW266EventHandler <NSObject>
/**
 相关操作响应的代理回调
 
 @param device 蓝牙钥匙
 @param lockEvent 响应事件对象
 
 */
- (void)bleW266_EventHandler:(BLEW266 *)device lockEvent:(BLEDeviceEvent *)lockEvent;

@end

@interface BLEW266 : BLEDevice 
@property (nonatomic , strong) NSString *deviceTime;
@property (nonatomic , assign) id <BleW266EventHandler> handlerDelegate; //锁具的处理回调,连接设备成功后回调会实时回传信息


/**
 设置锁具id

 @param lockId 锁id
 */
- (void)setLockID:(NSString *) lockId;

/**
 申请公钥

 @param info 服务器公钥信息
 */
- (void)applyPublicKey:(NSString *)info;

/**
 设置临时通讯秘钥

 @param info 密钥信息
 */
- (void)setCommKey:(NSString *)info;

/**
 设置OTC密钥

 @param info OTC密钥信息
 */
- (void)setOTCKey:(NSString *)info;

/**
 发起开锁请求

 @param info  data json
 @param timeOut timeout

 */
- (void)startUnLock:(NSString *)info timeOut:(NSInteger)timeOut;

/**
 开锁

 @param info 开锁码
 */
- (void)sendOTC:(NSString *)info;

/**
 设置参数
 
 @param doorsNum 锁数量
 @param romMode 蓝牙广播模式 aa按键激活 55普通
 @param lockMode 多锁控制模式：0.顺序、1~4.此锁号每次必开、5.独立；
 @param lockGap 顺序开锁的有效时间
 */
- (void)setParam:(NSString *)doorsNum romMode:(NSString *)romMode lockMode:(NSString *)lockMode lockGap:(NSString *)lockGap;



/**
 预发开锁

 @param info 所有参数
 */
- (void)sendPreOTC:(NSString *)info;


/**
 同步时间
 */
- (void)setTime;
@end

