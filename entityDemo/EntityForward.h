//
//  EntityForward.h
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 创建鸭子对象，隐藏内部实现
 */
id createEntityFromDictionary(NSDictionary *dic);

//采用消息转发机制的模型类，创建的模型为鸭子模型，通过protocol存取属性
//根据这篇技术博客实现  http://blog.sunnyxx.com/2014/08/24/objc-duck/
//根据上面技术博客的观点，其实@interface EntityForward的声明不暴露出来。但我们只是为了演示作用，就暴露给大家，让大家知道怎么回事

@protocol BaseForwardEntity;
@interface EntityForward : NSObject<BaseForwardEntity>

/** 根据一个字典对象初始化，所有对于protocol的存取方法，将转发消息到这个字典上
 */
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

/** 基础协议。很拙劣的定义了一个字典
 */
@protocol BaseForwardEntity <NSObject>

/** 这个字典定义很拙劣，用来实现，当json字符串对应的字典中key为关键字时，无法定义对应protocol属性的解决方案
 */
@property (nonatomic, strong) NSDictionary *translateDic;

@end

@protocol Course;
@protocol Student <BaseForwardEntity>

/** 唯一id。你无法直接将属性名定义为id，id->sid的对应关系放在translateDic中
 */
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) id<Course> course;

@end

@protocol Course <BaseForwardEntity>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *totalScore;
@property (nonatomic, strong) NSNumber *hour;

@end

@protocol ClassOne <BaseForwardEntity>

@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSArray *students;

@end
