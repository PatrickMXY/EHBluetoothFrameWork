//
//  BLEW266Protocol.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/31.
//  Copyright © 2018年 Patrick. All rights reserved.
//
#import "BLEW266Protocol.h"
#import "BLEDeviceCmdPackage.h"

@interface BLEW266Protocol ()
@property (nonatomic , strong) NSString *devAddr;
@property (nonatomic , assign) UInt8 devSubType;
@end
@implementation BLEW266Protocol

/**
 根据设备区分协议样本
 
 @param deviceType 设备类型
 */
- (void)setDeviceType:(uint)deviceType devAddr:(NSString *)devAddr
{
    self.devAddr = devAddr;
    self.devSubType = deviceType;
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
    protocolModel->Random = 1;
    protocolModel->DDevAddr = (unsigned int)self.devAddr.longLongValue;
    protocolModel->SDevAddr = 1234;
    protocolModel->DDevSubType = self.devSubType;
    [protocolModel setPkgData:data];
    if (needEncrypt) {
        
    }
    return protocolModel;
}
//设置锁号
- (NSArray *)bleProtocol_setLcokId:(NSString *)lockId
{
    NSMutableData *data = [NSMutableData new];
    uint lockIdCode = lockId.intValue;
    [data appendBytes:&lockIdCode length:4];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSetLockID data:data needEncrypt:YES] ToDatas];
}
//交换通讯秘钥
- (NSArray *)bleProtocol_exchangeCommkey:(NSString *)commKey
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[commKey hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeExchangeCommKey data:data needEncrypt:YES] ToDatas];
}
//设置更新通讯秘钥
- (NSArray *)bleProtocol_updateCommkey:(NSString *)commKey kcv:(NSString *)kcv oldKcv:(NSString *)oldKcv sign:(NSString *)sign;
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[commKey hexStringToData]];
    [data appendData:[kcv hexStringToData]];
    [data appendData:[oldKcv hexStringToData]];
    [data appendData:[sign hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeUpdateCommKey data:data needEncrypt:YES] ToDatas];
}
//设置更新otc秘钥
- (NSArray *)bleProtocol_updateOTCKey:(NSString *)otcKey kcv:(NSString *)kcv
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[otcKey hexStringToData]];
    [data appendData:[kcv hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeUpdateOTCKey data:data needEncrypt:YES] ToDatas];
}
//设置更新参数
- (NSArray *)bleProtocol_setParam:(NSString *)paramInfo
{
    NSMutableData *data = [NSMutableData new];
    [data appendData:[paramInfo hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeUndataParam data:data needEncrypt:YES] ToDatas];
}
//发起开锁
- (NSArray *)bleProtocol_startUnlock:(NSString *)userinfo overTime:(NSInteger)overTime
{
    NSMutableData *data = [NSMutableData new];
    for (NSInteger index=0; index<userinfo.length; index++) {
        NSString *tmpStr = [userinfo substringWithRange:NSMakeRange(index, 1)];
        [data appendData:[[NSString stringWithFormat:@"%i",(tmpStr.intValue+30)] hexStringToData]];
    }
    uint time = (int)overTime;
    [data appendBytes:&time length:1];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeUnlockLock data:data needEncrypt:YES] ToDatas];
}
//开锁
- (NSArray *)bleProtocol_sendOTC:(NSString *)otc
{
    NSMutableData *data = [NSMutableData new];
    for (NSInteger index=0; index<otc.length; index++) {
        NSString *tmpStr = [otc substringWithRange:NSMakeRange(index, 1)];
        [data appendData:[[NSString stringWithFormat:@"%i",(tmpStr.intValue+30)] hexStringToData]];
    }
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendLockOTC data:data needEncrypt:YES] ToDatas];
}

//申请OTC时回复硬件
- (NSArray *)bleProtocol_applyOTCReply
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeApplyLockOTC data:data needEncrypt:YES] ToDatas];
}
//收到闭锁码回复
- (NSArray *)bleProtocol_closeCodeReply
{
    Byte byte[2] = {0x00,0x00};
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[NSData dataWithBytes:byte length:sizeof(byte)]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSendCloseCode data:data needEncrypt:YES] ToDatas];
}
//同步时间
- (NSArray *)setTime
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmSS"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *yy = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(2, 2)].integerValue];
    NSString *MM = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(4, 2)].integerValue];
    NSString *dd = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(6, 2)].integerValue];
    NSString *hh = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(8, 2)].integerValue];
    NSString *mm = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(10, 2)].integerValue];
    NSString *ss = [NSString getHexByDecimal:[dateStr substringWithRange:NSMakeRange(12, 2)].integerValue];
    
    [data appendData:[yy hexStringToData]];
    [data appendData:[MM hexStringToData]];
    [data appendData:[dd hexStringToData]];
    [data appendData:[hh hexStringToData]];
    [data appendData:[mm hexStringToData]];
    [data appendData:[ss hexStringToData]];
    return [[self bleProtocol_configProtocolModel:EH_BLEInterfaceTypeSetLockTime data:data needEncrypt:YES] ToDatas];
    
}

@end
