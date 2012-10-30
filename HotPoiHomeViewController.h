//
//  HotPoiHomeViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define kCustomRowHeight  70.0
#define kCustomRowCount   7
#define kAppRowHeight    60
#import "HotPoiHomeViewController.h"
#import "RXCustomTabBar.h"
#import <UIKit/UIKit.h>
#import "MyMapBoxView.h"
#import "CustomRightMenuView.h"
#import "PCTOPUIview.h"

@interface HotPoiHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,CustomRightMenuClickProtocal>{
    CustomRightMenuView *crm ;
    NSArray *categoryArray;
    NSMutableArray* allData;//全部数据
    PCTOPUIview * pctop;
    bool isReadAllPoi;//延迟加载全部数据
}

@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray* entries;
//@property (nonatomic, retain) FMDatabase *db;
//@property (nonatomic, retain) FMResultSet* resultSet;
//@property (strong, nonatomic) IBOutlet UIView *hotPoiListView;
//@property (strong, nonatomic) IBOutlet UIView *hotPoiDetail;
//@property (strong, nonatomic) IBOutlet UIButton *detailBack;

@end
