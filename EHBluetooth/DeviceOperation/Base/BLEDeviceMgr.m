//
//  BLEKeyMgr.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEDeviceMgr.h"
#import "BleMgr.h"
#import "BLEDeviceType.h"
#import "BLEKey.h"
#import "BLEW266.h"
#import "BLEBroadcast.h"

@interface BLEDeviceMgr ()<BleDataSourceProtocol>
@property (nonatomic , assign) EH_BLEDeviceType type;
@property (nonatomic , copy)   BLEDeviceMgrScanResult resultBlock;
@property (nonatomic , strong) BleMgr *bleManger;
@property (nonatomic , strong) NSArray *filter;
@property (nonatomic , strong) NSMutableArray <BLEDevice *>*bleDevices;
@property (nonatomic , strong) NSMutableArray <BLEBroadcast *>*broadCastArr;

@end
@implementation BLEDeviceMgr

+ (instancetype)shareBleDeviceMgr
{
    static  BLEDeviceMgr *keyMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!keyMgr) {
            keyMgr = [[BLEDeviceMgr alloc]init];
        }
    });
    return keyMgr;
}
- (BleMgr *)bleManger
{
    if (!_bleManger) {
        _bleManger = _bleManger?:[BleMgr shareBleManger];
        _bleManger.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BLEKeyMgr_breakConnect:) name:NSNotificationCenter_PeripheralBreakConnect object:nil];
    }
    return _bleManger;
}
- (NSMutableArray <BLEDevice *> *)bleDevices
{
    return _bleDevices = _bleDevices?:[[NSMutableArray alloc]init];
}

/**
 设置扫描过滤器
 
 @param filter 过滤器可以是KeyID 或 Mac 地址，多个用逗号分开
 */
- (void)BleDeviceMgr_SetScanFilter:(NSString *)filter
{
    self.filter = [filter componentsSeparatedByString:@","];
}
/**
 扫描设备，根据过滤条件
 
 @param result 扫描到所有符合过滤条件的设备回调
 */
- (void)BleDeviceMgr_startScan:(EH_BLEDeviceType)type result:(BLEDeviceMgrScanResult)result
{
    _resultBlock = result;
    _type = type;
    if (self.bleDevices.count>0) {
        [self BleDeviceMgr_disconnectPeriphrals];
        [self.bleDevices removeAllObjects];
        [self.broadCastArr removeAllObjects];

    }
    [self.bleManger bleMgr_startScan];
}

/**
 断连所有设备
 */
- (void)BleDeviceMgr_disconnectPeriphrals
{
    for (BLEDevice *tmpKey in _bleDevices) {
        if (tmpKey.Connected) {
            [tmpKey disconnectBluetooth];
        }
    }
}
//停止扫描设备
- (void)BleDeviceMgr_StopScan
{
    [self.bleManger bleMgr_stopScan];
}
- (void)BLEKeyMgr_breakConnect:(NSNotification *)notification
{
    CBPeripheral *breckConnectP = notification.object;
    NSInteger index = 0;
    NSMutableArray *refreshKeys = [[NSMutableArray alloc]initWithArray:self.bleDevices];
    for (BLEDevice *tmpKey in self.bleDevices) {
        if (tmpKey.peripheral.identifier == breckConnectP.identifier){
            BLEDevice *breakConnectKey = tmpKey;
            breakConnectKey.Connected = NO;
            [refreshKeys replaceObjectAtIndex:index withObject:tmpKey];
        }
        index++;
    }
    self.bleDevices = refreshKeys;
    if (_resultBlock) {
        _resultBlock(self.bleDevices);
    }
}
/**
 断连所有设备
 */
- (void)BleDeviceMgr_disconnectAllDevices
{
    [self.bleManger bleMgr_disconnectPeriphrals];
}
#pragma mark BleEventProtocolScanResult
- (void)bleDataSource_scanResult:(CBPeripheral *)peripheral broadCast:(NSData *)broadCast error:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error.domain);
        if (_resultBlock) {
            [self.bleDevices removeAllObjects];
            [self.broadCastArr removeAllObjects];
            _resultBlock(self.bleDevices);
        }
        return;
    }
    
    BLEDeviceType *deviceType = [[BLEDeviceType alloc]initWithBroadCast:broadCast];
    if (_type == deviceType.deviceType && _type == EH_BLEDeviceTypeEkey) {
        BLEKey *key = [[BLEKey alloc]initWithPerphral:peripheral broadCast:broadCast];
        BOOL keyExist = NO;
        for (BLEKey *tmpKey in self.bleDevices) {
            if ([key.EKeyID isEqualToString:tmpKey.EKeyID]) {
                keyExist = YES;
            }
        }
        if (!keyExist) {
            if (self.filter.count>0) {
                if ([self.filter containsObject:key.EKeyID]) {
                    [self.bleDevices addObject:key];
                }
            }else{
                [self.bleDevices addObject:key];
            }
            if (_resultBlock) {
                _resultBlock(self.bleDevices);
            }
        }
    }else if (_type == deviceType.deviceType&& _type == EH_BLEDeviceTypeW266){
        BLEBroadcast *tmpBroadCast = [[BLEBroadcast alloc]initWithBroadcastData:broadCast];
        NSLog(@"闭锁码%@",tmpBroadCast.closeCode);
        BLEW266 *key = [[BLEW266 alloc]initWithPerphral:peripheral broadCast:broadCast];
        BOOL keyExist = NO;
        for (BLEW266 *tmpKey in self.bleDevices) {
            if ([key.EKeyID isEqualToString:tmpKey.EKeyID]) {
                keyExist = YES;
            }
        }
        if (!keyExist) {
            if (self.filter.count>0) {
                if ([self.filter containsObject:key.EKeyID]) {
                    [self.bleDevices addObject:key];
                    [self.broadCastArr addObject:tmpBroadCast];
                }
            }else{
                [self.bleDevices addObject:key];
                [self.broadCastArr addObject:tmpBroadCast];
            }
            if (_resultBlock) {
                _resultBlock(self.bleDevices);
            }
        }
        
        NSInteger index=0;
        NSMutableArray *tmpCastArr = [[NSMutableArray alloc]initWithArray:self.broadCastArr];
        for (BLEBroadcast *tmpCast in _broadCastArr) {
//            NSLog(@"数组里的m闭锁码%@-----%d",tmpCast.closeCode,tmpCast.keyId);
            if (tmpCast.keyId == tmpBroadCast.keyId) {
                if (![tmpCast.closeCode isEqualToString:tmpBroadCast.closeCode]&&![tmpBroadCast.closeCode isEqualToString:@"4294967295"]) {
                    [tmpCastArr replaceObjectAtIndex:index withObject:tmpBroadCast];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLEBroadCastUpDate" object:tmpBroadCast];
                }
            }
            index++;
        }
        _broadCastArr = tmpCastArr;
    }
}
- (NSMutableArray <BLEBroadcast *>*)broadCastArr
{
    return _broadCastArr = _broadCastArr?:[NSMutableArray new];
}

@end
