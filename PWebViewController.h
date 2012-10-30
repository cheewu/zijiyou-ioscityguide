//
//  PWebViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-9.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWebViewController : UIViewController<UIWebViewDelegate>
{
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,retain) PCTOPUIview * pctop;

@end
