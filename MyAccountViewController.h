//
//  MyAccountViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define kWBSDKDemoAppKey @"2005144757"
#define kWBSDKDemoAppSecret @"06da52a7425728603761b0166a7766c3"

#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101
#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"
#import "RXCustomTabBar.h"
#import "PCTOPUIview.h"
#import "PCustAButtonView.h"


@interface MyAccountViewController : UIViewController<WBEngineDelegate, UIAlertViewDelegate, WBLogInAlertViewDelegate,WBRequestDelegate>{
    
    PCustAButtonView *leftb;
    PCustAButtonView *rightb;
    UIView *listUIView;
  //  NSMutableArray* entries;
}
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,retain) NSMutableDictionary *poiData;
@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic, retain) UIView *weiboView;
-(void)selectButtonCheckIn;
-(void)selectButtonFav;
-(void)checkLogIn;
@end
