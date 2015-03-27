//
//  StudentKVC.h
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "KVCEntity.h"

@class Course;
@interface StudentKVC : KVCEntity

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
//kvc将帮你实现包装器类型到基本数据类型的转换。EntityForward中的定义是NSNumber，消息转发方式得到的就是类
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, strong) Course *course;

@end

@interface Course : KVCEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger totalScore;
@property (nonatomic, assign) NSInteger hour;

@end
