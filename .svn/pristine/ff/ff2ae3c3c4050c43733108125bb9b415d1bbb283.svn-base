//
//  EHBLEInteractionProtocol.h
//  BluetoothLock
//
//  Created by Patrick on 2018/4/9.
//  Copyright © 2018年 Patrick. All rights reserved.
//

//蓝牙交互的协议样本

#import <Foundation/Foundation.h>
#import "BLEDeviceType.h"




@interface BLEKeyProtocol : NSObject
+ (instancetype)shareBLEProtocol;

/**
 根据设备区分协议样本

 @param deviceType 设备类型
 */
- (void)setDeviceType:(BLEDeviceType *)deviceType devAddr:(NSString *)devAddr;


//初始化钥匙
- (NSArray *)bleProtocol_keyInit:(NSString *)commKey kcv:(NSString *)kcv;

//初始化锁具
- (NSArray *)bleProtocol_lockInit:(NSString *)LockID OTCKey:(NSString *)OTCKey OTCKCV:(NSString *)OTCKCV LockMode:(NSString *)LockMode codeList:(NSString *)codeList temporaryCommkey:(NSData *)temporaryCommkey;

//下发预发因子
- (NSArray *)bleProtocol_senPreFactor:(NSString *)factorInfo;

//更新应急码
- (NSArray *)bleProtocol_updateEmergencyKey:(NSString *)emergencyInfo;

//更改离线模式
- (NSArray *)bleProtocol_changeOfflineMode:(NSString *)offMode OffModeInfo:(NSString *)OffModeInfo temporaryCommkey:(NSData *)temporaryCommkey;

//获取钥匙随机数
- (NSArray *)bleProtocol_gainKeyRandom;

//同步时间
- (NSArray *)bleProtocol_resetTime:(NSData *)temporaryCommkey;

//授权关锁
- (NSArray *)bleProtocol_LockIn:(NSString *)authCode;

//记录锁体角度
- (NSArray *)bleProtocol_lockAngleRecord;

//设置临时通讯秘钥生命周期
- (NSArray *)bleProtocol_setCommkeyLifecycle:(int)lifecycle;

//获取锁具信息
- (NSArray *)bleProtocol_gainLockInfo;

//发起开锁
- (NSArray *)bleProtocol_startUnlock;

//发送otc开锁
- (NSArray *)bleProtocol_sendOTC:(NSString *)LockID  otc:(NSString *)otc;

//发送预发码
- (NSArray *)bleProtocol_sendPre:(NSString *)preCode;

//设置钥匙参数
- (NSArray *)bleProtocol_setParam:(NSString *)keyMode timeOver:(UInt8)timeOver temporaryCommkey:(NSData *)temporaryCommkey;

//下发离线秘钥
- (NSArray *)bleProtocol_sendOfflineCode:(NSString *)OffModeInfo temporaryCommkey:(NSData *)temporaryCommkey;

//删除钥匙离线秘钥
- (NSArray *)bleProtocol_clearOfflineCode:(NSString *)LockID temporaryCommkey:(NSData *)temporaryCommkey;

//查询离线秘钥
- (NSArray *)bleProtocol_queryOfflineCode;

//获取设备信息
- (NSArray *)bleProtocol_gainDeviceInfo;

//申请回传日志
- (NSArray *)bleProtocol_applyLockLog;

//验证应急码
- (NSArray *)bleProtocol_sendEmergencyCode:(NSString *)code;

//获取版本信息
- (NSArray *)bleProtocol_gainVersion;

//回复硬件收到申请OTC指令
- (NSArray *)bleProtocol_replyApply;

//回复收到锁状态变化指令
- (NSArray *)bleProtocol_replyLockStateNotify;

//回复收到日志
- (NSArray *)bleProtocol_replyLockLog;

//发起升级
- (NSArray *)bleProtocol_startUpgrage:(NSString *)upgradeKey kcv:(NSString *)kcv pkgQty:(unsigned int)qty hash:(unsigned int)hash;

//发送升级包
- (NSArray *)bleProtocol_sendUpgrageInfo:(NSInteger)PkgSEQ bin:(NSData *)bin hash:(unsigned int)hash;














@end

