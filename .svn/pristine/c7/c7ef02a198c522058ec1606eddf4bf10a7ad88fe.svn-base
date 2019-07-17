//
//  EHBLEInteractionProtocol.m
//  BluetoothLock
//
//  Created by Patrick on 2018/4/9.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEKeyProtocol.h"
#import "BLEDeviceCmdPackage.h"
#import "Encrept.h"
#import "BLEInterfaceType.h"


@interface BLEKeyProtocol ()
@property (nonatomic , strong) NSString *devAddr;
@property (nonatomic , assign) UInt8 devSubType;
@property (nonatomic , strong) BLEDeviceType *deviceType;

@end
@implementation BLEKeyProtocol
+ (instancetype)shareBLEProtocol
{
    static BLEKeyProtocol *protocol = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!protocol) {
            protocol = [[BLEKeyProtocol alloc]init];
        }
    });
    return protocol;
}
/**
 根据设备区分协议样本
 
 @param deviceType 设备类型
 */
- (void)setDeviceType:(BLEDeviceType *)deviceType devAddr:(NSString *)devAddr
{
    _deviceType = deviceType;
    self.devAddr = devAddr;
    self.devSubType = _deviceType.devSubType;
}

/**
 统配协议模型

 @param cmd cmd名称
 @param data 数据
 @param needEncrypt 是否需要加密
 @return 协议模型
 */
- (BLEDeviceCmdPackage *)bleProtocol_configProtocolModel:(unsigned int)cmd data:(NSData *)data needEncrypt:(BOOL)needEncrypt
{
    BLEDeviceCmdPackage *protocolModel = [[BLEDeviceCmdPackage alloc]init];;
    protocolModel->CMD    = cmd;
    protocolModel->Random = (int)random();
    protocolModel->DDevAddr = 99548789;
    protocolModel->SDevAddr = 1234;
    protocolModel->DDevSubType = self.devSubType;
    [protocolModel setPkgData:data];
    return protocolModel;
}
//初始化钥匙
- (NSArray *)bleProtocol_keyInit:(NSString *)commKey kcv:(NSString *)kcv
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[commKey hexStringToData]];
    [data appendData:[kcv hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeInitKey data:data needEncrypt:YES] ToDatas];
}

//初始化锁具
- (NSArray *)bleProtocol_lockInit:(NSString *)LockID OTCKey:(NSString *)OTCKey OTCKCV:(NSString *)OTCKCV LockMode:(NSString *)LockMode codeList:(NSString *)codeList temporaryCommkey:(NSData *)temporaryCommkey
{

    NSMutableData *data = [[NSMutableData alloc]init];
    UInt32 lockId = LockID.intValue;
    Byte lockIDByte[4] = {
        (Byte) ((lockId & 0xFFFFFFFF)),
        (Byte) ((lockId & 0xFFFFFFFF)>>8),
        (Byte) ((lockId & 0xFFFFFFFF)>>16),
        (Byte) ((lockId & 0xFFFFFFFF)>>24),
    };
    [data appendData:[NSData dataWithBytes:lockIDByte length:sizeof(lockIDByte)]];
    [data appendData:[OTCKey hexStringToData]];
    [data appendData:[OTCKCV hexStringToData]];
    [data appendData:[LockMode hexStringToData]];
    [data appendData:[codeList hexStringToData]];
    NSMutableData *signData = [[NSMutableData alloc]initWithData:data];
    [signData appendData:temporaryCommkey];
    [data appendData:[signData sha1]];

    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeInitLock data:data needEncrypt:YES] ToDatas];
}
//更新应急码
- (NSArray *)bleProtocol_updateEmergencyKey:(NSString *)emergencyInfo
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[emergencyInfo hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceUpdateEmergencyKey data:data needEncrypt:YES] ToDatas];
}
//同步时间
- (NSArray *)bleProtocol_resetTime:(NSData*)temporaryCommkey
{
    NSDateFormatter *datefomatter = [[NSDateFormatter alloc]init];
    [datefomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *TimeStr = [datefomatter stringFromDate:[NSDate date]];
    NSString *year = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(0, 4)] intValue]];
    NSString *mouth = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(4, 2)] intValue]];
    NSString *day = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(6, 2)] intValue]];
    NSString *hour  = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(8, 2)] intValue]];
    NSString *minnutes = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(10, 2)] intValue]];
    NSString *seconds = [NSString getHexByDecimal:[[TimeStr substringWithRange:NSMakeRange(12, 2)] intValue]];

    NSMutableData *sendData = [[NSMutableData alloc]init];
    [sendData appendData:[year hexStringToData]];
    [sendData appendData:[mouth hexStringToData]];
    [sendData appendData:[day hexStringToData]];
    [sendData appendData:[hour hexStringToData]];
    [sendData appendData:[minnutes hexStringToData]];
    [sendData appendData:[seconds hexStringToData]];

    NSMutableData *signData = [[NSMutableData alloc]initWithData:sendData];
    [signData appendData:temporaryCommkey];
    [sendData appendData:[signData sha1]];
    
    
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeResetTime data:sendData needEncrypt:YES] ToDatas];
}

