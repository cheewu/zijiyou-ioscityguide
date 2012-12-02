//
//  DescriptionJianJieViewController.h
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 12-12-1.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
@interface DescriptionJianJieViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate>{
    NSInteger _currentSection;
    NSInteger _currentRow;
}
@property (nonatomic,retain)  NSString *textDate;
@property (nonatomic,retain)  NSString *textTitle;

@property(nonatomic, retain) NSMutableArray* headViewArray;
@property(nonatomic, retain) UITableView* tableView;
@end
