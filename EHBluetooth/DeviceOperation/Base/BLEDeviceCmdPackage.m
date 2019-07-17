//
//  EHBLEProtocolSample.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/24.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEDeviceCmdPackage.h"
typedef struct __attribute__((packed)) {
    UInt16 DataLen;
    UInt8  SID;
    UInt8  CMD;
    UInt16 CMDRetCode;
    UInt8  DDevType;//0x01：后台 0x02：APP 0x03：钥匙 0x04：锁具
    UInt8  DDevSubType;
    UInt32 DDevAddr;
    UInt8  SDevType;
    UInt8  SDevSubType;
    UInt32 SDevAddr;
    UInt32 Random;
    UInt32 CallSEQ;
    UInt32 SignCode;
}EHBLEProtocolHeader;

@implementation BLEDeviceCmdPackage
- (instancetype)initWithGatherData:(NSData *)gatherData
{
    const void *gaindata = gatherData.bytes;
    EHBLEProtocolHeader *headerData;
    headerData = (EHBLEProtocolHeader *)gaindata;
//   占俩字节 计算数据长度，前两位代表整体数据长度，方便分包
    DataLen = headerData->DataLen;
    //    协议id
    SID = headerData->SID;
    //    命令名
    CMD = headerData->CMD;
    //    俩字节 相应结果+错误码
    CMDRetCode = headerData->CMDRetCode;
    DDevType = headerData->DDevType;
    DDevSubType = headerData->DDevSubType;
    DDevAddr = headerData->DDevAddr;

    SDevType = headerData->SDevType;
    SDevSubType = headerData->SDevSubType;
    SDevAddr = headerData->SDevAddr;

    Random = headerData->Random;

    CallSEQ = headerData->CallSEQ;

    SignCode = headerData->SignCode;

    //    data+26？？？？？？
    Byte *data  = (Byte *)[gatherData bytes];
    Data = [NSData dataWithBytes:data + 30 length:gatherData.length - 30];
    


    
    return self;
}
- (instancetype)initWithSendData:(unsigned int)Addr
{
    self = [super init];
    if (self) {
        SDevAddr = Addr;
    }
    return self;
}
//初始化的固定数值类型的模型
- (instancetype)init
{
    DataLen = 28;
    SID = 0xff;
    CMD = -1;
    CMDRetCode = 0;
    DDevType = 3;
    DDevSubType = 0;
    DDevAddr = -1;
    SDevType = 2;
    SDevSubType = 0;
    SDevAddr = -1;
    Random = arc4random();
    CallSEQ = 0;
    SignCode = -1;
    Data = [[NSData alloc]init];
    
    return self;
}

//使用环境，生成发送数据包时给数据部分赋值
- (void)setPkgData:(NSData *)_Data
{
    DataLen = 28 + (unsigned int)_Data.length;
    
    Data = [[NSData alloc] initWithData:_Data];
    [self setSignCode];
}
- (NSData *)ToData
{
    NSMutableData *returnData = [[NSMutableData alloc]init];
    
    [returnData appendData:[NSData dataWithBytes:&DataLen length:2]];
    
    [returnData appendData:[NSData dataWithBytes:&SID length:1]];
    
    [returnData appendData:[NSData dataWithBytes:&CMD length:1]];
    
    [returnData appendData:[NSData dataWithBytes:&CMDRetCode length:2]];
    
    [returnData appendData:[NSData dataWithBytes:&DDevType length:1]];
    [returnData appendData:[NSData dataWithBytes:&DDevSubType length:1]];
    [returnData appendData:[NSData dataWithBytes:&DDevAddr length:4]];
    
    [returnData appendData:[NSData dataWithBytes:&SDevType length:1]];
    [returnData appendData:[NSData dataWithBytes:&SDevSubType length:1]];
    [returnData appendData:[NSData dataWithBytes:&SDevAddr length:4]];
    
    [returnData appendData:[NSData dataWithBytes:&Random length:4]];
    [returnData appendData:[NSData dataWithBytes:&CallSEQ length:4]];
    [returnData appendData:[NSData dataWithBytes:&SignCode length:4]];
    
    [returnData appendData:Data];
    
    return returnData;
}
- (NSMutableArray *)ToDatas
{
    NSMutableData *returnData = [[NSMutableData alloc]init];
    
    [returnData appendData:[NSData dataWithBytes:&DataLen length:2]];
    
    [returnData appendData:[NSData dataWithBytes:&SID length:1]];
    
    [returnData appendData:[NSData dataWithBytes:&CMD length:1]];
    
    [returnData appendData:[NSData dataWithBytes:&CMDRetCode length:2]];
    
    [returnData appendData:[NSData dataWithBytes:&DDevType length:1]];
    [returnData appendData:[NSData dataWithBytes:&DDevSubType length:1]];
    [returnData appendData:[NSData dataWithBytes:&DDevAddr length:4]];
    
    [returnData appendData:[NSData dataWithBytes:&SDevType length:1]];
    [returnData appendData:[NSData dataWithBytes:&SDevSubType length:1]];
    [returnData appendData:[NSData dataWithBytes:&SDevAddr length:4]];
    
    [returnData appendData:[NSData dataWithBytes:&Random length:4]];
    [returnData appendData:[NSData dataWithBytes:&CallSEQ length:4]];
    [returnData appendData:[NSData dataWithBytes:&SignCode length:4]];
    
    [returnData appendData:Data];
    
    return [self subpackage:returnData];
}
- (NSMutableArray *)subpackage:(NSMutableData *)_Data
{
    NSMutableArray *returnValue = [[NSMutableArray alloc]init];
    
    while (_Data.length >= 20) {
        [returnValue addObject:[_Data subdataWithRange:NSMakeRange(0,20)]];
        
        [_Data replaceBytesInRange:NSMakeRange(0, 20) withBytes:NULL length:0];
    }
    
    [returnValue addObject:_Data];
    
    return returnValue;
}

+ (NSArray *)spliteUpgradeData:(NSData *)_Data
{
    NSMutableArray *Result = [[NSMutableArray alloc]init];
    
    int PackageCount = (int)_Data.length / 512;
    int PackageLast = _Data.length % 512;
    
    for(int i = 0;i<PackageCount;i++)
    {
        [Result addObject:[_Data subdataWithRange:NSMakeRange(i * 512, 512)]];
    }
    
    if(PackageLast != 0)
    {
        [Result addObject:[_Data subdataWithRange:NSMakeRange(512 * PackageCount, PackageLast)]];
    }
    
    return Result;
}
- (void)addCheckData
{
    int count = self->Data.length % 16;
    count = 16 - count;
    NSMutableData *pkgdata = [NSMutableData dataWithData:self->Data];
    
    Byte check = 0x01;
    while (count > 0) {
        [pkgdata appendData:[NSData dataWithBytes:&check length:1]];
        check++;
        count--;
    }
    
    [self setPkgData:pkgdata];
}
//增加signcode校验
- (void)setSignCode
{
    NSMutableData *enctyptData = [[NSMutableData alloc]init];
    [enctyptData appendData:[NSData dataWithBytes:&DDevAddr length:4]];
    [enctyptData appendData:[NSData dataWithBytes:&SDevAddr length:4]];
    [enctyptData appendData:Data];
    [enctyptData appendData:[NSData dataWithBytes:&Random length:4]];
    [enctyptData appendData:[NSData dataWithBytes:&CallSEQ length:4]];
    SignCode =  [Encrept APHash:enctyptData];
}
@end
