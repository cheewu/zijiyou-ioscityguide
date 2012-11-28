//
//  MyMapBoxView.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-27.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "MyMapBoxView.h"

#define int M_PI=3.14159265358979323846264338327950288
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))//弧度转角度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)//角度转弧度
@implementation MyMapBoxView
//@synthesize location;
//@synthesize offlineButton;
-(id)initWithFrame:(CGRect)frame url:(NSURL *)path zoom:(short)zoom{
    CLLocationCoordinate2D coord;
//    coord.longitude = 114.15;
//    coord.latitude = 22.28;
    
    NSString *map_center=NSLocalizedStringFromTable(@"map_center", @"InfoPlist",nil);
    NSArray *centerArray= [map_center componentsSeparatedByString:@","];
    
    coord.longitude =  [(NSString *)[centerArray objectAtIndex:0] doubleValue];
    coord.latitude =   [(NSString *)[centerArray objectAtIndex:1] doubleValue];
    
    
    return [self initWithFrame:frame url:path zoom:zoom coord:coord];
}

-(id)initWithFrame:(CGRect)frame url:(NSURL *)path zoom:(short)zoom coord:(CLLocationCoordinate2D) coord{
   // self = [super initWithFrame:frame];
    
    if (self) {
              // self.zoom = zoom;
        if(path!=nil){
            RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetURL:path];
            //  self = [super initWithFrame:frame andTilesource:offlineSource];
            self = [super initWithFrame:frame andTilesource:offlineSource centerCoordinate:coord zoomLevel:zoom maxZoomLevel:offlineSource.maxZoom minZoomLevel:offlineSource.minZoom backgroundImage:nil];
        }else{
            NSLog(@"online");
            NSString *map_max_level=NSLocalizedStringFromTable(@"map_max_level", @"InfoPlist",nil);
            float maxzoom = [map_max_level floatValue];
            
            RMOpenStreetMapSource *onlineSource = [[RMOpenStreetMapSource alloc] init];
            //                self = [super initWithFrame:frame andTilesource:onlineSource];
            self = [super initWithFrame:frame andTilesource:onlineSource centerCoordinate:coord zoomLevel:zoom maxZoomLevel:maxzoom minZoomLevel:onlineSource.minZoom backgroundImage:nil];
        }
        //self.centerCoordinate= coord;
       // self.backgroundColor = [UIColor darkGrayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.adjustTilesForRetinaDisplay = YES;

//        location=[UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *locimg =[UIImage imageNamed:@"locationicon"];
//        [location setImage:[UIImage imageNamed:@"locationiconnor"] forState:UIControlStateHighlighted];
//        [location setBackgroundImage:locimg forState:UIControlStateNormal];
//        [location addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        offlineButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *downloadmap =[UIImage imageNamed:@"downloadmap"];
//        [offlineButton setBackgroundImage:downloadmap forState:UIControlStateNormal];
//        [offlineButton setImage:[UIImage imageNamed:@"downloadmaps"] forState:UIControlStateHighlighted];
    }
    return self;
}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        RMOpenStreetMapSource *onlineSource = [[RMOpenStreetMapSource alloc] init];
//        //initWithReferenceURL:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaSourceURL : kNormalSourceURL)];
//        //mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 43, 320, 416) andTilesource:onlineSource];
//        self.zoom = 12;
//        self.centerCoordinate= CLLocationCoordinate2DMake(22.28, 114.15);
//        self.backgroundColor = [UIColor darkGrayColor];
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//       // self.viewControllerPresentingAttribution = self;
//        
//        
        
////        RMShape *route = [[RMShape alloc] initWithView:mapView];
////        [route setLineWidth:10.0];
////        [route setLineColor:[UIColor colorWithRed:1.f green:0.f blue:0.f alpha:1.f]];
////        [route moveToCoordinate:CLLocationCoordinate2DMake(22.28, 114.15)];
////        [route addLineToCoordinate:CLLocationCoordinate2DMake(22.30, 114.18)];
////        [route addLineToCoordinate:CLLocationCoordinate2DMake(22.27, 114.20)];
////        
////        //   [route closePath];
////        
////        RMShape *route1 = [[RMShape alloc] initWithView:mapView];
////        [route1 setLineWidth:15.0];
////        [route1 setLineColor:[UIColor colorWithRed:1.f green:1.f blue:0.f alpha:1.f]];
////        [route1 moveToCoordinate:CLLocationCoordinate2DMake(22.289, 114.15)];
////        [route1 addLineToCoordinate:CLLocationCoordinate2DMake(22.33, 114.198)];
////        [route1 addLineToCoordinate:CLLocationCoordinate2DMake(22.28, 114.290)];
//        
//        
//        
////        RMAnnotation *Anotation = [[RMAnnotation alloc]initWithMapView:mapView coordinate:CLLocationCoordinate2DMake(22.28, 114.15) andTitle:@""];
////        [Anotation setLayer:route];
////        // [Anotation setLayer:route1];
////        
////        RMAnnotation *Anotation1 = [[RMAnnotation alloc]initWithMapView:mapView coordinate:CLLocationCoordinate2DMake(22.28, 114.15) andTitle:@""];
////        [Anotation1 setLayer:route1];
//        
//        // [mapView addAnnotation:Anotation];
//        // [mapView addAnnotation:Anotation1];
//        
////        [self.view addSubview:mapView];
//        
//        location=[UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *locimg =[UIImage imageNamed:@"locationiconnor"];
//        [location setBackgroundImage:locimg forState:UIControlStateNormal];
//        [location setBackgroundImage:[UIImage imageNamed:@"locationicon"] forState:UIControlStateSelected];
//        [location setFrame:CGRectMake(10, self.frame.size.height-locimg.size.height-20, locimg.size.width, locimg.size.height)];
//        [location addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:location];
//    }
//    return self;
//}
-(void) locationClick
{
  //  self.showsUserLocation=YES;
    CLLocationCoordinate2D usl =[self.userLocation coordinate];

    if(usl.latitude){
      self.centerCoordinate=usl;
    }
    
    isSetCenter=NO;
    [self setShowsUserLocation:YES];
      //  [self bringSubviewToFront:<#(UIView *)#>];

//    if(locationManager==nil){
//        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
//        locationManager.delegate=self;
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        locationManager.distanceFilter=10.0f;
//        self.showsUserLocation=YES;
//        [self setShowsUserLocation:YES];
//    }
//    //启动位置更新
//    [locationManager startUpdatingLocation];
}
bool isSetCenter=NO;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [super locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
    if(!isSetCenter){
        self.centerCoordinate= newLocation.coordinate;
        isSetCenter=YES;
    }
         //self.userTrackingMode = RMUserTrackingModeNone;
    
//    if(newLocation.horizontalAccuracy>=0 ){
//       // self.centerCoordinate= newLocation.coordinate;
//        // [mapView locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
//      //  self.showsUserLocation=NO;
//        // mapView userLocation = [[RMUserLocation alloc] initWithMapView:mapView coordinate:newLocation.coordinate andTitle:@""];
//        RMUserLocation *rmu =[[RMUserLocation alloc]initWithMapView:self coordinate:newLocation.coordinate andTitle:@""];
//        rmu.userInfo =@"location";
//       
//        [self addAnnotation:rmu];
//
//        [locationManager stopUpdatingLocation];
//        locationManager=nil;
//    }
    
}



