//
//  BLEDeviceEvent.h
//  EHBluetooth
//
//  Created by 梦醒 on 2018/11/14.
//  Copyright © 2018 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEDeviceEvent : NSObject
@property (nonatomic , assign) NSInteger  EventCode;//事件代码
@property (nonatomic , strong) id         EventPara;//事件参数
@property (nonatomic , assign) NSInteger  retCode;//硬件的错误码信息。0是成功
@end

NS_ASSUME_NONNULL_END
