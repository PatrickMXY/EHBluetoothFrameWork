//
//  BLEKey0203.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BLEW266.h"
#import "BLEBroadcast.h"
#import "BleClient.h"
#import "BLEW266Protocol.h"
#import "BleEventProtocol.h"
#import "BLEDeviceError.h"
#import "BLEDeviceCmdPackage.h"

#define BLE_COMMNUTATION_TIMEOUT   10

//闭锁信息
typedef struct __attribute__((packed)) {
    UInt64 closeCode;
    UInt8 voltage; //0未连接，1已连接
} BleW266CloseInfo;
@interface BLEW266 () <BleEventProtocol>
//收到的数据长度
@property (assign , nonatomic) NSInteger dataLenth;
//收到的数据
@property (strong , nonatomic) NSMutableData *receivedData;
//W266响应事件模型
@property (nonatomic , strong) BLEDeviceEvent *event;
//定时器连接超时
@property (nonatomic , strong) dispatch_source_t timer;
//连接超时时限
@property (nonatomic , assign) NSInteger countDown;

@property (nonatomic , strong) BleClient *bleClient;//蓝牙设备操作

@property (nonatomic , strong) BLEW266Protocol *bleProtocol;//蓝牙通讯处理对象


@property (nonatomic , copy) BLEDeviceConnect connectBlock;

@property (nonatomic , assign) BOOL praUnlock;
@property (nonatomic , strong) NSString *praOTC;
@property (nonatomic , assign) BOOL updateCloseCode;
@property (nonatomic , strong) NSString *closeCode;


@end

@implementation BLEW266
- (instancetype)initWithPerphral:(CBPeripheral *)peripheral broadCast:(NSData *)broadCast
{
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.KeyName = self.peripheral.name;
        self.Connected  = NO;
        self.InitStatus = @"";
        self.FirwareVer = @"";
        if (broadCast) {
            BLEBroadcast *bleCast = [[BLEBroadcast alloc]initWithBroadcastData:broadCast];
            self.InitStatus = [NSString stringWithFormat:@"%u",bleCast.CMD];
            self.EKeyID = [NSString stringWithFormat:@"%u",(unsigned int)bleCast.keyId];
            NSMutableString *ekeyID = [[NSMutableString alloc]initWithString:self.EKeyID];
            while (ekeyID.length<8) {
                [ekeyID insertString:@"0" atIndex:0];
            }
            self.EKeyID = ekeyID;
            self.deviceType = bleCast.devType;
            CGFloat voltage = bleCast.Voltage;
            voltage = voltage/10;
            self.Voltage = [NSString stringWithFormat:@"%.1f",voltage];
            self.deviceTime = bleCast.deviceTime;
            NSLog(@"时间%@%@",self.EKeyID,self.deviceTime);

        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(broadCastUpdate:) name:@"BLEBroadCastUpDate" object:nil];

    }
    return self;
}
- (void)broadCastUpdate:(NSNotification *)notification
{
    BLEBroadcast *newCast = notification.object;
    if ([NSString isStringEmpty:newCast.closeCode]||[newCast.closeCode isEqualToString:@"00000000"]) {
        return;
    }
    NSString *closeCode = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@CloseCode",self.EKeyID]];
    if ([newCast.closeCode isEqualToString:closeCode]) {
        return;
    }
    if (newCast.keyId == self.EKeyID.intValue) {
        NSMutableDictionary *closeInfo = [NSMutableDictionary new];
        [closeInfo setValue:[NSString stringWithFormat:@"%.1d",newCast.Voltage/10] forKey:@"voltage"];
        [closeInfo setValue:newCast.closeCode forKey:@"closeCode"];
        BLEDeviceEvent *event = [BLEDeviceEvent new];
        event.EventCode = BLE_REPLY_CLOSECODE;
        event.EventPara = closeInfo;
        if (self.handlerDelegate) {
            self.updateCloseCode = YES;
            [self.handlerDelegate bleW266_EventHandler:self lockEvent:event];
            [[NSUserDefaults standardUserDefaults] setObject:newCast.closeCode forKey:[NSString stringWithFormat:@"%@CloseCode",self.EKeyID]];
            
        }
    }
}
- (void)connect:(NSInteger)timeout result:(BLEDeviceConnect)result{
    self.Connecting = YES;
    _connectBlock = result;
    [self.bleClient bleClient_connect];
    self.countDown = timeout?:ConnectTimeOutLimit;
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        weakSelf.countDown--;
        if (weakSelf.countDown>0) {
            return;
        }
        [weakSelf stopTimer];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf timerAction];
        });
    });
    dispatch_resume(timer);
    _timer = timer;
}

