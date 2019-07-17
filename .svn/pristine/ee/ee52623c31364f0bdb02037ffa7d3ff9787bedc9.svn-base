//
//  BleClient.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleEventProtocol.h"


@interface BleClient : NSObject
@property (nonatomic , assign) id <BleEventProtocol> delegate;

/**
 初始化Client对象

 @param peripheral Client绑定的设备
 @return Client对象
 */
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

/**
 连接设备

 */
- (void)bleClient_connect;

/**
 断连当前设备
 */
- (void)bleClient_disconnect;

/**
 数据写入
 不需要等待回复

 @param dataArr 分包 要写入的数据
 */
- (void)bleClient_sendData:(NSArray *)dataArr;

/**
 数据写入
 等待回复设置超时时间
 
 @param dataArr 分包 要写入的数据
 */
- (void)bleClient_sendData:(NSArray *)dataArr timeOut:(NSInteger)timeOut;



@end
