//
//  BLEKeyMgr.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"
#import "BLEDeviceType.h"

typedef void(^BLEDeviceMgrScanResult)(NSArray <BLEDevice *> *devices);

@interface BLEDeviceMgr : NSObject

+ (instancetype)shareBleDeviceMgr;
/**
 设置扫描过滤器 可不设

 @param filter 过滤器可以是KeyID 或 Mac 地址，多个用逗号分开
 */
- (void)BleDeviceMgr_SetScanFilter:(NSString *)filter;
/**
 扫描设备，根据过滤条件，

 @param result 扫描到所有符合过滤条件的设备回调，每次扫描到符合条件的新设备都会反馈
 */
- (void)BleDeviceMgr_startScan:(EH_BLEDeviceType)type result:(BLEDeviceMgrScanResult)result;


/**
 停止扫描设备
 */
- (void)BleDeviceMgr_StopScan;

/**
断连所有设备
 */
- (void)BleDeviceMgr_disconnectAllDevices;


@end
