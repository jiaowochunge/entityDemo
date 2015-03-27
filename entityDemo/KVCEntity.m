//
//  KVCEntity.m
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "KVCEntity.h"

@implementation KVCEntity

//kvc需要实现的两个方法。
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //这个是基类的实现，什么也不需要做，不要调用super方法，super默认实现是抛出异常
}

+ (instancetype)createEntityFromDictionary:(NSDictionary *)dic
{
    return [[self alloc] initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        @try {
            //文档帮助中并没有提到这个函数产生异常，产生异常是在KVC的其他方法中
            [self setValuesForKeysWithDictionary:dic];
        }
        @catch (NSException *exception) {
            NSLog(@"exception catched");
        }
    }
    return self;
}

@end
