//
//  Encrept.m
//  EHCommunicate
//
//  Created by 史博远 on 16/5/31.
//  Copyright © 2016年 Gjoy. All rights reserved.
//

#import "Encrept.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"


@implementation AES128

- (void)AES_SetKey :(Byte *)key
{
    [self AES_KeyExpansion:key :_wKey];
}

- (Byte *)AES_CipherBlock :(Byte *)input
{
    Byte state[4][4];
    int i,r,c;
    
    for(r=0; r<4; r++)
    {
        for(c=0; c<4 ;c++)
        {
            state[r][c] = input[c*4+r];
        }
    }
    
    [self AES_AddRoundKey:state :_wKey[0]];
    
    for(i=1; i<=10; i++)
    {
        [self AES_SubBytes:state];
        [self AES_ShiftRows:state];
        
        if(i!=10)
        {
            [self AES_MixColumns:state];
        }
        
        [self AES_AddRoundKey:state :_wKey[i]];
    }
    
    for(r=0; r<4; r++)
    {
        for(c=0; c<4 ;c++)
        {
            input[c*4+r] = state[r][c];
        }
    }
    
    return input;
}

- (Byte *)AES_InvCipherBlock :(Byte *)input;
{
    Byte state[4][4];
    int i,r,c;
    
    for(r=0; r<4; r++)
    {
        for(c=0; c<4 ;c++)
        {
            state[r][c] = input[c*4+r];
        }
    }
    
    [self AES_AddRoundKey:state :_wKey[10]];
    
    for(i=9; i>=0; i--)
    {
        [self AES_InvShiftRows:state];
        [self AES_InvSubBytes:state];
        [self AES_AddRoundKey:state :_wKey[i]];
        
        if(i)
        {
            [self AES_InvMixColumns:state];
        }
    }
    
    for(r=0; r<4; r++)
    {
        for(c=0; c<4 ;c++)
        {
            input[c*4+r] = state[r][c];
        }
    }
    
    return input;
}

- (NSData *)AES_Cipher :(Byte *)input :(unsigned int)length;
{
    Byte* in = input;
    int i;
    if(!length)
    {
        while(*(in+length++));
        in = input;
    }
    for(i=0; i<length; i += 16)
    {
        [self AES_CipherBlock:in + i];
    }
    return [NSData dataWithBytes:input length:length];
}
- (NSData *)AES_Cipher_base64:(Byte *)input :(unsigned int)length
{
    Byte* in = input;
    int i;
    if(!length)
    {
        while(*(in+length++));
        in = input;
    }
    for(i=0; i<length; i += 16)
    {
        [self AES_CipherBlock:in + i];
    }
    NSData *returnData = [GTMBase64 encodeData:[NSData dataWithBytes:input length:length]];
    return returnData;
}
- (NSData *)AES_InvCipher :(Byte *)input :(unsigned int)length;
{
    Byte* in = input;
    int i;
    for(i=0; i<length; i += 16)
    {
        [self AES_InvCipherBlock:in + i];
    }
    return [NSData dataWithBytes:input length:length];
}

