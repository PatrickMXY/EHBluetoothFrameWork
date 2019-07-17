//
//  BleUpgradeMgr.m
//  EHBluetooth
//
//  Created by 梦醒 on 2019/4/2.
//  Copyright © 2019 Patrick. All rights reserved.
//

#import "BleUpgradeMgr.h"

@interface BleUpgradeMgr()
@property (nonatomic , strong) NSURL *binPath;
@end
@implementation BleUpgradeMgr
- (instancetype)initWithPath:(NSURL *)url
{
    if (self = [super init]) {
        [self dealWithBinData:url];
    }
    return self;
}
- (void)dealWithBinData:(NSURL *)binPath
{
    NSMutableData *binData = [[NSMutableData alloc]initWithData:[NSData dataWithContentsOfURL:binPath]];
    NSMutableArray *binDataArr = [NSMutableArray new];
    
    NSInteger arrCount;
    if (binData.length%256==0) {
        arrCount = binData.length/256;
    }else{
        arrCount = binData.length/256 +1;
    }
    for (NSInteger index=0; index<arrCount; index++) {
        [binDataArr addObject:[binData subdataWithRange:NSMakeRange(index*256, 256)]];
    }
    self.dataBin = binData;
    self.dataArr = binDataArr;
    
}
@end
