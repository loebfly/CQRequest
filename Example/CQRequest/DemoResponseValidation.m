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
    //这里对响应体做一些处理,解密，设置错误等

    //这个回调必须执行,才回会到业务处
    completion(response);
}

@end
