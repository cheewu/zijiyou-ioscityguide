//
//  DescriptionViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-10.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaseManager.h"
#import "RMMapViewDelegate.h"
@interface DescriptionViewController : UIViewController<RMMapViewDelegate>{
    InAppPurchaseManager *iap;
     RMMapView *mapView;
}
@property (nonatomic,retain)  NSString *poimongoid;//页面跳转过来的参数
@property (nonatomic,retain)  NSMutableDictionary *poiData;//poi 数据如果没有就根据poimongoid 查询
//@property (nonatomic,retain) NSMutableDictionary *poiSubWayDatas;
@property (nonatomic,retain) NSMutableDictionary *idSubDirs;//需要的地铁数据集合
@property(nonatomic,retain) NSString *backIdentifier;//返回页面参数
//@property (strong, nonatomic) IBOutlet UIImageView *poiImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *poiName;
@property (strong, nonatomic) IBOutlet UIView *poiView;

@end
