//
//  CQRequest.h
//  CQRequest
//
//  Created by QingGe on 2017/12/7.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQBlocksDefine.h"
#import "CQRequestConvertible.h"

@interface CQRequest : NSObject

- (BOOL)isRequesting;
- (CQRequest *)progress:(CQReuqestProgressBlock)progressBlock;
- (CQRequest *)response:(CQRequestCompletionBlock)completion;

@end


@interface CQRequestManager : NSObject

+ (instancetype)sharedManager;
//请求
- (CQRequest *)request:(id<CQRequestConvertible>)requestConvertible;
//上传
- (CQRequest *)upload:(id<CQRequestConvertible>)requestConvertible fromFile:(NSURL *)fileURL;
- (CQRequest *)upload:(id<CQRequestConvertible>)requestConvertible fromData:(NSData *)data;
//下载
- (CQRequest *)download:(id<CQRequestConvertible>)requestConvertible
             resumeData:(NSData *)resumeData
            destination:(CQRequestDestinationBlock)destination;

@end

/*c-style*/
void cancelAllRequest(void);
CQRequest *request(id<CQRequestConvertible> requestConvertible);
CQRequest *uploadFile(id<CQRequestConvertible> requestConvertible, NSURL *fileURL);
CQRequest *uploadData(id<CQRequestConvertible> requestConvertible, NSData *bodyData);
CQRequest *download(id<CQRequestConvertible> requestConvertible, NSData *resumeData, CQRequestDestinationBlock destination);
