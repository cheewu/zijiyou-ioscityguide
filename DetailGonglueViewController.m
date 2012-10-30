//
//  DetailGonglueViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-11.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "DetailGonglueViewController.h"

@interface DetailGonglueViewController ()

@end

@implementation DetailGonglueViewController
//@synthesize contentTextView;
@synthesize text;
@synthesize title;
@synthesize dwebView;
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
//    [contentTextView setEditable:NO];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:title backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];
 //   [contentTextView setBackgroundColor:[UIColor clearColor]];
 //   [contentTextView setText:text];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    
    dwebView.backgroundColor = [UIColor clearColor];  //但是这个属性必须用代码设置，光 xib 设置不行
    
    dwebView.opaque = NO;
    
    //这行能在模拟器下明下加快 loadHTMLString 后显示的速度，其实在真机上没有下句也感觉不到加载过程
    
    dwebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    //下面的 backgroud-color:transparent 结合最前面的两行代码指定的属性就真正使得 WebView 的背景透明了
    //而后的 font:16px/18px 就是设置字体大小为 16px, 行间距为 18px，也可用  line-height: 18px 单独设置行间距
    //最后的 Custom-Font-Name 就是前面在项目中加上的字体文件所对应的字体名称了
    
//    NSString *webviewText = @"<style>body{margin:0;background-color:transparent;font:16px/18px Custom-Font-Name}</style>";
    //NSLog(@"text===%@",text);
    NSString *path=[[NSString alloc]initWithFormat:@"file://%@" ,[[NSBundle mainBundle] bundlePath] ];
    text = [text stringByReplacingOccurrencesOfString:@"@@URL@@" withString:path];
    //NSLog(@"text===%@",text);
 
    [dwebView loadHTMLString:text baseURL:nil]; //在 WebView 中显示本地的字符串
    
}

-(void)clickBack
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
 //   [self setContentTextView:nil];
    [self setText:nil];
    [self setTitle:nil];
    [self setDwebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
