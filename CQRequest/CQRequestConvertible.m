//
//  CQRequestConvertible.m
//  CQRequestDemo
//
//  Created by QingGe on 2017/12/13.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "CQRequestConvertible.h"
#import <AFNetworking/AFNetworking.h>
NSString * stringForMethod(CQRequestMethod method) {
    switch (method) {
        case CQRequestMethodGET:
            return @"GET";
        case CQRequestMethodPOST:
            return @"POST";
        case CQRequestMethodPUT:
            return @"PUT";
        case CQRequestMethodDELETE:
            return @"DELETE";
        case CQRequestMethodHEAD:
            return @"HEAD";
        case CQRequestMethodPATCH:
            return @"PATCH";
        default:
            return @"GET";
    }
}

@implementation NSMutableURLRequest (CWGJRequestConvertible)

+ (NSMutableURLRequest *)requestWithMethod:(CQRequestMethod)method
                                 URLString:(NSString *)URLString
                                    params:(NSDictionary *)params {
    return [self requestWithMethod:method
                         URLString:URLString
                            params:params
                           headers:nil
             constructingBodyBlock:nil];
}

+ (NSMutableURLRequest *)requestWithMethod:(CQRequestMethod)method
                                 URLString:(NSString *)URLString
                                    params:(NSDictionary *)params
                                   headers:(NSDictionary *)headers
                     constructingBodyBlock:(CQConstructingBodyBlock)constructingBodyBlock {
    static AFHTTPRequestSerializer *serializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializer = [AFHTTPRequestSerializer serializer];
    });
    NSMutableURLRequest *request = nil;
    NSError *error = nil;
    if (constructingBodyBlock) {
        request = [serializer multipartFormRequestWithMethod:stringForMethod(method)
                                                   URLString:URLString
                                                  parameters:params
                                   constructingBodyWithBlock:constructingBodyBlock
                                                       error:&error];
    } else {
        request = [serializer requestWithMethod:stringForMethod(method)
                                      URLString:URLString
                                     parameters:params
                                          error:&error];
    }
    NSParameterAssert(error == nil);
    NSParameterAssert(request);
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    return request;
}


@end
