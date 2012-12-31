//
//  PWebViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-9.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "PWebViewController.h"

@interface PWebViewController ()

@end

@implementation PWebViewController
@synthesize webView;
@synthesize pctop;
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
    [ViewController showWaiting:self.view];
    NSString *region_url=NSLocalizedStringFromTable(@"region_url", @"InfoPlist",nil);
    NSString *poi_article=NSLocalizedStringFromTable(@"poi_article", @"InfoPlist",nil);
    
    pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:[[NSString alloc]initWithFormat:@"%@攻略",poi_article]   backTitle:@"" righTitle:nil];
    
    
    [self.view addSubview: pctop];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    webView.scalesPageToFit =YES;
    webView.delegate =self;
    [self loadWebPageWithString:region_url];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)clickBack:(id)sender{
    UIStoryboard *sb = [ViewController getStoryboard];
    RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    [rb setSelectedIndex:4];
    [rb.btn1 setSelected:NO];
    [rb.btn5 setSelected:YES];
}

- (void)viewDidUnload
{
    [self setPctop:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSLog(urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ViewController hideWaiting:self.view];
}


@end
