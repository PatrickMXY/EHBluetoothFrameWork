//
//  BleMgr.m
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BleMgr.h"
#import "BLEBroadcast.h"
//#import <iOSDFULibrary/iOSDFULibrary-Swift.h>


@interface BleMgr ()<CBCentralManagerDelegate>

@property (nonatomic , strong) CBCentralManager *bleManger;
@property (nonatomic , strong) NSMutableArray <CBPeripheral *> * connectPeripherals;
@property (nonatomic , strong) NSMutableArray <CBPeripheral *> * peripherals;//已抛出的设备
@property (nonatomic , strong) NSArray *filterArr;
@property (nonatomic ,   copy) BleConnectBlock connectBlock;

@end

@implementation BleMgr
+ (instancetype)shareBleManger
{
    static BleMgr *bleManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!bleManger) {
            bleManger = [[BleMgr alloc]init];
            
        }
    });
    return bleManger;
}
- (NSMutableArray <CBPeripheral *> *)peripherals
{
    return _peripherals = _peripherals?:[[NSMutableArray alloc]init];
}
- (NSMutableArray <CBPeripheral *> *)connectPeripherals
{
    return _connectPeripherals = _connectPeripherals?:[[NSMutableArray alloc]init];
}
- (CBCentralManager *)bleManger
{
    if (!_bleManger) {
//        不会扫描重复的设备CBCentralManagerScanOptionAllowDuplicatesKey 开启蓝牙监听弹窗CBCentralManagerOptionShowPowerAlertKey
        NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey,[NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,nil];
        _bleManger = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue() options:option];
    }
    return _bleManger;
}
- (void)bleMgr_startScan
{
    [self.bleManger stopScan];
    NSLog(@"开始扫描");
    [self.peripherals removeAllObjects];
    [self bleMgr_disconnectPeriphrals];
    [self.bleManger scanForPeripheralsWithServices:
     nil options:nil];
}
- (void)bleMgr_stopScan;
{
    NSLog(@"停止扫描");
    [self.bleManger stopScan];
}

- (void)bleMgr_setFilter:(NSArray *)devTypeArr
{
    _filterArr = devTypeArr;
}
- (void)bleMgr_connectPeriphral:(CBPeripheral *)periphral connectResult:(BleConnectBlock)block
{
    _connectBlock = block;
    [self.bleManger connectPeripheral:periphral options:nil];
}
- (void)bleMgr_disconnectPeriphral:(CBPeripheral *)periphral connectResult:(BleConnectBlock)block
{
    _connectBlock = block;
    [self.bleManger cancelPeripheralConnection:periphral];
    if ([self.connectPeripherals containsObject:periphral]) {
        [self.connectPeripherals removeObject:periphral];
    }
}
- (void)bleMgr_disconnectPeriphrals
{
    for (CBPeripheral *periphral in self.connectPeripherals) {
        [self.bleManger cancelPeripheralConnection:periphral];
    }
    [self.connectPeripherals removeAllObjects];
}
- (void)bleMgr_upgrade:(NSURL *)url peripheral:(CBPeripheral *)peripheral
{
//    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:url];// or
//    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager:self.bleManger  target:peripheral];
//    [initiator withFirmwareFile:selectedFirmware];
//
//    initiator.logger = self; // - to get log info
//    initiator.delegate = self; // - to be informed about current state and errors
//    initiator.progressDelegate = self; // - to show progress bar
//    // initiator.peripheralSelector = ... // the default selector is used
//
//    DFUServiceController *controller = [initiator start];
}
#pragma mark Private Method

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (@available(iOS 10.0, *)) {
        if (central.state == CBManagerStatePoweredOn) {
            NSLog(@"当前设备蓝牙可用");
            [self bleMgr_startScan];
        }else{
            NSError *error = [NSError errorWithDomain:@"Bluetooth not switched on" code:0x99 userInfo:nil];
            [_dataSource bleDataSource_scanResult:nil broadCast:nil error:error];
            [self bleMgr_stopScan];
            [self.peripherals removeAllObjects];
            //            系统蓝牙设备断连时，断开回抛所有已连接设备
            for (CBPeripheral *tmpPeripheral in self.connectPeripherals) {
                if (_connectBlock) {
                    _connectBlock (NO,error);
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationCenter_PeripheralBreakConnect object:tmpPeripheral];
                }
                
            }

        }
    } else {
        // Fallback on earlier versions
    }

}
//搜索到的设备信息 、信号强度
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (!_dataSource) {
        [self.bleManger stopScan];
        NSLog(@"停止扫");
        return;
    }

//    设备回传跟数组更新绑定，只有新增满足条件设备才会回传设备
//    NSString *peripheralName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    NSLog(@"%@",peripheral.name);
    NSData   *broadCastData  = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//    NSLog(@"我是原始广播%@",broadCastData);
//    if (![self.peripherals containsObject:peripheral]) {
//        [self.peripherals addObject:peripheral];
    [_dataSource bleDataSource_scanResult:peripheral broadCast:broadCastData error:nil];
//    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    [self.bleManger stopScan];
//    NSLog(@"停止扫");
    NSLog(@"\n*********BleConnect********%@",peripheral.name);
    if (_connectBlock) {
        if (![_connectPeripherals containsObject:peripheral]) {
            [_connectPeripherals addObject:peripheral];
        }
        _connectBlock(YES , nil);
    }
//    if (_delegate) {
//        if (![_connectPeripherals containsObject:peripheral]) {
//            [_connectPeripherals addObject:peripheral];
//        }
//        [_delegate bleConnect:YES error:nil];
//    }
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"\n*********BleBreakConnect********%@%@",peripheral.name,error);
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationCenter_PeripheralBreakConnect object:peripheral];
    if ([self.connectPeripherals containsObject:peripheral]) {
        [self.connectPeripherals removeObject:peripheral];
    }
    if (_connectBlock) {
        _connectBlock (NO , error);
    }
//    if (_delegate) {
//        [_delegate bleConnect:NO error:error];
//    }
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"\n*********BleFailConnect********%@",error);
    if (_connectBlock) {
        _connectBlock (NO , error);
    }
//    if (_delegate) {
//        [_delegate bleConnect:NO error:error];
//    }
}

@end
