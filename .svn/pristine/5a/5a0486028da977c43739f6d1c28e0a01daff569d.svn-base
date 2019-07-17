//
//  BLELock.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLELock.h"

typedef struct  __attribute__((packed)) {
    UInt32  lockId;
    UInt8   lockInit;
    UInt8   lockMode;//0x00：自由开锁 0x01：主动实时开锁  0x02：离线开锁 0x03：被动实时开锁
    UInt32  VerInfo;
    UInt8   LockState;//锁状态
    UInt8   CLTState;//离合器状态
}BLELockData;

@implementation BLELock
- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        const void *lockdata = data.bytes;
        BLELockData *lockInfo = (BLELockData *)lockdata;
        self.LockNo = [NSString stringWithFormat:@"%u",(unsigned int)lockInfo->lockId];
        self.InitStatus = [NSString stringWithFormat:@"%u",lockInfo->lockInit];
        self.lockCoreState = [NSString stringWithFormat:@"%u",lockInfo->LockState];
        self.cluthState = [NSString stringWithFormat:@"%u",lockInfo->CLTState];
        
        UInt8 lockBuild = lockInfo->VerInfo &0xff;
        UInt8 lockVersion = (lockInfo->VerInfo>>8)&0xff;
        self.VerInfo = [NSString stringWithFormat:@"%d.%d",lockVersion,lockBuild];
    }
    return self;
}
- (void)setLockType:(NSString *)LockType
{
    _LockType = LockType;
}
- (void)setLockMode:(NSString *)LockMode
{
    _LockMode = LockMode;
    NSString *lockModeBinary = [NSString getBinaryByDecimal:_LockMode.integerValue];
    if (_LockType.intValue == 0x01) {
            self.InitStatus = [lockModeBinary substringWithRange:NSMakeRange(3, 1)];
            self.offlineMode = [lockModeBinary substringWithRange:NSMakeRange(2, 1)];
            self.preMode = [lockModeBinary substringWithRange:NSMakeRange(1, 1)];
            self.emergencyMode = [lockModeBinary substringWithRange:NSMakeRange(0, 1)];
    }else if(_LockType.intValue == 0x00){
            self.InitStatus = [lockModeBinary substringWithRange:NSMakeRange(7, 1)];
            self.offlineMode = [lockModeBinary substringWithRange:NSMakeRange(6, 1)];
            self.preMode = [lockModeBinary substringWithRange:NSMakeRange(5, 1)];
            self.emergencyMode = [lockModeBinary substringWithRange:NSMakeRange(4, 1)];
    }
    
}
- (void)setSensorStatus:(NSString *)SensorStatus
{
    _SensorStatus = SensorStatus;
    NSString *sensorBinary = [NSString getBinaryByDecimal:_SensorStatus.integerValue];
    self.cluthState = [sensorBinary substringWithRange:NSMakeRange(7, 1)];
    self.lockCoreState = [sensorBinary substringWithRange:NSMakeRange(6, 1)];
}
@end
