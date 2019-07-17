//
//  BLELock.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.

//这是个标准的锁具model

#import <Foundation/Foundation.h>

@interface BLELock : NSObject
@property (nonatomic , strong) NSString *linkStates;//锁具是否已连接上蓝牙设备,0未连接/拔出，1连接/插入

@property (nonatomic , strong) NSString *LockNo;//锁号
@property (nonatomic , strong) NSString *LockLink;//锁连接状态 0x00 锁拔出 0x01 锁插入
@property (nonatomic , strong) NSString *LockType;//锁具体连接类型  0x00：柜锁 0x01：挂锁
@property (nonatomic , strong) NSString *LockStatus;//开关锁状态：0x00 无效  0x01 锁连接，锁开状态  0x02 锁连接，锁关状态  0x03 自由锁开锁成功  0x04 自由锁开锁失败  0x05 OTC开锁成功  0x06 OTC开锁失败  0x07 预发码开锁成功  0x08 预发码开锁失败  0x09 关锁成功  0x0A 关锁失败  0x0B 离线开锁成功  0x0C 离线关锁失败
@property (nonatomic , strong) NSString *emergencyMode;//应急模式 0未开启 1应急模式
@property (nonatomic , strong) NSString *preMode;//预发模式 0未开启 1预发模式
@property (nonatomic , strong) NSString *offlineMode;//离线模式 0未开启 1离线
@property (nonatomic , assign) NSString *InitStatus;//初始化状态 0.未初始化,1.已初始化
@property (nonatomic , strong) NSString *LockRandom;//锁具随机数
@property (nonatomic , strong) NSString *closeCode;//闭锁码
@property (nonatomic , strong) NSString *lockAngle;//锁具安装角度
@property (nonatomic , assign) NSString *lockCoreState;//锁芯状态 0关 1开
@property (nonatomic , strong) NSString *cluthState;//离合器状态 0关 1开

@property (nonatomic , strong) NSString *LockMode;//解析前的lockMode
@property (nonatomic , strong) NSString *SensorStatus;//解析前的SensorStatus

@property (nonatomic , strong) NSString *VerInfo;//锁具版本信息

- (instancetype)initWithData:(NSData *)data;

@end
