//
//  BLEKeyLockLog.h
//  EHBluetooth
//
//  Created by 梦醒 on 2019/1/14.
//  Copyright © 2019 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEKeyLockLog : NSObject

@property (nonatomic , strong) NSString *LockID;
@property (nonatomic , strong) NSString *KeyID;
@property (nonatomic , strong) NSString *LockType;
@property (nonatomic , strong) NSString *LockMode;
@property (nonatomic , strong) NSString *LogType;
@property (nonatomic , strong) NSString *DateTime;
@property (nonatomic , strong) NSString *logCode;//闭锁码/开锁码：日志类型0x00时，该值是闭锁码； 0x01---0x03对应的是开锁码； 0x04，该值是0

@property (nonatomic , strong) NSString *emergencyMode;//应急模式 0未开启 1应急模式
@property (nonatomic , strong) NSString *preMode;//预发模式 0未开启 1预发模式
@property (nonatomic , strong) NSString *offlineMode;//离线模式 0未开启 1离线
@property (nonatomic , assign) NSString *InitStatus;//初始化状态 0.未初始化,1.已初始化

- (instancetype)initWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
