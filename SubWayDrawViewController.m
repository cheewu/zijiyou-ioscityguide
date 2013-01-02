//
//  SubWayDrawViewController.m
//  zijiyou-ioscityguide
//
//  Created by piaochunzhi on 12-12-31.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "SubWayDrawViewController.h"
#import "SubWayHomeViewController.h"
#import "SubWayUIView.h"

@interface SubWayDrawViewController ()

@end

@implementation SubWayDrawViewController

@synthesize lineDictionary;
@synthesize scrollView;
@synthesize idSubDirs;//所有换乘地铁数据
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
    [super viewDidLoad];
    if(lineid!=nil ||[lineDictionary objectForKey:@"linename"]==nil){
        
        if(lineid==nil){
            lineid=[lineDictionary objectForKey:@"lineid"];
        }
        NSString *sqlLine=[[NSString alloc]initWithFormat:@"SELECT * FROM subway where lineid ='%@'", lineid];
        //NSLog(@"sqlLine==%@",sqlLine);

        FMDatabase *db= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sqlLine db:db];//
        
        while ([resultSet next]) {
            NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
            NSString *_lineid = [resultSet stringForColumn:@"lineid"];
            NSString *linename = [resultSet stringForColumn:@"linename"];
            NSString *color = [resultSet stringForColumn:@"color"];
            NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
            NSString *subwaysystem = [resultSet stringForColumn:@"subwaysystem"];
            
            [resultDirs setObject:subwaysystem forKey:@"subwaysystem"];
            [resultDirs setObject:linename forKey:@"linename"];
            [resultDirs setObject:color forKey:@"color"];
            [resultDirs setObject:stationlist forKey:@"stationlist"];
            [resultDirs setObject:_lineid forKey:@"lineid"];
            lineDictionary= resultDirs;
        }
        [resultSet close];
        [db close];
    }
    
    NSString *subTitle = [lineDictionary objectForKey:@"linename"];
    NSString *subwaysystem = [lineDictionary objectForKey:@"subwaysystem"];
    
    
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:[[NSString alloc] initWithFormat:@"%@ %@",subwaysystem,subTitle] backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    
    double offy=5000;
    if(scrollView==nil){
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
    }
//    SubWayUIView *subwayView =[[SubWayUIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
     SubWayUIView *subwayView =[[SubWayUIView alloc]initWithFrame:CGRectMake(0, 0, 320, offy)];
    
    [scrollView addSubview:subwayView];
    [self.view addSubview: scrollView];
    
    [subwayView setBackgroundColor:[UIColor whiteColor]];

    
    NSString *stationlistjson =[lineDictionary objectForKey:@"stationlist"];
    [subwayView setStationlistjson:stationlistjson];
    [subwayView setNeedsDisplay];
    // NSLog(@"stationlistjson==------------=====%@",stationlistjson);
    // }
   
    
    
    
    [scrollView setContentSize:CGSizeMake(320, offy)];
}
-(void)clickBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end