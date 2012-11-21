//
//  DescriptionViewController.m  poi详细页面
//  zijiyoun
//
//  Created by piao chunzhi on 12-9-10.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "DescriptionViewController.h"
#import "DetailButtonUIView.h"
#import "MapBoxViewController.h"
#import "CheckInViewController.h"
#import "MyAccountViewController.h"
#import "YouJiViewController.h"
#import "StationView.h"
#import "TransferSubWayViewController.h"
#import "SubWayStationViewController.h"
#import "SubWayHomeViewController.h"
#import "PayMapViewController.h"
@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
@synthesize poiView;
//@synthesize title;
@synthesize backIdentifier;
//@synthesize poiImage;
@synthesize scrollView;
@synthesize poiName;
@synthesize poimongoid;
@synthesize idSubDirs;
//@synthesize poiSubWayDatas;
@synthesize poiData;
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
    if(poiData==nil){
        NSString *sql =[[NSString alloc] initWithFormat:@"SELECT * FROM poi WHERE poimongoid='%@'",poimongoid];
        FMDatabase *db= [ViewController getDataBase];
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];
        CLLocationCoordinate2D coor;
        NSMutableArray *dataArray=[[NSMutableArray alloc]init];
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coor setEntries:dataArray setAllData:nil];
        poiData = [dataArray objectAtIndex:0];
    }
    
    NSString *title=[poiData objectForKey:@"name"];
    NSString *address=[poiData objectForKey:@"address"];
    NSString *opentime=[poiData objectForKey:@"opentime"];
    NSString *telephone=[poiData objectForKey:@"telephone"];
    NSString *description=[poiData objectForKey:@"description"];
    NSString *category = [poiData objectForKey:@"category"];
    
    NSString *subway = [poiData objectForKey:@"subway"];
    float offy=225;
    float poiHeight= poiView.frame.size.height;
    if(![category isEqualToString:@"wikipedia"]){
         NSData *image = [poiData objectForKey:@"image"];
        if(image!=nil && image.length>0){
            UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 294, 158)];
            [poiView addSubview:imView];
            [imView setImage:[[UIImage alloc] initWithData:image]];
        }
         [poiName setText:title];
        
        poiView.layer.borderWidth  = 1;
        poiView.layer.borderColor= [[[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
        poiView.layer.shadowColor = [UIColor blackColor].CGColor;
        poiView.layer.shadowOffset = CGSizeMake(1,1);
        poiView.layer.shadowOpacity = 0.2;
        poiView.layer.shadowRadius = 3.0;
        [poiView setFrame:CGRectMake(poiView.frame.origin.x, poiView.frame.origin.y, poiView.frame.size.width, poiHeight)];
        
        UIImage *backsimage=[UIImage imageNamed:@"backsept"];
        UIImageView *sper=[[UIImageView alloc] initWithImage:backsimage];
        [sper setFrame:CGRectMake(poiView.frame.origin.x, poiHeight+10, backsimage.size.width, backsimage.size.height)];
        [scrollView addSubview:sper];
       // offy=225.0f;
    }else{
        poiHeight=50;
        [poiName setHidden:YES];
     //   [poiView setHidden:YES];
        CLLocationCoordinate2D coord;
        coord.latitude =  [[poiData objectForKey:@"latitude"] doubleValue];
        coord.longitude = [[poiData objectForKey:@"longitude"] doubleValue];
        
        mapView= [ViewController getMap:15 center:coord frame:CGRectMake(5, 5, 290, 180)];
        @try {
            [mapView setDelegate:self];
            RMAnnotation *anotation = [[RMAnnotation alloc]initWithMapView:mapView coordinate:coord andTitle:title];
            [anotation setAnchorPoint:CGPointMake(0.5, 1)];
            [anotation setAnnotationIcon:[UIImage imageNamed:@"checkin"]];
            anotation.userInfo = poiData;
            [mapView addAnnotation:anotation];
            [mapView setCenterCoordinate:[anotation coordinate]];
        }
        @catch (NSException *exception) {
            NSLog(@"SubWayStationViewController 坐标错误.......");
            NSLog(@"poiName==%@CLLocationCoordinate2D==coord.latitude=%f|coord.longitude=%f",title,coord.latitude,coord.longitude);
        }
        
        [poiView addSubview:mapView];
    }
    NSLog(@"category===%@",category);
    
  //  "wikipedia"
    
    //poimongoid=[poiData objectForKey:@"poimongoid"];
     
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:title backTitle:@"" righTitle:nil];
   
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    
    
    
    
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    UIColor *textColor=[[UIColor alloc]initWithRed:99/255.0f green:92/255.0f blue:77/255.0f alpha:1.0f];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    
    int sx=9;
    NSString *poi_route=NSLocalizedStringFromTable(@"poi_route", @"InfoPlist",nil);
    NSString *poi_checkin=NSLocalizedStringFromTable(@"poi_checkin", @"InfoPlist",nil);
    NSString *poi_favourite=NSLocalizedStringFromTable(@"poi_favourite", @"InfoPlist",nil);
   
    DetailButtonUIView *dbtra = [[DetailButtonUIView alloc]initWithFrame:CGRectMake(sx, offy, 95, 40) imageName:@"gohere" text:poi_route];
    [scrollView addSubview:dbtra];
    sx+=103;
    
    DetailButtonUIView *dbt = [[DetailButtonUIView alloc]initWithFrame:CGRectMake(sx, offy, 95, 40) imageName:@"checkin" text:poi_checkin];
    [scrollView addSubview:dbt];
    sx+=103;
    
    DetailButtonUIView *dbsc = [[DetailButtonUIView alloc]initWithFrame:CGRectMake(sx, offy, 95, 40) imageName:@"favourite" text:poi_favourite];
    [scrollView addSubview:dbsc];
    //sx+=103;
    
    offy+=50.0f;
    
    sx=9;
    
    
    //offy+=30;
    
    [[dbtra button]addTarget:self action:@selector(showTransfer) forControlEvents:UIControlEventTouchUpInside];
    [[dbt button]addTarget:self action:@selector(clickCheck) forControlEvents:UIControlEventTouchUpInside];
    [[dbsc button]addTarget:self action:@selector(clickFave) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIFont *font =[UIFont fontWithName:@"STHeitiSC-Medium" size:14];
    
    if(address!=nil&&![address isEqualToString:@""]){
        NSString *poi_address=NSLocalizedStringFromTable(@"poi_address", @"InfoPlist",nil);
        DetailButtonUIView *dbdt = [[DetailButtonUIView alloc]initWithFrame:CGRectMake(sx, offy, 300, 40) imageName:@"ditu" text:[[NSString alloc] initWithFormat:@"%@：%@",poi_address,address]];
        [[dbdt button]addTarget:self action:@selector(clickMap) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:dbdt];
        offy+=50.0f;

    }
    if(opentime!=nil&&![opentime isEqualToString:@""]){
       // [scrollView addSubview:[self getUIImageView:CGRectMake(15, offy,290, 2)]];
      //  offy+=5;
        UILabel *opentimeLabel=[[UILabel alloc]init];
        [opentimeLabel setBackgroundColor:[UIColor clearColor]];
        [opentimeLabel setFont:font];
        opentimeLabel.textColor=textColor;
        opentimeLabel.lineBreakMode = UILineBreakModeWordWrap;
        opentimeLabel.numberOfLines = 0;
        
        CGSize size = CGSizeMake(220,2000);
        CGSize labelsize = [opentime sizeWithFont:opentimeLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        [opentimeLabel setFrame:CGRectMake(100, offy,labelsize.width, labelsize.height)];
        
        opentimeLabel.text =  opentime;
       
        UILabel *opentimeStarLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 100,labelsize.height)];
        [opentimeStarLabel setBackgroundColor:[UIColor clearColor]];
        opentimeStarLabel.text = @"开放时间：";
        [opentimeStarLabel setFont:opentimeLabel.font];
        opentimeStarLabel.textColor=opentimeLabel.textColor;
        [scrollView addSubview:opentimeStarLabel];

        [scrollView addSubview:opentimeLabel];
        offy+=labelsize.height;
       
    }
    if(telephone!=nil&&![telephone isEqualToString:@""]){
    //    [scrollView addSubview:[self getUIImageView:CGRectMake(15, offy,290, 2)]];
        UILabel *telephoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 280,30)];
        [telephoneLabel setBackgroundColor:[UIColor clearColor]];
        telephoneLabel.text =   [[NSString alloc]initWithFormat:@"电        话：  %@",telephone];
        [telephoneLabel setFont:font];
        telephoneLabel.textColor=textColor;
        [scrollView addSubview:telephoneLabel];
        offy+=telephoneLabel.frame.size.height+5;
    }
   
    if(subway!=nil&&![subway isEqualToString:@""]){//附近交通
        offy+=5;
        [scrollView addSubview:[self getSeparatorUIImageView:CGRectMake(-5,offy, 350, 8)]];
        offy+=2;
        NSString *poi_traffic=NSLocalizedStringFromTable(@"poi_traffic", @"InfoPlist",nil);
        UILabel *jiaotongLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 280, 40)];
        [jiaotongLabel setBackgroundColor:[UIColor clearColor]];
        jiaotongLabel.text = poi_traffic;
        [jiaotongLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18]];
        jiaotongLabel.textColor=textColor;
        [scrollView addSubview:jiaotongLabel];
        offy+=jiaotongLabel.frame.size.height;
        
