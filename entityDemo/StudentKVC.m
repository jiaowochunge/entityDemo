//
//  StudentKVC.m
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "StudentKVC.h"

@implementation StudentKVC

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"course"]) {
        //两种方式一样的，给出参考
#if 0
        _course = [Course createEntityFromDictionary:value];
#else
        [super setValue:[Course createEntityFromDictionary:value] forKey:key];
#endif
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _sid = value;
    } else {
        //这句话可以不要，反正我们知道基类中这个函数什么都没干
        [super setValue:value forUndefinedKey:key];
    }
}

@end

@implementation Course

@end
