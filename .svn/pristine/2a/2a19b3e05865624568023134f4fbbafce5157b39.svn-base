//
//  NSData+Oxygen.h
//  BluetoothLock
//
//  Created by 梦醒 on 2018/5/15.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Oxygen)

/**
 将nsdata用aes128加密

 @param key 加密key
 @return 密文
 */
- (NSData *)AES128_encrypt:(NSString *)key base64:(BOOL)base64;

/**
 将nsdata用aes128解密

 @param key 解密key
 @return 明文
 */
- (NSData *)AES128_decrypt:(NSString *)key base64:(BOOL)base64;

/**
 将nsdata用aes128加密
 
 @param keyData 加密key
 @return 密文
 */
- (NSData *)AES128_encryptKeyData:(NSData *)keyData base64:(BOOL)base64;

/**
 将nsdata用aes128解密
 
 @param keyData 解密key
 @return 明文
 */
- (NSData *)AES128_decryptKeyData:(NSData *)keyData base64:(BOOL)base64;

/**
 补全16
 
 @param _str 待补全
 @return 补全
 */
+ (NSData *)addCheckData:(NSString *)_str;


@end