//获取锁具信息
- (NSArray *)bleProtocol_gainLockInfo
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeGainLockInfo data:data needEncrypt:YES] ToDatas];
}

//发起开锁
- (NSArray *)bleProtocol_startUnlock
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
    
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeStartUnlock data:data needEncrypt:YES] ToDatas];
}
////申请临时秘钥
//- (NSArray *)bleProtocol_applyForCommKey:(UInt32)KeyID Random:(UInt32)Random
//{
//    Byte byte[8] = {
//        (Byte) ((KeyID & 0xFFFFFFFF)),
//        (Byte) ((KeyID & 0xFFFFFFFF)>>8),
//        (Byte) ((KeyID & 0xFFFFFFFF)>>16),
//        (Byte) ((KeyID & 0xFFFFFFFF)>>24),
//        (Byte) ((Random & 0xFFFFFFFF)),
//        (Byte) ((Random & 0xFFFFFFFF)>>8),
//        (Byte) ((Random & 0xFFFFFFFF)>>16),
//        (Byte) ((Random & 0xFFFFFFFF)>>24)
//    };
//    NSMutableData *data = [[NSMutableData alloc]init];
//    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
//    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeApplyForCommKey data:data needEncrypt:YES] ToDatas];
//}
//回复硬件收到申请OTC指令
- (NSArray *)bleProtocol_replyApply
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeApplyOTC data:data needEncrypt:YES] ToDatas];
}
//获取钥匙随机数
- (NSArray *)bleProtocol_gainKeyRandom
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeGainKeyRandom data:data needEncrypt:YES] ToDatas];
}
//发送otc开锁
- (NSArray *)bleProtocol_sendOTC:(NSString *)LockID  otc:(NSString *)otc
{
    uint lockIdCode = LockID.intValue;
    uint otcCode = otc.intValue;
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:&lockIdCode length:4]];
    [data appendData:[NSData dataWithBytes:&otcCode length:4]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendOTC data:data needEncrypt:YES] ToDatas];
    
}
//发送预发码
- (NSArray *)bleProtocol_sendPre:(NSString *)preCode
{
    uint preotc = preCode.intValue;
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:&preotc length:4];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendPreOTC data:data needEncrypt:YES] ToDatas];
}
//下发预发因子
- (NSArray *)bleProtocol_senPreFactor:(NSString *)factorInfo
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[factorInfo hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendPreFactor data:data needEncrypt:YES] ToDatas];
}
//更改离线模式
- (NSArray *)bleProtocol_changeOfflineMode:(NSString *)offMode OffModeInfo:(NSString *)OffModeInfo temporaryCommkey:(NSData *)temporaryCommkey
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[offMode hexStringToData]];
    [data appendData:[OffModeInfo hexStringToData]];
    
    NSMutableData *signData = [[NSMutableData alloc]initWithData:data];
    [signData appendData:temporaryCommkey];
    [data appendData:[signData sha1]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeChangeOfflineMode data:data needEncrypt:YES] ToDatas];
}

//删除钥匙离线秘钥
- (NSArray *)bleProtocol_clearOfflineCode:(NSString *)LockID temporaryCommkey:(NSData *)temporaryCommkey
{
    NSMutableData *data = [NSMutableData new];
    UInt32 lockId = LockID.intValue;
    Byte lockIDByte[4] = {
        (Byte) ((lockId & 0xFFFFFFFF)),
        (Byte) ((lockId & 0xFFFFFFFF)>>8),
        (Byte) ((lockId & 0xFFFFFFFF)>>16),
        (Byte) ((lockId & 0xFFFFFFFF)>>24),
    };
    [data appendData:[NSData dataWithBytes:lockIDByte length:sizeof(lockIDByte)]];
    
    UInt32 random = rand();
    Byte randInfo[4] = {
        (Byte) ((random & 0xFFFFFFFF)),
        (Byte) ((random & 0xFFFFFFFF)>>8),
        (Byte) ((random & 0xFFFFFFFF)>>16),
        (Byte) ((random & 0xFFFFFFFF)>>24),
    };
    [data appendData:[NSData dataWithBytes:randInfo length:sizeof(lockIDByte)]];
    NSData *randomData = [[NSData alloc]initWithBytes:randInfo length:4];
    NSMutableData *randomDataComplete = [[NSMutableData alloc]initWithData:randomData];
    [randomDataComplete appendData:[@"0102030405060708090a0b0c" hexStringToData]];
    NSData *checkValue = [randomDataComplete AES128_encryptKeyData:temporaryCommkey base64:NO];
    [data appendData:checkValue];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeClearOfflineCode data:data needEncrypt:YES] ToDatas];
}

