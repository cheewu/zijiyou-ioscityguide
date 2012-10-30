//
//  TDNetworkQueue.m
//  TestDownload
//
//  Created by ChenYu Xiao on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TDNetworkQueue.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"


@interface TDNetworkQueue() <ASIHTTPRequestDelegate>

@end


@implementation TDNetworkQueue 

@synthesize asiNetworkQueue = _asiNettworkQueue;
@synthesize requestArray = _requestArray;
@synthesize showView;
+ (id)sharedTDNetworkQueue
{
    @try {
        static dispatch_once_t pred;
        static TDNetworkQueue * tdNetworkQueue= nil;
        
        dispatch_once(&pred, ^{ tdNetworkQueue = [[self alloc] init];});
        return tdNetworkQueue;
    }
    @catch (NSException *exception) {
        
    }
  
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.asiNetworkQueue = [[ASINetworkQueue alloc] init];
        [self.asiNetworkQueue setShowAccurateProgress:YES];
        [self.asiNetworkQueue go];
        
        self.requestArray = [[NSMutableArray alloc] init];
        
    }
    fillImage =[UIImage imageNamed:@"downprocfill"];
    return self;
}

- (void)addDownloadRequestInQueue:(NSURL *)paramURL 
                     withTempPath:(NSString *)paramTempPath 
                 withDownloadPath:(NSString *)paramDownloadPath 
                 withView:(MapDownViewController *)paramView
{
    [self setShowView:paramView];
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:paramURL];
    request.delegate = self;//代理
 //   [request setDidReceiveDataSelector:@selector(request:didReceiveBytes:)];
    [request setDownloadDestinationPath:paramDownloadPath];//下载路径
    [request setTemporaryFileDownloadPath:paramTempPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = self;
    [self.asiNetworkQueue addOperation:request];//添加到队列，队列启动后不需重新启动
    if ([[NSFileManager defaultManager] fileExistsAtPath:paramTempPath]) {
        NSLog(@"有了");
//        NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:paramTempPath traverseLink:YES];
//        
//        NSLog(fileAttributes);
    }
    else {
        NSLog(@"没有");
    }
}


- (void)clearAllRequestsDelegate
{
    for (ASIHTTPRequest *request in self.requestArray) {
        [request setDownloadProgressDelegate:nil];
    }
    
}


- (void)clearOneRequestDelegateWithURL:(NSString *)paramURL
{
    for (ASIHTTPRequest *request in self.requestArray) {
        if ([[request.url absoluteString] isEqualToString:paramURL]) {
            [request setDownloadProgressDelegate:nil];
        }
    }
    
}

- (void)requestsDelegateSettingWithDictonary:(NSDictionary *) paramDictonary
{
    for (ASIHTTPRequest *request in self.requestArray) {
        for (id key in paramDictonary)
        {
            if ([[request.url absoluteString] isEqualToString:(NSString *)key]) {
                [request setDownloadProgressDelegate:[paramDictonary objectForKey:key]];
            }
        }
    }
}

- (void)pauseDownload:(NSString *)paramPauseURL
{
    @try{
    for (ASIHTTPRequest *request in self.requestArray) {
        if ([[request.url absoluteString] isEqualToString:paramPauseURL]) {
            NSLog(@"取消：%@",paramPauseURL);
            // 取消请求
            [request clearDelegatesAndCancel];
            [self.requestArray removeObject:request];
        }
    }
    }
    @catch (NSException *exception) {
    
    }
}



#pragma mark ASIHTTPRequestDelegate
//-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
//{
//    NSLog(@"bytes: %llu", bytes);
//}
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
// //   NSLog(@"didReceiveData==%d", [data length]/60);
//    
//    NSString *speedText=[[NSString alloc]initWithFormat:@"%d k/s" , [data length]/60];
//    [showView.speedText setText:speedText];
//}

