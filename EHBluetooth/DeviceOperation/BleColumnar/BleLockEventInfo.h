//
//  BleLockEventInfo.h
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/7/27.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleLockEventInfo : NSObject

@property (nonatomic , copy) NSString *eventID;
@property (nonatomic , copy) NSString *priority;
@property (nonatomic , copy) NSString *sequence;
@property (nonatomic , copy) NSString *broadcast;
@property (nonatomic , copy) NSString *addressListLen;
@property (nonatomic , copy) NSString *addressList;
@property (nonatomic , copy) NSString *dataLen;
@property (nonatomic , copy) NSString *data;

@end