//下发离线秘钥
- (NSArray *)bleProtocol_sendOfflineCode:(NSString *)OffModeInfo temporaryCommkey:(NSData *)temporaryCommkey
{
    NSMutableData *data = [NSMutableData new];
    NSData *sendData = [[OffModeInfo hexStringToData] AES128_encryptKeyData:temporaryCommkey base64:NO];
    
    
     [data appendData:sendData];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendOfflineCode data:data needEncrypt:YES] ToDatas];
}

//授权关锁
- (NSArray *)bleProtocol_LockIn:(NSString *)authCode
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[authCode hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeLockIn data:data needEncrypt:YES] ToDatas];
}
//记录锁体角度
- (NSArray *)bleProtocol_lockAngleRecord
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeLockAngleRecord data:data needEncrypt:YES] ToDatas];
}
//设置临时通讯秘钥生命周期
- (NSArray *)bleProtocol_setCommkeyLifecycle:(int)lifecycle
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:&lifecycle length:4];
    [data appendData:[data sha1]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSetCommkeyLifecycle data:data needEncrypt:YES] ToDatas];
}
//设置钥匙参数
- (NSArray *)bleProtocol_setParam:(NSString *)keyMode timeOver:(UInt8)timeOver temporaryCommkey:(NSData *)temporaryCommkey
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[keyMode hexStringToData]];
    [data appendBytes:&timeOver length:1];
    NSMutableData *signData = [[NSMutableData alloc]initWithData:data];
    [signData appendData:temporaryCommkey];
    
    [data appendData:[signData sha1]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSetParam data:data needEncrypt:YES] ToDatas];
}
//查询离线秘钥
- (NSArray *)bleProtocol_queryOfflineCode
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeQueryOfflineCode data:data needEncrypt:YES] ToDatas];
}
//获取设备信息
- (NSArray *)bleProtocol_gainDeviceInfo
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeGainEkeyAndLock data:data needEncrypt:YES] ToDatas];
}
//申请回传日志
- (NSArray *)bleProtocol_applyLockLog
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeRequestGetLog data:data needEncrypt:YES] ToDatas];
}
//验证应急码
- (NSArray *)bleProtocol_sendEmergencyCode:(NSString *)code
{
    uint emergencyCode = code.intValue;
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:&emergencyCode length:4];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeVerifyEwmergencyCode data:data needEncrypt:YES] ToDatas];
}
//获取版本信息
- (NSArray *)bleProtocol_gainVersion
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeGetVerison data:data needEncrypt:YES] ToDatas];
}
//回复收到锁状态变化指令
- (NSArray *)bleProtocol_replyLockStateNotify
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeLockStateChange data:data needEncrypt:YES] ToDatas];
}
//回复收到日志
- (NSArray *)bleProtocol_replyLockLog
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:byte length:2];
        return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeLog data:data needEncrypt:YES] ToDatas];
    
}
//发起升级
- (NSArray *)bleProtocol_startUpgrage:(NSString *)upgradeKey kcv:(NSString *)kcv pkgQty:(unsigned int)qty hash:(unsigned int)hash
{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[upgradeKey hexStringToData]];
    [data appendData:[kcv hexStringToData]];
    [data appendBytes:&qty length:2];
    [data appendBytes:&hash length:4];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeStartUpgrade data:data needEncrypt:YES] ToDatas];
}
//发送升级包
- (NSArray *)bleProtocol_sendUpgrageInfo:(NSInteger)PkgSEQ bin:(NSData *)bin hash:(unsigned int)hash
{
    int seq = (int)PkgSEQ ;
    NSLog(@"包序号%d",seq);
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:&seq length:2];
    [data appendData:bin];
    [data appendBytes:&hash length:4];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendUpgradeInfo data:data needEncrypt:YES] ToDatas];
}

@end