- (void)timerAction
{
    if (self.handlerDelegate && !self.Connected) {
        self.event.EventCode = BLE_CONNECT;
        self.Connected = NO;
        NSError *error = [[NSError alloc]initWithDomain:@"Connection timeout" code:0x66 userInfo:nil];
        [self disconnectBluetooth];
        if (_connectBlock) {
            _connectBlock(NO);
        }
        self.event.retCode = 1;
        self.event.EventPara = error;
        [self.handlerDelegate bleW266_EventHandler:self lockEvent:self.event];
    }
}
- (void)stopTimer;
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)disconnectBluetooth
{
    //    主动断连释放超时计时器
    [self stopTimer];
    self.Connecting = NO;
    if (self.Connected) {
        [self.bleClient bleClient_disconnect];
    }
}
/**
 设置锁具id
 
 @param lockId 锁id
 */
- (void)setLockID:(NSString *) lockId
{
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_setLcokId:lockId] timeOut: BLE_COMMNUTATION_TIMEOUT];
}

/**
 申请公钥
 
 @param info 服务器公钥信息
 */
- (void)applyPublicKey:(NSString *)info
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_exchangeCommkey:[infoDic objectForKey:@"PublicKeyC"]] timeOut: BLE_COMMNUTATION_TIMEOUT];
}

/**
 设置临时通讯秘钥
 
 @param info 密钥信息
 */
- (void)setCommKey:(NSString *)info
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    NSString *commkey = [infoDic objectForKey:@"CommKey"];
    NSString *kcv = [infoDic objectForKey:@"KCV"];
    NSString *oldKcv = [infoDic objectForKey:@"KCVOld"];
    NSString *sign = [infoDic objectForKey:@"PriSigniture"];
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_updateCommkey:commkey kcv:kcv oldKcv:oldKcv sign:sign] timeOut: BLE_COMMNUTATION_TIMEOUT];
}

/**
 设置OTC密钥
 
 @param info OTC密钥信息
 */
- (void)setOTCKey:(NSString *)info
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_updateOTCKey:[infoDic objectForKey:@"OTCKey"] kcv:[infoDic objectForKey:@"KCV"]] timeOut: BLE_COMMNUTATION_TIMEOUT];
}

/**
 发起开锁请求
 
 @param userId 用户id
 @param overTime 开锁超时时间
 */
- (void)startUnLock:(NSString *)info timeOut:(NSInteger)timeOut
{
//    非预发码开锁
     _praUnlock = NO;
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_startUnlock:[infoDic objectForKey:@"TmpUserID"] overTime:timeOut] timeOut: BLE_COMMNUTATION_TIMEOUT];
}

/**
 开锁
 
 @param otc 开锁码
 */
- (void)sendOTC:(NSString *)info
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_sendOTC:[infoDic objectForKey:@"OTCCode"]] timeOut: BLE_COMMNUTATION_TIMEOUT];
}
/**
 设置参数
 
 @param info 参数信息
 */
- (void)setParam:(NSString *)doorsNum romMode:(NSString *)romMode lockMode:(NSString *)lockMode lockGap:(NSString *)lockGap
{
    NSMutableString *mutableStr = [NSMutableString new];
    [mutableStr appendString:@"04"];
    [mutableStr appendString:[NSString getHexByDecimal:58]];
    [mutableStr appendString:[NSString stringWithFormat:@"0%@",doorsNum]];
    [mutableStr appendString:[NSString getHexByDecimal:59]];
    [mutableStr appendString:romMode];
    [mutableStr appendString:[NSString getHexByDecimal:60]];
    [mutableStr appendString:[NSString stringWithFormat:@"0%@",lockMode]];
    [mutableStr appendString:[NSString getHexByDecimal:49]];
    NSString *gapStr = [NSString getHexByDecimal:lockGap.integerValue];
    if (gapStr.length==1) {
        gapStr = [NSString stringWithFormat:@"0%@",gapStr];
    }
    [mutableStr appendString:gapStr];
    
    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_setParam:mutableStr] timeOut: BLE_COMMNUTATION_TIMEOUT];
}


