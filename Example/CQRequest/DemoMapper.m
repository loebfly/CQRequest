//
//  DemoMapper.m
//  CQRequest_Example
//
//  Created by QingGe on 2019/1/26.
//  Copyright © 2019 luchunqing. All rights reserved.
//

#import "DemoMapper.h"

@implementation DemoMapper

- (id)mapResponseData:(NSData *)data mapClass:(Class)mapClass {
    //返回ResponseObject,例如数组，对象
    return [NSArray array];
    return [NSObject new];
}

@end