static double lastProgress=0;
- (void)setProgress:(float)newProgress{
    @try{
        if(lastProgress==0){
            lastProgress=newProgress;
            return ;
        }
        [showView.currentSize setText:[[NSString alloc] initWithFormat:@"%.2fM",newProgress*fullDate]];
        double k =(newProgress-lastProgress)*fullDate*1024;
        if(k<0){
            k=-k;
        }
        NSLog(@"newProgress=%.2f",newProgress);
        NSLog(@"lastProgress=%.2f",lastProgress);
        NSLog(@"fullDate=%.2f",fullDate);
        lastProgress=newProgress;
        [showView.speedText setText:[[NSString alloc] initWithFormat:@"%.2f k/s",k]];

        double width =fillImage.size.width*newProgress;
        if(width<=18){
            width=18;
        }
        double fillheight=fillImage.size.height;
       // double fillwidth=fillImage.size.width;
        if(isRetina){
            fillheight*=2;
            width*=2;
        }
        
       tempImage =[self getHalfImage:fillImage rect:CGRectMake(0, 0, width, fillheight)];

        [showView.downfillImage setImage:tempImage];

        NSString *prc;
        if(newProgress>=1){
            prc= @"下载完成";
        }else{
            prc= [[NSString alloc] initWithFormat:@"正在下载... %.1f%%",newProgress*100];
        }
        [showView.downpre setText:prc];
    }@catch (NSException *e) {
        [self showErro];
        [showView finished];
    }

}
- (UIImage*)getHalfImage:(UIImage *)image rect:(CGRect)rect{
    CGImageRef originImageRef = image.CGImage;
    CGImageRef subImageRef =CGImageCreateWithImageInRect(originImageRef,rect);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    if(isRetina){
        UIGraphicsBeginImageContext(CGSizeMake(rect.size.width/2, rect.size.height/2));
        [subImage drawInRect:CGRectMake(0, 0, rect.size.width/2, rect.size.height/2)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    return subImage;
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    @try{
        NSLog(@"收到头部！");
        NSLog(@"%f",request.contentLength/1024.0/1024.0);
        NSLog(@"%@",responseHeaders);
       // NSLog([responseHeaders objectForKey:@"Content-Range"]);
        NSString *rang = [responseHeaders objectForKey:@"Content-Range"];
        NSString *fullSize;
        NSString *cuSize;
        if(rang==nil){
            fullDate =request.contentLength/1024.0/1024.0;
            fullSize=[[NSString alloc]initWithFormat:@" / %.2f M" ,fullDate];
            cuSize=[[NSString alloc]initWithFormat:@""];
        }else{
            NSString *stringf = @"/";
            NSString *cf = @"bytes ";
            NSRange ran = [rang rangeOfString:stringf];
            NSRange cran = [rang rangeOfString:cf];

            if(ran.location>0){
                NSString *retst=[rang substringFromIndex:ran.location+1];
    //            NSLog(@"string2:%@",retst);
                fullDate =[retst doubleValue]/1024.0/1024.0;
                fullSize = [[NSString alloc]initWithFormat:@" / %.2f M" ,fullDate];
                NSRange crag;
                crag.location=cran.length;
                crag.length=[rang rangeOfString:@"-"].location-cran.length;

                cuSize=[[NSString alloc]initWithFormat:@"%.2f M" ,[[rang substringWithRange:crag] doubleValue]/1024.0/1024.0];
                

                NSLog(@"cuSize:%@",cuSize);
            }
        }
        [showView.allSize setText:fullSize];
        [showView.currentSize setText:cuSize];
    }@catch (NSException *e) {
        [self showErro];
        [showView finished];
    }
    //NSLog([showView.allSize text]);
}



- (void)requestStarted:(ASIHTTPRequest *)request
{
    @try{
        NSLog(@"下载开始！");
        [self.requestArray addObject:request];
    }@catch (NSException *e) {
       [self showErro];
        [showView finished];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功！");

//    for (ASIHTTPRequest *aRequest in self.requestArray) {
//        NSLog(@"sURL:%@", [aRequest.url absoluteString]);
//        if ([[aRequest.url absoluteString] isEqualToString:[request.url absoluteString]]) {
//            [self.requestArray removeObject:request];
//        }
//    }
    [showView.currentSize setText:[[NSString alloc] initWithFormat:@"%.2f M",fullDate]];
    [showView.speedText setText:@""];
    [showView finished];
    
    for (int i=0; i<self.requestArray.count; i++) {
        ASIHTTPRequest *aRequest = [self.requestArray objectAtIndex:i];
        if ([[aRequest.url absoluteString] isEqualToString:[request.url absoluteString]]) {
            [self.requestArray removeObject:request];
        }
    }
    
    [showView.startButton setHidden:YES];
//    for (ASIHTTPRequest *aRequest in self.requestArray) {
//        NSLog(@"sURL:%@", [aRequest.url absoluteString]);
//    }

    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self showErro];
    NSLog(@"下载失败！");
     @try{
       // NSLog( [[request error] debugDescription]);
        [showView finished];
        for (int i=0; i<self.requestArray.count; i++) {
            ASIHTTPRequest *aRequest = [self.requestArray objectAtIndex:i];
            if ([[aRequest.url absoluteString] isEqualToString:[request.url absoluteString]]) {
                [self.requestArray removeObject:request];
            }
        }
     }
     @catch (NSException *e) {
         [showView finished];
     }
}

-(void)showErro{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"下载失败！"
                          message:nil
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)dealloc
{
    [tempImage dealloc];
    tempImage=nil;
    [fillImage dealloc];
    fillImage = nil;
    [self setShowView:nil];
    [super dealloc];
}




@end
