//
//  BLEColumnarLockMacro.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/5/17.
//  Copyright © 2018年 Patrick. All rights reserved.
//


// 弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;
//国际化
#define LocalizedString(name) NSLocalizedString(name, @"")

#define BLE_CHARACTERISTIC_WRITE @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define BLE_CHARACTERISTIC_READ  @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define BLE_CHARACTERISTIC_SERVICE @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
