//
//  BLEKeyLockLog.m
//  EHBluetooth
//
//  Created by 梦醒 on 2019/1/14.
//  Copyright © 2019 Patrick. All rights reserved.
//

#import "BLEKeyLockLog.h"
#import "BLEKeyStruct.h"

@implementation BLEKeyLockLog
- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        const void *lockdata = data.bytes;
        BleLockGainLog *logInfo = (BleLockGainLog *)lockdata;
        self.LockID = [NSString stringWithFormat:@"%u",(unsigned int)logInfo->LockID];
        self.KeyID = [NSString stringWithFormat:@"%u",(unsigned int)logInfo->KeyID];
        self.LockType = [NSString stringWithFormat:@"%d",logInfo->LockType];
        self.LockMode = [NSString stringWithFormat:@"%d",logInfo->LockMode];
        self.LogType = [NSString stringWithFormat:@"%d",logInfo->LogType];
        self.DateTime = [NSString stringWithFormat:@"%u%@%@%@%@%@", htons(logInfo->TimeYear),
                         [self stringWithIntComplete:logInfo->TimeMouth],
                         [self stringWithIntComplete:logInfo->TimeDay],
                         [self stringWithIntComplete:logInfo->TimeHour],
                         [self stringWithIntComplete:logInfo->TimeMinutes],
                         [self stringWithIntComplete:logInfo->TimeSeconds]];
        self.logCode = [NSString stringWithFormat:@"%u",(unsigned int)logInfo->Code];

    }
    return self;
}
- (void)setLockMode:(NSString *)LockMode
{
    _LockMode = LockMode;
    NSString *lockModeBinary = [NSString getBinaryByDecimal:_LockMode.integerValue];
    if (self.LockType.intValue != 0x00) {
        if (self.LockType.intValue>0x03) {
            self.InitStatus = [lockModeBinary substringWithRange:NSMakeRange(3, 1)];
            self.offlineMode = [lockModeBinary substringWithRange:NSMakeRange(2, 1)];
            self.preMode = [lockModeBinary substringWithRange:NSMakeRange(1, 1)];
            self.emergencyMode = [lockModeBinary substringWithRange:NSMakeRange(0, 1)];;
        }else{
            self.InitStatus = [lockModeBinary substringWithRange:NSMakeRange(7, 1)];
            self.offlineMode = [lockModeBinary substringWithRange:NSMakeRange(6, 1)];
            self.preMode = [lockModeBinary substringWithRange:NSMakeRange(5, 1)];
            self.emergencyMode = [lockModeBinary substringWithRange:NSMakeRange(4, 1)];
        }
    }
}
//转换成的时间格式需要补零操作
- (NSString *)stringWithIntComplete:(int)figure
{
    NSString *str = [NSString stringWithFormat:@"%u", figure];
    if (str.length == 1) {
        str = [NSString stringWithFormat:@"0%@", str];
    }
    return str;
}
@end
