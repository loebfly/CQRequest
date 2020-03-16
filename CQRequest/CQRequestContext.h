//
//  CQRequestContext.h
//  CQRequest
//  请求上下文类
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQRequestConvertible.h"

@protocol CQRequestSignature,CQResponseValidation,CQResponseMapper;

@interface CQRequestContext : NSObject<CQRequestConvertible>

+ (instancetype)requestContext;
//请求
@property (nonatomic, assign) CQRequestMethod method;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSString *logURL;//用于输出请求日志
@property (nonatomic, strong, readonly) NSMutableDictionary *headers;//请求头
@property (nonatomic, strong, readonly) NSMutableDictionary *params;//请求参数
@property (nonatomic, copy)  CQConstructingBodyBlock constructingBodyBlock;

@property (nonatomic, strong) id<CQRequestSignature> signature;

//设置参数
- (void)addParam:(id)param forKey:(NSString *)key;
//同时添加多个参数
- (void)addParams:(NSDictionary *)params;
//这个方法覆盖原来的请求参数,传空相当于重置请求参数
- (void)setParams:(NSDictionary *)params;

//响应
@property (nonatomic, strong) id<CQResponseValidation> validation;
/**
 因数据模型转换框架有很多，故不做依赖,交由外部实现。
 这里这个做的原因是将业务和数据模型转换拆分
 代理的返回值作为CQResponse 的responseObject值
*/
@property (nonatomic, strong) Class mapClass;
@property (nonatomic, strong) id<CQResponseMapper> mapper;

@end

//对请求上下文做处理的协议
@protocol CQRequestSignature <NSObject>

- (void)signatureWithContext:(CQRequestContext *)context;

@end

//对响应进行数据验证的协议
@protocol CQResponseValidation <NSObject>

- (void)validateResponse:(CQResponse *)response completion:(CQRequestCompletionBlock)completion;

@end

//数据模型转化协议
@protocol CQResponseMapper <NSObject>

- (id)mapResponseData:(id)responseData mapClass:(Class)mapClass;

@end
