//
//  ViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-18.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "ViewController.h"
#import "RMTileSource.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "DescriptionJianJieViewController.h"
@interface ViewController ()

@end
//static NSString *VERSION=@"1.22";//如果有 db更新 需要更新此版本，来保证拷贝新数据库
@implementation ViewController
@synthesize homeView;
//@synthesize entries;

NSArray *pcbs;
//NSDictionary *pcbsnavtions;
NSArray *navitons;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // NSLog(@"tabBarController.selectedIndex=%d",self.tabBarController.selectedIndex);
   // NSLog([self.tabBarController.p debugDescription]);
}
- (void)viewDidLoad
{
    if(locationManager==nil){
        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10.0f;
    }
    //启动位置更新
    [locationManager startUpdatingLocation];

    
  //  [self performSelectorInBackground:@selector(setDB) withObject:nil];//移动数据库文件

    int starTop=180;
    int bheight=45;
    int offh =5;
    
    UIImageView *homeTileView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hometitle"]];
    
    [homeTileView setFrame:CGRectMake(10, 30, homeTileView.image.size.width, homeTileView.image.size.height)];
    
    
    [self.view addSubview:homeTileView];
    
   // hometitle
    
    pcb1 = [PCustButtonController alloc];
    pcb2= [PCustButtonController alloc];
    pcb3= [PCustButtonController alloc];
    pcb4= [PCustButtonController alloc];
    
    NSString *city_subway=NSLocalizedStringFromTable(@"city_subway", @"InfoPlist",nil);
    NSString *city_wiki=NSLocalizedStringFromTable(@"city_wiki", @"InfoPlist",nil);
    NSString *my_wiki=NSLocalizedStringFromTable(@"my_wiki", @"InfoPlist",nil);
    NSString *hot_poi=NSLocalizedStringFromTable(@"hot_poi", @"InfoPlist",nil);
   // [[NSString alloc] initWithFormat:@"",]
    
    NSArray *objValue = [NSArray arrayWithObjects:hot_poi,city_subway,city_wiki,my_wiki , nil];
    NSArray *objKey =[NSArray arrayWithObjects:@"homeiconpoi",@"homeiconsubway",@"homeiconcity",@"homeiconmy", nil];
    NSArray *widthValue = [NSArray arrayWithObjects:[NSNumber numberWithInt:180],[NSNumber numberWithInt:160],[NSNumber numberWithInt:200],[NSNumber numberWithInt:190] , nil];
    pcbs=[NSArray arrayWithObjects:pcb1,pcb2,pcb3,pcb4,nil];
  //  navitons=[NSArray arrayWithObjects:@"HotPoiHome",@"SubWay",@"CityInt",@"MyHome", nil];

       
    for(int i=0;i<pcbs.count;i++){
        PCustButtonController *pcb = [pcbs objectAtIndex:i];
        pcb =[pcb initWithFrame:CGRectMake(0, starTop,[[widthValue objectAtIndex:i] floatValue], bheight)typeImageName:[objKey objectAtIndex:i] textString:[objValue objectAtIndex:i]];
        
       // [pcb.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //
        starTop+=bheight+offh;
        //
        [homeView addSubview:pcb];
        
    }
    
    [pcb1.button addTarget:self action:@selector(pcb1buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [pcb2.button addTarget:self action:@selector(pcb2buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [pcb3.button addTarget:self action:@selector(pcb3buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [pcb4.button addTarget:self action:@selector(pcb4buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [super viewDidLoad];

}
- (void)pcb1buttonClicked{
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb = [sb instantiateViewControllerWithIdentifier:@"HotPoiHome"];
    rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (void)pcb2buttonClicked{
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWay"];
    rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];

}
- (void)pcb3buttonClicked{
//    UIStoryboard *sb = [ViewController getStoryboard];
//    ViewController *rb = [sb instantiateViewControllerWithIdentifier:@"CityInt"];
//    rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
//    [self.navigationController pushViewController:rb animated:YES];
//    [self presentModalViewController:rb animated:YES];
//    
//    
    UIStoryboard *sb = [ViewController getStoryboard];
    DescriptionJianJieViewController *rb = [sb instantiateViewControllerWithIdentifier:@"DescriptionJianjie"];

    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];

}
- (void)pcb4buttonClicked{
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb = [sb instantiateViewControllerWithIdentifier:@"MyHome"];
    rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];

}


//- (void)buttonClicked:(UIButton *)sender
//{
//    for(int i=0;i<pcbs.count;i++){
//        if(((PCustButtonController *)[pcbs objectAtIndex:i]).button ==sender){
//            NSString *st=((NSString *)[navitons objectAtIndex:i]);
//            
//            UIStoryboard *sb = [ViewController getStoryboard];
//            ViewController *rb = [sb instantiateViewControllerWithIdentifier:st];
//            
//            rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
//            
//            [self.navigationController pushViewController:rb animated:YES];
//            [self presentModalViewController:rb animated:YES];
//            break;
//        }
//    }
//}

//-(void)setDB{
//    [ViewController initializeDB];
//}
+(void) initializeDB{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *userDirectory= [NSHomeDirectory()
                              stringByAppendingPathComponent:@"Documents/user.db"];
    if (!([fileManager fileExistsAtPath:userDirectory])){//如果不存在 强制拷user.db
        NSURL * dburl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"user" ofType:@"db"]];
        NSData *userdbData= [NSData dataWithContentsOfFile:[dburl path]];
        [fileManager createFileAtPath:userDirectory contents:userdbData attributes:nil];
    }
}
+(UIStoryboard *) getStoryboard{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    return sb;
}
+(FMDatabase *)getDataBase{
    NSURL * dburl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"poi" ofType:@"db"]];

    FMDatabase *db = [FMDatabase databaseWithPath:[dburl path]];
    
    return db;
}
+(FMDatabase *)getTransferDataBase{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSURL *documentsDictoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *dburl = [documentsDictoryURL URLByAppendingPathComponent:@"transfer.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:[dburl path]];
    return db;
}
+(FMDatabase *)getUserDataBase{
    //    NSURL * dburl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"poi" ofType:@"db"]];
    [ViewController initializeDB];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSURL *documentsDictoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *dburl = [documentsDictoryURL URLByAppendingPathComponent:@"user.db"];
    
    // NSString *path = [[NSString alloc] initWithFormat:@"%@/poi.db",[[NSBundle mainBundle] bundlePath]];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[dburl path]];
   // [db setKey:@"www.zijiyou.com"];
    return db;
}


+(FMResultSet *)getDataBase:(NSString *)sql db:(FMDatabase *)db{
    FMResultSet *resultSet=nil;
    if ([db open]) {
        resultSet = [db executeQuery:sql];
    }
    return resultSet;
}

+(void)setPoiArray:(FMResultSet *)resultSet isNeedDist:(bool)isNeedDist coord:(CLLocationCoordinate2D) clocation setEntries:(NSMutableArray *)entries setAllData:(NSMutableArray *)allData{
    while ([resultSet next]) {
        
//        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *name =[NSDataDES getContentByHexAndDes:[resultSet stringForColumn:@"name"] key:deskey] ;
        if(name==nil){
            continue;
        }

        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *address = [resultSet stringForColumn:@"address"];
        NSData *img = [resultSet dataForColumn:@"image"];
        CLLocationCoordinate2D coord;
        coord.latitude =  [resultSet doubleForColumn:@"latitude"];
        coord.longitude =  [resultSet doubleForColumn:@"longitude"];
 
        if(isNeedDist){
            double distance = [MyMapBoxView getDistanceLatA:coord.latitude lngA:coord.longitude latB:clocation.latitude lngB:clocation.longitude];
            [resultDirs setObject:[[NSNumber alloc] initWithDouble:distance] forKey:@"distance"];
        }
        //  NSLog(@"distance===%.2f",distance);
        NSString * category=[resultSet stringForColumn:@"category"];
        NSString *opentime = [resultSet stringForColumn:@"opentime"];
        NSString *telephone = [resultSet stringForColumn:@"telephone"];
        NSString *description = [resultSet stringForColumn:@"description"];
        NSString *poiid = [resultSet stringForColumn:@"poiid"];
        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
        NSString *subway = [resultSet stringForColumn:@"subway"];
        NSString *line = [resultSet stringForColumn:@"line"];


        [resultDirs setObject: [NSNumber numberWithDouble:(coord.latitude)] forKey:@"latitude"];
        [resultDirs setObject: [NSNumber numberWithDouble:(coord.longitude)] forKey:@"longitude"];
        [resultDirs setObject:poiid forKey:@"poiid"];
        [resultDirs setObject:subway forKey:@"subway"];
        if(address!=nil){
            [resultDirs setObject:address forKey:@"address"];
        }
        if(opentime!=nil){
            [resultDirs setObject:opentime forKey:@"opentime"];
        }
        if(telephone!=nil){
            [resultDirs setObject:telephone forKey:@"telephone"];
        }
        if(description!=nil){
            [resultDirs setObject:description forKey:@"description"];
        }
        if(line!=nil){
            [resultDirs setObject:line forKey:@"line"];
        }
        if(img!=nil){
            [resultDirs setObject:img forKey:@"image"];
        }
        [resultDirs setObject:name forKey:@"name"];
        [resultDirs setObject:category forKey:@"category"];
        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
        
        if(allData!=nil){
            [allData addObject:resultDirs];
        }
        if(entries!=nil){
            [entries addObject:[resultDirs copy]];
        }
        
        
        // NSLog(name);
    }
   
}
+(void)getAllSubwayDic:(NSMutableDictionary *)entriesDic{
    NSMutableArray *entries = [[NSMutableArray alloc]init];
    [ViewController getAllSubway:entries];
    for (NSMutableDictionary *resultDirs in entries) {
        NSString *lineid = [resultDirs objectForKey:@"lineid"];
        [entriesDic setObject:resultDirs forKey:lineid];
    }
}
+(void)getAllSubway:(NSMutableArray *)entries{
    NSString *sql =@"SELECT * FROM subway order by lineid";
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//


    while ([resultSet next]) {
        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *lineid = [resultSet stringForColumn:@"lineid"];
        NSString *linename = [resultSet stringForColumn:@"linename"];
        NSString *color = [resultSet stringForColumn:@"color"];
        NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
        
        [resultDirs setObject:linename forKey:@"linename"];
        [resultDirs setObject:color forKey:@"color"];
        [resultDirs setObject:stationlist forKey:@"stationlist"];
        [resultDirs setObject:lineid forKey:@"lineid"];
        [entries addObject:resultDirs];
    }
    [resultSet close];
    [db close];
}



- (void)viewDidUnload
{
    homeView=nil;
    pcb1=nil;
    pcb2=nil;
    pcb3=nil;
    pcb4=nil;
    homeView=nil;
    pcbs=nil;
    navitons=nil;
    [locationManager stopUpdatingLocation];
    locationManager=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}
- (IBAction)btnPressHide:(id)sender {
  //  [self.tabBarController hideNewTabBar];
}

- (IBAction)btnPressShow:(id)sender {
   // [self.tabBarController showNewTabBar];
}


//-(void)myThreadMainMethod:(id)sender
//{
//    NSString *sql =@"SELECT * FROM poi order by rank desc";// WHERE category='attraction'
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    CLLocationCoordinate2D coord;
//    [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];
//    [resultSet close];
//    [db close];
//}



+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//显示进度滚轮指示器
+(void)showWaiting:(UIView *)parent {
    
    int width = 32, height = 32;
    
    CGRect frame = CGRectMake(100, 200, 110, 70) ;//[parent frame]; //[[UIScreen mainScreen] applicationFrame];
    int x = frame.size.width;
    int y = frame.size.height;
    
    frame = CGRectMake((x - width) / 2, (y - height) / 2, width, height);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    frame = CGRectMake((x - 70)/2, (y - height) / 2 + height, 80, 20);
    UILabel *waitingLable = [[UILabel alloc] initWithFrame:frame];
    waitingLable.text = @"Loading...";
    waitingLable.textColor = [UIColor whiteColor];
    waitingLable.font = [UIFont systemFontOfSize:15];
    waitingLable.backgroundColor = [UIColor clearColor];
    
    frame =  CGRectMake(100, 200, 110, 70) ;//[parent frame];
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.backgroundColor = [UIColor grayColor];
    theView.alpha = 0.7;
    
    [theView addSubview:progressInd];
    [theView addSubview:waitingLable];
    
    
    [theView setTag:9999];
    [parent addSubview:theView];
}

//消除滚动轮指示器
+(void)hideWaiting:(UIView *)parent
{
    [[parent viewWithTag:9999] removeFromSuperview];
}

+(RMMapView *)getMap:(short)zoom center:(CLLocationCoordinate2D)center frame:(CGRect)frame{
    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:downMapFileName];
    NSURL *zstoreURL ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {//在线地图
        
        NSURL *documentsDictoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        zstoreURL = [documentsDictoryURL URLByAppendingPathComponent:@"osm.mbtiles"];
    }else{//离线地图
    }
    RMMapView *mapView;
    if(zstoreURL!=nil){
        RMMBTilesSource *tileSource = [[RMMBTilesSource alloc] initWithTileSetURL:zstoreURL];
        mapView = [[RMMapView alloc]initWithFrame:frame andTilesource:tileSource centerCoordinate:center zoomLevel:zoom maxZoomLevel:tileSource.maxZoom minZoomLevel:tileSource.minZoom backgroundImage:nil];
    }else{
        NSLog(@"online");
        RMOpenStreetMapSource *ontileSource = [[RMOpenStreetMapSource alloc] init];
        mapView = [[RMMapView alloc]initWithFrame:frame andTilesource:ontileSource centerCoordinate:center zoomLevel:zoom maxZoomLevel:ontileSource.maxZoom minZoomLevel:ontileSource.minZoom backgroundImage:nil];
    }
    return mapView;
}


+(void)getPoiBaseData:(NSString*)sql data:(NSMutableArray *)setData{
    FMDatabase *db= [ViewController getDataBase];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
    while ([resultSet next]) {
        NSString *name =[NSDataDES getContentByHexAndDes:[resultSet stringForColumn:@"name"] key:deskey] ;
        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
        if(name==nil){
            NSLog(@"解密失败 poimongoid=%@",poimongoid);
            continue;
        }
        // NSString *name =[resultSet stringForColumn:@"name"] ;
        // NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
        NSString *category = [resultSet stringForColumn:@"category"];
        NSData *img = [resultSet dataForColumn:@"image"];
        
        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        [resultDirs setObject:name forKey:@"name"];
        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
        [resultDirs setObject:category forKey:@"category"];
        if(img!=nil){
            [resultDirs setObject:img forKey:@"image"];
        }
        [setData addObject:resultDirs];
    }
    
    [resultSet close];
    [db close];
}



@end
