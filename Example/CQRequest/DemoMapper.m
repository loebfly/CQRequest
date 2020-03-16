//
//  DemoMapper.m
//  CQRequest_Example
//
//  Created by QingGe on 2019/1/26.
//  Copyright © 2019 luchunqing. All rights reserved.
//

#import "DemoMapper.h"
#import <MJExtension/MJExtension.h>
@implementation DemoMapper

- (id)mapResponseData:(id)responseData mapClass:(Class)mapClass {
    //示例
    //这里的responseData 来自于CQResponse 的 responseObject 也就是 DemoResponseValidation 代理方法 中处理过得业务数据
    id result = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
       result = [mapClass mj_objectWithKeyValues:responseData];
    } else if ([responseData isKindOfClass:[NSArray class]]) {
       result = [mapClass mj_objectArrayWithKeyValuesArray:responseData];
    }
    return result;
}

@end
