//
//  BLEKey.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.

//变形金刚，做了一堆,钥匙初始化，锁具初始化，开关锁

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



#define ConnectTimeOutLimit 10 //默认连接的超时时间

typedef void(^BLEDeviceConnect)(BOOL  isConnect);

@interface BLEDevice : NSObject
@property (nonatomic , assign) BOOL Connecting;
@property (nonatomic , strong) CBPeripheral *peripheral;//蓝牙设备模型
@property (nonatomic , assign) BOOL Connected;//是否连接
@property (nonatomic , strong) NSString *KeyName;//蓝牙设备名称
@property (nonatomic , strong) NSString *EKeyID;//电子钥匙ID
@property (nonatomic , strong) NSString *MacAddress;//MAC
@property (nonatomic , strong) NSString *InitStatus;//初始化状态 1未初始化，2已经初始化
@property (nonatomic , strong) NSString *FirwareVer;//固件版本
@property (nonatomic , strong) NSString *Voltage;//电压
@property (nonatomic , assign) uint deviceType;


/**
 初始化设备对象

 @param broadCast 设备的广播数据
 @return 钥匙对象
 */
- (instancetype)initWithPerphral:(CBPeripheral *)peripheral broadCast:(NSData *)broadCast;

/**
 连接蓝牙钥匙
 
 @param timeout 连接超时时限
 */
- (void)connect:(NSInteger)timeout result:(BLEDeviceConnect)result;

/**
 断连当前设备
 */
- (void)disconnectBluetooth;


@end
