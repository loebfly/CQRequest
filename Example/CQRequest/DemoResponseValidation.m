//
//  DemoResponseValidation.m
//  CQRequest
//
//  Created by QingGe on 2017/12/14.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "DemoResponseValidation.h"

@implementation DemoResponseValidation

- (void)validateResponse:(CQResponse *)response completion:(CQRequestCompletionBlock)completion {
    
    //示例...
    
    //这里对响应体做一些处理,解密，设置错误等
    if (!response.error) {
      NSData *responseData = response.data;
      NSError *error = nil;
      NSDictionary *responseJsonData = [NSJSONSerialization JSONObjectWithData:responseData             options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            response.error = error;
        } else {
            //一般业务网络请求后都会有一个 responseCode 状态码 比如 200 代表 成功 404 代表错误 等等 , message 错误说明
            NSInteger responseCode = [responseJsonData[@"responseCode"] integerValue];
            if (responseCode == 200) {
                //这里建议赋值业务数据，便于 mapper 转模型
                response.responseObject = responseJsonData[@"data"];
            } else {
                //其他错误处理
                NSError *error = [NSError errorWithDomain:CQRequestErrorDomain
                    code:responseCode
                userInfo:@{NSLocalizedDescriptionKey: responseJsonData[@"message"]}];
                response.error = error;
            }
        }
    }
    
    //这个回调必须执行,才回会到业务处
    completion(response);
}

@end
