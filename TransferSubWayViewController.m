//
//  TransferSubWayViewController.m
//  自己游
//
//  Created by piaochunzhi on 12-10-1.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "TransferSubWayViewController.h"
#import "ListViewBox.h"
#import "SubWayStationViewController.h"
@interface TransferSubWayViewController ()

@end

@implementation TransferSubWayViewController
@synthesize poiData;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    center.latitude=-200;
    center.longitude=-200;
    
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    NSString *title=[poiData objectForKey:@"name"];

    
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:title backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    
    if(locationManager==nil){
        locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10.0f;
    }
    //启动位置更新
    [locationManager startUpdatingLocation];
        [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)clickBack{
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self clickBack];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation];
    locationManager=nil;
    NSString *errorType = (error.code == kCLErrorDenied) ? @"访问被拒绝,将无法找到您的位置！":@"获取位置信息失败！";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"定位失败！"
                          message:errorType
                          delegate:self
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    [locationManager setDelegate:nil];
    locationManager=nil;
    
    center = newLocation.coordinate;
    
    
    if(center.latitude==-200||center.longitude==-200){
        NSString *errorType =@"换乘的地铁站失败！";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"定位失败！"
                              message:errorType
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        //启动位置更新
        [locationManager startUpdatingLocation];
        [alert show];
        return;
    }

    FMDatabase *db= [ViewController getDataBase];
    FMDatabase *dbTransfer= [ViewController getTransferDataBase];
    NSMutableArray *sourcesentries =[[NSMutableArray alloc]init];
    [self getNearStation:center entries:sourcesentries db:db];
    
    CLLocationCoordinate2D destcenter;
    destcenter.latitude =  [[poiData objectForKey:@"latitude"] doubleValue];
    destcenter.longitude = [[poiData objectForKey:@"longitude"] doubleValue];
    
    NSMutableArray *destentries =[[NSMutableArray alloc]init];
    [self getNearStation:destcenter entries:destentries db:db];
    
    if([sourcesentries count]>0 &&[destentries count]>0){
        if(idSubDirs==nil|| [idSubDirs count]==0){
            idSubDirs = [[NSMutableDictionary alloc]init];
            [ViewController getAllSubwayDic:idSubDirs];
        }
               
        NSMutableDictionary *despoi = [destentries objectAtIndex:0];
        NSMutableDictionary *sourpoi = [sourcesentries objectAtIndex:0];
        NSString *destName=[despoi objectForKey:@"name"];
        NSString *sourceName=[sourpoi objectForKey:@"name"];
        
        NSString *destinationstation=[despoi objectForKey:@"poimongoid"];
        NSString *sourcestation=[sourpoi objectForKey:@"poimongoid"];
        NSMutableString *sqlds =[[NSMutableString alloc] initWithFormat:@"SELECT * FROM transfer "];
        [sqlds appendFormat: @"WHERE sourcestation='%@' and destinationstation='%@'",sourcestation,destinationstation];
        NSLog(@"sqlds===%@",sqlds);
        FMResultSet *resultSet  =[ViewController getDataBase:sqlds db:dbTransfer];
        int offy=44;
        while ([resultSet next]) {
            //NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
            //stationcount integer,stationlist
            NSString *stationcount = [resultSet stringForColumn:@"stationcount"];
            NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
            if([stationcount isEqualToString:@"0"]){
                NSString *errorType =@"就在附近不需要换乘地铁";
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"就在附近不需要换乘地铁"
                                      message:errorType
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            //[{ "p" : "505aea5e8ead0e1916000050" , "l" : 20}, { "p" : "505aea5e8ead0e191600004f" , "l" : 20}, { "p" : "505aea5e8ead0e191600004e" , "l" : 20}, { "p" : "505aea5e8ead0e191600004d" , "l" : 20}, { "p" : "505aea5e8ead0e191600004c" , "l" : 20}, { "p" : "505aea5e8ead0e1916000003" , "l" : 0}, { "p" : "505aea5e8ead0e1916000002" , "l" : 0}, { "p" : "505aea5e8ead0e1916000036" , "l" : 16}, { "p" : "505aea5e8ead0e1916000021" , "l" : 0}, { "p" : "505aea5e8ead0e1916000022" , "l" : 14}, { "p" : "505aea5e8ead0e1916000023" , "l" : 14}, { "p" : "505aea5e8ead0e1916000024" , "l" : 14}, { "p" : "505aea5e8ead0e1916000025" , "l" : 0}, { "p" : "505aea5e8ead0e191600002e" , "l" : 15}]
//            NSLog(@"stationcount===%@",stationcount);
//            NSLog(@"stationlist===%@",stationlist);
            
            UIView *topTextUIView=[[UIView alloc]initWithFrame:CGRectMake(0, offy, 320, 50)];
            //UIColor *textColor=[[UIColor alloc]initWithRed:95/255.0f green:87/255.0f blue:73/255.0f alpha:1.0f];
            UILabel *jiaotongLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 3, 320, 25)];
            [topTextUIView setBackgroundColor:[UIColor whiteColor]];
            jiaotongLabel.text = [[NSString alloc]initWithFormat:@"从 %@ 到 %@",sourceName,destName];
            [jiaotongLabel setFont:[UIFont fontWithName:@"STHeitiSC" size:18]];
            jiaotongLabel.textColor=[UIColor blackColor];
            [jiaotongLabel setBackgroundColor:[UIColor clearColor]];
            [topTextUIView addSubview:jiaotongLabel];
            
            UILabel *desLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 28, 320, 15)];
            desLabel.text = [[NSString alloc]initWithFormat:@"总共：%@站",stationcount];
            [desLabel setFont:[UIFont fontWithName:@"STHeitiSC" size:10]];
            desLabel.textColor= [[UIColor alloc]initWithRed:125/255.0f green:125/255.0f blue:125/255.0f alpha:1.0f];;
            [desLabel setBackgroundColor:[UIColor clearColor]];
            [topTextUIView addSubview:desLabel];
            
            offy+=topTextUIView.frame.size.height;
            UIImageView *iView =[[UIImageView alloc]initWithFrame:CGRectMake(10, offy, 320, 8)];
            UIImage * xuxianbg= [UIImage imageNamed:@"separator"];
            //平铺
           // iView.backgroundColor=[UIColor colorWithPatternImage:xuxianbg];
            [iView setImage:xuxianbg];
           
            NSData* jsonData = [stationlist dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            
            
            offy=8;
            for (NSMutableDictionary *line in json) {
                NSString *l =[[NSString alloc]initWithFormat:@"%@" ,[line objectForKey:@"l"] ];
                NSMutableDictionary *lineDic = [idSubDirs objectForKey:l];
                NSString *linename = [lineDic objectForKey:@"linename"];
                NSString *color = [lineDic objectForKey:@"color"];
                NSString *p =[line objectForKey:@"p"];
               // NSLog(@"TransferSubWayViewController p===%@",p);
               // NSString *sqlpoi = [[NSString alloc]initWithFormat:@"SELECT * FROM poi where poimongoid='%@'",[NSDataDES getContentByHexAndDes:p key:deskey]];
                NSString *sqlpoi = [[NSString alloc]initWithFormat:@"SELECT * FROM poi where poimongoid='%@'",p];
                
                NSLog(@"TransferSubWayViewController sqlpoi===%@",sqlpoi);
                FMResultSet *poiresultSet  =[ViewController getDataBase:sqlpoi db:db];
                NSMutableArray *entries=[[NSMutableArray alloc]init];
                [ViewController setPoiArray:poiresultSet isNeedDist:NO coord:center setEntries:entries setAllData:nil];
                NSMutableDictionary *_poiData;
                if([entries count]>0){
                    _poiData = [entries objectAtIndex:0];
                }
                [poiresultSet close];
                NSString *leftImage =nil;
                if([l isEqualToString:@"0"]){//换乘站
                    leftImage = @"subwaytransfer";
                }
                
                ListViewBox * list = [[ListViewBox alloc] initWithFrame:CGRectMake(15, offy, 285, 45) imgURL:@"arrows" textColor:color text:linename stationText:[_poiData objectForKey:@"name"] leftImage:leftImage];
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubWay:)];
                [list addGestureRecognizer:gestureRecognizer];
                [list setPoiData:_poiData];
                [list setLineId:l];
                [scrollView addSubview:list];
                offy+=50;
            }
            offy+=10;
            [scrollView setContentSize:CGSizeMake(320, offy)];
            [self.view addSubview:topTextUIView];
            [self.view addSubview:iView];

            break;
        }
        [resultSet close];
        
    }else{
        NSString *errorType =@"附近没有可以换乘的地铁站!";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"换乘查询失败！"
                              message:errorType
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    [db close];

}
-(void)tapSubWay:(id)sender{
   // NSString *lineid= [((ListViewBox *)[sender view]) lineId];
    NSDictionary *_poiData= [((ListViewBox *)[sender view]) poiData];
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayStationViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [rb setPoiData:_poiData];
    [rb setIdSubDirs:idSubDirs];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
-(void)getNearStation:(CLLocationCoordinate2D)centerLoc entries:(NSMutableArray *)entries db:(FMDatabase *)db{
    RMSphericalTrapezium bounds = [MyMapBoxView getBounds:centerLoc distance:SEARCHRANG];

    NSMutableString *sql =[[NSMutableString alloc] initWithFormat:@"SELECT * FROM poi where category='subway' "];
    [sql appendFormat: @"AND latitude > %f  AND latitude < %f",bounds.southWest.latitude,bounds.northEast.latitude];
    [sql appendFormat:@" AND longitude > %f  AND longitude < %f",bounds.southWest.longitude,bounds.northEast.longitude];
    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];
    //读取数据
    [ViewController setPoiArray:resultSet isNeedDist:YES coord:center setEntries:entries setAllData:nil];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [entries sortUsingDescriptors:sortDescriptors];
    [resultSet close];
}

- (void)viewDidUnload
{
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    
    idSubDirs =nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
@end
