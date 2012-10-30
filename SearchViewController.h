//
//  SearchViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-30.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define kCustomRowCount   7
#define kAppIconHeight    60
#import "PCRectButton.h"
#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>{
    PCRectButton *pcr;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (nonatomic, retain) NSMutableArray* entries;
@property (nonatomic, retain) NSMutableArray* filterEntries;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)hiddenKey:(id)sender;
@end
