//
//  SubWayStationViewController.m  地铁站信息
//  自己游
//
//  Created by piaochunzhi on 12-9-30.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//

#import "SubWayStationViewController.h"
#import "ListViewBox.h"
#import "SubWayDetailViewController.h"
#import "SubWayHomeViewController.h"
#import "DescriptionJianJieViewController.h"
@interface SubWayStationViewController ()

@end

@implementation SubWayStationViewController
@synthesize poiData;
@synthesize idSubDirs;
@synthesize scrollView;
@synthesize poimongoid;
@synthesize backIdentifier;
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
    NSLog(@"SubWayStationViewController viewDidLoad");
    FMDatabase *db= [ViewController getDataBase];
    if(poiData==nil && poimongoid!=nil){
        NSString *sql =[[NSString alloc] initWithFormat:@"SELECT * FROM poi WHERE poimongoid='%@'",poimongoid];
        
        FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];
        CLLocationCoordinate2D coor;
        NSMutableArray *dataArray=[[NSMutableArray alloc]init];
        [ViewController setPoiArray:resultSet isNeedDist:NO coord:coor setEntries:dataArray setAllData:nil];
        if(dataArray!=nil && [dataArray count]>0){
            poiData = [dataArray objectAtIndex:0];
        }
    }
    NSString *line = [poiData objectForKey:@"line"];
    NSData* jsonData = [line dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* json =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    

    if(idSubDirs==nil){
         NSMutableString *linesqlApp=[[NSMutableString alloc]init];
        for (NSString *lineid in [json allKeys]) {
            [linesqlApp appendFormat:@"\"%@\",",lineid];
        }
        idSubDirs = [[NSMutableDictionary alloc]init];
        
         NSString *sqlLine=[[NSString alloc]initWithFormat:@"SELECT * FROM subway where lineid in (%@)", [linesqlApp substringToIndex:linesqlApp.length-1]];
        [SubWayHomeViewController getSubWayForSql:sqlLine outDir:idSubDirs];
       // [ViewController getAllSubwayDic:idSubDirs];
    }
    
    
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    UIColor *textColor=[[UIColor alloc]initWithRed:99/255.0f green:92/255.0f blue:77/255.0f alpha:1.0f];
    //平铺
    self.view.backgroundColor=[UIColor colorWithPatternImage:tabelbg];

    
    NSString *title=[poiData objectForKey:@"name"];
    textTitle= title;
    description=[poiData objectForKey:@"description"];

    CLLocationCoordinate2D coord;
    coord.latitude =  [[poiData objectForKey:@"latitude"] doubleValue];
    coord.longitude = [[poiData objectForKey:@"longitude"] doubleValue];
    
    
    
    PCTOPUIview *pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:title backTitle:@"" righTitle:nil];
    
    [pctop.button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];

    UIView *poiView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    poiView.layer.borderWidth  = 1;
    poiView.layer.borderColor= [[[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
    poiView.layer.shadowColor = [UIColor blackColor].CGColor;
    poiView.layer.shadowOffset = CGSizeMake(5,5);
    poiView.layer.shadowOpacity = 0.2;
    poiView.layer.shadowRadius = 3.0;
    
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
    
    
    UILabel *sulabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 300, 50)];
    [sulabel setText:@"经过的线路"];
    [sulabel setBackgroundColor:[UIColor clearColor]];
    [sulabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
    [sulabel setTextColor:textColor];
    //{ ""14"" : { ""name"" : ""荃湾线"" , ""order"" : ""6""} , ""16"" : { ""name"" : ""观塘线"" , ""order"" : 2}}"
    
  //  NSLog(@"line====%@",line);
       int offy =250;
    for (NSString *lineid in [json allKeys]) {
            NSMutableDictionary *lineDic= [idSubDirs objectForKey:lineid];
            NSString *linename = [lineDic objectForKey:@"linename"];
            NSString *color = [lineDic objectForKey:@"color"];
        
        
        NSString *stationlist = [lineDic objectForKey:@"stationlist"];
        
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

        
            ListViewBox * list = [[ListViewBox alloc] initWithFrame:CGRectMake(15, offy, 285, 45) imgURL:@"arrows" textColor:color text:linename stationText:nil leftImage:nil sandetName:stetName];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubWay:)];
            [list addGestureRecognizer:gestureRecognizer];
            [list setLineId:lineid];
            [scrollView addSubview:list];

            offy+=50;
    }
    
    if(description!=nil&&![description isEqualToString:@""]){
        UILabel *jianjieLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, offy, 280, 50)];
        [jianjieLabel setBackgroundColor:[UIColor clearColor]];
        NSString *poi_introduction=NSLocalizedStringFromTable(@"poi_introduction", @"InfoPlist",nil);
        jianjieLabel.text = poi_introduction;
        [jianjieLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        jianjieLabel.textColor=textColor;
        [scrollView addSubview:jianjieLabel];
        offy+=40;
//        
//        CGSize size = CGSizeMake(320,2000);
//        CGSize labelsize = [description sizeWithFont:jianjieLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//        
//        UIWebView *dwebView=[[UIWebView alloc]initWithFrame:CGRectMake(15, offy, 290, labelsize.height+5)];
//        dwebView.backgroundColor = [UIColor whiteColor];
//        dwebView.opaque = NO;
//        //这行能在模拟器下明下加快 loadHTMLString 后显示的速度，其实在真机上没有下句也感觉不到加载过程
//        dwebView.dataDetectorTypes = UIDataDetectorTypeNone;
//        [dwebView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//        [dwebView setScalesPageToFit:NO];  //大小自适应
//        //NSLog(@"text===%@",text);
//        NSString *path=[[NSString alloc]initWithFormat:@"file://%@" ,[[NSBundle mainBundle] bundlePath] ];
//        description = [description stringByReplacingOccurrencesOfString:@"@@URL@@" withString:path];
//        
//        [dwebView loadHTMLString:description baseURL:nil]; //在 WebView 中显示本地的字符
//        [scrollView addSubview:dwebView];
//        
//        offy+=labelsize.height+20;
//        
        NSData* jsonData = [description dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* jsonDescription =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        
        if(jsonDescription!=nil && jsonDescription.count>0){
            NSMutableString *general= [jsonDescription[0] objectForKey:@"General"];
            if(general!=nil){
                UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(12, offy, 297, 125)];
                textView.layer.borderWidth  = 1;
                textView.layer.borderColor= [[[UIColor alloc]initWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:255] CGColor];
                textView.layer.shadowColor = [UIColor blackColor].CGColor;
                textView.layer.shadowOffset = CGSizeMake(2,2);
                textView.layer.shadowOpacity = 0.2;
                textView.layer.shadowRadius = 3.0;
                textView.backgroundColor = [UIColor whiteColor];
                
                UILabel *jianjieTextView=[[UILabel alloc] initWithFrame:CGRectMake(8, 0, 285, 100)];
                // 设置UILabel文字
                jianjieTextView.text =general;
                // 设置Text为粗体
                jianjieTextView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
                //        jianjieTextView.textColor = [UIColor redColor];
                //        // 设置背景色
                //        jianjieTextView.backgroundColor = [UIColor clearColor];
                // 文字换行
                jianjieTextView.numberOfLines = 5;
                UILabel *moreLabel=[[UILabel alloc] initWithFrame:CGRectMake(200, 100, 80, 20)];
                UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [moreButton setFrame:CGRectMake(200, 100, 80, 20)];
                moreLabel.text =@"查看更多>>";
                moreLabel.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
                [moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
                [textView addSubview:moreLabel];
                [textView addSubview:moreButton];
                [textView addSubview:jianjieTextView];
                
                [scrollView addSubview:textView];
                offy+=textView.frame.size.height+20;
            }
        }
    }

    [scrollView addSubview: sulabel];
    [scrollView setContentSize:CGSizeMake(320,offy+10)];
    [scrollView addSubview: poiView];

    [db close];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)moreClick{
    UIStoryboard *sb = [ViewController getStoryboard];
    DescriptionJianJieViewController *rb = [sb instantiateViewControllerWithIdentifier:@"DescriptionJianjie"];
    [rb setTextDate:description];
    [rb setTextTitle:textTitle];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
}
- (void)viewDidUnload
{
   // [self setPoimongoid:nil];
    [self setIdSubDirs:nil];
    [self setPoiData:nil];
    [self setScrollView:nil];
    mapView=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[annotation annotationIcon]];
    return marker;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickBack{
  //  NSLog(@"SubWayStationViewController  dismissModalViewControllerAnimated");
    [self dismissModalViewControllerAnimated:YES];
    if(backIdentifier!=nil){
        RXCustomTabBar *rb =(RXCustomTabBar *)[self presentingViewController];
        if([backIdentifier isEqualToString:@"MapBoxViewController"]){
            [rb setSelectedIndex:1];
            [rb.btn1 setSelected:NO];
            [rb.btn2 setSelected:YES];
        }else if([backIdentifier isEqualToString:@"SubWayStation"]){
            [rb setSelectedIndex:3];
            [rb.btn1 setSelected:NO];
            [rb.btn4 setSelected:YES];
        }
    }
}
-(void)tapSubWay:(id)sender{
    NSString *lineid= [((ListViewBox *)[sender view]) lineId];
    //NSMutableDictionary *line= [idSubDirs objectForKey:lineid];
    UIStoryboard *sb = [ViewController getStoryboard];
    SubWayDetailViewController *rb = [sb instantiateViewControllerWithIdentifier:@"SubWayDetail"];
    //[rb setLine:line];
    [rb setLineid:lineid];
    //[rb setIdSubDirs:idSubDirs];
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    
}
@end
