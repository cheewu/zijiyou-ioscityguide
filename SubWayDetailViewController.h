//
//  SubWayDetailViewController.h
//  自己游
//
//  Created by piaochunzhi on 12-9-25.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubWayDetailViewController : UIViewController
@property (nonatomic, retain) NSString *lineid;
@property (nonatomic, retain) NSMutableDictionary *line;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *idSubDirs;//所有地铁数据
@end
