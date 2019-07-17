//
//  BLEKeyMgr.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/30.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>



@class BLEKey;
typedef void(^BLEKeyMgrScanResult)(NSArray <BLEKey *>*bleKeys);


@interface BLEKeyMgr : NSObject


+ (instancetype)shareBleKeyMgr;
/**
 设置扫描过滤器 可不设

 @param filter 过滤器可以是KeyID 或 Mac 地址，多个用逗号分开
 */
- (void)BleKeyMgr_SetScanFilter:(NSString *)filter;
/**
 扫描设备，根据过滤条件，

 @param result 扫描到所有符合过滤条件的设备回调，每次扫描到符合条件的新设备都会反馈
 */
- (void)BleKeyMgr_StartScan:(BLEKeyMgrScanResult)result;

/**
 停止扫描设备
 */
- (void)BleKeyMgr_StopScan;

/**
 设置搜索到的设备的代理

 @param traget 设置代理的对象
 */
- (void)setEventHanderDelegate:(id)traget;

/**
 断连所有设备
 */
- (void)BleKeyMgr_disconnectAllDevice;


@end
