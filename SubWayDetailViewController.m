//
//  SubWayDetailViewController.m  单条线路的详细页面
//  自己游
//
//  Created by piaochunzhi on 12-9-25.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "SubWayDetailViewController.h"
#import "StationView.h"
#import "SubWayStationViewController.h"
#import "SubWayHomeViewController.h"
#import "PCTOPUIview.h"

@interface SubWayDetailViewController ()

@end

@implementation SubWayDetailViewController
@synthesize line;
@synthesize scrollView;
@synthesize idSubDirs;
@synthesize lineid;
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
    NSLog(@"SubWayDetailViewController viewDidLoad");
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    if(lineid!=nil ||[line objectForKey:@"linename"]==nil){
        
        if(lineid==nil){
            lineid=[line objectForKey:@"lineid"];
        }
        NSString *sqlLine=[[NSString alloc]initWithFormat:@"SELECT * FROM subway where lineid ='%@'", lineid];
        NSLog(@"isBub==%@",sqlLine);
        
//             [SubWayHomeViewController getSubWayForSql:sqlLine outDir:idSubDirs];
//             line = [idSubDirs objectForKey:[[NSString alloc] initWithFormat:@"%@",lineid]];
//        
            FMDatabase *db= [ViewController getDataBase];
            FMResultSet *resultSet  =[ViewController getDataBase:sqlLine db:db];//

            while ([resultSet next]) {
                NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
                NSString *_lineid = [resultSet stringForColumn:@"lineid"];
                NSString *linename = [resultSet stringForColumn:@"linename"];
                NSString *color = [resultSet stringForColumn:@"color"];
                NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
                
                [resultDirs setObject:linename forKey:@"linename"];
                [resultDirs setObject:color forKey:@"color"];
                [resultDirs setObject:stationlist forKey:@"stationlist"];
                [resultDirs setObject:_lineid forKey:@"lineid"];
                line= resultDirs;
            }
            [resultSet close];
            [db close];
    }
    
    NSString *subTitle = [line objectForKey:@"linename"];

    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:subTitle backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    
//    [ { "poimongoid" : "505aea5e8ead0e191600001f", "stationOrder" : "0" , "stationMinute" : "0" , "transferLine" : [ 14]} , { "poimongoid" : "505aea5e8ead0e1916000020", "stationOrder" : "1" , "stationMinute" : "2" , "transferLine" : [ 14]} , { "poimongoid" : "505aea5e8ead0e1916000021", "stationOrder" : "2" , "stationMinute" : "3" , "transferLine" : [ 14]} , { "poimongoid" : "505aea5e8ead0e1916000036", "stationOrder" : "3" , "stationMinute" : "5" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e1916000002", "stationOrder" : "4" , "stationMinute" : "7" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e1916000037", "stationOrder" : "5" , "stationMinute" : "9" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e1916000038", "stationOrder" : "6" , "stationMinute" : "11" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e1916000039", "stationOrder" : "7" , "stationMinute" : "13" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003a", "stationOrder" : "8" , "stationMinute" : "15" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003b", "stationOrder" : "9" , "stationMinute" : "17" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003c", "stationOrder" : "10" , "stationMinute" : "19" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003d", "stationOrder" : "11" , "stationMinute" : "21" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003e", "stationOrder" : "12" , "stationMinute" : "23" , "transferLine" : [ ]} , { "poimongoid" : "505aea5e8ead0e191600003f", "stationOrder" : "13" , "stationMinute" : "25" , "transferLine" : [ 17]} , { "poimongoid" : "505aea5e8ead0e1916000040", "stationOrder" : "14" , "stationMinute" : "28" , "transferLine" : [ 17]}]
    NSString *stationlistjson =[line objectForKey:@"stationlist"];
    [super viewDidLoad];
    //if(stationlistjson){
        NSLog(@"stationlistjson==------------=====%@",stationlistjson);
   // }
    if(stationlistjson!=nil){
        NSData* jsonData = [stationlistjson dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];

        if(idSubDirs==nil){
            idSubDirs= [[NSMutableDictionary alloc] init];
        }else{
            [idSubDirs removeAllObjects];
        }
        
        [SubWayHomeViewController getSubWayForJson:json jsonkey:@"transferLine" outDir:idSubDirs];
   
    
        NSMutableString *poimongoids=[[NSMutableString alloc]initWithString:@""];
        
        NSMutableDictionary *poimogoidsDic= [[NSMutableDictionary alloc]init];//经过的线路
        for (NSDictionary *dic in json) {
            NSString* poimongoid =[NSDataDES getContentByHexAndDes:[dic objectForKey:@"poimongoid"] key:deskey];
            
            NSLog(@"poimongoidpoimongoidpoimongoidpoimongoidpoimongoid===%@",poimongoid);
            
            [poimongoids appendString:@"\""];
            [poimongoids appendString:poimongoid];
            [poimongoids appendString:@"\""];
            [poimongoids appendString:@","];
            
            NSArray*trline= [dic objectForKey:@"transferLine"];
            
            NSMutableArray *trlineArray = [[NSMutableArray alloc]init];
            for (id tr in trline) {
                NSLog(@"===%@",tr);
                [trlineArray addObject:[idSubDirs objectForKey:[[NSString alloc] initWithFormat:@"%@",tr]]];
            }
            [poimogoidsDic setObject:trlineArray forKey:poimongoid];
        }
            
        NSString *sqlpois;
        if(poimongoids.length>0){
            sqlpois=[poimongoids substringToIndex:poimongoids.length-1];
        }
        NSMutableArray *entries=[[NSMutableArray alloc]init];
        NSString *sql =[[NSString alloc]initWithFormat:@"SELECT * FROM poi where poimongoid in(%@)",sqlpois];// WHERE category='attraction'
        FMDatabase *db= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
        CLLocationCoordinate2D coord;
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];
        
        [resultSet close];
        [db close];
        int offy=15;
        int i=0;
        for (NSDictionary *poi in entries) {
            StationView *stationV = [[StationView alloc]initWithFrame:CGRectMake(15, offy, 290,45) transferStations: [poimogoidsDic objectForKey:[poi objectForKey:@"poimongoid"]] poiData:poi];
            //stations addObject:￼
           // [stationV.button setTag:i];
            //[stationV.button addTarget:self action:@selector(subStationClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subStationClick:)];
            [stationV addGestureRecognizer:gestureRecognizer];

            
            [scrollView addSubview:stationV];
            i++;
            offy+=50;
        }
        offy+=10;
        [scrollView setContentSize:CGSizeMake(320, offy)];
    }else{
        [self clickBack];
    }
	// Do any additional setup after loading the view.
}

-(void)subStationClick:(UITapGestureRecognizer *)sender{
  //  NSLog([[NSString alloc]initWithFormat:@"%d" ,[[sender superview] tag] ]);
   // NSLog([[sender view] debugDescription]);
    StationView *stationV =[sender view];
    
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayStationViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;;
    NSLog(@"[[stationV poiData] objectForKey:======%@",[[stationV poiData] objectForKey:@"poimongoid"]);
    [rb setPoimongoid:[[stationV poiData] objectForKey:@"poimongoid"]];
   // [rb setPoiData:[stationV poiData]];
   // [rb setIdSubDirs:[self idSubDirs]];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}

-(void)clickBack{
    [self dismissModalViewControllerAnimated:YES];

}
- (void)viewDidUnload
{
   // [self setLine:nil];
    [self setIdSubDirs:nil];
    [self setLine:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
