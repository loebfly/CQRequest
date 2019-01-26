//
//  CQRequestConvertible.h
//  CQRequest
//  配置生成请求工厂类
//  Created by QingGe on 2017/12/13.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponse.h"
#import "CQBlocksDefine.h"

typedef NS_ENUM (NSInteger, CQRequestMethod) {
    CQRequestMethodGET,
    CQRequestMethodPOST,
    CQRequestMethodPUT,
    CQRequestMethodDELETE,
    CQRequestMethodHEAD,
    CQRequestMethodPATCH,
};

@protocol AFMultipartFormData;
typedef void (^CQConstructingBodyBlock)(id<AFMultipartFormData> formData);

@protocol CQRequestConvertible <NSObject>

- (NSMutableURLRequest *)requestSerialize;

@optional
- (void)responseDeserialize:(CQResponse *)response completion:(CQRequestCompletionBlock)completion;

@end

@interface NSMutableURLRequest (CWGJRequestConvertible)

+ (NSMutableURLRequest *)requestWithMethod:(CQRequestMethod)method
                                 URLString:(NSString *)URLString
                                    params:(NSDictionary *)params;

+ (NSMutableURLRequest *)requestWithMethod:(CQRequestMethod)method
                                 URLString:(NSString *)URLString
                                    params:(NSDictionary *)params
                                   headers:(NSDictionary *)headers
                     constructingBodyBlock:(CQConstructingBodyBlock)constructingBodyBlock;

@end
