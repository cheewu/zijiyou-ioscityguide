//
//  PWeiBoLoginViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-4.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PWeiBoLoginViewController.h"
#import "WBShareKit.h"
@interface PWeiBoLoginViewController ()

@end

@implementation PWeiBoLoginViewController

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
    [self performSelector:@selector(onLogInOAuth) withObject:nil afterDelay:1.0];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)onLogInOAuth{
     [[WBShareKit mainShare] startSinaOauthWithSelector:@selector(sinaSuccess:) withFailedSelector:@selector(sinaError:)];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark sina delegate
- (void)sinaSuccess:(NSData *)_data
{
    NSLog(@"sina ok:%@",_data);
}

- (void)sinaError:(NSError *)_error
{
    NSLog(@"sina error:%@",_error);
}



@end