//       // idSubDirs
//        NSMutableArray *subentries=[[NSMutableArray alloc]init];
//        idSubDirs =[[NSMutableDictionary alloc]init];//所有地铁数据
//        [ViewController getAllSubway:subentries];
//        for (NSMutableDictionary *resultDirs in subentries) {
//            [idSubDirs setObject:resultDirs forKey:[resultDirs objectForKey:@"lineid"]];
//        }
        
        
        NSData* jsonData = [subway dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        if(idSubDirs==nil){
            idSubDirs= [[NSMutableDictionary alloc] init];
         }else{
             [idSubDirs removeAllObjects];
        }
        [SubWayHomeViewController getSubWayForJson:json jsonkey:@"lineid" outDir:idSubDirs];
        
       // 
        
    // [ { "poimongoid" : "505aea5e8ead0e191600000f", "lineid" : [ 13 , 14] , "name" : "中环" , "dis" : 185.1} , { "poimongoid" : "505aea5e8ead0e1916000010", "lineid" : [ 13] , "name" : "金钟" , "dis" : 717.3}]
//        NSMutableString *linesqlApp=[[NSMutableString alloc]init];
//        NSMutableDictionary *lineDic= [[NSMutableDictionary alloc]init];//所有的key为要查找的地铁线路
//        for (NSDictionary *dic in json) {
//            NSArray *trline= [dic objectForKey:@"lineid"];
//            for (id tr in trline) {
//                [lineDic setObject:tr forKey:tr];
//            }
//        }
//        for (NSString *lineid in [lineDic allKeys]) {
//            [linesqlApp appendFormat:@"\"%@\",",lineid];
//        }
//        NSString *sqlLine;
//        if(linesqlApp.length>0){
//            sqlLine=[[NSString alloc]initWithFormat:@"SELECT lineid,linename,color FROM subway where lineid in (%@)", [linesqlApp substringToIndex:linesqlApp.length-1]];
//            NSLog(sqlLine);
//            FMDatabase *db= [ViewController getDataBase];
//            FMResultSet *resultSet  =[ViewController getDataBase:sqlLine db:db];//
//            if(idSubDirs==nil){
//                idSubDirs= [[NSMutableDictionary alloc] init];
//            }else{
//                [idSubDirs removeAllObjects];
//            }
//            while ([resultSet next]) {
//                NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
//                NSString *lineid = [resultSet stringForColumn:@"lineid"];
//                NSString *linename = [resultSet stringForColumn:@"linename"];
//                NSString *color = [resultSet stringForColumn:@"color"];
//               // NSString *stationlist = [resultSet stringForColumn:@"stationlist"];
//                
//                [resultDirs setObject:linename forKey:@"linename"];
//                [resultDirs setObject:color forKey:@"color"];
//               // [resultDirs setObject:stationlist forKey:@"stationlist"];
//                [resultDirs setObject:lineid forKey:@"lineid"];
//                [idSubDirs setObject:resultDirs forKey:lineid];
//            }
//            [resultSet close];
//            [db close];
//        }
        //---------------
        NSMutableDictionary *poimogoidsDic= [[NSMutableDictionary alloc]init];//一个poi 对应的多条地铁线路key:lineid value:NSMutableArray
      //  NSMutableString *poimongoids=[[NSMutableString alloc]initWithString:@""];
        for (NSDictionary *dic in json) {
            NSArray*trline= [dic objectForKey:@"lineid"];
            
            NSString* poimongoid =[dic objectForKey:@"poimongoid"];
//            [poimongoids appendString:@"\""];
//            [poimongoids appendString:poimongoid];
//            [poimongoids appendString:@"\""];
//            [poimongoids appendString:@","];
            
                       
            NSMutableArray *trlineArray = [[NSMutableArray alloc]init];
            for (id tr in trline) {
                [trlineArray addObject:[idSubDirs objectForKey:[[NSString alloc] initWithFormat:@"%@",tr]]];
            }
            [poimogoidsDic setObject:trlineArray forKey:poimongoid];///一个poi 对应的多个线路
            
            StationView *stationV = [[StationView alloc]initWithFrame:CGRectMake(15, offy, 290,50) transferStations: trlineArray poiData:dic];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subStationClick:)];
            [stationV addGestureRecognizer:gestureRecognizer];
            [stationV setPoiData:dic];
            [scrollView addSubview:stationV];
            
            offy+=55;
        }

