//
//  BLEDeviceError.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/18.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEDeviceError.h"
#import "BLEInterfaceType.h"

@implementation BLEDeviceError
+ (NSError *)BleKeyError_errorCode:(uint)retCode errorTag:(NSInteger)tag
{
    NSError *error;
    NSString *errorMsg;
    switch (tag) {
        case EH_BLEInterfaceTypeInitKey:errorMsg = @"ERROR:InitKey";
            break;
        case EH_BLEInterfaceTypeInitLock:errorMsg = @"ERROR:InitLock";
            break;
        case EH_BLEInterfaceTypeSendPreFactor:errorMsg = @"ERROR:SendPreFactor";
            break;
        case EH_BLEInterfaceUpdateEmergencyKey:errorMsg = @"ERROR:UpdateEmergencyKey";
            break;
        case EH_BLEInterfaceTypeGainKeyRandom:errorMsg = @"ERROR:GainKeyRandom";
            break;
        case EH_BLEInterfaceTypeResetTime:errorMsg = @"ERROR:ResetTime";
            break;
        case EH_BLEInterfaceTypeGainLockInfo:errorMsg = @"ERROR:GainLockInfo";
            break;
        case EH_BLEInterfaceTypeStartUnlock:errorMsg = @"ERROR:StartUnlock";
            break;
        case EH_BLEInterfaceTypeSendOTC:errorMsg = @"ERROR:SendOTC";
            break;
        case EH_BLEInterfaceTypeSendPreOTC:errorMsg = @"ERROR:SendPreOTC";
            break;
        case EH_BLEInterfaceTypeApplyOTC:errorMsg = @"ERROR:ApplyOTC";
            break;
        case EH_BLEInterfaceTypeLog:errorMsg = @"ERROR:Log";
            break;
        case EH_BLEInterfaceTypeLockStateChange:errorMsg = @"ERROR:LockStateChange";
            break;
        default:
            break;
    }
    if (retCode!=0) {
        switch (retCode) {
            case 1:errorMsg = @"钥匙未初始化";
                break;
            case 2:errorMsg = @"签名校验错误";
                break;
            case 3:errorMsg = @"密钥验证失败";
                break;
            case 4:errorMsg = @"锁具未连接";
                break;
            case 5:errorMsg = @"锁号不符";
                break;
            case 6:errorMsg = @"锁连接时不能上传日志";
                break;
            case 7:errorMsg = @"错误锁定";
                break;
            case 8:errorMsg = @"命令不支持";
                break;
            case 9:errorMsg = @"机械错误";
                break;
            case 10:errorMsg = @"离线秘钥已满";
                break;
            case 11:errorMsg = @"离线秘钥不存在";
                break;
            case 12:errorMsg = @"锁已初始化，请勿重新初始化";
                break;
            case 13:errorMsg = @"锁回复超时";
                break;
            case 14:errorMsg = @"锁未初始化";
                break;
            case 255:errorMsg = @"通讯超时";
                break;
                
            default:
                break;
        }
        error = [[NSError alloc]initWithDomain:errorMsg code:retCode userInfo:nil];
    }
    return error;
}
+ (NSError *)BleW266Error_errorCode:(uint)retCode errorTag:(NSInteger)tag
{
    NSError *error;
    NSString *errorMsg;
    switch (tag) {
        case EH_BLEInterfaceTypeSetLockID:errorMsg = @"ERROR:SetLockID";
            break;
        case EH_BLEInterfaceTypeExchangeCommKey:errorMsg = @"ERROR:ExchangeCommKey";
            break;
        case EH_BLEInterfaceTypeUpdateCommKey:errorMsg = @"ERROR:UpdateCommKey";
            break;
        case EH_BLEInterfaceTypeUpdateOTCKey:errorMsg = @"ERROR:UpdateOTCKey";
            break;
        case EH_BLEInterfaceTypeUndataParam:errorMsg = @"ERROR:UndataParam";
            break;
        case EH_BLEInterfaceTypeUnlockLock:errorMsg = @"ERROR:UnlockLock";
            break;
        case EH_BLEInterfaceTypeSendLockOTC:errorMsg = @"ERROR:SendLockOTC";
            break;
        case EH_BLEInterfaceTypeApplyLockOTC:errorMsg = @"ERROR:ApplyLockOTC";
            break;
        case EH_BLEInterfaceTypeSendCloseCode:errorMsg = @"ERROR:SendCloseCode";
            break;
        default:
            break;
    }
    if (retCode!=0 && retCode !=0xffff) {
        
        error = [[NSError alloc]initWithDomain:[NSString stringWithFormat:@"%@%  d",errorMsg,retCode] code:retCode userInfo:nil];
        if (retCode==4 && tag==EH_BLEInterfaceTypeUpdateCommKey) {
            error = [[NSError alloc]initWithDomain:@"The device has been activated" code:retCode userInfo:nil];
        }
    }
    return error;
}

@end
