//
//  BleMgr.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleEventProtocol.h"

#define NSNotificationCenter_PeripheralBreakConnect @"PeripheralBreakConnect"


@protocol BleConnectDelegate <NSObject>
- (void)bleConnect:(BOOL)success error:(NSError *)error;
@end


typedef void(^BleConnectBlock)(BOOL success , NSError *error);
@interface BleMgr : NSObject
@property (nonatomic , assign) id <BleConnectDelegate> delegate;
@property (nonatomic , assign) id <BleDataSourceProtocol> dataSource;
/**
 管理单列
 
 @return 单列
 */
+ (instancetype)shareBleManger;
/**
 设置过滤
 
 @param devTypeArr 设备类型
 
 */
- (void)bleMgr_setFilter:(NSArray *)devTypeArr ;
/**
 扫描设备
 */
- (void)bleMgr_startScan;

/**
 停止扫描
 */
- (void)bleMgr_stopScan;

/**
 连接蓝牙设备

 @param periphral 待连接设备
 */
- (void)bleMgr_connectPeriphral:(CBPeripheral *)periphral connectResult:(BleConnectBlock)block;

/**
 断连蓝牙设备

 @param periphral 待断连设备
 */
- (void)bleMgr_disconnectPeriphral:(CBPeripheral *)periphral connectResult:(BleConnectBlock)block;

/**
 断连所有设备
 */
- (void)bleMgr_disconnectPeriphrals;



@end
