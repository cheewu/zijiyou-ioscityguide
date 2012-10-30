//
//  HotPoiHomeViewController.m 热门地点
//  zijiyoun
//
//  Created by piao chunzhi on 12-8-23.
//  Copyright (c) 2012年 piao chunzhi. All rights reserved.
//
#import "SubWayStationViewController.h"

@interface HotPoiHomeViewController ()

@end

@implementation HotPoiHomeViewController
@synthesize subView;
@synthesize firstView;
@synthesize tableView;
@synthesize entries;
//@synthesize hotPoiListView;
//@synthesize hotPoiDetail;
//@synthesize detailBack;
//@synthesize resultSet;
//@synthesize db;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
 -(void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    
 }


-(void)getData:(NSString*)sql data:(NSMutableArray *)setData{
    [ViewController getPoiBaseData:sql data:setData];
//    FMDatabase *db= [ViewController getDataBase];
//    FMResultSet *resultSet  =[ViewController getDataBase:sql db:db];//
//    while ([resultSet next]) {
//        NSString *name =[NSDataDES getContentByHexAndDes:[resultSet stringForColumn:@"name"] key:deskey] ;
//        NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
//        if(name==nil){
//            NSLog(@"解密失败 poimongoid=%@",poimongoid);
//            continue;
//        }
//       // NSString *name =[resultSet stringForColumn:@"name"] ;
//       // NSString *poimongoid = [resultSet stringForColumn:@"poimongoid"];
//        NSString *category = [resultSet stringForColumn:@"category"];
//        NSData *img = [resultSet dataForColumn:@"image"];
//        
//        NSMutableDictionary *resultDirs = [[NSMutableDictionary alloc] init];
//        [resultDirs setObject:name forKey:@"name"];
//        [resultDirs setObject:poimongoid forKey:@"poimongoid"];
//        [resultDirs setObject:category forKey:@"category"];
//        if(img!=nil){
//            [resultDirs setObject:img forKey:@"image"];
//        }
//        [setData addObject:resultDirs];
//    }
//    
//    [resultSet close];
//    [db close];
//
}



-(void)myThreadMainMethod:(id)sender
{
    NSLog(@"开始查询：%@",[NSDate date]);
    NSString *sql =@"SELECT name,poimongoid,image,category FROM poi WHERE category='attraction' order by rank desc limit 0,10";// WHERE category='attraction'

    [self getData:sql data:entries];
    RightMenuButton *butt=[crm.buttonDirects objectForKey:@"listattraction"];
   // [crm selectMenu:butt];//设置景点为默认查找项目

    [crm allSelectButtonISselect:NO];
    [butt isButtonSelect:YES];
    
    [self performSelector:@selector(uiReloadData) withObject:nil];
    
    //延缓读取所有数据
    NSLog(@"开始结束：%@",[NSDate date]);
    
    // if(!isReadAllPoi){//延迟加载所有数据方便后面筛选
    [allData removeAllObjects];
    
    // isReadAllPoi=YES;
    //  }

}
-(void)getReAllData{
    NSString *sqlall =@"SELECT name,poimongoid,image,category FROM poi order by rank desc";
    [self getData:sqlall data:allData];
}

-(void)uiReloadData{
    [tableView reloadData];
    [ViewController hideWaiting:self.view];
}

