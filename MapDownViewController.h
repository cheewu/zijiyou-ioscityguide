//
//  MapDownViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-5.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define downURL @"http://iapfile.b0.upaiyun.com/iap_hk.zip" //@"http://www.zijiyou.com/maps/osm_hk.mbtiles"
#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "TDNetworkQueue.h"


@interface MapDownViewController : UIViewController
- (IBAction)downButton:(id)sender;
@property(nonatomic,retain) PCTOPUIview * pctop;
@property (strong, nonatomic) IBOutlet UILabel *speedText;
@property (strong, nonatomic) IBOutlet UILabel *currentSize;
@property (strong, nonatomic) IBOutlet UILabel *allSize;
@property (strong, nonatomic) IBOutlet UILabel *downpre;
@property (strong, nonatomic) IBOutlet UIImageView *downfillImage;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property(nonatomic,retain) NSString *backIdentifier;
@property(nonatomic,retain) NSString *backpoimongoid;
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
-(void)finished;
@end
