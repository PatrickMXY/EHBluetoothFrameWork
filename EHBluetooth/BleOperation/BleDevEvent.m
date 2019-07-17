//
//  BleDevEvent.m
//  GeneralBle
//
//  Created by 梦醒 on 2018/6/11.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "BleDevEvent.h"

@implementation BleDevEvent
- (instancetype)initWithType:(BleDevEventType)type eventData:(id)eventData
{
    if (self = [super init]) {
        self.eventType = type;
        self.eventData = eventData;
    }
    return self;
}

@end
