//
//  SubWayUIView.h
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 13-1-1.
//  Copyright (c) 2013年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SubWayHomeViewController.h"
#import "SubWayStationViewController.h"
#import "SubWayDrawViewController.h"
#import "StationUILabel.h"
@interface SubWayUIView : UIView{
     NSMutableDictionary *idSubDirs;//所有地铁数据
    //int offy;//高度
}
@property (nonatomic ,retain) NSString *stationlistjson;//josn数据
@property (nonatomic ,retain) NSString *color;
@property (nonatomic ,assign) int offy;//josn数据
@property (retain, nonatomic)  UIScrollView *scrollView;
@property (nonatomic, retain) SubWayDrawViewController *subWayDrawViewController;
@end
