//
//  SubWayHomeViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubWayHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *subWayImg;
@property (nonatomic, retain) NSMutableArray* entries;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *idSubDirs;
+(void)getSubWayForJson:(NSArray *)json jsonkey:(NSString*)key outDir:(NSMutableDictionary *)idSubDirs;//根据json 获得指定线路数据
+(void)getSubWayForSql:(NSString*)sql outDir:(NSMutableDictionary *)idSubDirs;
@end