/**
 预发开锁
 
 @param info 参数
 */
- (void)sendPreOTC:(NSString *)info
{
//    先发起开锁，硬件回复后直接用预发码开锁
    _praUnlock = YES;
    NSDictionary *infoDic = [NSDictionary dictionaryWithJsonStr:info];
    _praOTC = [infoDic objectForKey:@"PreIssueCode"];
     [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_startUnlock:[infoDic objectForKey:@"TmpUserID"] overTime:6] timeOut: BLE_COMMNUTATION_TIMEOUT];
}
/**
 同步时间
 */
- (void)setTime
{
    [self.bleClient bleClient_sendData:[self.bleProtocol setTime] timeOut:BLE_COMMNUTATION_TIMEOUT];
}

#pragma  mark BleEventProtocol
//连接回调
- (void)bleEvent_connectResult:(BOOL)success error:(NSError *)error
{
    self.Connecting = NO;
    [self stopTimer];
    if (error && !success) {
        //        设备断连
        self.event.EventCode = BLE_DISCONNECT;
        if (error.code == 6) {
            error = [NSError errorWithDomain:@"The connection has timed out unexpectedly." code:error.code userInfo:nil];
        }else if (error.code == 7){
            error = [NSError errorWithDomain:@"The specified device has disconnected from us." code:error.code userInfo:nil];
        }
        self.event.EventPara = error;
    }else{
        self.event.EventCode = BLE_CONNECT;
    }
    self.Connected = success;
    if (!success) {
        [self clearData];
    }
    if (_connectBlock) {
        _connectBlock(success);
    }
    self.event.retCode = 0;
    [self.handlerDelegate bleW266_EventHandler:self lockEvent:self.event];
}
//监听到数据处理
- (void)bleEvent_bleDevEvent:(BleDevEvent *)bleEvent error:(NSError *)error
{
    BLEDeviceEvent *event = [[BLEDeviceEvent alloc]init];
    if (error) {
        event.retCode = 1;
        event.EventPara = error;
        if (self.handlerDelegate) {
            [self.handlerDelegate bleW266_EventHandler:self lockEvent:event];
        }
    }
    if (bleEvent.eventType ==  BleDevEventTypeGainData) {
        if ([self dealWithData:bleEvent.eventData]) {
            NSLog(@"\n*********BleRecievedData********%@",self.receivedData);
            BLEDeviceCmdPackage *response = [[BLEDeviceCmdPackage alloc]initWithGatherData:self.receivedData];
            switch (response->CMD) {
                case EH_BLEInterfaceTypeSetLockID:{
                    event.EventCode = BLE_SETLOCKID_REPLY;
                }
                    break;
                case EH_BLEInterfaceTypeExchangeCommKey:{
                    event.EventCode = BLE_APPLYPUBLICKEY_REPLY;
                    event.EventPara = [response->Data toHexString];
                }
                    break;
                case EH_BLEInterfaceTypeUpdateCommKey:{
                    event.EventCode = BLE_SETCOMMKEY_REPLY;
                }
                    break;
                case EH_BLEInterfaceTypeUpdateOTCKey:{
                    event.EventCode = BLE_SETOTCKEY_REPLY;
                }
                    break;
                case EH_BLEInterfaceTypeUndataParam:{
                    event.EventCode = BLE_SETPARAM_REPLY;
                }
                    break;
                case EH_BLEInterfaceTypeUnlockLock:{
                    self.updateCloseCode = NO;
                    if (_praUnlock) {
                        [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_sendOTC:self.praOTC] timeOut: BLE_COMMNUTATION_TIMEOUT];
                    }
                }
                    break;
                case EH_BLEInterfaceTypeSendLockOTC:{
                    event.EventCode = BLE_SENDOTC_REPLY;
                    
                }
                    break;
                case EH_BLEInterfaceTypeApplyLockOTC:{
                    
                    if (_praUnlock) {
                        //                        预发码直接开锁
                        [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_sendOTC:self.praOTC]];
                    }else{
                        event.EventCode = BLE_REPLY_APPLYOTC;
                        event.EventPara = response->Data;
                    }
                    //                    收到申请otc 回复硬件
                    [NSThread sleepForTimeInterval:2];
                    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_applyOTCReply]];
                    
                }
                    break;
                case EH_BLEInterfaceTypeSendCloseCode:{
                    [NSThread sleepForTimeInterval:2];
                    [self.bleClient bleClient_sendData:[self.bleProtocol bleProtocol_closeCodeReply]];
                    event.EventCode = BLE_REPLY_CLOSECODE;
                    NSMutableData *gatherData = [[NSMutableData alloc]initWithData:response->Data];
                    NSString *str = [gatherData toHexString];
                    
                    NSString *hex1 = [str substringToIndex:1];
                    NSString *hex2 = [str substringWithRange:NSMakeRange(1, 1)];
                    NSString *voltage = [NSString stringWithFormat:@"%.1f",(hex1.floatValue*16+hex2.floatValue)/10];
                    
                    NSString *closeCodeStr = [str substringFromIndex:2];
                    NSMutableString *closeCode = [NSMutableString new];
                    for (NSInteger index=0; index<8; index++) {
                        [closeCode appendFormat:@"%u",([closeCodeStr substringWithRange:NSMakeRange(index*2, 2)].intValue -30)];
                    }
                    NSMutableDictionary *closeInfo = [NSMutableDictionary new];
                    self.Voltage = voltage;
                    [closeInfo setValue:voltage forKey:@"voltage"];
                    [closeInfo setValue:closeCode forKey:@"closeCode"];
                    event.EventPara = closeInfo;
                    self.updateCloseCode = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:closeCode forKey:[NSString stringWithFormat:@"%@CloseCode",self.EKeyID]];
                    
                }
                    break;
                case EH_BLEInterfaceTypeSetLockTime:{
                    event.EventCode = BLE_SETTIME_REPLY;
                }
                    break;
                default:
                    break;
            }
            NSError *responseError = [BLEDeviceError BleW266Error_errorCode:response->CMDRetCode errorTag:response->CMD];
            if (responseError) {
                event.EventPara = responseError;
                event.retCode = 1;
    
            }else{
                event.retCode = 0;
            }
            if (self.handlerDelegate) {
                [self.handlerDelegate bleW266_EventHandler:self lockEvent:event];
            }
            [self clearData];
            
        }
    }
}


