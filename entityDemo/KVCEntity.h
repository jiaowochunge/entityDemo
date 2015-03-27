//
//  KVCEntity.h
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 采用kvc解析字典。这只是一个轻量级的解析，没有类型检查，遇到类型错误还是会挂
 */
@interface KVCEntity : NSObject

+ (instancetype)createEntityFromDictionary:(NSDictionary *)dic;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
