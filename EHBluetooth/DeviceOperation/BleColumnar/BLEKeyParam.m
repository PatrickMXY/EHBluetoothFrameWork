//
//  BLEKeyParam.m
//  EHBluetooth
//
//  Created by 梦醒 on 2019/3/6.
//  Copyright © 2019 Patrick. All rights reserved.
//

#import "BLEKeyParam.h"
@interface BLEKeyParam ()
@property (nonatomic , strong) NSString *status;//参数配置里的初始化状态，0 未，1已
@end
@implementation BLEKeyParam
/**
 通过二进制产生一个配置参数的对象
 
 @param binary 二进制
 @return param
 */
- (instancetype)initWithBinary:(NSString *)binary timeOver:(NSString *)timeOver
{
    if (self = [super init]) {
        self.lockAuth = [binary substringWithRange:NSMakeRange(0, 1)];
        self.pressMode = [binary substringWithRange:NSMakeRange(1, 1)];;
        self.rouseType = [binary substringWithRange:NSMakeRange(2, 1)];
        self.lockRouse = [binary substringWithRange:NSMakeRange(3, 1)];
        self.ekeyLockType = [binary substringWithRange:NSMakeRange(4, 1)];
        self.ekeyUnlockType = [binary substringWithRange:NSMakeRange(5, 1)];
        self.hummerSwitch = [binary substringWithRange:NSMakeRange(6, 1)];
        self.status = [binary substringWithRange:NSMakeRange(7, 1)];
        self.bleTimeOver = timeOver;
        
        
    }
    return self;
}

/**
 通过十六进制产生一个配置参数对象
 
 @param hexString 十六进制
 @return param
 */
- (instancetype)initWithHexString:(NSString *)hexString timeOver:(NSString *)timeOver
{
    NSString *binary = [NSString getBinaryByDecimal:[NSString getDecimalByHex:hexString].integerValue];
    return [self initWithBinary:binary timeOver:timeOver];
}

- (NSString *)keyMode
{
    NSMutableString *mutableKeymode = [NSMutableString new];
    [mutableKeymode appendString:self.lockAuth];
    [mutableKeymode appendString:self.pressMode];
    [mutableKeymode appendString:self.rouseType];
    [mutableKeymode appendString:self.lockRouse];
    [mutableKeymode appendString:self.ekeyLockType];
    [mutableKeymode appendString:self.ekeyUnlockType];
    [mutableKeymode appendString:self.hummerSwitch];
    [mutableKeymode appendString:self.status];

    NSString *keyMode = [NSString getHexByDecimal:[NSString getDecimalByBinary:mutableKeymode].integerValue];
    if (keyMode.length==1) {
        keyMode = [NSString stringWithFormat:@"0%@",keyMode];
    }
    return keyMode;
    
}
@end
