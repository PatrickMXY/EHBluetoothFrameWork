//
//  BleDevType.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,EH_BLEDeviceType){
    EH_BLEDeviceTypeEkey = 0xb1,
    EH_BLEDeviceTypeW266 = 0x61,
    EH_BLEDeviceTypeUnknow,
};

@interface BLEDeviceType : NSObject

@property (nonatomic , assign) EH_BLEDeviceType deviceType;
@property (nonatomic , assign) uint     devSubType;
@property (nonatomic , strong) NSString *serviceCharacteristic;
@property (nonatomic , strong) NSString *writeCharacteristic;
@property (nonatomic , strong) NSString *readCharacteristic;

- (instancetype)initWithBroadCast:(NSData *)broadCast;

@end
