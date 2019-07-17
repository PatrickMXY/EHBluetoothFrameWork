//
//  BLEKeyV1.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/6/14.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <EHBluetooth/EHBluetooth.h>
#import "BLEKeyParam.h"
#import "BLELock.h"

@protocol BleKeyEventHandler <NSObject>
/**
 相关操作响应的代理回调
 
 @param bleKey 蓝牙钥匙
 @param lockEvent 响应事件对象
 */
- (void)bleKey_EventHandler:(BLEKey *)bleKey lockEvent:(BLEDeviceEvent *)lockEvent;

@end


typedef void(^BLELinkLockBlock)(BLELock *lock);
typedef void(^BLEDeviceInfoBlock)(BLELock *lock);
@interface BLEKey : BLEDevice

@property (nonatomic , strong) NSString *keyMode;//解析前的keymode

@property (nonatomic , strong) NSString *lockAuth;//关锁授权 0 无需授权 1 需要授权
@property (nonatomic , strong) NSString *pressMode;//按键确认 0 强制关锁 1 开关锁键
@property (nonatomic , strong) NSString *rouseType;//唤醒方式 0：Touch唤醒 1：按键唤醒
@property (nonatomic , strong) NSString *lockRouse;//锁唤醒广播 0：锁唤醒广播 1：锁不唤醒广播
@property (nonatomic , strong) NSString *ekeyLockType;//关锁方式 0：自动关锁 1：手动关锁
@property (nonatomic , strong) NSString *ekeyUnlockType;//开锁方式 0：自动开锁 1：手动开锁
@property (nonatomic , strong) NSString *hummerSwitch;//蜂鸣器 0：开 1：关
@property (nonatomic , strong) NSString *bleTimeOver;//蓝牙超时时间，单位为10s，无数据通信关闭蓝牙
@property (nonatomic , strong) NSString *offlineKey;//离线密钥存储状态 位图，每个Bit代表一个离b密钥存储空间。1表示占用，0表示未占用
@property (nonatomic , strong) NSString *offlineLogNum;//未读取的日志数量



@property (nonatomic , assign) id <BleKeyEventHandler> handlerDelegate; //锁具的处理回调,连接设备成功后回调会实时回传信息

/**
 取临时通讯Key随机数
 
 @return 通讯key随机数
 */
- (NSString *)bleKey_getTmpCommKeyRandom;

/**
 取临时通讯Key随机数
 
 */
- (void)bleKey_tmpCommKeyRandom;
/**
 设置临时通讯秘钥
 
 @param commkey 后台获取的tmpcommkey
 */
- (BOOL)bleKey_setTmpCommKey:(NSString *)commkey;
/**
 初始化钥匙
 
 @param InitInfo 参数为初始化信息，从后台服务器发出
 */
- (void)bleKey_initEKey:(NSString *)InitInfo;
/**
 钥匙恢复出厂设置
 
 @param InitInfo 参数为初始化信息，从后台服务器发出
 */
- (void)bleKey_recoveryEKey:(NSString *)InitInfo;
/**
 
 初始化连接锁具
 @param InitInfo 不知道
 */
- (void)bleKey_initLock:(NSString *)InitInfo;

/**
 恢复出厂设置连接锁具
 @param InitInfo 不知道
 
 */
- (void)bleKey_recoveryLock:(NSString *)InitInfo lockId:(NSString *)lockId;

/**
 获取当前连接锁具信息

 @param lockBlock 获取到的信息回调
 */
- (void)bleKey_linkedLock:(BLELinkLockBlock)lockBlock;
/**
 开锁
 */
- (void)bleKey_startUnLock;
/**
 设置蓝牙设备连接时间
 */
- (void)bleKey_setTime;
/**
 发送OTC码
 
 @param otcCode otc码
 */
- (void)bleKey_sendOTC:(NSString *)lockId otc:(NSString *)otcCode;


/**
 设置参数
 @param param 参数配置对象
 */
- (void)bleKey_setParam:(BLEKeyParam *)param;


/**
 下发预发因子

 @param info 预发因子信息
 */
- (void)bleKey_sendPreFactor:(NSString *)info;

/**
 预发开锁
 
 @param info 所有参数
 */
- (void)bleKey_sendPreOTC:(NSString *)info;


#pragma mark 合并新增

/**
 下发更新应急码

 @param emergencyInfo 应急信息
 */
- (void)bleKey_sendEmergencyCodes:(NSString *)emergencyInfo;

/**
 授权关锁

 @param authCode 授权信息
 */
- (void)bleKey_authLock:(NSString *)authCode;

/**
 记录锁安装角度
 */
- (void)bleKey_setLockAngle;

/**
 设置commkey生命周期

 @param lifecycle 有效期
 */
- (void)bleKey_setTmpCommkeyLifecycle:(NSInteger)lifecycle;

/**
 开启关闭锁具离线模式
 
 @param offMode 离线模式 0x01开启离线 0x02关闭离线
 @param OffModeInfo 接口返回
 */
- (void)bleKey_changeOfflineMode:(NSString *)offMode  OffModeInfo:(NSString *)OffModeInfo;

/**
 下发离线秘钥

 @param offlineInfo 离线秘钥信息
 */
- (void)bleKey_sendOfflineCode:(NSString *)offlineInfo;

/**
 清除离线秘钥

 @param lockId 锁具id
 */
- (void)bleKey_clearOfflineCode:(NSString *)lockId;

/**
 查询离线秘钥
 */
- (void)bleKey_queryOfflineCodes;


/**
 获取当前钥匙跟锁具信息
 */
- (void)bleKey_gainDeviceInfo:(BLELinkLockBlock)lockBlock;

/**
 请求硬件上传开关锁日志
 */
- (void)bleKey_requestLockLog;

/**
 校验应急码

 @param emergencyCode 应急码
 */
- (void)bleKey_verifyEmergencyCode:(NSString *)emergencyCode;

/**
 获取版本号
 */
- (void)bleKey_gainVersion;

/**
 启动挂锁升级

 @param upgradeInfo 升级信息
 @param url bin文件地址
 */
- (void)bleKey_startLockUpgrade:(NSString *)upgradeKey upgradeInfo:(NSString *)upgradeInfo binPath:(NSURL *)url;



@end
