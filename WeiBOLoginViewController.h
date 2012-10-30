//
//  WeiBOLoginViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-4.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WeiBOLoginViewController : UIViewController<WBEngineDelegate, UIAlertViewDelegate, WBLogInAlertViewDelegate,WBRequestDelegate>

@property (nonatomic, retain) WBEngine *weiBoEngine;
@end
