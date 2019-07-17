//
//  BLEW266Protocol.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/31.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEW266Protocol : NSObject
/**
 根据设备区分协议样本
 
 @param deviceType 设备类型
 */
- (void)setDeviceType:(uint)deviceType devAddr:(NSString *)devAddr;
//设置锁号
- (NSArray *)bleProtocol_setLcokId:(NSString *)lockId;
//交换通讯秘钥
- (NSArray *)bleProtocol_exchangeCommkey:(NSString *)commKey;
//设置更新通讯秘钥
- (NSArray *)bleProtocol_updateCommkey:(NSString *)commKey kcv:(NSString *)kcv oldKcv:(NSString *)oldKcv sign:(NSString *)sign;
//设置更新otc秘钥
- (NSArray *)bleProtocol_updateOTCKey:(NSString *)otcKey kcv:(NSString *)kcv;
//设置更新参数
- (NSArray *)bleProtocol_setParam:(NSString *)paramInfo;
//发起开锁
- (NSArray *)bleProtocol_startUnlock:(NSString *)userinfo overTime:(NSInteger)overTime;
//开锁
- (NSArray *)bleProtocol_sendOTC:(NSString *)otc;
//申请OTC时回复硬件
- (NSArray *)bleProtocol_applyOTCReply;
//收到闭锁码回复
- (NSArray *)bleProtocol_closeCodeReply;
//同步时间
- (NSArray *)setTime;


@end

