//
//  HomeNearViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-28.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMapBoxView.h"
#import "CustomRightMenuView.h"
@interface HomeNearViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource,CustomRightMenuClickProtocal>
{
    CLLocationManager *locationManager;
    NSMutableArray* entries;
    CustomRightMenuView *crm ;
    NSArray *categoryArray;
    NSMutableArray* allData;
    PCTOPUIview * pctop;
}
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray* entries;
@property(nonatomic,retain) CLLocationManager *locationManager;
@end