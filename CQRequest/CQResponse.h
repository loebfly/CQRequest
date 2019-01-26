//
//  CQResponse.h
//  CQRequest
//
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQResponse : NSObject

- (instancetype)initWithURLResponse:(NSURLResponse *)URLResponse
                               data:(NSData *)data;

@property (nonatomic, strong, readonly) NSURLResponse *URLResponse;
@property (nonatomic, strong, readonly) NSData *data;//请求原数据
@property (nonatomic, strong) NSError *error;//请求错误
//调用后，error会有值 CQRequestErrorDomain
@property (nonatomic, copy) void (^cancelBlock)(void);
//默认为 data json后的数据,如果在CQRequestContext中设置了mapClass和mapper，值为 mapper代理返回数据
@property (nonatomic, strong) id responseObject;

@property (nonatomic, strong) NSDictionary *extraInfo;//扩展信息,预留字段

@property (nonatomic, strong) NSString *logString;//日志



@end
