//
//  MapDownViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-5.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "MapDownViewController.h"
#import "ZipArchive.h"
@interface MapDownViewController ()

@end

@implementation MapDownViewController
@synthesize pctop;
@synthesize speedText;
@synthesize currentSize;
@synthesize allSize;
@synthesize downpre;
@synthesize downfillImage;
@synthesize startButton;
@synthesize backIdentifier;
@synthesize backpoimongoid;
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
    
   // pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"地图下载" isShowBack:YES isShowRight:NO ];
   // [self.downfillImage setFrame:[self.downImageView frame]];
    pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"离线数据下载" backTitle:@"" righTitle:nil];
    
    [self.view addSubview: pctop];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    
 
//    [downfillImage setFrame:[[self downImageView] frame]];
    //平铺
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:tabelbg]];
    [super viewDidLoad];
   
        
    
 //   TDNetworkQueue *tdNetworkQuese = [TDNetworkQueue sharedTDNetworkQueue];
    //[tdNetworkQuese pauseDownload:test1URL];
            
            
	// Do any additional setup after loading the view.
}


-(void)clickBack:(id)sender{
    @try {
        TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];
        [tdNetworkQueue pauseDownload:downURL];
     NSLog(@"backIdentifier=%@",backIdentifier);
    NSLog(@"backpoimongoid=%@",backpoimongoid);
    if(([backIdentifier isEqualToString:@"PayMapViewController"])){
        UIStoryboard *sb = [ViewController getStoryboard];
        DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        [rb setPoimongoid:[self backpoimongoid]];
        [rb setPoiData:nil];
        [rb setBackIdentifier:@"MapDownViewController"];
        rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:rb animated:YES];
    }else if(([backIdentifier isEqualToString:@"MapBoxViewController"])){
        UIStoryboard *sb = [ViewController getStoryboard];
        RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
        rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:rb animated:YES];
        [self presentModalViewController:rb animated:YES];
        [rb setSelectedIndex:1];//地图
        [rb.btn1 setSelected:NO];
        [rb.btn2 setSelected:YES];
        
    }
    else if(![backIdentifier isEqualToString:@"DescriptionViewController"]){
        
        UIStoryboard *sb = [ViewController getStoryboard];
        RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
        rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
       // [self.navigationController pushViewController:rb animated:YES];
        [self presentModalViewController:rb animated:YES];
        [rb setSelectedIndex:1];
        [rb.btn1 setSelected:NO];
        [rb.btn2 setSelected:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    }
    @catch (NSException *exception) {
        NSLog(@"exception=%@",[exception debugDescription]);
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)viewDidUnload
{
    [self setBackIdentifier:nil];
    [self setSpeedText:nil];
    [self setCurrentSize:nil];
    [self setAllSize:nil];
    [self setDownpre:nil];
    [self setDownfillImage:nil];
    [self setStartButton:nil];
    [self setDownImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)downButton:(id)sender {
    TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];

    if([sender tag]!=1)
    {
        NSLog(@"创建请求2");
        //初始化Documents路径
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/iap.zip"];
        NSString *tempPath = [path stringByAppendingPathComponent:@"osm_hkmbtiles.temp"];
        NSURL *url = [NSURL URLWithString:downURL];
        
        [tdNetworkQueue addDownloadRequestInQueue:url withTempPath:tempPath withDownloadPath:downloadPath withView:self];
        
        UIImage * pauseImage= [UIImage imageNamed:@"downpause"];
        
        [startButton setImage:pauseImage forState:UIControlStateNormal];
        [sender setTag:1];
    }else{
        UIImage * downstart= [UIImage imageNamed:@"downstart"];
        [startButton setImage:downstart forState:UIControlStateNormal];
        [sender setTag:0];
        [tdNetworkQueue pauseDownload:downURL];
    }
}
-(void)finished{
    UIImage * downstart= [UIImage imageNamed:@"downstart"];
    [startButton setImage:downstart forState:UIControlStateNormal];
    [startButton setTag:0];
    [MapDownViewController unzipDownDB:YES];

}

+(void)unzipDownDB:(Boolean)isReTry{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/iap.zip"];
    NSFileManager *fileManager=[NSFileManager defaultManager];

    if (([fileManager fileExistsAtPath:downloadPath])){//如果不存在 强制拷user.db
        ZipArchive* zip = [[ZipArchive alloc] init];
        
        if([zip UnzipOpenFile:downloadPath])
        {
            BOOL ret = [zip UnzipFileTo:path overWrite:YES];
            if( NO==ret)
            {
                if(isReTry){
                    [MapDownViewController unzipDownDB:NO];
                }else{
                    NSString *tempPath = [path stringByAppendingPathComponent:@"osm_hkmbtiles.temp"];
                    NSString *tempPath1 = [path stringByAppendingPathComponent:@"osm_hk.mbtiles"];
                    NSString *tempPath2 = [path stringByAppendingPathComponent:@"transfer.db"];
                    [fileManager removeItemAtPath:tempPath1 error:nil];
                    [fileManager removeItemAtPath:tempPath2 error:nil];
                    [fileManager removeItemAtPath:downloadPath error:nil];
                    [fileManager removeItemAtPath:tempPath error:nil];
                }
                NSLog(@"zip errrrrr====");
            }
            
            [zip UnzipCloseFile];
        }
    }
}
@end
