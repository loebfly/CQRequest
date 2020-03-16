//
//  CQViewController.m
//  CQRequest
//
//  Created by luchunqing on 01/25/2019.
//  Copyright (c) 2019 luchunqing. All rights reserved.
//

#import "CQViewController.h"
#import "CQRequestContext+Base.h"
#import "CQRequestKit.h"
@interface CQViewController ()

@end

@implementation CQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CQRequestContext *context = [CQRequestContext baseRequestContext];
    //设置请求参数
    [context addParam:@"参数值" forKey:@"参数名"];
    //设置模型转换类
    context.mapClass = [NSObject class];
    
    //调用请求
    CQRequest *req;
    //普通
    req = request(context);
    
    
    //上传
    NSData *upData = nil;
    req = uploadData(context, upData);
    req = uploadFile(context, [NSURL fileURLWithPath:@"文件地址"]);
    
    //下载
    NSData *resumeData = nil;
    req = download(context, resumeData, ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //返回要下载存放的路径
        return targetPath;
    });
    
    //请求结果响应
    [req response:^(CQResponse *response) {
        if (response.error) {
            //错误
        } else {
            //请求成功
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