//        NSString *sqlpois;
//        if(poimongoids.length>0){
//            sqlpois=[poimongoids substringToIndex:poimongoids.length-1];
//        }
//        NSMutableArray *entries=[[NSMutableArray alloc]init];
//        NSString *sql =[[NSString alloc]initWithFormat:@"SELECT * FROM poi where poimongoid in(%@)",sqlpois];
//        FMDatabase *db= [ViewController getDataBase];
//        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//        CLLocationCoordinate2D coord;
//        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coord setEntries:entries setAllData:nil];//所有地铁站的poi
//        
//        [resultSet close];
//        [db close];
//        poiSubWayDatas =[[NSMutableDictionary alloc]init];
//        for (NSDictionary *_poi in entries) {
//            [poiSubWayDatas setObject:_poi forKey:[_poi objectForKey:@"poimongoid"]];
//        }

        offy+=10;
    }

     offy+=5;
    [scrollView addSubview:[self getSeparatorUIImageView:CGRectMake(-5,offy, 350, 8)]];
//游记
    NSString *poi_article=NSLocalizedStringFromTable(@"poi_article", @"InfoPlist",nil);
    if([category isEqualToString:@"attraction"]){
        
        UILabel *youjiLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 280, 50)];
        [youjiLabel setBackgroundColor:[UIColor clearColor]];
        youjiLabel.text =  poi_article;
        [youjiLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18]];
        youjiLabel.textColor=textColor;
        [scrollView addSubview:youjiLabel];
        offy+=40;
        UIView *youjiView = [[UIView alloc]initWithFrame:CGRectMake(10, offy, 300, 70)];
        [youjiView setBackgroundColor:[UIColor whiteColor]];
        youjiView.layer.borderWidth  = 1;
        youjiView.layer.borderColor= [[[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
        if(![category isEqualToString:@"wikipedia"]){
            NSData *image = [poiData objectForKey:@"image"];
            if(image!=nil){
                UIImageView *youjiImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:image]];
                [youjiImageView setFrame:CGRectMake(10, 10, 65, 50)];
                youjiImageView.layer.borderWidth  = 1;
                youjiImageView.layer.borderColor= [[[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
                youjiImageView.layer.shadowColor = [UIColor blackColor].CGColor;
                youjiImageView.layer.shadowOffset = CGSizeMake(2,2);
                youjiImageView.layer.shadowOpacity = 0.2;
                youjiImageView.layer.shadowRadius = 3.0;
                [youjiView addSubview:youjiImageView];
            }
        }
        
        NSString *youText;
        if(title.length<=6){
            youText=title;
        }else{
            youText=@"关于此景点的";
        }
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 0, 205, 70)];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        NSString *poi_article=NSLocalizedStringFromTable(@"poi_article", @"InfoPlist",nil);
        contentLabel.text = [[NSString alloc]initWithFormat: @"在线阅读%@%@",youText,poi_article];
        [contentLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16]];
        contentLabel.textColor=textColor;
        [youjiView addSubview:contentLabel];
        offy+=90;
        
        UIButton *youjiButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [youjiButton setFrame:CGRectMake(0, 0, youjiView.frame.size.width, youjiView.frame.size.height)];
        [youjiButton addTarget:self action:@selector(youjiShow) forControlEvents:UIControlEventTouchUpInside];
        
        
        [youjiView addSubview:youjiButton];
        [scrollView addSubview:youjiView];
    }
   
    
    
   
    [scrollView addSubview:[self getSeparatorUIImageView:CGRectMake(-5,offy, 350, 8)]];
    
    
    if(description!=nil&&![description isEqualToString:@""]){//简介
      //  offy+=10;
        NSString *poi_introduction=NSLocalizedStringFromTable(@"poi_introduction", @"InfoPlist",nil);
        UILabel *jianjieLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 280, 50)];
        [jianjieLabel setBackgroundColor:[UIColor clearColor]];
        jianjieLabel.text = poi_introduction;
        [jianjieLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        jianjieLabel.textColor=textColor;
        [scrollView addSubview:jianjieLabel];
        offy+=40;
        
        CGSize size = CGSizeMake(320,2000);
        CGSize labelsize = [description sizeWithFont:jianjieLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];

        UIWebView *dwebView=[[UIWebView alloc]initWithFrame:CGRectMake(15, offy, 290, labelsize.height+5)];
        dwebView.backgroundColor = [UIColor whiteColor];  
        dwebView.opaque = NO;
        //这行能在模拟器下明下加快 loadHTMLString 后显示的速度，其实在真机上没有下句也感觉不到加载过程
        dwebView.dataDetectorTypes = UIDataDetectorTypeNone;
        [dwebView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
         [dwebView setScalesPageToFit:NO];  //大小自适应
        //NSLog(@"text===%@",text);
        NSString *path=[[NSString alloc]initWithFormat:@"file://%@" ,[[NSBundle mainBundle] bundlePath] ];
        description = [description stringByReplacingOccurrencesOfString:@"@@URL@@" withString:path];
        
        [dwebView loadHTMLString:description baseURL:nil]; //在 WebView 中显示本地的字符串
//        for (id subview in dwebView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
//            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
//                ((UIScrollView *)subview).scrollEnabled = NO;
//        }
        
        [scrollView addSubview:dwebView];
        
        offy+=labelsize.height+20;
    }
     [scrollView setContentSize:CGSizeMake(320,offy)];
     
}
-(void)youjiShow{
    UIStoryboard *sb = [ViewController getStoryboard];
    NSString *poi_article=NSLocalizedStringFromTable(@"poi_article", @"InfoPlist",nil);
    YouJiViewController *rb = [sb instantiateViewControllerWithIdentifier:@"YoujiWeb"];
    rb.title=[[NSString alloc]initWithFormat:@"%@%@" ,[poiData objectForKey:@"name"],poi_article];
    rb.url=[[NSString alloc]initWithFormat:@"http://www.zijiyou.com/poi/%@" ,[poiData objectForKey:@"poimongoid"]];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[annotation annotationIcon]];
    return marker;
}
-(UIImageView *) getSeparatorUIImageView:(CGRect)rect{
    UIImageView *tempseparator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"separator"]];
    [tempseparator setFrame:rect];
    return tempseparator;
}

