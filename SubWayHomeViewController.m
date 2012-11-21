//
//  SubWayHomeViewController.m
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#define kCustomRowCount   7
#define kAppIconHeight    60
#import "SubWayHomeViewController.h"
#import "ListViewBox.h"
#import "RXCustomTabBar.h"
#import "SubWayDetailViewController.h"
@interface SubWayHomeViewController ()

@end

@implementation SubWayHomeViewController
@synthesize subWayImg;
@synthesize scrollView;
@synthesize entries;
@synthesize idSubDirs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return @"地铁类型";
}



- (void)viewDidLoad
{
    NSString *city_subway=NSLocalizedStringFromTable(@"city_subway", @"InfoPlist",nil);
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:city_subway backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    if(idSubDirs==nil){
        idSubDirs=[[NSMutableDictionary alloc]init];
    }
    
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
   // subWayTabelView.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    subWayImg.image = [UIImage imageNamed:@"homesubway"];
    
    CALayer * layer = [subWayImg layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 6.0f;
//    //添加四个边阴影
//    layer.shadowColor = [UIColor blackColor].CGColor;
//    layer.shadowOffset = CGSizeMake(0, 0);
//    layer.shadowOpacity = 0.5;
//    layer.shadowRadius = 10.0;//给iamgeview添加阴影 < wbr > 和边框
    //添加两个边阴影
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(4, 4);
    layer.shadowOpacity = 0.5;
    layer.shadowRadius = 3.0;
    
  //  [scrollView setFrame:CGRectMake(0, 85, 320, 600)];
  //  [scrollView setContentSize:CGSizeMake(320, 1000)];
   // scrollView.frame.size.height=200;
   // scrollView.contentsize.height=300;
    //subWayTabelView.backgroundColor=[UIColor clearColor];
    
    UILabel *sulabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, 300, 50)];
    [sulabel setText:@"地铁"];
    [sulabel setBackgroundColor:[UIColor clearColor]];
    [sulabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
    [sulabel setTextColor:[UIColor darkGrayColor]];
    
    [scrollView addSubview:sulabel];

    int offy=230;
    entries=[[NSMutableArray alloc]init];
    [ViewController getAllSubway:entries];
    FMDatabase *db= [ViewController getDataBase];
    for (NSMutableDictionary *resultDirs in entries) {
      
    
//    NSString *sql =@"SELECT * FROM subway order by lineid";
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    while ([resultSet next]) {
//        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
        NSString *lineid = [resultDirs objectForKey:@"lineid"];
        NSString *linename = [resultDirs objectForKey:@"linename"];
        NSString *color = [resultDirs objectForKey:@"color"];
        NSString *stationlist = [resultDirs objectForKey:@"stationlist"];
        
        NSData* jsonData = [stationlist dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        NSString *stetName; //起点终点
        if ([json count]>=2) {
            NSString *stname;
            NSString *etname;

            NSString* spoimongoid =[[json objectAtIndex:0] objectForKey:@"poimongoid"];
            NSString* epoimongoid = [[json objectAtIndex:[json count]-1] objectForKey:@"poimongoid"];
            
            //[NSDataDES getContentByHexAndDes:spoimongoid key:deskey];
            
            NSString* ssql =[[NSString alloc]initWithFormat:@"SELECT name FROM poi where poimongoid ='%@'",[NSDataDES getContentByHexAndDes:spoimongoid key:deskey]];
            NSString* esql =[[NSString alloc]initWithFormat:@"SELECT name FROM poi where poimongoid ='%@'",[NSDataDES getContentByHexAndDes:epoimongoid key:deskey]];
            
           // NSLog(@"ssql====%@",ssql);
            
            FMResultSet *sresultSet  =[ViewController getDataBase:ssql db:db];//
            while ([sresultSet next]) {
                stname =[NSDataDES getContentByHexAndDes:[sresultSet stringForColumn:@"name"] key:deskey];
            }
            [sresultSet close];
            FMResultSet *eresultSet  =[ViewController getDataBase:esql db:db];//
            while ([eresultSet next]) {
                etname =[NSDataDES getContentByHexAndDes:[eresultSet stringForColumn:@"name"] key:deskey];
            }
            [eresultSet close];
            stetName=[[NSString alloc]initWithFormat:@"%@ - %@",stname,etname];
        }
        
//        [resultDirs setObject:linename forKey:@"linename"];
//        [resultDirs setObject:color forKey:@"color"];
//        [resultDirs setObject:stationlist forKey:@"stationlist"];
//         [resultDirs setObject:lineid forKey:@"lineid"];
//        [entries addObject:resultDirs];
        
        ListViewBox * list = [[ListViewBox alloc] initWithFrame:CGRectMake(15, offy, 285, 45) imgURL:@"arrows" textColor:color text:linename stationText:nil leftImage:nil sandetName:stetName];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubWay:)];
        [list addGestureRecognizer:gestureRecognizer];
        [list setLineId:lineid];
        [scrollView addSubview:list];
        
        [idSubDirs setObject:resultDirs forKey:lineid];
        offy+=50;
    }
//    [resultSet close];
    [db close];
    
    [super viewDidLoad];

     [scrollView setContentSize:CGSizeMake(320,offy+10)];
}
-(void)tapSubWay:(id)sender{
    NSString *lineid= [((ListViewBox *)[sender view]) lineId];
   // NSMutableDictionary *line= [idSubDirs objectForKey:lineid];
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayDetailViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayDetail"];
    [rb setLineid:lineid];
    //[rb setLine:line];
    //[rb setIdSubDirs:idSubDirs];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];

}

