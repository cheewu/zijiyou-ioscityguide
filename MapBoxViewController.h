//
//  MapBoxViewController.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-19.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapViewDelegate.h"
#import "MyMapBoxView.h"
#import "FMDatabase.h"
#import "SMCalloutView.h"
#import "RMMapView.h"
#import "RMMBTilesSource.h"
#import "RMShape.h"
#import "RMAnnotation.h"
#import "RMPath.h"
#import "RMOpenStreetMapSource.h"
#import "RMUserLocation.h"
#import "PCustonTip.h"
#import "RMUserLocation.h"
#import "CustomRightMenuView.h"
#import "MapDownViewController.h"
#import "PCTOPUIview.h"

@interface MapBoxViewController : UIViewController<RMMapViewDelegate,CustomRightMenuClickProtocal>
{
    MyMapBoxView *mapView ;
    RMMarker *topPin;
    CustomRightMenuView *crm ;
    NSArray *categoryArray;
    NSURL *storeURL;
    PCTOPUIview *pctop;
  //  SMCalloutView *calloutView;
//    UIButton *location;
//    CLLocationManager *locationManager;
    RMAnnotation *anotationPOI;
   NSMutableArray* anotations;
}
@property (nonatomic,retain) NSMutableDictionary *poiData;
@property (strong, nonatomic) IBOutlet UIView *subMenuView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSString *detail;
@property(nonatomic,retain) MyMapBoxView *mapView;
@property (nonatomic, retain) NSMutableArray* entries;

- (void)callbackClick:(id)sender;
//@property(nonatomic,retain) UIButton *location;
//@property(nonatomic,retain) CLLocationManager *locationManager;
@end
