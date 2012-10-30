//
//  YouJiViewController.m
//  zijiyoun
//
//  Created by piaochunzhi on 12-9-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "YouJiViewController.h"

@interface YouJiViewController ()

@end

@implementation YouJiViewController
@synthesize youjiWebView;
@synthesize title;
@synthesize url;

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
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:title backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];
    
    youjiWebView.scalesPageToFit =YES;
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    
    [youjiWebView setDelegate:self];
    NSURL *nurl =[NSURL URLWithString:url];
    NSURLRequest *request =[NSURLRequest requestWithURL:nurl];
    [youjiWebView loadRequest:request];

    [super viewDidLoad];
    [self.view addSubview : activityIndicatorView] ;
	// Do any additional setup after loading the view.
}
-(void)backClick{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    activityIndicatorView =nil;
    [self setYoujiWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}

@end