-(UIImageView *) getUIImageView:(CGRect)rect{
    UIImageView *iView =[[UIImageView alloc]initWithFrame:rect];
    UIImage * xuxianbg= [UIImage imageNamed:@"xuxian"]; 
    //平铺
    iView.backgroundColor=[UIColor colorWithPatternImage:xuxianbg];
    return iView;
}
-(void)subStationClick:(UITapGestureRecognizer *)sender{
    StationView *stationV =[sender view];
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayStationViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    NSString *key=[[stationV poiData] objectForKey:@"poimongoid"];
   // [rb setPoiData:[poiSubWayDatas objectForKey:key]];
    [rb setPoimongoid:key];
    [rb setIdSubDirs:[self idSubDirs]];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}

-(void)clickCheck{
    UIStoryboard *sb = [ViewController getStoryboard];
    CheckInViewController *rb = [sb instantiateViewControllerWithIdentifier:@"CheckIn"];
    //rb.detail=@"DescriptionViewController";
    rb.poiData =  poiData;
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
-(void)clickFave{
    //NSLog(@"SADFAADAFDFADF=======%@",poiid);
    NSString *poiid = [poiData objectForKey:@"poiid"];
    FMDatabase *db= [ViewController getUserDataBase];
    if ([db open]) {
        NSString *sql = [[NSString alloc]initWithFormat:@"SELECT * FROM favourite WHERE poiid='%@'",poiid];
        FMResultSet *rs = [db executeQuery:sql];
        if([rs next]){
            NSString *poi_favourite_already=NSLocalizedStringFromTable(@"poi_favourite_already", @"InfoPlist",nil);
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                               message:poi_favourite_already
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
            [alertView show];
        }else{

            NSString *poi_favourite=NSLocalizedStringFromTable(@"poi_favourite", @"InfoPlist",nil);

            NSString *sql = @"insert into favourite (poiid,poiname) values (?,?)";
            [db executeUpdate:sql,poiid,[poiData objectForKey:@"name"]];
            if ([db hadError])
            {
                    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                                       message:[[NSString alloc]initWithFormat:@"%@失败",poi_favourite]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                    [alertView show];
                }else{
                
                    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                                       message:[[NSString alloc]initWithFormat:@"%@成功",poi_favourite]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                    [alertView show];
            }
        }
        
        [rs close];
    }
    [db close];
}
-(void)clickMap{
    UIStoryboard *sb = [ViewController getStoryboard];
    MapBoxViewController *rb = [sb instantiateViewControllerWithIdentifier:@"MapView"];
    rb.detail=@"DescriptionViewController";
    rb.poiData = poiData;
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}

-(void)clickBack{
    if([backIdentifier isEqualToString:@"MapDownViewController"]){
        UIStoryboard *sb = [ViewController getStoryboard];
        RXCustomTabBar *rb = [sb instantiateViewControllerWithIdentifier:@"HomeIndex"];
        rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:rb animated:YES];
        [self presentModalViewController:rb animated:YES];
        return;
    }
    [self dismissModalViewControllerAnimated:YES];
    if([backIdentifier isEqualToString:@"HomeNearViewController"]){
        RXCustomTabBar *rb =(RXCustomTabBar *)[self presentingViewController];
        [rb setSelectedIndex:2];
        [rb.btn1 setSelected:NO];
        [rb.btn3 setSelected:YES];
    }else if([backIdentifier isEqualToString:@"SearchViewController"]){
        RXCustomTabBar *rb =(RXCustomTabBar *)[self presentingViewController];
        [rb setSelectedIndex:3];
        [rb.btn1 setSelected:NO];
        [rb.btn4 setSelected:YES];
    }else if([backIdentifier isEqualToString:@"MapBoxViewController"]){
        RXCustomTabBar *rb =(RXCustomTabBar *)[self presentingViewController];
        [rb setSelectedIndex:1];//地图
        [rb.btn1 setSelected:NO];
        [rb.btn2 setSelected:YES];
    }else if([backIdentifier isEqualToString:@"MyAccountViewController"]){
        MyAccountViewController *rb =(MyAccountViewController *)[self presentingViewController];
        [rb selectButtonFav];
    }

}
- (void)viewDidUnload
{
    [self setIdSubDirs:nil];
    [self setPoiData:nil];
    [self setBackIdentifier:nil];
    [self setPoiName:nil];
 //   [self setPoiImage:nil];
    [self setPoiView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)showTransfer{
//    //获得商店信息
//    if ([SKPaymentQueuecanMakePayments] == YES) {//有权限购买
//        NSSet *set = [NSSetsetWithArray:[[NSArrayalloc] initWithObjects:@"1001",nil]];
//            
//        SKProductsRequest *request = [[SKProductsRequestalloc] initWithProductIdentifiers:set];
//        request.delegate = self;
//        [request start];
//    }
//
//    BOOL isProUpgradePurchased=  [[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"];
//    if(!isProUpgradePurchased){
//        
//        if(iap==nil){
//            iap =[[InAppPurchaseManager alloc]init];
//        }
//        [iap setDepView:self.view];
//        if([iap canMakePurchases]){
//            [iap loadStore];
//        }
//        return;
//    }
    
    BOOL isPurchased=[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"];//是否已经购买
    if(!isPurchased){//如果没有购买
        [self showPayMap];
    }else{//购买了
        UIStoryboard *sb = [ViewController getStoryboard];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        NSString *userDirectory= [NSHomeDirectory()
                                  stringByAppendingPathComponent:@"Documents/transfer.db"];
        if (!([fileManager fileExistsAtPath:userDirectory])){//如果不存在 跳转到下载
            UIStoryboard *sb = [ViewController getStoryboard];
            MapDownViewController *rb = [sb instantiateViewControllerWithIdentifier:@"MapDown"];
            rb.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            rb.backIdentifier = @"PayMapViewController";
            [rb setBackpoimongoid:poimongoid];
            [self.navigationController pushViewController:rb animated:YES];
            [self presentModalViewController:rb animated:YES];
        }else{
            TransferSubWayViewController *rb = [sb instantiateViewControllerWithIdentifier:@"TransferSubWay"];
            rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
            [rb setPoiData: poiData];
            [self.navigationController pushViewController:rb animated:YES];
            [self presentModalViewController:rb animated:YES];
        }
    }
}

-(void)showPayMap{
    UIStoryboard *sb = [ViewController getStoryboard];
    PayMapViewController *rb = [sb instantiateViewControllerWithIdentifier:@"PayMap"];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [rb setBackpoimongoid:poimongoid];
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
