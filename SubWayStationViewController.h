//
//  SubWayStationViewController.h
//  自己游
//
//  Created by piaochunzhi on 12-9-30.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubWayStationViewController : UIViewController<RMMapViewDelegate>{
    RMMapView *mapView;
    NSString *description;
    NSString *textTitle;
}
@property (nonatomic,retain)  NSString *poimongoid;//页面跳转过来的参数
@property (nonatomic ,retain) NSDictionary *poiData;//如果没有数据就查poimongoid
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *idSubDirs;//所有地铁数据
@property(nonatomic,retain) NSString *backIdentifier;//返回页面参数
@end
