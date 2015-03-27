//
//  ViewController.m
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "ViewController.h"
#import "EntityForward.h"
#import "StudentKVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testEntityForward];
    [self testEntityKVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testEntityForward
{
    //student的字典，来自服务器传回的json解析结果。多了个hobby，没关系。
    NSDictionary *jsonDic = @{@"id":@"123456789", @"name":@"bob", @"age":@19, @"sex":@0, @"hobby":@"chess"};
    id<Student> std = createEntityFromDictionary(jsonDic);
    //很蠢的实现方式，需要改进
    std.translateDic = @{@"sid":@"id"};
    NSLog(@"std.id = %@, std.name = %@, std.age = %@", std.sid, std.name, std.age);
    std.name = @"john";
    NSLog(@"std.name = %@", std.name);
    
    //测试复合数据结构。
    NSDictionary *courseDic = @{@"name":@"math", @"totalScore":@100, @"hour":@53, @"teacher":@"James"};
    //这里，我们故意把age写错了。
    NSDictionary *studentDic = @{@"id":@"123456789", @"name":@"bob", @"age1":@19, @"sex":@0, @"course":courseDic};
    id<Student> student = createEntityFromDictionary(studentDic);
    student.translateDic = @{@"sid":@"id"};
    NSLog(@"student.id = %@, student.name = %@, student.age = %@", student.sid, student.name, student.age);
    NSLog(@"student choose couse : %@", student.course.name);
    
    //测试数组结构
    NSDictionary *classDic = @{@"teacher":@"Mr. Hans", @"students":@[@{@"id":@"123456789", @"name":@"bob", @"age":@19, @"sex":@0, @"hobby":@"chess"}, @{@"id":@"123498765", @"name":@"bob's brother", @"age":@18, @"sex":@0}]};
    id<ClassOne> classOne = createEntityFromDictionary(classDic);
    for (id<Student> student in classOne.students) {
        NSLog(@"classOne student:%@", student.name);
    }
}

- (void)testEntityKVC
{
    NSDictionary *courseDic = @{@"name":@"math", @"totalScore":@100, @"hour":@53, @"teacher":@"James"};
    //这里，我们故意把age写错了。
    NSDictionary *studentDic = @{@"id":@"123456789", @"name":@"bob", @"age1":@19, @"sex":@0, @"course":courseDic};
    StudentKVC *student = [StudentKVC createEntityFromDictionary:studentDic];
    //这里，由于age的键名不对，初始化为0
    NSLog(@"student.id = %@, name = %@, age = %ld, sex = %@, course = %@", student.sid, student.name, (long)student.age, student.sex ? @"man":@"woman", student.course.name);
    
    courseDic = @{@"name":@[@"math"]};
    studentDic = @{@"name":@"bob", @"course":courseDic};
    student = [StudentKVC createEntityFromDictionary:studentDic];
    //这里，couseDic的name，我们期望是个string，但其实是个Array，将来会挂掉。
    NSLog(@"student.id = %@, name = %@, age = %ld, sex = %@, course = %@", student.sid, student.name, (long)student.age, student.sex ? @"man":@"woman", student.course.name);
}

@end
