//
//  BleBroadcast.m
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEBroadcast.h"
#import "BLEDeviceType.h"

//接受广播数据的结构体
typedef struct  __attribute__((packed)) {
    UInt8  DevType;
    UInt8  DevSubType;
    UInt8  CMD;//0x03：已连锁，等待连接  0x02：未连锁广播
    UInt32 KeyId;
    UInt32 SignCode;
    UInt8  initStatus;
    UInt32 DevRandom;
    UInt32 LockId;
    UInt8  Voltage;
    UInt8  lockType;
}BLEDeviceBroadcastEkey;
typedef struct  __attribute__((packed)) {
    UInt8  DevType;
    UInt8  DevSubType;
    UInt8  CMD;//0x03：请求连接   0x02：等待连接
    UInt32 KeyId;
    UInt32 SignCode;
    UInt8  Voltage;
    UInt32 CloseCode;
    UInt8  Spare;
    UInt8  year;
    UInt8  mouth;
    UInt8  day;
    UInt8  hours;
    UInt8  minutes;
    UInt8  seconds;

}BLEDeviceBroadcastW266;

@implementation BLEBroadcast
- (id)initWithBroadcastData:(NSData *)data
{
    if (self=[super init]) {
        if (data.length>0) {
            Byte *bytes = (Byte *)[data bytes];
            int deviceType = bytes[0];
            if (deviceType == EH_BLEDeviceTypeEkey) {
                const void *broadcastData = data.bytes;
                BLEDeviceBroadcastEkey *broadcast = (BLEDeviceBroadcastEkey *)broadcastData;
                self.devType        = broadcast->DevType;
                self.devSubType     = broadcast->DevSubType;
                self.CMD            = broadcast->CMD;
                self.keyId          = broadcast->KeyId;
                self.signCode       = broadcast->SignCode;
                self.bleInitStatus  = broadcast->initStatus;
                self.devRandom      = broadcast->DevRandom;
                self.Voltage        = broadcast->Voltage;
                self.lockId         = broadcast->LockId;
                self.lockType       = broadcast->lockType;
            }else if (deviceType == EH_BLEDeviceTypeW266){
                const void *broadcastData = data.bytes;
                BLEDeviceBroadcastW266 *broadcast = (BLEDeviceBroadcastW266 *)broadcastData;
                self.devType        = broadcast->DevType;
                self.devSubType     = broadcast->DevSubType;
                self.CMD            = broadcast->CMD;
                self.keyId          = broadcast->KeyId;
                self.signCode       = broadcast->SignCode;
                self.Voltage        = broadcast->Voltage;
                UInt32 closeCode = broadcast->CloseCode;
                Byte code[4] = {
                    (Byte) ((closeCode & 0xFFFFFFFF)),
                    (Byte) ((closeCode & 0xFFFFFFFF)>>8),
                    (Byte) ((closeCode & 0xFFFFFFFF)>>16),
                    (Byte) ((closeCode & 0xFFFFFFFF)>>24),
                };
                NSData *codeData = [[NSData alloc]initWithBytes:code length:4];                self.closeCode      = [NSString getDecimalByHex:[codeData toHexString]];
                self.deviceTime     = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                       [self stringWithIntComplete:broadcast->year],
                                       [self stringWithIntComplete:broadcast->mouth],
                                       [self stringWithIntComplete:broadcast->day],
                                       [self stringWithIntComplete:broadcast->hours],
                                       [self stringWithIntComplete:broadcast->minutes],
                                       [self stringWithIntComplete:broadcast->seconds]];

            }
        }
    }    return self;
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
//闭锁码不足8位在前面补零
- (void)setCloseCode:(NSString *)closeCode
{
    if ([NSString isStringEmpty:closeCode]) {
        return;
    }
    NSMutableString *mutableCloseCode = [[NSMutableString alloc]initWithString:closeCode];
    while (mutableCloseCode.length<8) {
        [mutableCloseCode insertString:@"0" atIndex:0];
    }
    _closeCode = mutableCloseCode;
}



@end
