//
//  DemoRequestSignature.m
//  CQRequest
//
//  Created by QingGe on 2017/12/14.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "DemoRequestSignature.h"

@implementation DemoRequestSignature

- (void)signatureWithContext:(CQRequestContext *)context {
    //按业务需求这里可以对请求做一些处理，例如参数加密，增加
    
    //拿到请求参数
    NSMutableDictionary *requestParms = [NSMutableDictionary dictionaryWithDictionary:context.params];
    //加密
    //...
    //一次性写入多个参数,会重新给请求参数赋值
    [context setParams:requestParms];
    //添加新的参数
    [context addParam:@"新增的值" forKey:@"新增的Key"];
    //...
}

@end
