//
//  TransferSubWayViewController.h
//  自己游
//
//  Created by piaochunzhi on 12-10-1.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define SEARCHRANG 2000
#import <UIKit/UIKit.h>

@interface TransferSubWayViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D center;
    NSMutableDictionary *idSubDirs;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,retain) NSDictionary *poiData;
@end
