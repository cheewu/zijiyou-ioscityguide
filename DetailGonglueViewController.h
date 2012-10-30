//
//  DetailGonglueViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-11.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailGonglueViewController : UIViewController
//@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic,retain) NSString* text;
@property (nonatomic,retain) NSString* title;
@property (strong, nonatomic) IBOutlet UIWebView *dwebView;
@end