-(void)DelayData{
     [self performSelectorInBackground:@selector(getAllData) withObject:nil];
    [self performSelectorInBackground:@selector(getReAllData) withObject:nil];
    //[entries removeAllObjects];
}
-(void)getAllData{
    //延迟加载剩下景点数据
    NSString *sqlreload =@"SELECT name,poimongoid,image,category FROM poi WHERE category='attraction' order by rank desc limit 10,200";
    [self getData:sqlreload data:entries];
    [self uiReloadData];
   // [self performSelector:@selector(uiReloadData) withObject:nil];
    NSLog(@"开始结束：%@",[NSDate date]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
      if(entries==nil){
          entries =[[NSMutableArray alloc] init];
          [self performSelectorInBackground:@selector(myThreadMainMethod:) withObject:nil];
    }
    if(allData==nil){
        allData =[[NSMutableArray alloc] init];
    }
    [ViewController showWaiting:self.view];

    
    
    
         
    tableView.rowHeight = kCustomRowHeight;
  //  pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"热门地点" ];
    pctop = [[PCTOPUIview alloc]initWithFrame:CGRectMake(0, 0, 320, 48) title:@"热门地点" backTitle:@"" righTitle:@"筛选"];
    [pctop.button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    //HomeIndex
    [self.view addSubview: pctop];
    //  NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadInMainMethod:) object:nil];
    // [myThread start];
    
    // Return the number of sections.
    
    UIImage * tabelbg= [UIImage imageNamed:@"tabelbag"];
    //平铺
    tableView.backgroundColor=[UIColor colorWithPatternImage:tabelbg];
    tableView.rowHeight = kCustomRowHeight;
    
    crm = [[CustomRightMenuView alloc]initWithFrame:CGRectMake(320, 0, 120, 480)];
    
    crm.delegate=self;
    crm.mainView=firstView;
    [crm setActionButton:pctop.rightButton];
    [subView addSubview:crm];
   // [self performSelectorInBackground:@selector(DelayData) withObject:nil];

	// Do any additional setup after loading the view.
    [self performSelector:@selector(DelayData) withObject:nil afterDelay:2];
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
    isReadAllPoi=NO;
    [self setTableView:nil];
    [self setEntries:nil];
    allData=nil;
    crm=nil;
    pctop=nil;
    categoryArray=nil;
    [self setFirstView:nil];
    [self setSubView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) backList:(id)sender{
  //  hotPoiDetail.hidden=YES;
   // hotPoiListView.hidden=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section
    NSLog(@"[entries count]=%d",[entries count]);
    return [entries count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // if (cell == nil)
   // {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       // cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCustomRowHeight)];

        UIView* bgView = [[UIView alloc] init] ;
        bgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        [cell setSelectedBackgroundView:bgView];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    
    cell.textLabel.text =[[self.entries objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
   
    
    
    UIImage * jdtemp;
    NSData *data = [[self.entries objectAtIndex:indexPath.row] objectForKey:@"image"];
 
    if(data==nil||data.length==0){
        jdtemp= [UIImage imageNamed:@"JingDianTemp.png"];
    }else{
        jdtemp=[UIImage imageWithData: data];
    }
    CGSize itemSize = CGSizeMake(kAppRowHeight+20, kAppRowHeight);
    UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [jdtemp drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.imageView.image = newImage;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


//    //圆角
//    //if (isRounded) {
        //cell.imageView.layer.cornerRadius = 3.0;
        //cell.imageView.layer.masksToBounds = YES;
//   // }
//    //圆角边框
//   // if(isBorder){
    
        cell.imageView.layer.borderWidth  = 5;
        cell.imageView.layer.borderColor= [[UIColor whiteColor] CGColor];
    
     cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
     cell.imageView.layer.shadowOffset = CGSizeMake(3, 3);
     cell.imageView.layer.shadowOpacity = 0.25;
     cell.imageView.layer.shadowRadius = 3.0;
   

    return cell;
}


//筛选内容按钮点击
- (void)callbackClick:(id)sender{
    
    [self performSelectorInBackground:@selector(backgroundClick:) withObject:sender];

}

-(void)backgroundClick:(id)sender{

    int indeBut =[sender tag];
    
    BOOL isHidden=![sender isSelected];//没被选中
    //   NSMutableDictionary *resultDirs=[entries objectAtIndex:indeBut-1];
    [entries removeAllObjects];
    
    if(indeBut==1){//全部被点击
        if(!isHidden){
            for (NSMutableDictionary *data in allData) {
                [entries addObject:[data copy]];
            }
        }
        [self.tableView reloadData];
        return;
    }
    
    NSMutableDictionary *buttons = [crm buttonDirects];
    NSArray *copyData =[allData copy];
    for (NSDictionary *nmud in copyData) {
        NSString *category =[nmud objectForKey:@"category"];
        for (RightMenuButton *rightBut  in [buttons allValues]) {
            NSString * categoryNow=[rightBut categoryName];
            if([category isEqualToString:categoryNow]){
                if(![[rightBut listSelectImage] isHidden]){
                    if([category isEqualToString:categoryNow]){
                        [entries addObject:[nmud copy]];
                    }
                }
            }
        }
    }
    [ViewController hideWaiting:self.view];

    [self.tableView reloadData];
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *poiData =[self.entries objectAtIndex:indexPath.row];
    NSString *category = [poiData objectForKey:@"category"];
    UIStoryboard *sb = [ViewController getStoryboard];
    ViewController *rb;
    
    if([category isEqualToString:@"subway"]){//如果是地铁
        rb = [sb instantiateViewControllerWithIdentifier:@"SubWayStation"];
        [((SubWayStationViewController *)rb) setPoimongoid:[poiData objectForKey:@"poimongoid"]];
        [((SubWayStationViewController *)rb) setPoiData:nil];
        [((SubWayStationViewController *)rb) setIdSubDirs:nil];
    }else{
        rb = [sb instantiateViewControllerWithIdentifier:@"Description"];
        ((DescriptionViewController *)rb).backIdentifier=@"HotPoiHomeViewController";
        [((DescriptionViewController *)rb) setPoimongoid:[poiData objectForKey:@"poimongoid"]];
        [((DescriptionViewController *)rb) setPoiData:nil];
    }
    
    rb.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:rb animated:YES];
    [self presentModalViewController:rb animated:YES];
    [self.tableView reloadData];
   //[cell setSelectedBackgroundView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