#pragma mark Private Method
/**
 数据处理,硬件分包发送长度20字节
 
 @param data 收到的数据
 @return 是否收发数据完成
 */
- (BOOL)dealWithData:(NSData *)data
{
    NSLog(@"dealData%@",data);
    Byte *bytes = (Byte *)[data bytes];
    if (self.receivedData.length == 0 ) {
        self.dataLenth = bytes[0] + bytes[1] * 256;
        if (self.dataLenth<=0) {
            return NO;
        }
    }
    [self.receivedData appendData:data];
    if (self.receivedData.length-2 == self.dataLenth) {
        return YES;
    }else if(self.receivedData.length-2 >self.dataLenth){
        [self clearData];
        return NO;
    }
    return NO;
}
- (void)clearData
{
    self.dataLenth = 0;
    [self.receivedData setLength:0];
    NSLog(@"清除数据");
}
//转换成的时间格式需要补零操作
- (NSString *)stringWithIntComplete:(int)figure
{
    NSString *str = [NSString stringWithFormat:@"%u",figure];
    if (str.length==1) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}
- (void)dealloc
{
//    NSLog(@"我被释放了%@",self);
//    dispatch_source_cancel(_timer);
}
#pragma mark SETTER GETTER
- (BleClient *)bleClient
{
    if (!_bleClient) {
        _bleClient = _bleClient?:[[BleClient alloc]initWithPeripheral:self.peripheral];
        _bleClient.delegate = self;
    }
    return _bleClient;
}
- (BLEDeviceEvent *)event
{
    return _event = _event?:[[BLEDeviceEvent alloc]init];
}
- (BLEW266Protocol *)bleProtocol
{
    if (!_bleProtocol) {
        _bleProtocol = [[BLEW266Protocol alloc]init];
        [_bleProtocol setDeviceType:self.deviceType devAddr:self.EKeyID];
    }
    return _bleProtocol;
}

- (NSMutableData *)receivedData
{
    return _receivedData = _receivedData?:[[NSMutableData alloc]init];
}
@end
