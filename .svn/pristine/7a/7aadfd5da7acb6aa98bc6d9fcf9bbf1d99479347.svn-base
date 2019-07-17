//
//  BLEKeyMgr.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/30.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEKeyMgr.h"
#import "BLEDeviceMgr.h"
#import "BLEKey.h"

@interface BLEKeyMgr ()
@property (nonatomic , strong) id traget;
@property (nonatomic , copy)   BLEKeyMgrScanResult resultBlock;
@property (nonatomic , strong) BLEDeviceMgr *bleManger;
@property (nonatomic , strong) NSString *filter;
@property (nonatomic , strong) NSMutableArray <BLEKey *>*bleDevices;
@end
@implementation BLEKeyMgr
+ (instancetype)shareBleKeyMgr
{
    static  BLEKeyMgr *keyMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!keyMgr) {
            keyMgr = [[BLEKeyMgr alloc]init];
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
- (void)BleKeyMgr_SetScanFilter:(NSString *)filter
{
     [self.bleManger BleDeviceMgr_SetScanFilter:filter];
}
/**
 扫描设备，根据过滤条件，
 
 @param result 扫描到所有符合过滤条件的设备回调，每次扫描到符合条件的新设备都会反馈
 */
- (void)BleKeyMgr_StartScan:(BLEKeyMgrScanResult)result
{
    __weak typeof(self) weakself = self;
    [self.bleManger BleDeviceMgr_startScan:EH_BLEDeviceTypeEkey result:^(NSArray<BLEDevice *> *bleKeys) {
        if (result) {
            weakself.bleDevices = [[NSMutableArray alloc]initWithArray:bleKeys];
            for (BLEKey *tmpkey in weakself.bleDevices) {
                tmpkey.handlerDelegate = weakself.traget;
               
            }
            result(weakself.bleDevices);
        }
    }];
}

/**
 停止扫描设备
 */
- (void)BleKeyMgr_StopScan
{
    [self.bleManger BleDeviceMgr_StopScan];
}
/**
 设置搜索到的设备的代理
 
 @param traget 设置代理的对象
 */
- (void)setEventHanderDelegate:(id)traget
{
    self.traget = traget;
}
/**
 断连所有设备
 */
- (void)BleKeyMgr_disconnectAllDevice
{
    [self.bleManger BleDeviceMgr_disconnectAllDevices];
}
@end
