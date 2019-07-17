//
//  BleClient.m
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BleClient.h"
#import "BleMgr.h"


//分包发送的间隔
#define sleepDelay 0.020



@interface BleClient () <CBPeripheralDelegate,BleEventProtocol,BleConnectDelegate>

@property (nonatomic , strong) BleMgr *bleManager;
//当前设备
@property (nonatomic , strong) CBPeripheral *peripheral;
//连接的蓝牙设备所支持的服务
@property (strong , nonatomic) CBService *service;
//可读的特征 notify
@property (strong , nonatomic) CBCharacteristic *readCharacteristic;
//可写的特征
@property (strong , nonatomic) CBCharacteristic *writeCharacteristic;

@property (strong , nonatomic) dispatch_source_t timer;

@property (nonatomic , assign) NSInteger timerCount;

@property (nonatomic , strong) NSDate *connectTime;

@property (assign , nonatomic) BOOL isReceivedData;


@end

@implementation BleClient
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
    }
    return self;
}
- (void)bleClient_connect
{
    
    WEAKSELF;
    _connectTime = [NSDate date];
    [self.bleManager bleMgr_connectPeriphral:self.peripheral connectResult:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.peripheral.delegate = self;
            [weakSelf.peripheral discoverServices:nil];
        }else{
            [weakSelf.delegate bleEvent_connectResult:success error:error];
        }
    }];
    
//    [self.bleManager bleMgr_connectPeriphral:self.peripheral];
}
- (void)bleClient_disconnect
{
    WEAKSELF;
    [self.bleManager bleMgr_disconnectPeriphral:self.peripheral connectResult:^(BOOL success, NSError *error) {
        if (weakSelf.delegate) {
            NSError *disConnectError = [NSError errorWithDomain:@"Actively disconnect the bluetooth connection" code:5 userInfo:nil];
            [weakSelf.delegate bleEvent_connectResult:success error:disConnectError];
        }
    }];
//    [self.bleManager bleMgr_disconnectPeriphral:self.peripheral];
}
- (void)bleClient_sendData:(NSArray *)dataArr
{
    _isReceivedData = YES;
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSData *sendData in dataArr) {
            [NSThread sleepForTimeInterval:sleepDelay];
            [weakSelf.peripheral writeValue:sendData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    });
    NSLog(@"sendData%@",dataArr);
}
- (void)bleClient_sendData:(NSArray *)dataArr timeOut:(NSInteger)timeOut
{
    _timerCount = timeOut;
    [self bleClient_setTimer];
    [self bleClient_sendData:dataArr];
}
#pragma mark Private Method
- (BleMgr *)bleManager
{
    if (!_bleManager) {
        _bleManager = [BleMgr shareBleManger];
        _bleManager.delegate = self;
    }
    return _bleManager;
}

- (void)bleClient_setTimer
{
    __weak typeof(self) weakSelf = self;
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        weakSelf.timerCount--;
        NSLog(@"timer %ld",(long)self.timerCount);
        if (weakSelf.timerCount<0) {
            [weakSelf stopTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && weakSelf.isReceivedData) {
                    NSError *error = [[NSError alloc]initWithDomain:@"Bluetooth communication timeout" code:0x99 userInfo:nil];
                    NSLog(@"%@",error);
                    [weakSelf.delegate bleEvent_bleDevEvent:nil error:error];
                }
            });
        }
    });
    dispatch_resume(_timer);
}
- (void)stopTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark connectDelegate
- (void)bleConnect:(BOOL)success error:(NSError *)error
{
    if (success) {
        self.peripheral.delegate = self;
        [self.peripheral discoverServices:nil];
    }
    if (_delegate) {
        [_delegate bleEvent_connectResult:success error:error];
    }
    
}
#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for(CBService *service in peripheral.services)
    {
        if([[service.UUID UUIDString] isEqualToString:BLE_CHARACTERISTIC_SERVICE])
        {
            //                持有相应的服务，并且搜索当前服务下的特征
            self.service = service;
            [peripheral discoverCharacteristics:nil forService:_service];
            break;
        }
    }
   
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID.UUIDString isEqualToString:BLE_CHARACTERISTIC_SERVICE]) {
        for (CBCharacteristic *tmpCharacteristic in service.characteristics) {
            //满足read
            if ([tmpCharacteristic.UUID.UUIDString isEqualToString:BLE_CHARACTERISTIC_READ]) {
                self.readCharacteristic = tmpCharacteristic;
//                在获取到可监听的特征时，添加监听
                [self.peripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
            }
            //满足write
            if ([tmpCharacteristic.UUID.UUIDString isEqualToString:BLE_CHARACTERISTIC_WRITE]) {
                self.writeCharacteristic = tmpCharacteristic;
            }
        }
    }
    if (_delegate) {
        [_delegate bleEvent_connectResult:YES error:error];
        NSLog(@"连接成功%f",[[NSDate date] timeIntervalSinceDate:_connectTime]);
        NSNumber *timeNumber = [[NSNumber alloc]initWithFloat:[[NSDate date] timeIntervalSinceDate:_connectTime]];;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BleConnectTime" object:timeNumber];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error uploading value for characteristic %@ error:%@",characteristic.UUID,[error localizedDescription]);
        if (self.delegate) {
            [self.delegate bleEvent_bleDevEvent:nil error:error];
        }
        return;
    }
    //  收取到数据上报,清空 当前会话计时器 重置 计时时间
    _isReceivedData = NO;
    [self stopTimer];
    BleDevEvent *event = [[BleDevEvent alloc]initWithType:BleDevEventTypeGainData eventData:characteristic.value];
    if (self.delegate) {
        [self.delegate bleEvent_bleDevEvent:event error:nil];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
    NSLog(@"数据写入成功");
}


@end
