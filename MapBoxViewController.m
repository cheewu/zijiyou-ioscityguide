//
//  MapBoxViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-19.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "MapBoxViewController.h"
#import "SubWayStationViewController.h"
#import "PayMapViewController.h"
//#define kNormalSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-s2effxa8.jsonp"] // see https://tiles.mapbox.com/justin/map/map-s2effxa8
//#define kRetinaSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-kswgei2n.jsonp"] // see https://tiles.mapbox.com/justin/map/map-kswgei2n
@implementation MapBoxViewController
//@synthesize location;
@synthesize subMenuView;
@synthesize mainView;
@synthesize mapView;
@synthesize entries;
@synthesize detail;//如果是详细页面地图
@synthesize poiData;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    if(entries==nil){
        entries =[[NSMutableArray alloc]init];
    }
    anotations=[[NSMutableArray alloc]init];
   // float mapheight=self.view.frame.size.height-44-48;
    BOOL isDetail=false;
    short zoom=13;
    
//    景点: attraction
//    餐厅: restaurant
//    购物: shoppingcenter
//    地铁: subway
//    火车: railway
//    机场：airport
//    维基： wikipedia
    NSString *button_select=NSLocalizedStringFromTable(@"button_select", @"InfoPlist",nil);
    
    if(![detail isEqualToString:@"DescriptionViewController"]){
        pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"地图" backTitle:nil righTitle:button_select];
 
        crm = [[CustomRightMenuView alloc]initWithFrame:CGRectMake(320, 0, 120, 480)];
        crm.delegate=self;
        crm.mainView = mainView;
        [crm setActionButton:pctop.rightButton];
        [subMenuView addSubview:crm];
        
    }else{//详细页面跳转过来
        pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"地图" backTitle:@"" righTitle:nil];
        [pctop.button addTarget:self action:@selector(clickback) forControlEvents:UIControlEventTouchUpInside];
      //  mapheight+=48;
        [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height+48)];
        isDetail=true;
        zoom =16;
    }
    [mainView addSubview: pctop];
    
    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:downMapFileName];
    BOOL isPurchased=[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"];//是否已经购买
     
   
    NSString *map_level=NSLocalizedStringFromTable(@"map_level", @"InfoPlist",nil);
    int mapzoom = [map_level intValue];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]&&isPurchased) {//如果有离线文件
        
        NSURL *documentsDictoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [documentsDictoryURL URLByAppendingPathComponent:@"osm.mbtiles"];
        
        mapView = [[MyMapBoxView alloc] initWithFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y+44, mainView.frame.size.width, mainView.frame.size.height) url:storeURL zoom:mapzoom];
        mapView.delegate =self;
        
        self.mapView.viewControllerPresentingAttribution = self;
        [mainView addSubview:mapView];
    }else{
        mapView = [[MyMapBoxView alloc] initWithFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y+44, mainView.frame.size.width, mainView.frame.size.height) url:nil zoom:mapzoom];
      
        mapView.delegate =self;
        
        self.mapView.viewControllerPresentingAttribution = self;
        [mainView addSubview:mapView];
        UIButton *offlineButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *downloadmap =[UIImage imageNamed:@"downloadmap"];
        [offlineButton setBackgroundImage:downloadmap forState:UIControlStateNormal];
        [offlineButton setImage:[UIImage imageNamed:@"downloadmaps"] forState:UIControlStateHighlighted];
        [offlineButton setFrame:CGRectMake(mainView.frame.size.width-100, mapView.frame.size.height-60,72, 37)];
      //  [offlineButton setShowsTouchWhenHighlighted:YES];
        [offlineButton addTarget:self action:@selector(offMapDownLoad) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:offlineButton];
    }
    if(poiData!=nil){
        CLLocationCoordinate2D _coord;
        _coord.latitude =  [[poiData objectForKey:@"latitude"] doubleValue];
        _coord.longitude = [[poiData objectForKey:@"longitude"] doubleValue];
        mapView.centerCoordinate = _coord;
        NSString *_name=[poiData objectForKey:@"name"] ;
        RMAnnotation *anotation = [[RMAnnotation alloc]initWithMapView:mapView coordinate:_coord andTitle:_name];
        
        [anotation setAnchorPoint:CGPointMake(0.5, 0.5)];
        anotation.userInfo = poiData;
        anotationPOI = anotation;
        [mapView addAnnotation:anotation];
        [mapView setCenterCoordinate:[anotationPOI coordinate]];
        [self performSelector:@selector(openTipPOI) withObject:nil afterDelay:0.5];
    }
    
   UIButton *location=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *locimg =[UIImage imageNamed:@"locationicon"];
    [location setImage:[UIImage imageNamed:@"locationiconnor"] forState:UIControlStateHighlighted];
    [location setBackgroundImage:locimg forState:UIControlStateNormal];
    [location addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
     [location setFrame:CGRectMake(20, mapView.frame.size.height-60,72, 37)];
    
   
   //  [location setShowsTouchWhenHighlighted:YES];
   
    [mainView addSubview:location];
   // NSLog(@"mapView.location.imageView.image.size.width==%f",mapView.location.imageView.image.size.width);
    
   // [self myThreadMainMethod];
    
   // if(![detail isEqualToString:@"DescriptionViewController"]){
        //读取数据
      //  [self performSelectorInBackground:@selector(myThreadMainMethod) withObject:nil];
 //   }else{
        
  //  }

    [super viewDidLoad];
    
   
    [self performSelectorInBackground:@selector(myThreadMainMethod) withObject:nil];
   // [self performSelector:@selector(myThreadMainMethod) withObject:nil afterDelay:1.0];
}
-(void)locationClick{
    [mapView locationClick];
}
-(void)openTipPOI{
    if(anotationPOI!=nil){
        [self openTip:anotationPOI];
        
        // [self performSelector:@selector(setZoomTip) withObject:nil afterDelay:1.0];
    }
}
//-(void)setZoomTip{
//     mapView.zoom=16;
//}

