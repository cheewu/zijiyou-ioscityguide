//
//  HotPoiTabBarViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-22.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "HotPoiTabBarViewController.h"
#import "CustomNavigationBar.h"
@interface HotPoiTabBarViewController ()

@end

@implementation HotPoiTabBarViewController

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
//    self.selectedViewController.navigationController.navigationBar.backItem.title = @"Home";
//    CustomNavigationBar* customNavigationBar = (CustomNavigationBar*)self.selectedViewController.navigationController.navigationBar;
//    // Clear the tint color
//    customNavigationBar.tintColor = nil;
//    // Clear the background
//    [customNavigationBar clearBackground];
//    
//    // Set the nav bar's background
//    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"back.png"]];
//    
//    // Instead of a custom back button, use the standard back button with a dark gray tint
//    customNavigationBar.tintColor = [UIColor darkGrayColor];// self.navigationItem.backBarButtonItem.title = @"back";
//	// Do any additional setup after loading the view.
//
//	// Do any additional setup after loading the view.
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

@end
