//
//  MapDownViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-5.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
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
@property (weak, nonatomic) IBOutlet UILabel *downTitle;
-(void)finished;
@end
