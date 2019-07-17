//
//  BLEW266Mgr.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/30.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEW266Mgr.h"
#import "BLEDeviceMgr.h"
#import "BLEW266.h"

@interface BLEW266Mgr()
@property (nonatomic , strong) id traget;
@property (nonatomic , copy)   BLEW266MgrScanResult resultBlock;
@property (nonatomic , strong) BLEDeviceMgr *bleManger;
@property (nonatomic , strong) NSString *filter;
@property (nonatomic , strong) NSMutableArray <BLEW266 *>*bleDevices;
@end
@implementation BLEW266Mgr
+ (instancetype)shareBleW266Mgr
{
    static  BLEW266Mgr *keyMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!keyMgr) {
            keyMgr = [[BLEW266Mgr alloc]init];
        }
    });
    return keyMgr;
}
- (BLEDeviceMgr *)bleManger
{
    return _bleManger = _bleManger?:[BLEDeviceMgr shareBleDeviceMgr];
}
/**
 设置扫描过滤器 可不设
 
 @param filter 过滤器可以是KeyID 或 Mac 地址，多个用逗号分开
 */
- (void)BleW266Mgr_SetScanFilter:(NSString *)filter
{
    [self.bleManger BleDeviceMgr_SetScanFilter:filter];
}
/**
 扫描设备，根据过滤条件，
 
 @param result 扫描到所有符合过滤条件的设备回调，每次扫描到符合条件的新设备都会反馈
 */
- (void)BleW266Mgr_StartScan:(BLEW266MgrScanResult)result
{
    WEAKSELF;
    weakSelf.bleDevices = nil;
    [self.bleManger BleDeviceMgr_startScan:EH_BLEDeviceTypeW266 result:^(NSArray<BLEDevice *> *devices) {
        if (result) {
//            bug
            weakSelf.bleDevices = [[NSMutableArray alloc]initWithArray:devices];
            for (BLEW266 *tmpKey in weakSelf.bleDevices) {
                tmpKey.handlerDelegate = weakSelf.traget;
            }
            result(weakSelf.bleDevices);
        }
    }];
}

/**
 停止扫描设备
 */
- (void)BleW266Mgr_StopScan
{
    [self.bleManger BleDeviceMgr_StopScan];
}

/**
 设置搜索到的设备的代理
 
 @param traget 设置代理的对象
 */
- (void)setEventHanderDelegate:(id)traget
{
    _traget = traget;
}

- (void)BleW266Mgr_disconnectAllDevice
{
    [self.bleManger BleDeviceMgr_disconnectAllDevices];
}
@end
