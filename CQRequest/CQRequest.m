//
//  CQRequest.m
//  CQRequest
//
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "CQRequest.h"
#import "CQRequestContext.h"
#import <AFNetworking/AFNetworking.h>
#import "CQRequestError.h"
@interface CQRequest ()
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, strong) CQResponse *response;
@property (nonatomic, strong) NSMutableArray<CQRequestCompletionBlock> *completionBlocks;
@property (nonatomic, copy) CQReuqestProgressBlock progressBlock;

@end

@implementation CQRequest

- (void)dealloc {
    [self.progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount))];
}

- (void)setProgress:(NSProgress *)progress {
    [_progress removeObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount))];
    _progress = progress;
    [_progress addObserver:self forKeyPath:NSStringFromSelector(@selector(completedUnitCount)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(completedUnitCount))]) {
        if (self.progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBlock(self.progress);
            });
        }
    }
}

- (CQRequest *)progress:(CQReuqestProgressBlock)progressBlock {
    self.progressBlock = progressBlock;
    return self;
}

- (CQRequest *)response:(CQRequestCompletionBlock)completion {
    if (!self.completionBlocks) {
        self.completionBlocks = [NSMutableArray arrayWithCapacity:1];
    }
    if (completion) {
        if (self.response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self.response);
            });
        }
        [self.completionBlocks addObject:completion];
    }
    return self;
}

- (BOOL)isRequesting {
    return self.task && (self.task.state == NSURLSessionTaskStateRunning || self.task.state == NSURLSessionTaskStateSuspended);
}

- (void)dispatchCompletionsWithResponse:(CQResponse *)response {
    NSError *responseError = response.error;
    if (responseError && ![responseError.domain isEqualToString:CQRequestErrorDomain]&& responseError.code != NSURLErrorCancelled) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"未知错误"};
        NSError *error = [NSError errorWithDomain:CQRequestErrorDomain
                                             code:CQRequestErrorUnknown
                                         userInfo:userInfo];
        response.error = error;
    }
    self.response = response;
    for (CQRequestCompletionBlock block in self.completionBlocks) {
        block(response);
    }
}

@end


#pragma mark - c
typedef void (^CompletionHandler)(NSURLResponse *URLResponse, id data, NSError *error);
CompletionHandler completionHandler(CQRequest *request, id<CQRequestConvertible> requestConvertible) {
    return ^(NSURLResponse *URLResponse, id data, NSError *error) {
        if (request.progress.completedUnitCount != request.progress.totalUnitCount) {
            request.progress.totalUnitCount = request.progress.completedUnitCount;
            if (request.progressBlock) {
                request.progressBlock(request.progress);
            }
        }
        CQResponse *response = [[CQResponse alloc] initWithURLResponse:URLResponse data:data];
        response.error = error;
        if ([requestConvertible respondsToSelector:@selector(responseDeserialize:completion:)]) {
            CQRequestContext *requestContext = (CQRequestContext *)requestConvertible;
            response.logString = requestContext.logURL;
            [requestConvertible responseDeserialize:response completion:^(CQResponse *response) {
#ifdef DEBUG
                NSLog(@"<=====【Response Start】=====>");
                CQRequestContext *requestContext = (CQRequestContext *)requestConvertible;
                response.logString = requestContext.logURL;
                NSLog(@"【path】%@", requestContext.path);
                NSLog(@"【Response】:%@", response.responseObject);
                NSLog(@"<=====【Response End】=====>");
#endif
                [request dispatchCompletionsWithResponse:response];
            }];
        } else {
            [request dispatchCompletionsWithResponse:response];
        }
    };
}


/************************************CQRequestManager********************************************/

@interface CQRequestManager ()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation CQRequestManager