-(void)clickback{
    [self dismissModalViewControllerAnimated:YES];

//    UIStoryboard *sb = [ViewController getStoryboard];
//    DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
//    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
//    [self.navigationController pushViewController:rb animated:YES];
//    [self presentModalViewController:rb animated:YES];
}

- (void)offMapDownLoad
{
    //UIStoryboard *sb = [ViewController getStoryboard];
    BOOL isPurchased=[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"];//是否已经购买
    if(!isPurchased){//如果没有购买
        [self showPayMap];
    }else{//购买了
        UIStoryboard *sb = [ViewController getStoryboard];
        MapDownViewController *rb = [sb instantiateViewControllerWithIdentifier:@"MapDown"];
        rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        rb.backIdentifier = @"MapBoxViewController";
        
        [self.navigationController pushViewController:rb animated:YES];
        [self presentModalViewController:rb animated:YES];
    }
}

-(void)showPayMap{
    UIStoryboard *sb = [ViewController getStoryboard];
    PayMapViewController *rb = [sb instantiateViewControllerWithIdentifier:@"PayMap"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    rb.backID = @"MapBoxViewController";
    
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (void)viewDidUnload
{
    anotations=nil;
    anotationPOI =nil;
    mapView=nil;
    topPin=nil;
    entries=nil;
    crm=nil;
    categoryArray=nil;
    storeURL=nil;
    [self setPoiData:nil];
    [self setDetail:nil];
    [self setSubMenuView:nil];
    [self setMainView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)myThreadMainMethod
{
    for (id obj in crm.buttonDirects.keyEnumerator) {
        //  NSLog([obj debugDescription]);
        if(![obj isEqualToString:@"listall"] && ![obj isEqualToString:@"listwikipedia"] && ![obj isEqualToString:@"listop"] ){
            UIButton *butt=[crm.buttonDirects objectForKey:obj];
            [crm selectMenu:butt];
        }
    }

    [entries removeAllObjects];
    NSString *sql =@"SELECT name,poiid,poimongoid,category,longitude,latitude FROM poi";
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
    while ([resultSet next]) {
       
      //  NSString *name = [resultSet stringForColumn:@"name"];
        NSString *name =[NSDataDES getContentByHexAndDes:[resultSet stringForColumn:@"name"] key:deskey] ;
        if(name==nil){
            continue;
        }
         NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *poiid = [resultSet stringForColumn:@"poiid"];
        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
        NSString *category = [resultSet stringForColumn:@"category"];
        //NSData *img = [resultSet dataForColumn:@"image"];
        [resultDirs setObject:poiid forKey:@"poiid"];
        [resultDirs setObject:name forKey:@"name"];
        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
        [resultDirs setObject:category forKey:@"category"];
        CLLocationCoordinate2D coord;
        coord.latitude =  [resultSet doubleForColumn:@"latitude"];
        coord.longitude =  [resultSet doubleForColumn:@"longitude"];
        //        if(img!=nil){
        //            [resultDirs setObject:img forKey:@"image"];
        //        }
        [resultDirs setObject: [NSNumber numberWithDouble:(coord.latitude)] forKey:@"latitude"];
        [resultDirs setObject: [NSNumber numberWithDouble:(coord.longitude)] forKey:@"longitude"];
        [entries addObject:resultDirs];
        RMAnnotation *anotation = [[RMAnnotation alloc]initWithMapView:mapView coordinate:coord andTitle:name];
        
        [anotation setAnchorPoint:CGPointMake(0.5, 0.5)];
        anotation.userInfo = resultDirs;
        //   [mapView addAnnotation:anotation];
        [anotations addObject:anotation];
//        if(poiData!=nil && [poiid isEqualToString:[poiData objectForKey:@"poiid"]]){
//            anotationPOI = anotation;
//            //[mapView addAnnotation:anotation];
//            //[mapView setCenterCoordinate:[anotationPOI coordinate]];
//        }

    }
    [resultSet close];
    [db close];
    
//    NSString *sql =@"SELECT name,poiid,poimongoid,category,longitude,latitude FROM poi";
//
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    CLLocationCoordinate2D coord;
//    
//    [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];
//    [resultSet close];
//    [db close];
//    for (NSMutableDictionary *resultDirs in entries) {
//        NSString *name = [resultDirs objectForKey:@"name"];
//        NSString *poiid = [resultDirs objectForKey:@"poiid"];
//
//        CLLocationCoordinate2D coord;
//        coord.latitude =  [[resultDirs objectForKey:@"latitude"] doubleValue];
//        coord.longitude = [[resultDirs objectForKey:@"longitude"] doubleValue];
//              
//        RMAnnotation *anotation = [[RMAnnotation alloc]initWithMapView:mapView coordinate:coord andTitle:name];
//        
//        [anotation setAnchorPoint:CGPointMake(0.5, 0.5)];
//        anotation.userInfo = resultDirs;
//     //   [mapView addAnnotation:anotation];
//        [anotations addObject:anotation];
//        if(poiData!=nil && [poiid isEqualToString:[poiData objectForKey:@"poiid"]]){
//            anotationPOI = anotation;
//            //[mapView addAnnotation:anotation];
//            //[mapView setCenterCoordinate:[anotationPOI coordinate]];
//        }
//    }
//    for (id obj in crm.buttonDirects.keyEnumerator) {
//        //  NSLog([obj debugDescription]);
//        if(![obj isEqualToString:@"listall"] && ![obj isEqualToString:@"listwikipedia"] && ![obj isEqualToString:@"listop"] ){
//             UIButton *butt=[crm.buttonDirects objectForKey:obj];
//            [crm selectMenu:butt];
//        }
//    }
   // UIButton *butt=[crm.buttonDirects objectForKey:@"listattraction"];
 //   [butt setSelected:NO];
    //[crm selectMenu:butt];//设置景点为默认查找项目
  //  [self callbackClick:butt];
    
//    [self performSelector:@selector(openTipPOI) withObject:nil afterDelay:1.5];
    [self performSelectorInBackground:@selector(addMarks) withObject:self];
}
-(void)addMarks{
    NSArray *annotains =[anotations copy];//[mapView annotations];
    for (RMAnnotation *anotation in annotains) {
        NSString *category =[anotation.userInfo objectForKey:@"category"];
       
        if( ![category isEqualToString:@"wikipedia"]){
             [mapView addAnnotation:anotation];
        }
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    NSString * category=[[NSString alloc]initWithFormat:@"poi%@",[annotation.userInfo objectForKey:@"category"] ];
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:category]];
   // annotation.coordinate = annotation.location.coordinate;
   // marker.textBackgroundColor = [UIColor whiteColor];
   //marker.textForegroundColor = [UIColor greenColor];
   // [marker changeLabelUsingText:@"usted esta aca"];
//    [marker hideLabel];
   
   //marker.zPosition=-1;
  //  [marker changeLabelUsingText:@"usted esta aca"];

        
        
    return marker;
}
//点击在弹出窗口
- (void)tapOnLabelForAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map{
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb;

  // UIStoryboard *sb = [ViewController getStoryboard];
    //DescriptionViewController *rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
    // rb.title = [[self.entries objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *backIdentifier;
    
    if([detail isEqualToString:@"DescriptionViewController"]){
        backIdentifier=@"MapBoxDescriptionViewController";
    }else{
        backIdentifier=@"MapBoxViewController";
    }
//    [rb setPoimongoid:[annotation.userInfo objectForKey:@"poimongoid"]];
//    [rb setPoiData:nil];
    NSMutableDictionary * _poiData=annotation.userInfo;
    NSString *category = [_poiData objectForKey:@"category"];
    
    if([category isEqualToString:@"subway"]){//如果是地铁
        rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
        [((SubWayStationViewController *)rb) setPoimongoid:[_poiData objectForKey:@"poimongoid"]];
        [((SubWayStationViewController *)rb) setPoiData:nil];
        [((SubWayStationViewController *)rb) setIdSubDirs:nil];
        ((SubWayStationViewController *)rb).backIdentifier=backIdentifier;
    }else{
        rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        ((DescriptionViewController *)rb).backIdentifier=backIdentifier;
        [((DescriptionViewController *)rb) setPoimongoid:[_poiData objectForKey:@"poimongoid"]];
        [((DescriptionViewController *)rb) setPoiData:nil];
    }
    
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point{
   // [self disclosureTapped];
}
-(void)openTip:(RMAnnotation *)annotation
{
   
    if(topPin==nil || topPin!= annotation.layer){
        [topPin hideLabel];
        [topPin setLabel:nil];
        topPin= annotation.layer;
        
        NSString * name=[annotation.userInfo objectForKey:@"name"];
        
         NSLog(@"name====--%@",name);
        
        
        
               SMCalloutView *calloutView = [SMCalloutView new];
        // calloutView.delegate = self;
        calloutView.title = name;
       
        calloutView.calloutOffset = CGPointMake(20, 20);
        UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        calloutView.rightAccessoryView = disclosure;

        [calloutView presentCalloutFromRect:CGRectMake(-12, -15, 0, 0)
                                     inView:mapView
                          constrainedToView:mapView
                   permittedArrowDirections:SMCalloutArrowDirectionDown
                                   animated:YES];
        


        [topPin setLabel:calloutView];

        [calloutView setUserInteractionEnabled:YES];

    }

}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    mapView.centerCoordinate = annotation.coordinate;
    [self openTip:annotation];
}

- (void)popupCalloutView {
    // This does all the magic.
//    [calloutView presentCalloutFromRect:mapView.frame
//                                 inView:mapView
//                      constrainedToView:mapView
//               permittedArrowDirections:SMCalloutArrowDirectionDown
//                               animated:YES];
    
}

- (NSTimeInterval)calloutView:(SMCalloutView *)theCalloutView delayForRepositionWithSize:(CGSize)offset {
    
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)disclosureTapped {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap!" message:@"You tapped the disclosure button."
                                                   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Whatevs",nil];
    [alert show];
}

- (void)marsTapped {
    // again, we'll introduce an artifical delay to feel more like MKMapView for this demonstration.
   // [calloutView performSelector:@selector(dismissCalloutAnimated:) withObject:nil afterDelay:1.0/3.0];
}


- (void)callbackClick:(id)sender{
    
    [self performSelectorInBackground:@selector(backgroundClick:) withObject:sender];
    
}

-(void)backgroundClick:(id)sender{
    
    [mapView removeAllAnnotations];
    
    int indeBut =[sender tag];
    
    NSArray *annotains =[anotations copy];//[mapView annotations];
   // BOOL isHidden=![sender isSelected];//没被选中
 //   NSMutableDictionary *resultDirs=[entries objectAtIndex:indeBut-1];
   

    NSMutableDictionary *buttons = [crm buttonDirects];
    
    
    for (RMAnnotation *anotation in annotains) {
        NSString *category =[anotation.userInfo objectForKey:@"category"];
     //   NSLog(@"======------");
      //  NSLog(category);
    //    NSLog([resultDirs objectForKey:@"category"]);
        if(indeBut==1){
            //[anotation.layer setHidden:isHidden];
            if([sender isSelected]){
                [mapView addAnnotation:anotation];
            }
        }
        else {
            
            for (RightMenuButton *rightBut  in [buttons allValues]) {
                NSString * categoryNow=[rightBut categoryName];
                if([category isEqualToString:categoryNow]){
                    if(![[rightBut listSelectImage] isHidden]){
                     //   NSLog(@"categoryNow==%@",[anotation.userInfo objectForKey:@"name"]);
                        if([category isEqualToString:categoryNow]){
                          //  [anotation.layer setHidden:NO];
                            [mapView addAnnotation:anotation];
                        }
                    }
                    else{
                      //  [anotation.layer setHidden:YES];
                    }
                }
            }
        }
    }
}


@end
