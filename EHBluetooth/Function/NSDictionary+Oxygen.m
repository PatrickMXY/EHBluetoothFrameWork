//
//  NSDictionary+Oxygen.m
//  BLEColumnarLock
//
//  Created by 梦醒 on 2018/8/8.
//  Copyright © 2018年 Patrick. All rights reserved.
//

#import "NSDictionary+Oxygen.h"

@implementation NSDictionary (Oxygen)

+ (NSDictionary *)dictionaryWithJsonStr:(NSString *)jsonstr
{
    if (!jsonstr) {
        return nil;
    }
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"JsonAnalysisError:%@",error);
    }
    return dic;
}

@end
