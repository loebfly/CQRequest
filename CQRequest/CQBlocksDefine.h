//
//  BlocksDefine.h
//  CQRequest
//
//  Created by QingGe on 2017/12/13.
//  Copyright © 2017年 QingGe. All rights reserved.
//

#ifndef CQBlocksDefine_h
#define CQBlocksDefine_h
@class CQResponse;
typedef void(^CQReuqestProgressBlock)(NSProgress *progress);
typedef NSURL *(^CQRequestDestinationBlock)(NSURL *targetPath, NSURLResponse *response);

typedef void (^CQRequestCompletionBlock)(CQResponse *response);

#endif /* BlocksDefine_h */
