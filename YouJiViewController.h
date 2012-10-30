//
//  YouJiViewController.h
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouJiViewController : UIViewController<UIWebViewDelegate>{
    UIActivityIndicatorView *activityIndicatorView;
}
@property (weak, nonatomic) IBOutlet UIWebView *youjiWebView;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* url;
@end
