//
//  TDNetworkQueue.h
//  TestDownload
//
//  Created by ChenYu Xiao on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapDownViewController.h"

@class ASINetworkQueue;
@class ASIHTTPRequest;
@class MapDownViewController;

@interface TDNetworkQueue : NSObject{
    double fullDate;
    UIImage *fillImage;
    UIImage *tempImage;
}

@property (nonatomic, strong)ASINetworkQueue *asiNetworkQueue;

@property (nonatomic, strong)NSMutableArray *requestArray;

@property(nonatomic,strong) MapDownViewController *showView;
// 单例的构造方法
+ (id)sharedTDNetworkQueue;

// 增加下载的request进入队列
- (void)addDownloadRequestInQueue:(NSURL *)paramURL
                     withTempPath:(NSString *)paramTempPath
                 withDownloadPath:(NSString *)paramDownloadPath
                         withView:(MapDownViewController *)paramView;

// 当controller被关闭清除内存的时候，设置到delegate的view要设置为nil
- (void)clearAllRequestsDelegate;

// 当controller被关闭清除内存的时候，设置到delegate的view要设置为nil.只对一个有效果
- (void)clearOneRequestDelegateWithURL:(NSString *)paramURL;

// 恢复progressview的进度
- (void)requestsDelegateSettingWithDictonary:(NSDictionary *) paramDictonary;

// 暂停下载
- (void)pauseDownload:(NSString *)paramPauseURL;


@end
