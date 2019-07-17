//
//  BleDevEvent.h
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , BleDevEventType) {
    BleDevEventTypeConnect,
    BleDevEventTypeWriteData,
    BleDevEventTypeGainData,
};

@interface BleDevEvent : NSObject

@property (nonatomic , assign) BleDevEventType eventType;
@property (nonatomic , assign) id eventData;

-(instancetype)initWithType:(BleDevEventType)type eventData:(id)eventData;




@end


