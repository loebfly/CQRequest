//
//  CQResponse.m
//  CQRequest
//
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import "CQResponse.h"

@implementation CQResponse

- (instancetype)initWithURLResponse:(NSURLResponse *)URLResponse data:(NSData *)data {
    self = [super init];
    if (self) {
        _URLResponse = URLResponse;
        _data = data;
    }
    return self;
}

@end