-(void)clickBack:(id)sender{
    UIStoryboard *sb = [ViewController getStoryboard];
    RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setIdSubDirs:nil];
    [self setEntries:nil];
    [self setSubWayImg:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


+(void)getSubWayForJson:(NSArray *)json jsonkey:(NSString*)key outDir:(NSMutableDictionary *)idSubDirs{
    NSMutableString *linesqlApp=[[NSMutableString alloc]init];
    NSMutableDictionary *lineDic= [[NSMutableDictionary alloc]init];//所有的key为要查找的地铁线路
    for (NSDictionary *dic in json) {
        if(dic==nil || [dic count]==0){
            NSLog(@"NSDictionary == dic--dic---=======%@",[dic debugDescription]);
            continue;
        }
        
        NSArray *trline= [dic objectForKey:key];
        if(trline==nil || [trline count]==0){
            NSLog(@"NSDictionary == trline-----=======%@",[trline debugDescription]);
            continue;
        }
      //  NSLog(@"trline-----=======%d",[trline count]);
        for (id tr in trline) {
           // NSLog(@"tr-----=======%@",tr);
            [lineDic setObject:tr forKey:tr];
        }
    }
    for (NSString *lineid in [lineDic allKeys]) {
        [linesqlApp appendFormat:@"\"%@\",",lineid];
    }
    NSString *sqlLine;
    if(linesqlApp.length>0){
        sqlLine=[[NSString alloc]initWithFormat:@"SELECT * FROM subway where lineid in (%@)", [linesqlApp substringToIndex:linesqlApp.length-1]];
        
        [SubWayHomeViewController getSubWayForSql:sqlLine outDir:idSubDirs];
//        FMDatabase *db= [ViewController getDataBase];
//        FMResultSet *resultSet  =[ViewController getDataBase:sqlLine db:db];//
//        while ([resultSet next]) {
//            NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
//            NSString *lineid = [resultSet stringForColumn:@"lineid"];
//            NSString *linename = [resultSet stringForColumn:@"linename"];
//            NSString *color = [resultSet stringForColumn:@"color"];
//            NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
//            
//            [resultDirs setObject:linename forKey:@"linename"];
//            [resultDirs setObject:color forKey:@"color"];
//            [resultDirs setObject:stationlist forKey:@"stationlist"];
//            [resultDirs setObject:lineid forKey:@"lineid"];
//            [idSubDirs setObject:resultDirs forKey:lineid];
//        }
//        [resultSet close];
//        [db close];
    }
}

+(void)getSubWayForSql:(NSString*)sql outDir:(NSMutableDictionary *)idSubDirs{
    NSLog(@"getSubWayForJson===%@",sql);
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
        [idSubDirs setObject:resultDirs forKey:lineid];
    }
    [resultSet close];
    [db close];
    NSLog(@"idSubDirs count ===%d",[idSubDirs count]);
}
@end
