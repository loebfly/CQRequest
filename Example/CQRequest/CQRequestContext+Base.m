//
//  CQRequestContext+Base.m
//  CQRequest
//
//  Created by luchunqing on 01/25/2019.
//  Copyright (c) 2019 luchunqing. All rights reserved.
//

#import "CQRequestContext+Base.h"
#import "DemoResponseValidation.h"
#import "DemoRequestSignature.h"
#import "DemoMapper.h"
@implementation CQRequestContext (Base)

+ (instancetype)baseRequestContext {
    CQRequestContext *context = [self requestContext];
    context.timeoutInterval = 60.f;
    context.baseURL = [NSURL URLWithString:@"Request Address"];
    context.signature = [DemoRequestSignature new];
    context.validation = [DemoResponseValidation new];
    context.method = CQRequestMethodPOST;
    context.mapper = [DemoMapper new];
    return context;
}

@end
