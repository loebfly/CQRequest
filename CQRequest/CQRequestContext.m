//
//  CQRequestContext.m
//  CQRequest
//
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "CQRequestContext.h"
#import "CQRequestConvertible.h"
#import "CQRequestError.h"

@interface CQRequestContext ()

@property (nonatomic, strong, readonly) NSURL *URL;

@end

@implementation CQRequestContext

#pragma mark - Factory

+ (instancetype)requestContext {
    return [self new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeoutInterval = 30.f;
        self.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        _headers = [NSMutableDictionary dictionary];
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSURL *)URL {
    NSParameterAssert(self.baseURL != nil || self.path.length > 0);
    if (self.path) {
        return [NSURL URLWithString:self.path relativeToURL:self.baseURL];
    } else {
        return [NSURL URLWithString:@"" relativeToURL:self.baseURL];
    }
}

- (void)setParams:(NSDictionary *)params {
    _params = [NSMutableDictionary dictionaryWithDictionary:params];
}

- (void)addParams:(NSDictionary *)params {
    __weak typeof(self) weakSelf = self;
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf->_params setObject:obj forKey:key];
    }];
}

- (void)addParam:(id)param forKey:(NSString *)key {
    if (param && key) {
        _params[key] = param;
    }
}

#pragma mark - CQRequestConvertible
- (NSMutableURLRequest *)requestSerialize {
    if ([self.signature respondsToSelector:@selector(signatureWithContext:)]) {
        [self.signature signatureWithContext:self];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithMethod:self.method
                                                                URLString:self.URL.absoluteString
                                                                   params:self.params
                                                                  headers:self.headers
                                                    constructingBodyBlock:self.constructingBodyBlock];
    request.timeoutInterval = self.timeoutInterval;
    request.cachePolicy = self.cachePolicy;
    return request;
}

- (void)responseDeserialize:(CQResponse *)response completion:(CQRequestCompletionBlock)completion {
    if ([self.validation respondsToSelector:@selector(validateResponse:completion:)]) {
        __weak typeof(self) weakSelf = self;
        [self.validation validateResponse:response completion:^(CQResponse *response) {
            if (!response.error && weakSelf.mapClass) {
                [weakSelf mapResponse:response completion:completion];
            } else {
                completion(response);
            }
        }];
    } else {
        if (!response.error && self.mapClass && self.mapper) {
            [self mapResponse:response completion:completion];
        } else {
            completion(response);
        }
    }
}


- (void)mapResponse:(CQResponse *)response
         completion:(CQRequestCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (!response.error && response.responseObject) {
            if ([self.mapper respondsToSelector:@selector(mapResponseData:mapClass:)]) {
                response.responseObject = [self.mapper mapResponseData:response.responseObject mapClass:self.mapClass];
            }
            
            __weak typeof(response) weakResponse = response;
            response.cancelBlock = ^{
                weakResponse.error = [NSError errorWithDomain:CQRequestErrorDomain
                                                         code:CQRequestErrorCancel
                                                     userInfo:@{NSLocalizedDescriptionKey: @"请求取消"}];
            };
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response);
        });
    });
}


@end
