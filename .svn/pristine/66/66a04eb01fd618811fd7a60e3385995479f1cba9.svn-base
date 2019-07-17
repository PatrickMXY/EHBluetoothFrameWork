//
//  EHBLEProtocolSample.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/24.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
//DataLen
//数据长度
//SID
//会话ID
//CMD
//命令字
//CMDRetCode
//返回值
//DDevType
//目标设备类型
//DDevSubType
//目标设备子类型
//DDevAddr
//目标地址
//SDevType
//源设备类型
//SDevSubType
//源设备子类型
//SDevAddr
//源设备地址
//Random
//随机数
//CallSEQ
//调用流水
//SignCode
//签名
//Data
//数据部分


@interface BLEDeviceCmdPackage : NSObject
{
    //    协议部分
@public
    //两个字节
    unsigned int DataLen;
    //    会话id
    unsigned int SID;
    //命令字
    unsigned int CMD;
    //两个字节
    unsigned int CMDRetCode;
    //    目标设备类型
    unsigned int DDevType;
    //    目标设备子类型
    unsigned int DDevSubType;
    //    目标地址
    unsigned int DDevAddr;
    //    源设备类型
    unsigned int SDevType;
    //    源设备子类型
    unsigned int SDevSubType;
    //    源设备地址
    unsigned int SDevAddr;
    //    生成的随机数
    unsigned int Random;
    //调用流水
    unsigned int CallSEQ;
    //    APHash
    unsigned int SignCode;
    //    收发数据包
    
    NSData *Data;
}

//初始化协议模型
- (instancetype)initWithGatherData:(NSData *)gatherData;
//初始化个带源地址的模型
- (instancetype)initWithSendData:(unsigned int)Addr;
//长度20字节的 data集合
- (NSMutableArray *)ToDatas;
//将模型转换成data类型
- (NSData *)ToData;
//给协议对象的数据部分赋值
- (void)setPkgData:(NSData *)_Data;
- (NSMutableArray *)subpackage:(NSMutableData *)_Data;
//若字段本身长度为16的倍数，则补16字节，若本身长度不是16的倍数，则补至最小的16的倍数 用于AES加密
- (void)addCheckData;
//未知
+ (NSArray *)spliteUpgradeData:(NSData *)_Data;

@end