- (void)AES_KeyExpansion :(Byte *)key :(Byte[][4][4]) w
{
    int i,j,r,c;
    Byte rc[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
    Byte t[4];
    Byte temp;
    for(r=0; r<4; r++)
    {
        for(c=0; c<4; c++)
        {
            w[0][r][c] = key[r+c*4];
        }
    }
    for(i=1; i<=10; i++)
    {
        for(j=0; j<4; j++)
        {
            for(r=0; r<4; r++)
            {
                t[r] = j ? w[i][r][j-1] : w[i-1][r][3];
            }
            if(j == 0)
            {
                temp=t[0];
                for(r=0; r<3; r++)
                {
                    t[r] = Sbox[t[(r+1)%4]];
                }
                t[3] = Sbox[temp];
                t[0] ^= rc[i-1];
            }
            for(r=0; r<4; r++)
            {
                w[i][r][j] = w[i-1][r][j] ^ t[r];
            }
        }
    }
}

- (Byte)AES_FFmul :(Byte)a :(Byte)b
{
    Byte bw[4];
    Byte res=0;
    int i;
    bw[0] = b;
    for(i=1; i<4; i++)
    {
        bw[i] = bw[i-1]<<1;
        if(bw[i-1]&0x80)
        {
            bw[i]^=0x1b;
        }
    }
    for(i=0; i<4; i++)
    {
        if((a>>i)&0x01)
        {
            res ^= bw[i];
        }
    }
    return res;
}

- (void)AES_SubBytes :(Byte[][4])state
{
    int r,c;
    for(r=0; r<4; r++)
    {
        for(c=0; c<4; c++)
        {
            state[r][c] = Sbox[state[r][c]];
        }
    }
}

- (void)AES_ShiftRows :(Byte[][4])state
{
    Byte t[4];
    int r,c;
    for(r=1; r<4; r++)
    {
        for(c=0; c<4; c++)
        {
            
            t[c] = state[r][(c+r)%4];
        }
        for(c=0; c<4; c++)
        {
            state[r][c] = t[c];
        }
    }
}

- (void)AES_MixColumns :(Byte[][4])state
{
    Byte t[4];
    int r,c;
    for(c=0; c< 4; c++)
    {
        for(r=0; r<4; r++)
        {
            t[r] = state[r][c];
        }
        for(r=0; r<4; r++)
        {
            state[r][c] = [self AES_FFmul:0x02 :t[r]]
            ^ [self AES_FFmul:0x03 :t[(r+1)%4]]
            ^ [self AES_FFmul:0x01 :t[(r+2)%4]]
            ^ [self AES_FFmul:0x01 :t[(r+3)%4]];
        }
    }
}

- (void)AES_AddRoundKey :(Byte[][4])state :(Byte[][4])k
{
    int r,c;
    for(c=0; c<4; c++)
    {
        for(r=0; r<4; r++)
        {
            state[r][c] ^= k[r][c];
        }
    }
}

- (void)AES_InvSubBytes :(Byte[][4])state
{
    int r,c;
    for(r=0; r<4; r++)
    {
        for(c=0; c<4; c++)
        {
            state[r][c] = InvSbox[state[r][c]];
        }
    }
}

- (void)AES_InvShiftRows :(Byte[][4])state
{
    Byte t[4];
    int r,c;
    for(r=1; r<4; r++)
    {
        for(c=0; c<4; c++)
        {
            t[c] = state[r][(c-r+4)%4];
        }
        for(c=0; c<4; c++)
        {
            state[r][c] = t[c];
        }
    }
}

- (void)AES_InvMixColumns :(Byte[][4])state
{
    Byte t[4];
    int r,c;
    for(c=0; c< 4; c++)
    {
        for(r=0; r<4; r++)
        {
            t[r] = state[r][c];
            
        }
        for(r=0; r<4; r++)
        {
            state[r][c] = [self AES_FFmul:0x0e :t[r]]
            ^ [self AES_FFmul:0x0b :t[(r+1)%4]]
            ^ [self AES_FFmul:0x0d :t[(r+2)%4]]
            ^ [self AES_FFmul:0x09 :t[(r+3)%4]];
        }
    }
}

@end

@implementation Encrept

#pragma mark TEA加密

+(void) Encrept:(Byte [])Src :(Byte [])Key :(int)len :(Byte [])Dst
{
    
    int counter = len/8;
    unsigned long a = Key[0] + (Key[1]<<8) + (Key[2]<<16) + (Key[3]<<24);
    unsigned long b = Key[4] + (Key[5]<<8) + (Key[6]<<16) + (Key[7]<<24);
    unsigned long c = Key[8] + (Key[9]<<8) + (Key[10]<<16) + (Key[11]<<24);
    unsigned long d = Key[12] + (Key[13]<<8) + (Key[14]<<16) + (Key[15]<<24);
    unsigned long x,y,sum,temd,g,h;
    int n;
    
    for(int i = 0;i<= counter-1; i++)
    {
        x = 0xFFFFFFFF&(((unsigned)Src[8*i]) + ((unsigned)(Src[8*i+1]<<8)) + ((unsigned)(Src[8*i+2]<<16)) + ((unsigned)(Src[8*i+3]<<24)));
        y = 0xFFFFFFFF&(((unsigned)Src[8*i+4]) + ((unsigned)(Src[8*i+5]<<8)) + ((unsigned)(Src[8*i+6]<<16)) + ((unsigned)(Src[8*i+7]<<24)));
        sum = 0;
        n = TEA_ROUND;
        while (n>0)
        {
            sum = sum +TEA_DELTA;
            temd = 0xFFFFFFFF&(y <<4);
            g = 0xFFFFFFFF&(a ^y);
            h = 0xFFFFFFFF&(y >>5);
            h = 0xFFFFFFFF&(sum ^h);
            x = 0xFFFFFFFF&(x +temd +g +h +b);
            y = 0xFFFFFFFF&(y +(x <<4) +(c ^x) +((sum ^(x >>5)) +d));
            n = n -1;
        }
        
        Dst[8*i] = (Byte)x;
        Dst[8*i+1] = ((Byte)(x>>8));
        Dst[8*i+2] = ((Byte)(x>>16));
        Dst[8*i+3] = ((Byte)(x>>24));
        Dst[8*i+4] = (Byte)y;
        Dst[8*i+5] = ((Byte)(y>>8));
        Dst[8*i+6] = ((Byte)(y>>16));
        Dst[8*i+7] = ((Byte)(y>>24));
    }
}

+(void) Decrypt:(Byte [])Src :(Byte [])Key :(int)len :(Byte [])Dst
{
    int counter = len/8;
    unsigned long a = Key[0] + (Key[1]<<8) + (Key[2]<<16) + (Key[3]<<24);
    unsigned long b = Key[4] + (Key[5]<<8) + (Key[6]<<16) + (Key[7]<<24);
    unsigned long c = Key[8] + (Key[9]<<8) + (Key[10]<<16) + (Key[11]<<24);
    unsigned long d = Key[12] + (Key[13]<<8) + (Key[14]<<16) + (Key[15]<<24);
    unsigned long x,y,sum;
    int n;
    
    for(int i = 0;i<= counter-1;i++)
    {
        x = 0xFFFFFFFF&(((unsigned)Src[8*i]) + ((unsigned)(Src[8*i+1]<<8)) + ((unsigned)(Src[8*i+2]<<16)) + ((unsigned)(Src[8*i+3]<<24)));
        y = 0xFFFFFFFF&(((unsigned)Src[8*i+4]) + ((unsigned)(Src[8*i+5]<<8)) + ((unsigned)(Src[8*i+6]<<16)) + ((unsigned)(Src[8*i+7]<<24)));
        sum = TEA_DELTA;
        sum =sum * TEA_ROUND;
        n = TEA_ROUND;
        while(n>0)
        {
            y = 0xFFFFFFFF&(y-((x << 4)+ (c ^ x)+(sum ^ (x >> 5))+d));
            x = 0xFFFFFFFF&(x-((y << 4)+ (a ^ y)+ (sum ^ (y >> 5))+b));
            sum = sum - TEA_DELTA;
            n = n-1;
        }
        Dst[8*i] = (Byte)x;
        Dst[8*i+1] = ((Byte)(x>>8));
        Dst[8*i+2] = ((Byte)(x>>16));
        Dst[8*i+3] = ((Byte)(x>>24));
        Dst[8*i+4] = (Byte)y;
        Dst[8*i+5] = ((Byte)(y>>8));
        Dst[8*i+6] = ((Byte)(y>>16));
        Dst[8*i+7] = ((Byte)(y>>24));
    }
}

#pragma mark Hash算法

+(unsigned int) APHash:(NSData *)data
{
    Byte *_data = (Byte *)[data bytes];
    
    unsigned int hash = 0;
    
    for(long i = 0;i<data.length;i++)
    {
        Byte ch = _data[i];
        if((i & 1) == 0)
            hash ^= ((hash << 7) ^ ch ^ (hash >> 3));
        else
            hash ^= (~((hash << 11) ^ ch ^ (hash >> 5)));
    }
//    hash =  0x0FFFFFFFF&hash;
    return hash;
}

+(unsigned int) APHash_Part:(unsigned int)_hash :(NSData *)data :(int)L
{
    Byte *_data = (Byte *)[data bytes];
    
    unsigned int hash = 0;
    
    for(long i = L;i<data.length + L;i++)
    {
        Byte ch = _data[i - L];
        if((i & 1) == 0)
            hash ^= ((hash << 7) ^ ch ^ (hash >> 3));
        else
            hash ^= (~((hash << 11) ^ ch ^ (hash >> 5)));
    }
    
    return hash;
}

+(unsigned int) RSHash:(NSData *)data
{
    Byte *_data = (Byte *)[data bytes];
    
    unsigned int hash = 0;
    
    for(long i = 0;i<data.length;i++)
    {
        hash = _data[i] + (hash << 6) + (hash << 16) - hash;
    }
    
    return hash;
}

@end

@implementation NSString (encrypto)

- (NSString*) sha1
{
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
//
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//
//    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

//    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    base64 = [GTMBase64 encodeData:base64];
//
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];


    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
//
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

- (NSString *) sha1_base64
{
    
    NSData *data=[self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSString *) md5_base64
{
    const char *cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    base64 = [GTMBase64 encodeData:base64];
    
    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
    return output;
}

- (NSData *) hexStringToData
{
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([self length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

- (BOOL)isMail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return[emailTest evaluateWithObject:self];
}

- (BOOL)isPhoneNum
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *numRegex = @"[0-9]";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numRegex];
    
    return[numTest evaluateWithObject:self];
}

- (Boolean)isChinese
{
    NSInteger count = self.length;
    NSInteger result = 0;
    for(int i=0; i< count;i++)
    {
        int a = [self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff)//判断输入的是否是中文
        {
            result++;
        }
    }
    if (count == result) {//当字符长度和中文字符长度相等的时候
        return YES;
    }
    return NO;
}

- (Boolean)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end

@implementation NSData (formatto)
- (NSData *)sha1
{
    NSData *data = self;
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    return base64;
}
- (NSString *) toHexString
{
    if (!self || [self length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%X", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end







