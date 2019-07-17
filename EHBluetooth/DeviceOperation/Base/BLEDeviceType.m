//
//  BleDevType.m
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEDeviceType.h"
#import "BLEBroadcast.h"

#define BLEV1_CHARACTERISTIC_WRITE @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define BLEV1_CHARACTERISTIC_READ  @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define BLEV1_CHARACTERISTIC_SERVICE @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"


@implementation BLEDeviceType
- (instancetype)initWithBroadCast:(NSData *)broadCast
{
    if (self = [super init]) {
        BLEBroadcast *cast = [[BLEBroadcast alloc]initWithBroadcastData:broadCast];
        if (cast.devType == EH_BLEDeviceTypeEkey) {
            self.deviceType = EH_BLEDeviceTypeEkey;
            self.devSubType = cast.devSubType;
            self.serviceCharacteristic = BLEV1_CHARACTERISTIC_SERVICE;
            self.writeCharacteristic   = BLEV1_CHARACTERISTIC_WRITE;
            self.readCharacteristic    = BLEV1_CHARACTERISTIC_READ;
        }else if (cast.devType == EH_BLEDeviceTypeW266){
            self.deviceType = EH_BLEDeviceTypeW266;
            self.devSubType = cast.devSubType;
            self.serviceCharacteristic = BLEV1_CHARACTERISTIC_SERVICE;
            self.writeCharacteristic   = BLEV1_CHARACTERISTIC_WRITE;
            self.readCharacteristic    = BLEV1_CHARACTERISTIC_READ;
        }else{
            self.deviceType = EH_BLEDeviceTypeUnknow;
        }
    }
    return self;
}

@end
