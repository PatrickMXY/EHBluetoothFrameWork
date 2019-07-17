//
//  BLEKeyParam.h
//  EHBluetooth
//
//  Created by 梦醒 on 2019/3/6.
//  Copyright © 2019 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEKeyParam : NSObject
@property (nonatomic , strong) NSString *keyMode;//keyMode hexString

@property (nonatomic , strong) NSString *lockAuth;//关锁授权 0 无需授权 1 需要授权
@property (nonatomic , strong) NSString *pressMode;//按键确认 0 强制关锁 1 开关锁键
@property (nonatomic , strong) NSString *rouseType;//唤醒方式 0：Touch唤醒 1：按键唤醒
@property (nonatomic , strong) NSString *lockRouse;//锁唤醒广播 0：锁唤醒广播 1：锁不唤醒广播
@property (nonatomic , strong) NSString *ekeyLockType;//关锁方式 0：自动关锁 1：手动关锁
@property (nonatomic , strong) NSString *ekeyUnlockType;//开锁方式 0：自动开锁 1：手动开锁
@property (nonatomic , strong) NSString *hummerSwitch;//蜂鸣器 0：开 1：关
@property (nonatomic , strong) NSString *bleTimeOver;//蓝牙超时时间，单位为10s，无数据通信关闭蓝牙


/**
 通过二进制产生一个配置参数的对象

 @param binary 二进制 必须是8位
 @return param
 */
- (instancetype)initWithBinary:(NSString *)binary timeOver:(NSString *)timeOver;

/**
 通过十六进制产生一个配置参数对象

 @param hexString 十六进制
 @return param
 */
- (instancetype)initWithHexString:(NSString *)hexString timeOver:(NSString *)timeOver;

@end

NS_ASSUME_NONNULL_END
