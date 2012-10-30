//
//  CityIntViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-24.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailGonglueViewController.h"
@interface CityIntViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableDictionary *typeImages;
}
@property(nonatomic,retain)NSMutableArray *objValue;
@property (nonatomic, retain) NSMutableArray* entries;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