+ (instancetype)sharedManager {
    static CQRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CQRequestManager new];
    });
    return manager;
}

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)cancelAllRequests {
    [self.sessionManager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
}


- (void)request:(CQRequest *)request convertible:(id<CQRequestConvertible>)requestConvertible {
    NSURLRequest *URLRequest = [requestConvertible requestSerialize];
    NSParameterAssert(URLRequest);
    if (URLRequest.HTTPBodyStream) {
        request.task = [self.sessionManager uploadTaskWithStreamedRequest:URLRequest
                                                                 progress:nil
                                                        completionHandler:completionHandler(request, requestConvertible)];
        request.progress = [self.sessionManager uploadProgressForTask:request.task];
        
    } else {
        request.task = [self.sessionManager dataTaskWithRequest:URLRequest
                                              completionHandler:completionHandler(request, requestConvertible)];
        request.progress = [self.sessionManager downloadProgressForTask:request.task];
    }
    [request.task resume];
}

- (CQRequest *)request:(id<CQRequestConvertible>)requestConvertible {
    CQRequest *request = [CQRequest new];
    [self request:request convertible:requestConvertible];
    
#ifdef DEBUG
    NSLog(@"<=====【Request Start】=====>");
    CQRequestContext *requestContext = (CQRequestContext *)requestConvertible;
    NSLog(@"【%@】%@", request.task.originalRequest.HTTPMethod, request.task.originalRequest.URL);
    NSLog(@"【path】%@", requestContext.path);
    if (requestContext.params.count) {
        NSLog(@"【Params】%@", requestContext.params);
    }
    NSLog(@"<=====【Request End】=====>");
#endif
    return request;
}

- (CQRequest *)upload:(id<CQRequestConvertible>)requestConvertible fromFile:(NSURL *)fileURL {
    CQRequest *request = [CQRequest new];
    NSURLRequest *URLRequest = [requestConvertible requestSerialize];
    request.task = [self.sessionManager uploadTaskWithRequest:URLRequest
                                                     fromFile:fileURL
                                                     progress:nil
                                            completionHandler:completionHandler(request, requestConvertible)];
    request.progress = [self.sessionManager uploadProgressForTask:request.task];
    [request.task resume];
    return request;
}

- (CQRequest *)upload:(id<CQRequestConvertible>)requestConvertible fromData:(NSData *)data {
    CQRequest *request = [CQRequest new];
    NSURLRequest *URLRequest = [requestConvertible requestSerialize];
    request.task = [self.sessionManager uploadTaskWithRequest:URLRequest
                                                     fromData:data
                                                     progress:nil
                                            completionHandler:completionHandler(request, requestConvertible)];
    request.progress = [self.sessionManager uploadProgressForTask:request.task];
    [request.task resume];
    return request;
}

- (CQRequest *)download:(id<CQRequestConvertible>)requestConvertible
             resumeData:(NSData *)resumeData
            destination:(CQRequestDestinationBlock)destination {
    CQRequest *request = [CQRequest new];
    NSURLRequest *URLRequest = [requestConvertible requestSerialize];
    if (resumeData) {
        request.task = [self.sessionManager downloadTaskWithResumeData:resumeData
                                                              progress:nil
                                                           destination:destination
                                                     completionHandler:completionHandler(request, requestConvertible)];
    } else {
        request.task = [self.sessionManager downloadTaskWithRequest:URLRequest
                                                           progress:nil
                                                        destination:destination
                                                  completionHandler:completionHandler(request, requestConvertible)];
    }
    request.progress = [self.sessionManager downloadProgressForTask:request.task];
    [request.task resume];
    return request;
}

@end

/****************************************-c style method-***************************************/
void cancelAllRequest() {
    [[CQRequestManager sharedManager] cancelAllRequests];
}

CQRequest *request(id<CQRequestConvertible> requestConvertible) {
    return [[CQRequestManager sharedManager] request:requestConvertible];
}

CQRequest *uploadFile(id<CQRequestConvertible> requestConvertible, NSURL *fileURL) {
    return [[CQRequestManager sharedManager] upload:requestConvertible fromFile:fileURL];
}

CQRequest *uploadData(id<CQRequestConvertible> requestConvertible, NSData *bodyData) {
    return [[CQRequestManager sharedManager] upload:requestConvertible fromData:bodyData];
}

CQRequest *download(id<CQRequestConvertible> requestConvertible, NSData *resumeData, CQRequestDestinationBlock destination) {
    return [[CQRequestManager sharedManager] download:requestConvertible resumeData:resumeData destination:destination];
}

