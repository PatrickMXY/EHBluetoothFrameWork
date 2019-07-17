//
//  BleEventProtocol.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/12.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleDevEvent.h"

@protocol BleEventProtocol <NSObject>
@optional
/**
 连接设备

 @param success 连接结果
 @param error 错误信息
 */
- (void)bleEvent_connectResult:(BOOL)success error:(NSError *)error;

/**
 设备相关的事件
 
 @param bleEvent 事件
 @param error 错误信息
 */
- (void)bleEvent_bleDevEvent:(BleDevEvent *)bleEvent error:(NSError *)error;

@end

@protocol BleDataSourceProtocol <NSObject>

/**
 扫描响应事件
 
 @param peripheral 扫描到的设备
 @param broadCast  广播数据
 @param error 错误信息
 */
- (void)bleDataSource_scanResult:(CBPeripheral *)peripheral broadCast:(NSData *)broadCast error:(NSError *)error;


@end
