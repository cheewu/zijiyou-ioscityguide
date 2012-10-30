//
//  MyMapBoxView.h
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-27.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "RMMapView.h"
#import "RMMBTilesSource.h"
#import "RMShape.h"
#import "RMAnnotation.h"
#import "RMPath.h"
#import "RMOpenStreetMapSource.h"
#import "RMUserLocation.h"
#import "RMMarker.h"
#import "RMCircle.h"
#import "FMDatabase.h"

//typedef enum {
//    ONLINE = 0,
//    OFFLINE   = 1,
//} MapBoxType;

@interface MyMapBoxView : RMMapView{
    UIButton *location;
   // CLLocationManager *locationManager;
}
//@property(nonatomic,retain) UIButton *location;
//@property(nonatomic,retain) UIButton *offlineButton;
//typedef struct {
//	CLLocationCoordinate2D leftTop;
//	CLLocationCoordinate2D righttop;
//    CLLocationCoordinate2D leftbottom;
//    CLLocationCoordinate2D rightbottom;
//} CLLocationCoordinate2DBounds;

//@property(nonatomic,retain) CLLocationManager *locationManager;
-(id)initWithFrame:(CGRect)frame url:(NSURL *)path zoom:(short)zoom;
-(id)initWithFrame:(CGRect)frame url:(NSURL *)path zoom:(short)zoom coord:(CLLocationCoordinate2D) coord;
+(RMSphericalTrapezium) getBounds:(CLLocationCoordinate2D )xy distance:(double) distance;
+(double) getDistanceLatA:(double)latA
                     lngA:(double)lngA
                     latB:(double)latB
                     lngB:(double)lngB;
-(void) locationClick;
@end
