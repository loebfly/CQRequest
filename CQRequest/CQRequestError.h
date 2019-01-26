//
//  CQRequestError.h
//  CQRequest
//
//  Created by QingGe on 2017/12/14.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#ifndef CQRequestError_h
#define CQRequestError_h

extern NSString * const CQRequestErrorDomain;

typedef NS_ENUM (NSInteger, CQRequestErrorCode) {
    CQRequestErrorUnknown = NSURLErrorUnknown,   // 未知错误
    CQRequestErrorCancel = NSURLErrorCancelled,  // 请求取消
    CQRequestErrorTimeOut = NSURLErrorTimedOut,  // 请求超时
    CQRequestErrorNoNetWork = NSURLErrorNotConnectedToInternet,  //无网络
    CQRequestErrorSuccess,// 成功
};


#endif /* CQRequestError_h */