static double EARTH_RADIUS = 6378.137;
+(double)rad:(double) d{
    // NSLog(@"ddddd= %f ",d);
    return d * 3.141592654 / 180.0;
}

+(RMSphericalTrapezium) getBounds:(CLLocationCoordinate2D )xy distance:(double) distance{
    //[NSNumber numberWithDouble
   // NSLog(@"lat=%d ",lat);
    NSLog(@"distance= %f ",distance);

    
    double degreeRadius = distance / 110000.0; // (5000m / 110km per degree latitude)
    
    //CLLocationCoordinate2D centerCoordinate = [((RMMapBoxSource *)self.mapView.tileSource) centerCoordinate];
    NSLog(@"xy.latitude=%f xy.longitude==%f",xy.latitude ,xy.longitude);
    RMSphericalTrapezium zoomBounds = {
        .southWest = {
            .latitude  = xy.latitude - degreeRadius,
            .longitude = xy.longitude - degreeRadius
        },
        .northEast = {
            .latitude  =xy.latitude  + degreeRadius,
            .longitude = xy.longitude + degreeRadius
        }
    };
    return zoomBounds;
    
    
//    double dlng = 2 * asin(sin(distance / (2 * EARTH_RADIUS)) / cos(lat));
//    dlng = RADIANS_TO_DEGREES(dlng);//      # 弧度转换成角度
//    double dlat = distance / EARTH_RADIUS;
//    dlat = RADIANS_TO_DEGREES(dlat) ;//    # 弧度转换成角度
//    
//    //double lefttop=(lat + dlat, lng - dlng);
//   // double righttop=(lat + dlat, lng + dlng);
//   // double leftbottom=(lat - dlat, lng - dlng);
//  //  double rightbottom=(lat - dlat, lng + dlng);
//    CLLocationCoordinate2DBounds zoomBounds = {
//        .leftTop = {
//            .latitude  = lat + dlat,
//            .longitude = lng - dlng
//        },
//        .righttop = {
//            .latitude  = lat + dlat,
//            .longitude = lng + dlng
//        },
//        .leftbottom = {
//            .latitude  = lat - dlat,
//            .longitude = lng - dlng
//        },
//        .rightbottom = {
//            .latitude  = lat - dlat,
//            .longitude = lng + dlng
//        }
//    };
//    return zoomBounds;
}



/**
 *  获取两点经纬度地址的方法 返回的单位是米
 *
 *  @param  latA A点的纬度
 *  @param  lngA A点的经度
 *  @param  latB B点的纬度
 *  @param  lngB B点的经度
 *
 *  @return A，B连点的距离
 */
+(double) getDistanceLatA:(double)latA
                     lngA:(double)lngA
                     latB:(double)latB
                     lngB:(double)lngB{
    
    double radLat1 = [self rad:latA];
    double radLat2 = [self rad:latB];
    
    double a = radLat1 - radLat2;
    double b = [self rad:lngA] - [self rad:lngB];
    
    double s = 2 * sin(sqrt(pow(sin(a / 2), 2)
                            + cos(radLat1) * cos(radLat2)
                            * pow(sin(b / 2), 2)));
    s = s * EARTH_RADIUS;
    s = s*1000;
    double c = (round((s))/10)*10 ;
    c = floor(c);
    return c;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [super locationManager:manager didFailWithError:error];
    self.showsUserLocation=NO;
    
    isSetCenter=NO;
    //[locationManager stopUpdatingLocation];
    //locationManager=nil;
    NSString *errorType = (error.code == kCLErrorDenied) ? @"访问被拒绝,将无法找到您的位置！":@"获取位置信息失败！";
    //  @"Access Denied" : @"Unknown Error";
    //    if(error.code ==kCLErrorDenied){
    //
    //    }else if(error.code ==kCLErrorLocationUnknown){
    //
    //    }
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"定位失败！"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




@end
