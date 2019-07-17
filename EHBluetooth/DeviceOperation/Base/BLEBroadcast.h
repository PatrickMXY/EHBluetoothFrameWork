//
//  BleBroadcast.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.

//基于Easthouse的广播类型

#import <Foundation/Foundation.h>

@interface BLEBroadcast : NSObject
@property (nonatomic , assign) UInt8  devType;
@property (nonatomic , assign) UInt8  devSubType;
@property (nonatomic , assign) UInt8  CMD;
@property (nonatomic , assign) UInt32 keyId;
@property (nonatomic , assign) UInt32 signCode;
@property (nonatomic , assign) UInt8  bleInitStatus;
@property (nonatomic , assign) UInt32 devRandom;
@property (nonatomic , assign) UInt32 firwareVer;
@property (nonatomic , assign) UInt8  Voltage;
@property (nonatomic , assign) UInt32 lockId;
@property (nonatomic , assign) UInt8  lockType;

@property (nonatomic , strong) NSString *closeCode;
@property (nonatomic , strong) NSString *deviceTime;


- (id)initWithBroadcastData:(NSData *)data;

@end
