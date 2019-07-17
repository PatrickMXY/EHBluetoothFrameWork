//
//  NSData+Oxygen.m
//  BluetoothLock
//
//  Created by 梦醒 on 2018/5/15.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "NSData+Oxygen.h"
#import "GTMBase64.h"


@implementation NSData (Oxygen)

/**
 将nsdata用aes128加密
 
 @param key 加密key
 @return 密文
 */
- (NSData *)AES128_encrypt:(NSString *)key base64:(BOOL)base64
{
    NSData *strdata = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    int count = strdata.length % 16;
    count = 16 - count;
    NSMutableData *resultdata = [NSMutableData dataWithData:strdata];
    
    Byte check = 0x00;
    while (count > 0) {
        [resultdata appendData:[NSData dataWithBytes:&check length:1]];
        count--;
    }
    AES128 *aes =[[AES128 alloc]init];
    [aes AES_SetKey:(Byte *)[strdata bytes]];
    NSData *encdata = [aes AES_Cipher:(Byte *)[self bytes] :16];
    
//    Byte *keys = (Byte *)[[NSData addCheckData:key] bytes];
////    AES128  *aes = [[AES128 alloc]init];
////    [aes AES_SetKey:keys];
//    NSData *data1= [aes AES_Cipher_base64:(Byte *)[self bytes] :(unsigned int)self.length];
//    NSData *data2 = [aes AES_Cipher:(Byte *)[self bytes] :(unsigned int)self.length];
    return  encdata;
}

/**
 将nsdata用aes128解密
 
 @param key 解密key
 @return 明文
 */
- (NSData *)AES128_decrypt:(NSString *)key base64:(BOOL)base64
{
    
    
    Byte *keys = (Byte *)[[NSData addCheckData:key] bytes];
    AES128  *aes = [[AES128 alloc]init];
    [aes AES_SetKey:keys];
    NSData *decryptData = base64?[GTMBase64 decodeData:self]:self;
    decryptData = [aes AES_InvCipher:(Byte *)[decryptData bytes] :(unsigned int)decryptData.length];
    return decryptData;
}

/**
 将nsdata用aes128加密
 
 @param keyData 加密key
 @return 密文
 */
- (NSData *)AES128_encryptKeyData:(NSData *)keyData base64:(BOOL)base64
{
    int count = keyData.length % 16;
    count = 16 - count;
    NSMutableData *resultdata = [NSMutableData dataWithData:keyData];
    Byte check = 0x00;
    while (count > 0) {
        [resultdata appendData:[NSData dataWithBytes:&check length:1]];
        count--;
    }
    AES128 *aes =[[AES128 alloc]init];
    [aes AES_SetKey:(Byte *)[resultdata bytes]];
    NSData *encdata = [aes AES_Cipher:(Byte *)[self bytes] :16];
    return encdata;
}

/**

 将nsdata用aes128解密
 @param keyData 解密Key
 @param base64 是否base64转
 @return return value description
 */
- (NSData *)AES128_decryptKeyData:(NSData *)keyData base64:(BOOL)base64
{
    int count = keyData.length % 16;
    count = 16 - count;
    NSMutableData *resultdata = [NSMutableData dataWithData:keyData];
    
    Byte check = 0x00;
    while (count > 0) {
        [resultdata appendData:[NSData dataWithBytes:&check length:1]];
        count--;
    }
    
    Byte *keys = (Byte *)[resultdata bytes];
    AES128  *aes = [[AES128 alloc]init];
    [aes AES_SetKey:keys];
    NSData *decryptData = base64?[GTMBase64 decodeData:self]:self;
    decryptData = [aes AES_InvCipher:(Byte *)[decryptData bytes] :(unsigned int)decryptData.length];
    return decryptData;
}

/**
 补全16
 
 @param _str 待补全
 @return 补全
 */
+ (NSData *)addCheckData:(NSString *)_str
{
    NSData *strdata = [_str dataUsingEncoding:NSUTF8StringEncoding];
    int count = strdata.length % 16;
    count = 16 - count;
    NSMutableData *resultdata = [NSMutableData dataWithData:strdata];
    
    Byte check = 0x00;
    while (count > 0) {
        [resultdata appendData:[NSData dataWithBytes:&check length:1]];
        count--;
    }
    
    return resultdata;
}


@end
