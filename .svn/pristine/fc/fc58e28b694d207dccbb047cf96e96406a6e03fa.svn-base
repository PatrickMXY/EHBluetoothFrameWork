//
//  NSString+Oxygen.h
//  BluetoothLock
//
//  Created by Patrick on 2018/3/28.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Oxygen)
//字符串为空或者nil
+ (BOOL)isStringEmpty:(NSString *)str;
//字符串为空或者nil或者空格
+ (BOOL)isStringEmptyOrBlank:(NSString *)str;


#pragma mark Encrypt
- (NSString *)stringSha1;

/**
 对string做aes128处理
 
 @param key 加密key
 @param complete 是否对待加密的数据做补全
 @param base64 是否对密文做base64转码
 @return 密文
 */
- (NSString *)AES128_encrypt:(NSString *)key needComplete:(BOOL)complete base64:(BOOL)base64;


/**
 将密文解密
 
 @param key 解密key
 @param complete key
 @param base64 是否做base64转码
 @return 明文
 */
- (NSString *)AES128_decrypt:(NSString *)key needComplete:(BOOL)complete base64:(BOOL)base64;


// 十六进制转换为十进制
+ (NSString *)getDecimalByHex:(NSString *)hexString;

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

//二进制转十进制
+ (NSString *)getDecimalByBinary:(NSString *)binaryStr;

//  十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSUInteger)decimal;

/**
 生成八位随机数，且头不为零

 @return 随机数
 */
+ (NSString *)randomCreate;




@end
