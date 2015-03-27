//
//  EntityForward.m
//  entityDemo
//
//  Created by John on 15/3/27.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "EntityForward.h"

id processDic(id input);

/** 这里是为了检查入参的合法性
 */
id createEntityFromDictionary(NSDictionary *dic)
{
    return processDic(dic);
}

/** 这里采用递归处理原始字典，凡字典中嵌套字典的时候，要将嵌套的字典替换为EntityForward对象，以支持消息转发
 */
id processDic(id input)
{
    if ([input isKindOfClass:[NSDictionary class]]) {
        //检测是否存在复合数据结构，即字典和数组
        __block BOOL hasComplex = NO;
        NSDictionary *oriDic = input;
        [oriDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                hasComplex = YES;
                *stop = YES;
            }
        }];
        //不存在复合数据结构，返回处理过的实体对象
        if (!hasComplex) {
            return [[EntityForward alloc] initWithDictionary:input];
        }
        NSMutableDictionary *output = [input mutableCopy];
        NSArray *allkey = output.allKeys;
        for (int i = 0; i != allkey.count; ++i) {
            id key = allkey[i];
            id value = [output objectForKey:key];
            [output setObject:processDic(value) forKey:key];
        }
        return [[EntityForward alloc] initWithDictionary:output];
    } else if ([input isKindOfClass:[NSArray class]]) {
        NSArray *oriArr = input;
        NSMutableArray *output = [NSMutableArray arrayWithCapacity:oriArr.count];
        for (int i = 0; i != oriArr.count; ++i) {
            [output addObject:processDic(oriArr[i])];
        }
        return output;
    } else {
        return input;
    }
}

#pragma mark - implementation EntityForward

@interface EntityForward ()
{
    //翻译关键字
    NSDictionary *_translateDic;
}

//可变字典，真实的数据结构，可以响应setter方法
@property (nonatomic, strong) NSMutableDictionary *dummy;

@end

@implementation EntityForward

@synthesize translateDic = _translateDic;

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    NSParameterAssert(dic);
    NSAssert([dic isKindOfClass:[NSDictionary class]], @"param type error");
    self = [super init];
    if (self) {
        self.dummy = [dic mutableCopy];
    }
    return self;
}

//分析消息签名。具体网上搜索“ios 消息转发”
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    SEL forwordSelector = aSelector;
    if ([self propertyNameFromGetterSelector:aSelector]) {
        forwordSelector = @selector(objectForKey:);
    } else if ([self propertyNameFromSetterSelector:aSelector]) {
        forwordSelector = @selector(setObject:forKey:);
    }
    return [[_dummy class] instanceMethodSignatureForSelector:forwordSelector];
}

/** 原理：entity的真实数据结构是一个可变字典。当收到一个存取消息时，将消息解析，转发给字典。
 譬如收到protocol Student的消息setName，将转发为[NSDictionary setObject: forKey:]；
 同理，getName消息(ios下为name消息)转发为[NSDictionary objectForKey:]
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *propertyName = nil;
    // Try getter
    propertyName = [self propertyNameFromGetterSelector:anInvocation.selector];
    if (propertyName) {
        anInvocation.selector = @selector(objectForKey:);
        [anInvocation setArgument:&propertyName atIndex:2]; // self, _cmd, key
        [anInvocation invokeWithTarget:_dummy];
        return;
    }
    // Try setter
    propertyName = [self propertyNameFromSetterSelector:anInvocation.selector];
    if (propertyName) {
        anInvocation.selector = @selector(setObject:forKey:);
        [anInvocation setArgument:&propertyName atIndex:3]; // self, _cmd, obj, key
        [anInvocation invokeWithTarget:_dummy];
        return;
    }
    [super forwardInvocation:anInvocation];
}

//简单的消息处理
- (NSString *)propertyNameFromGetterSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    if (parameterCount == 0) {
        //翻译关键字逻辑。Student对应的原始字典键名为id，ios不能取名为id的属性，遇到其他关键字也很蛋疼。但你不能跟后台人说，你们建表的时候别用id作为列名啊，description也不能用，UIImage也不能用……
        if ([_translateDic objectForKey:selectorName]) {
            return [_translateDic objectForKey:selectorName];
        }
        return selectorName;
    }
    return nil;
}

- (NSString *)propertyNameFromSetterSelector:(SEL)aSelector
{
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    if ([selectorName hasPrefix:@"set"] && parameterCount == 1) {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        selectorName = [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)].lowercaseString;
        if ([_translateDic objectForKey:selectorName]) {
            return [_translateDic objectForKey:selectorName];
        }
        return selectorName;
    }
    return nil;
}

@end