//
//  WeiBOLoginViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-4.
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
#import "WeiBOLoginViewController.h"
#import "WBShareKit.h"
@interface WeiBOLoginViewController ()

@end

@implementation WeiBOLoginViewController
@synthesize weiBoEngine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[WBShareKit mainShare] startSinaOauthWithSelector:@selector(sinaSuccess:) withFailedSelector:@selector(sinaError:)];
    
    
    
	self.weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [weiBoEngine setRootViewController:self];
    [weiBoEngine setDelegate:self];
    [weiBoEngine setRedirectURI:@"http://"];
    [weiBoEngine setIsUserExclusive:NO];
    
    [super viewDidLoad];
    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        NSLog(@"if");
        [weiBoEngine logOut];
        
    }else{
        [self performSelector:@selector(onLogInOAuth) withObject:nil afterDelay:1.0];
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onLogInOAuth
{
    [weiBoEngine logIn];
}
- (void)viewDidUnload
{
    [self setWeiBoEngine:nil];
}



#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods

- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    NSLog(userID);
    NSLog(password);
    [weiBoEngine logInUsingUserID:userID password:password];
    
    //    [indicatorView startAnimating];
}


#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登出！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
        
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
     NSLog(weiBoEngine.accessToken);
    
    
     NSLog(weiBoEngine.userID);
    
    
    [params setObject:weiBoEngine.accessToken forKey:@"access_token"];
    [params setObject:weiBoEngine.userID forKey:@"uid"];
    [weiBoEngine loadRequestWithMethodName:@"users/show.json"
                               httpMethod:@"GET"
                                   params:params
                             postDataType:kWBRequestPostDataTypeNone
                         httpHeaderFields:nil];
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
}
- (void)request:(WBRequest *)request didReceiveRawData:(NSData *)data{
    NSLog(@"didReceiveRawData");
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"requestDidSucceedWithResult");
    //登录成功
    //    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
    }
}


- (void)request:(WBRequest *)request didReceiveResponse:(NSURLResponse *)response{
     NSLog(@"didReceiveRawData");
}


- (void)request:(WBRequest *)request didFailWithError:(NSError *)error{
     NSLog(@"didFailWithError");
}

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result{
     NSLog(@"didFinishLoadingWithResult");
}



- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登出成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"请重新登录！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}


@end
