//
//  BLEKeyStruct.h
//  EHBluetooth
//
//  Created by 梦醒 on 2019/1/14.
//  Copyright © 2019 Patrick. All rights reserved.
//

#ifndef BLEKeyStruct_h
#define BLEKeyStruct_h
//获取锁具随机数
typedef struct __attribute__((packed)) {
    UInt32 LockId;
    UInt32 random;
} BleLockApplyOTC;
//获取钥匙随机数
typedef struct __attribute__((packed)) {
    UInt32 random;
} BleKeyApplyRandom;
//锁状态
typedef struct __attribute__((packed)) {
    UInt32 LockId;
    UInt8 LockLink; //0未连接，1已连接
} BleLockState;
//锁状态变化
typedef struct __attribute__((packed)) {
    UInt32 LockId;
    UInt8 lockLink; //0未连接，1已连接
    UInt8 LockState; //0x00无效，0x01锁连接，关锁， 0x02锁连接，开锁， 0x03自有锁开锁成功， 0x04 自有锁开锁失败 ，0x05 OTC开锁成功， 0x06 OTC开锁失败 ，0x07预发码开锁成功，0x08预发码开锁失败 0x09 关锁成功 0x0a 关锁失败
    UInt32 closeCode;
    UInt32 LockRand;
    UInt8 LockType;
    UInt8 LockMode;
    UInt8 FixDeg;
    UInt8 SensorStatus;
    UInt8 LogNum;
} BleLockStateChange;
typedef struct __attribute__((packed)) {
    UInt32 LockID;
    UInt32 KeyID;
    UInt8  LockType;
    UInt8  LockMode;
    UInt8  LogType;
    UInt16 TimeYear;
    UInt8  TimeMouth;
    UInt8  TimeDay;
    UInt8  TimeHour;
    UInt8  TimeMinutes;
    UInt8  TimeSeconds;
    UInt32 Code;
} BleLockGainLog;
typedef struct __attribute__((packed)) {
    UInt8 Voltage;
    UInt8 KeyMode;
    UInt8 TimeOver;
    UInt8 OfflineKey;
    UInt8 LogNum;
    UInt32 KeyRand;
    UInt32 LockID;
    UInt8 LockType;
    UInt8 LockMode;
    UInt32 LockRand;
    UInt32 CloseRand;
    UInt8 FixDeg;
    UInt8 SensorStatus;
} BleDeviceInfo;
typedef struct __attribute__((packed)) {
    UInt32 offlineKey1;
    UInt32 offlineKey2;
    UInt32 offlineKey3;
    UInt32 offlineKey4;
    UInt32 offlineKey5;
    UInt32 offlineKey6;
    UInt32 offlineKey7;
    UInt32 offlineKey8;
} BleOfflineKey;
typedef struct __attribute__((packed)) {
    UInt32 KeyVersion;
    UInt32 LockVersion;
} BleVersionInfo;
typedef struct __attribute__((packed)) {
    UInt16 LogNum;
} BleLogInfo;

#endif /* BLEKeyStruct_h */
