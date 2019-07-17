//
//  NSString+Oxygen.m
//  BluetoothLock
//
//  Created by Patrick on 2018/3/28.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "NSString+Oxygen.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Oxygen)
+ (BOOL)isStringEmpty:(NSString *)str
{
	if(str && ![str isEqual:[NSNull null]] && ![str isEqualToString:@""]){
		return NO;
	}else{
		return YES;
	}
}

+ (BOOL)isStringEmptyOrBlank:(NSString *)str
{
	if([NSString isStringEmpty:str] || [@"" isEqualToString:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
		return YES;
	}else{
		return NO;
	}
}


// 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
        
    }
    return hexStr;
}
//十六进制转Data
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            byte = *ch - 'A' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }else if('A' <= *ch && *ch <= 'F'){
                byte += *ch - 'A' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}
#pragma mark Encrypt
- (NSString *)stringSha1
{
    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    //
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

/**
 对string做aes128处理

 @param key 加密key
 @param complete 是否对待加密的数据做补全
 @param base64 是否对密文做base64转码
 @return 密文
 */
- (NSString *)AES128_encrypt:(NSString *)key needComplete:(BOOL)complete base64:(BOOL)base64
{
    NSData *encryptData = complete?[NSData addCheckData:self]:[self dataUsingEncoding:NSUTF8StringEncoding];
    encryptData = [encryptData AES128_encrypt:key base64:base64];
    NSString *encryptStr = [[NSString alloc]initWithData:encryptData encoding:NSUTF8StringEncoding];
    return encryptStr;
}


/**
 将密文解密

 @param key 解密key
 @param complete key
 @param base64 是否做base64转码
 @return 明文
 */
- (NSString *)AES128_decrypt:(NSString *)key needComplete:(BOOL)complete base64:(BOOL)base64
{

    NSData *decryptData = [self dataUsingEncoding:NSUTF8StringEncoding];
    decryptData = [decryptData AES128_decrypt:key base64:base64];
    NSString *decryptStr = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptStr;
}

// 十六进制转换为十进制。
+ (NSString *)getDecimalByHex:(NSString *)hexString
{ //
    if (nil == hexString){
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:hexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber.stringValue;
    
}
//二进制转十进制
+ (NSString *)getDecimalByBinary:(NSString *)binaryStr
{
    NSInteger ll = 0 ;
    NSInteger  temp = 0 ;
    for (NSInteger i = 0; i < binaryStr.length; i ++){
        
        temp = [[binaryStr substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binaryStr.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%ld",(long)ll];
    
    return result;
}

//  十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSUInteger)decimal;
{
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = decimal%2;
        divisor = decimal/2;
        decimal = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    //倒序输出
    NSString * result = @"";
    for (int i = 8 -1; i >= 0; i --)
    {
        if (i <= prepare.length - 1) {
            result = [result stringByAppendingFormat:@"%@",
                      [prepare substringWithRange:NSMakeRange(i , 1)]];
            
        }else{
            result = [result stringByAppendingString:@"0"];
            
        }
    }
    return result;
}


/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal
{
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}
/**
 生成八位随机数，且头不为零
 
 @return 随机数
 */
+ (NSString *)randomCreate
{
//  利用时间生成
    NSDateFormatter *datefomatter = [[NSDateFormatter alloc]init];
    [datefomatter setDateFormat:@"ddHHmmss"];
    NSMutableString *lockNo = [[NSMutableString alloc]initWithString:[datefomatter stringFromDate:[NSDate date]]];
    NSString *random = [NSString stringWithFormat:@"%d",(1 + (arc4random() % (9)))];
    for (NSInteger index=0; index<lockNo.length; index++) {
        NSString *indexStr = [lockNo substringWithRange:NSMakeRange(index, 1)];
        if ([indexStr isEqualToString:@"0"]) {
            [lockNo replaceCharactersInRange:NSMakeRange(index, 1) withString:random];
        }
    }
    return lockNo;
}

@end
